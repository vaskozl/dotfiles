#!/usr/bin/env perl
my $url = $ENV{'UZBL_URI'};
exec "mpv '$url'"

