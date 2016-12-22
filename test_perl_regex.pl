#!/usr/bin/perl
use strict;

#my $string = "/l/abc123-def456-ghi789";
my $string = "/l/abc1234-def456-ghi789";
#my $string = "/l/a-def456-ghi789";
#my $string = "/r/abc123-def456-ghi789";
#my $string = "/r/a-6-9";

if ($string =~ /\/\D\/[\w]{1,6}[\-][\w]{1,6}[\-][\w]{1,6}/) {
	print "FOUND\n";
}
