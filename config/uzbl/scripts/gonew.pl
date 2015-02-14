#!/usr/bin/perl

my @cmd = @ARGV;
my $fifo = $ENV{'UZBL_FIFO'};


#If there are no dots in the first word or more than one word is suppllied expect a phrase for google. Else go to the uri specified.
if (index(@cmd[0], '.') == -1 || scalar @cmd > 1)
{
        # Replace this with your search engine
	qx(uzbl-browser --uri "http://www.google.com/search?q=@ARGV");
}
else
{
	qx(uzbl-browser --uri @cmd");
}
