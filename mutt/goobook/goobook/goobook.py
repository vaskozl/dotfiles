#!/usr/bin/env python2
# vim: fileencoding=UTF-8 filetype=python ff=unix expandtab sw=4 sts=4 tw=120
# maintainer: Christer Sjöholm -- goobook AT furuvik DOT net
#
# Copyright (C) 2009  Carlos José Barroso
# Copyright (C) 2010  Christer Sjöholm
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

'''\
The idea is make an interface to google contacts that mimics the behaviour of
abook for mutt. It's developed in python and uses the fine
google data api (gdata).
'''

import email.header
import locale
import logging
import optparse
import getpass
import sys
import os
import subprocess
import re
import time
import ConfigParser
from netrc import netrc
from os.path import realpath, expanduser
from storage import Storage

try:
    import simplejson
    json = simplejson # this hushes pyflakes
except ImportError:
    import json

import gdata
from gdata.contacts.client import ContactsClient, ContactsQuery
from gdata.contacts.data import ContactEntry
from gdata.data import Email, Name, FullName

log = logging.getLogger('goobook')

CONFIG_FILE = '~/.goobookrc'
CONFIG_TEMPLATE = '''\
# "#" or ";" at the start of a line makes it a comment.
[DEFAULT]
# If not given here, email and password is taken from .netrc using
# machine google.com
;email: user@gmail.com
;password: top secret
# The following are optional, defaults are shown
;max_results: 9999
;cache_filename: ~/.goobook_cache
;cache_expiry_hours: 24
'''

ENCODING = locale.getpreferredencoding()

class GooBook(object):
    '''This class can't be used as a library as it looks now, it uses sys.stdin
       print, sys.exit() and getpass().'''
    def __init__ (self, config):
        self.config = config
        self.__client = None
        self.contacts = {}
        ''' This is where all the contacts is stored
        {'contacts': {contact_id: <contact>}
         'groups': {'group': [contact_id] ]
        }
        <contact> is a {'name':'', 'email':''}
        '''

    @property
    def password(self):
        if not self.config.password:
            self.config.password = getpass.getpass()
        return self.config.password

    def __get_client(self):
        '''Login to Google and return a ContactsClient object.

        '''
        if not self.__client:
            if not self.config.email or not self.password:
                print >> sys.stderr, "ERROR: Missing email or password"
                sys.exit(1)
            client = ContactsClient()
            client.ssl = True
            client.ClientLogin(email=self.config.email, password=self.password, service='cp', source='goobook')
            self.__client = client
        return self.__client

    def __query_contacts(self, query):
        match = re.compile(query, re.I).search
        for contact in self.contacts['contacts'].itervalues():
            for field in ('name', 'nick', 'emails'):
                value = contact.get(field, None)
                if not value:
                    pass
                elif isinstance(value, basestring):
                    if value and match(value):
                        yield contact
                        break
                else: #value is list
                    found_one = False
                    for value2 in value:
                        if value2 and match(value2):
                            yield contact
                            found_one = True
                            break
                    if found_one:
                        break

    def __query_groups(self, query):
        match = re.compile(query, re.I).search
        for (group_id, group_name) in self.contacts['groups'].iteritems():
            if match(group_name):
                yield (group_name, list(self.__get_group_contacts(group_id)))

    def query(self, query):
        """Do the query, and print it out in

        """
        self.load()
        #query contacts
        matching_contacts = sorted(self.__query_contacts(query), key=lambda c: c['name'])
        #query groups
        matching_groups = sorted(self.__query_groups(query), key=lambda g: g[0])
        # mutt's query_command expects the first line to be a message,
        # which it discards.
        print "\n",
        for contact in matching_contacts:
            if 'emails' in contact and contact['emails']:
                emailaddrs = sorted(contact['emails'])
                for emailaddr in emailaddrs:
                    print (u'%s\t%s' % (emailaddr, contact['name'])).encode(ENCODING)
        for group_name, contacts in matching_groups:
            emails = ['%s <%s>' % (c['name'], c['emails'][0]) for c in contacts if c['emails']]
            emails = ', '.join(emails)
            if not emails:
                continue
            print (u'%s\t%s (group)' % (emails, group_name)).encode(ENCODING)

    def __get_group_contacts(self, group_id):
        for contact in self.contacts['contacts'].itervalues():
            if group_id in contact['groups']:
                yield contact

    def load(self):
        """Load the cached addressbook feed, or fetch it (again) if it is
        old or missing or invalid or anyting

        """
        contacts = None

        # if cache older than cache_expiry_hours
        if (not os.path.exists(self.config.cache_filename) or
                ((time.time() - os.path.getmtime(self.config.cache_filename)) >
                    (self.config.cache_expiry_hours * 60 *60))):
            contacts = self.fetch()
            self.store(contacts)
        if not contacts:
            try:
                contacts = json.load(open(self.config.cache_filename))
                if contacts.get('goobook_cache') != '1.1':
                    contacts = None # Old cache format
            except ValueError:
                pass # Failed to read JSON file.
        if not contacts:
            contacts = self.fetch()
            self.store(contacts)
        if not contacts:
            raise Exception('Failed to find any contacts') # TODO
        self.contacts = contacts


    def fetch_contacts(self):
        client = self.__get_client()
        query = ContactsQuery(max_results=self.config.max_results)
        entries = client.get_contacts(query=query).entry
        return dict([self.__parse_contact(ent) for ent in entries])

    @staticmethod
    def __parse_contact(ent):
        '''takes a gdata contact entry and returns a parsed contact.
        on the form (contact_id, {fieldname:content})

        '''
        contact = {}
        contact['name'] = ent.title.text
        contact['emails'] = [emailent.address for emailent in ent.email]
        if ent.nickname:
            contact['nick'] = ent.nickname.text
        contact['groups'] = [g.href for g in ent.group_membership_info]
        return (ent.id.text, contact)

    def fetch_contact_groups(self):
        client = self.__get_client()
        return dict([(g.id.text, g.title.text) for g in client.get_groups().entry])

    def fetch(self):
        """Actually go out on the wire and fetch the addressbook.
        Returns the contacts data structure.

        """
        contacts = self.fetch_contacts()
        groups = self.fetch_contact_groups()
        return {'contacts':contacts, 'groups':groups, 'goobook_cache': '1.1'}

    def store(self, contacts):
        """Pickle the addressbook and a timestamp

        """
        if contacts: # never write a empty addressbook
            json.dump(contacts, open(self.config.cache_filename, 'w'), indent=2)

    def add(self):
        """Add an address from From: field of a mail.
        This assumes a single mail file is supplied through stdin.

        """
        from_line = ""
        for line in sys.stdin:
            if line.startswith("From: "):
                from_line = line
                break
        if from_line == "":
            print "Not a valid mail file!"
            sys.exit(2)
        #Parse From: line
        #Take care of non ascii header
        from_line = unicode(email.header.make_header(email.header.decode_header(from_line)))
        #Parse the From line
        (name, mailaddr) = email.utils.parseaddr(from_line)
        if not name:
            name = mailaddr
        #save to contacts
        client = self.__get_client()
        new_contact = ContactEntry(name=Name(full_name=FullName(text=name)))
        new_contact.email.append(Email(address=mailaddr, rel='http://schemas.google.com/g/2005#home', primary='true'))
        client.create_contact(new_contact)
        print 'Created contact:', name.encode(ENCODING), mailaddr.encode(ENCODING)

def read_config(config_file):
    '''Reads the ~/.goobookrc and ~/.netrc.
    returns the configuration as a dictionary.

    '''
    config = Storage({ # Default values
        'email': '',
        'password': '',
        'max_results': '9999',
        'cache_filename': '~/.goobook_cache',
        'cache_expiry_hours': '24',
        })
    config_file = os.path.expanduser(config_file)
    if os.path.lexists(config_file) or os.path.lexists(config_file + '.gpg'):
        try:
            parser = ConfigParser.SafeConfigParser()
            if os.path.lexists(config_file):
                log.info('Reading config: %s', config_file)
                f = open(config_file)
            else:
                log.info('Reading config: %s', config_file + '.gpg')
                sp = subprocess.Popen(['gpg', '--no-tty', '-q', '-d', config_file + ".gpg"], stdout=subprocess.PIPE)
                f = sp.stdout
            parser.readfp(f)
            config.update(dict(parser.items('DEFAULT', raw=True)))
        except (IOError, ConfigParser.ParsingError), e:
            print >> sys.stderr, "Failed to read configuration %s\n%s" % (config_file, e)
            sys.exit(1)
    if not config.get('email') or not config.get('password'):
        log.info('email or password missing from config, checking .netrc')
        auth = netrc().authenticators('google.com')
        if auth:
            login = auth[0]
            password = auth[2]
            if not config.get('email'):
                config['email'] = login
            if not config.get('password'):
                config['password'] = password
        else:
            log.info('No match in .netrc')

        config.cache_filename = realpath(expanduser(config.cache_filename))

        log.debug(config)
    return config

def main():
    class MyParser(optparse.OptionParser):
        def format_epilog(self, formatter):
            return self.epilog
    usage = 'usage: %prog [options] <command> [<arg>]'
    description = 'Search you Google contacts from mutt or the command-line.'
    epilog = '''\
Commands:
  add              Add the senders address to contacts, reads a mail from STDIN.
  reload           Force reload of the cache.
  query <query>    Search contacts using query (regex).
  config-template  Prints a template for .goobookrc to STDOUT

'''
    parser = MyParser(usage=usage, description=description, epilog=epilog)
    parser.set_defaults(config_file=CONFIG_FILE)
    parser.add_option("-c", "--config", dest="config_file",
                    help="Specify alternative configuration file.", metavar="FILE")
    parser.add_option("-v", "--verbose", dest="logging_level", default=logging.ERROR,
                    help="Specify alternative configuration file.",
                    action='store_const', const=logging.INFO)
    parser.add_option("-d", "--debug", dest="logging_level",
                    help="Specify alternative configuration file.",
                    action='store_const', const=logging.DEBUG)
    (options, args) = parser.parse_args()
    if len(args) == 0:
        parser.print_help()
        sys.exit(1)
    logging.basicConfig(level=options.logging_level)
    config = read_config(options.config_file)
    goobk = GooBook(config)
    try:
        cmd = args.pop(0)
        if cmd == "query":
            if len(args) != 1:
                parser.error("incorrect number of arguments")
            goobk.query(args[0].decode(ENCODING))
        elif cmd == "add":
            goobk.add()
        elif cmd == "reload":
            goobk.store(goobk.fetch())
        elif cmd == "config-template":
            print CONFIG_TEMPLATE
        else:
            parser.error('Command not recognized: %s' % cmd)
    except gdata.client.BadAuthentication, e:
        print >> sys.stderr, e # Incorrect username or password
        sys.exit(1)

if __name__ == '__main__':
    main()
