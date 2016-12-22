#!/usr/bin/perl
die "File $ARGV[0] doesn't exist" unless -f $ARGV[0];
use MP3::Mplib;
my $mp3 = MP3::Mplib->new($ARGV[0]);
my $v2tag = $mp3->get_v2tag;
print "Error writing tags of $ARGV[0]\n" unless $mp3->set_v2tag($v2tag,&UTF8);
