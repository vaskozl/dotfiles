:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
GooBook -- Access your Google contacts from the command line.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

.. contents:: **Table of Contents**

-------------------------
About
-------------------------

The purpose of GooBook is to make it possible to use your Google Contacts in
a MUA such as Mutt. It's use mimics that of abook (somewhat).

-------------------------
Installation Instructions
-------------------------

GooBook is only released as a source distribution.

It can be installed using easy_install or pip or manually with the source
tarball.

===================
easy_install or pip
===================

This is the recommended way to install goobook.
If installing this way you will not need to download the source manually.

Run easy_install or pip::

    $ easy_install -U goobook
    $ pip install goobook

easy_install is part of setuptools which should come with most distributions.


===================
Source installation
===================

Download the source tarball, uncompress it, then run the install command::

    $ tar -xzvf goobook-*.tar.gz
    $ cd goobook-*
    $ sudo python ./setup.py install

=========
Upgrading
=========

If you are upgrading from a pre 1.0 version you will have to remove the old
cachefile and create a new configuration.

-----------------------------
Configure
-----------------------------

For most users it will be enough to add an entry to your ~/.netrc::

    machine google.com
      login your@google.email
      password secret

To get access too more settings you can create ~/.goobookrc::

    [DEFAULT]
    # If not given here, email and password is taken from .netrc using
    # machine google.com
    email: user@gmail.com
    password: top secret
    # The following are optional, defaults are shown
    max_results: 9999
    cache_filename: ~/.goobook_cache
    cache_expiry_hours: 24

==============
Proxy settings
==============

If you use a proxy you need to set the https_proxy environment variable.

-----------------------------
Usage
-----------------------------

To query your contacts::

    $ goobook query QUERY

The add command reads a email from STDIN and adds the From address to your Google contacts::

    $ goobook add

The cache is updated automatically according to the configuration but you can also force an update::

    $ goobook reload

==========
Mutt Setup
==========

Set in your .muttrc file::

    set query_command="goobook query '%s'

to query address book. (Normally bound to "Q" key.)

If you want to be able to use <tab> to complete email addresses instead of Ctrl-t add this:

    bind editor <Tab> complete-query

To add email addresses (with "a" key normally bound to create-alias command)::

    macro index,pager a "<pipe-message>goobook add<return>" "add the sender address to Google contacts"

If you want to add an email's sender to Contacts, press a while it's selected in the index or pager.

-----------------------------
Feedback and getting involved
-----------------------------

- Mailing list: http://groups.google.com/group/goobook
- Issue tracker: http://code.google.com/p/goobook/issues/list
- Code Repository: http://code.google.com/p/goobook/source/checkout
