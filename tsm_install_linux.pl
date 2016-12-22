#!/usr/bin/perl
use strict;
use Expect;
use Term::ReadKey;

my $timeout = "60";

print "Enter your username:  ";
chomp(my $ssh_sudo_user = <STDIN>);

print "Enter your password:  ";
ReadMode(2);
chomp(my $ssh_sudo_password = <STDIN>);
ReadMode(0);

my @hosts = (
'CHANGEME',
); 

foreach my $remote_host (@hosts) {

	my @output;
	my $os_type;
	my $spawn_ok;
	my $revoke_sudo_executed_flag = 0;
	my $sudo_executed_flag = 0;
	my $command1_flag = 0;
	my $command2_flag = 0;
	my $command3_flag = 0;
	my $root_exit_flag = 0;
	my $ssh_session = new Expect;
	my $revoke_sudo_cmd = "sudo -k";
	my $sudo_cmd = "sudo su -";
	my $exit_cmd = "exit";
	my $install_complete = 0;
	my $root_cmd1 = "if [ \$\(uname -m\) == 'x86_64' ]; then rpm -e TIVsm-BA TIVsm-API TIVsm-API64; rpm --force -Uhv http://10.2.15.21/tsm/linux/TIVsm-API.i386.rpm http://10.2.15.21/tsm/linux/TIVsm-API64.i386.rpm http://10.2.15.21/tsm/linux/TIVsm-BA.i386.rpm; else rpm -e TIVsm-BA TIVsm-API; rpm --force -Uhv http://10.2.15.21/tsm/linux/TIVsm-API.i386.rpm http://10.2.15.21/tsm/linux/TIVsm-BA.i386.rpm; fi";
	my $root_cmd2 = "touch /opt/tivoli/tsm/client/ba/bin/dsm.sys; chown 24063:2426 /opt/tivoli/tsm/client/ba/bin/dsm.sys; chmod 644 /opt/tivoli/tsm/client/ba/bin/dsm.sys; touch /opt/tivoli/tsm/client/ba/bin/dsm.opt; chown 24063:2426 /opt/tivoli/tsm/client/ba/bin/dsm.opt; chmod 644 /opt/tivoli/tsm/client/ba/bin/dsm.opt; touch /opt/tivoli/tsm/client/ba/bin/inclexcl.txt; chown 24063:2426 /opt/tivoli/tsm/client/ba/bin/inclexcl.txt; chmod 644 /opt/tivoli/tsm/client/ba/bin/inclexcl.txt; install -d -g 2426 /opt/tivoli/tsm/logs; chmod g+s /opt/tivoli/tsm/logs; touch /opt/tivoli/tsm/logs/{dsmerror.log,dsmprune.log,dsmsched.log,dsmwebcl.log}; chmod 666 /opt/tivoli/tsm/logs/{dsmerror.log,dsmprune.log,dsmsched.log,dsmwebcl.log}; wget http://10.2.15.21/js/bin/tsm_sched_restart.ksh -O /usr/local/bin/tsm_sched_restart.ksh; chmod 544 /usr/local/bin/tsm_sched_restart.ksh";
	my $root_cmd3 = "if ! grep -i suse /etc/*release > /dev/null 2>&1; then if ! egrep 'tsm_sched|dsmcad' /etc/rc.local > /dev/null 2>&1; then echo '/usr/local/bin/tsm_sched_restart.ksh &' >> /etc/rc.local; fi; else if ! egrep 'tsm_sched|dsmcad' /etc/init.d/boot.local > /dev/null 2>&1; then echo '/usr/local/bin/tsm_sched_restart.ksh &' >> /etc/init.d/boot.local; fi; fi; /usr/local/bin/tsm_sched_restart.ksh; if ! grep 'tsm9grp' /etc/sudoers > /dev/null 2>&1; then echo -e \"\n#TSM Administration Section\n%tsm9grp ALL = /bin/su - tsm9appl\n%tsm9grp ALL = /usr/local/bin/tsm_sched_restart.ksh\n%tsm9grp ALL = /usr/local/bin/tsm_sta_restart.ksh\n%tsm9grp ALL = /opt/tivoli/tsm/client/ba/bin/dsmc\n%tsm9grp ALL = /bin/ls\n%tsm9grp ALL = /usr/tivoli/tsm/client/ba/bin/dsmc\n%tsm9grp ALL = /usr/bin/ls\" >> /etc/sudoers; fi";


#	$ssh_session->exp_internal(1);
#	$ssh_session->max_accum(80);
#	$ssh_session->raw_pty(1);
	$ssh_session->log_file("tsm_install_linux.log");
	$ssh_session->log_group(0);
	$ssh_session->log_user(0);
	$ssh_session->log_stdout(1);
	$ssh_session->spawn("ssh -q -o NumberOfPasswordPrompts=1 -o PubkeyAuthentication=no $ssh_sudo_user\@$remote_host")
		or die "Cannot spawn ssh: $!\n";;
	$ssh_session->expect($timeout,
		[ qr/\[$ssh_sudo_user\@$remote_host.*\]\$ /, sub { 
			if ($revoke_sudo_executed_flag == 0 && $sudo_executed_flag == 0) {
				my $self = shift;
				$self->send("$revoke_sudo_cmd\n");
				$revoke_sudo_executed_flag = 1;
				$spawn_ok = 1;
				exp_continue;
			} elsif ($revoke_sudo_executed_flag == 1 && $sudo_executed_flag == 0) {
				my $self = shift;
				$self->send("$sudo_cmd\n");
				$sudo_executed_flag = 1;
				exp_continue;
			} elsif ($root_exit_flag == 1) {
				my $self = shift;
				$self->send("$exit_cmd\n");
			}
		} ],
		[ qr/\(yes\/no\)\?\s*$/, sub {
			my $self = shift;
			$self->send("yes\n");
			exp_continue;
		} ],
		[ qr/REMOTE HOST IDEN/, sub {
			print "FIX: .ssh/known_hosts\n";
			exp_continue;
		} ],
		[ qr/\'s password:/i, sub {
			my $self = shift;
			$self->send("$ssh_sudo_password\n");
			exp_continue;
		} ],
		[ qr/^Password:/, sub { 
			my $self = shift;
			$self->send("$ssh_sudo_password\n");
			exp_continue;
		} ],
		[ qr/(\[root\@$remote_host\] \/ \#|^$remote_host:~ \#|\[root\@$remote_host.*\]\#|^$remote_host:.*\>)/,	sub { 
			if ($command1_flag == 0 && $command2_flag == 0 && $command3_flag == 0 && $install_complete == 0) {
				my $self = shift;
				$self->send("$root_cmd1\n");
				$command1_flag = 1;
				$install_complete = 1;
				exp_continue;
			} elsif ($command1_flag == 1 && $command2_flag == 0 && $command3_flag == 0 && $install_complete == 1) {
				my $self = shift;
				$self->send("$root_cmd2\n");
				$command2_flag = 1;
				exp_continue;
			} elsif ($command1_flag == 1 && $command2_flag == 1 && $command3_flag == 0 && $install_complete == 1) {
				my $self = shift;
				$self->send("$root_cmd3\n");
				$command3_flag = 1;
				exp_continue;
			} else {
				my $self = shift;
				$self->send("$exit_cmd\n");
				$root_exit_flag = 1;
				exp_continue;
			}
		} ],
		[ eof => sub { print "eof $remote_host\n"; } ],
		[ timeout => sub { print "timeout $remote_host\n";} ],
	);

}
