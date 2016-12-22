#!/usr/bin/perl
use CPAN;
# list all modules on my disk that have newer versions on CPAN
for $mod (CPAN::Shell->expand("Module","/./")){
	next unless $mod->inst_file;
	next if $mod->uptodate;
	printf "Module %s is installed as %s, could be updated to %s from CPAN\n",
	$mod->id, $mod->inst_version, $mod->cpan_version;
}
