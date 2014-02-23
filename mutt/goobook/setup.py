#!/usr/bin/env python
# vim: fileencoding=UTF-8 filetype=python ff=unix expandtab sw=4 sts=4 tw=120
# author: Christer Sjöholm -- goobook AT furuvik DOT net

from distribute_setup import use_setuptools
use_setuptools()

from setuptools import setup, find_packages
class UltraMagicString(object):
    ''' Stolen from http://stackoverflow.com/questions/1162338/whats-the-right-way-to-use-unicode-metadata-in-setup-py

    Catch-22:
    - if I return Unicode, python setup.py --long-description as well
      as python setup.py upload fail with a UnicodeEncodeError
    - if I return UTF-8 string, python setup.py sdist register
      fails with an UnicodeDecodeError
    '''

    def __init__(self, value):
        self.value = value

    def __str__(self):
        return self.value

    def __unicode__(self):
        return self.value.decode('UTF-8')

    def __add__(self, other):
        return UltraMagicString(self.value + str(other))

    def split(self, *args, **kw):
        return self.value.split(*args, **kw)

setup(name='goobook',
      version = '1.3',
      description = 'Search your google contacts from mutt.',
      long_description=UltraMagicString(open('README.txt').read()),
      maintainer = UltraMagicString('Christer Sjöholm'),
      maintainer_email = 'goobook@furuvik.net',
      url = 'http://goobook.googlecode.com/',
      classifiers = [f.strip() for f in """
        Development Status :: 5 - Production/Stable
        Environment :: Console
        Operating System :: OS Independent
        Programming Language :: Python
        Programming Language :: Python :: 2.6
        Intended Audience :: End Users/Desktop
        License :: OSI Approved :: GNU General Public License (GPL)
        Topic :: Communications :: Email :: Address Book
        """.splitlines() if f.strip()],
      license = 'GPLv3',
      install_requires = [
          'gdata>=2.0.7',
          'simplejson>=2.1.0'],
      packages = find_packages(),
      entry_points = {'console_scripts': [ 'goobook = goobook.goobook:main']}
     )

