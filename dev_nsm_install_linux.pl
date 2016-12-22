#!/usr/bin/perl
use strict;
use Expect;
use Term::ReadKey;

my $timeout = "40";

print "Enter your username:  ";
chomp(my $ssh_sudo_user = <STDIN>);

print "Enter your password:  ";
ReadMode(2);
chomp(my $ssh_sudo_password = <STDIN>);
ReadMode(0);

my @hosts = (
	'lindsk1stg',
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
	my $root_cmd1 = "awservices stop; unishutdown all; cp -p /etc/sysctl.conf /etc/sysctl.conf.\$(date +%H%M_%m%d%y).NSM; cp -p /etc/profile /etc/profile.\$(date +%H%M_%m%d%y).NSM; mount -o ro 10.2.15.21:/opt/install /mnt; cd /mnt/src/nsm31_xlinux; ./setupNSM";
	my $root_cmd2 = "cd /root; umount /mnt; cat > /opt/CA/UnicenterNSM/atech/services/config/aws_sadmin/aws_sadmin.cfg << DONE
	SNMP_COMMUNITY  public|0.0.0.0|read        # Any host can read with public
	SNMP_COMMUNITY  admin|0.0.0.0|write        # Any host can write using admin
	SNMP_TRAP       127.0.0.1|162              # traps to localhost
	SNMP_TRAP       10.2.8.172|162             # traps to NSMCOL01
	DONE";
	my $root_cmd3 = "cp /opt/CA/UnicenterNSM/atech/services/config/aws_orb/quick.cfg /opt/CA/UnicenterNSM/atech/services/config/aws_orb/quick.cfg.\$(date +%H%M_%m%d%y).BKP; sed 's/^PLUGIN awm_qikpipe aws_orb22/#PLUGIN awm_qikpipe aws_orb22/' /opt/CA/UnicenterNSM/atech/services/config/aws_orb/quick.cfg.\$(date +%H%M_%m%d%y).BKP > /opt/CA/UnicenterNSM/atech/services/config/aws_orb/quick.cfg; source /etc/profile; awservices start; date | mail -s \"NSM installed on $remote_host\" $ssh_sudo_user\@tuc.com";


#	$ssh_session->exp_internal(1);
#	$ssh_session->max_accum(80);
#	$ssh_session->raw_pty(1);
	$ssh_session->log_file("/tmp/nsm_install_log");
	$ssh_session->log_group(0);
	$ssh_session->log_user(0);
	$ssh_session->log_stdout(1);
	$ssh_session->spawn("ssh -o NumberOfPasswordPrompts=1 -o PubkeyAuthentication=no -q $ssh_sudo_user\@$remote_host")
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
		[ qr/Please enter your choice:/, sub { 
			my $self = shift;
			$self->send("4\n");
			exp_continue;
		} ],
		[ qr/Do you want to shutdown Agent Technology\? \(y\/n\) \(default: n\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Is this a remote install\? \(y\/n\) \(default: n\)/, sub { 
			my $self = shift;
			$self->send("n\n");
			exp_continue;
		} ],
		[ qr/Please select a product to install:/, sub { 
			my $self = shift;
			$self->send("4,8\n");
			exp_continue;
		} ],
		[ qr/Please enter your choice \(e.g. 1,3\):/, sub { 
			my $self = shift;
			$self->send("1,4\n");
			exp_continue;
		} ],
		[ qr/The command is located within the license file provided./, sub { 
			my $self = shift;
			$self->send("proceed\n");
			exp_continue;
		} ],
		[ qr/\(\$AGENTWORKS_DIR\) \(default: \/opt\/CA\/UnicenterNSM\/atech\)/, sub { 
			my $self = shift;
			$self->send("/opt/CA/UnicenterNSM/atech\n");
			exp_continue;
		} ],
		[ qr/Do you want it created\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Technology information\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Please enter the name of the owner of the Agent Technology Product:/, sub { 
			my $self = shift;
			$self->send("root\n");
			exp_continue;
		} ],
		[ qr/Press the Enter key to continue.../, sub { 
			my $self = shift;
			$self->send("\n");
			exp_continue;
		} ],
		[ qr/Press \[Enter\] to begin individual agent installations.../, sub { 
			my $self = shift;
			$self->send("\n");
			exp_continue;
		} ],
		[ qr/Do you want to install the Log_A2 agent\? \(y\/n\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/agent's log files\? \(y\/n\) \(default: n\)/, sub { 
			my $self = shift;
			$self->send("n\n");
			exp_continue;
		} ],
		[ qr/Do you want to install the UNIX_Systems agent\? \(y\/n\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Do you want to install the Performance Agents \[y\/n\] \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Allow \/etc\/profile to be updated \?  \[y\/n\] \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/manager \? \[y\/n\] \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Please enter Configuration Machine name:/, sub { 
			my $self = shift;
			$self->send("10.2.8.116\n");
			exp_continue;
		} ],
		[ qr/Please enter Configuration Machine name \[.*\]:/, sub { 
			my $self = shift;
			$self->send("10.2.8.116\n");
			exp_continue;
		} ],
		[ qr/Do you want to install the Process agent\? \(y\/n\)/, sub { 
			my $self = shift;
			$self->send("n\n");
			exp_continue;
		} ],
		[ qr/starts automatically whenever your system is started\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/\(\$CAIGLBL0000\) \(default: \/opt\/CA\/UnicenterNSM\)/, sub { 
			my $self = shift;
			$self->send("/opt/CA/UnicenterNSM\n");
			exp_continue;
		} ],
		[ qr/Do you want setup to modify them for you\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Is it OK to add the caicci port number now\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Do you want to route messages to the Event Manager\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Do you want to activate Store and Forward\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Interface running under Windows-NT\? \(y\/n\) \(default: y\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Enter the name of the node running NSM Worldview \(default: \<cancel\>\)/, sub { 
			my $self = shift;
			$self->send("10.2.8.116\n");
			exp_continue;
		} ],
		[ qr/1.5.  \(y\/n\) \(default: n\)/, sub { 
			my $self = shift;
			$self->send("n\n");
			exp_continue;
		} ],
		[ qr/Please specify the host name for the NSM Manager Node./, sub { 
			my $self = shift;
			$self->send("10.2.8.116\n");
			exp_continue;
		} ],
		[ qr/Please specify the node \( ipaddress or hostname \)/, sub { 
			my $self = shift;
			$self->send("10.2.8.116\n");
			exp_continue;
		} ],
		[ qr/reside\? \( \/etc/, sub { 
			my $self = shift;
			$self->send("\n");
			exp_continue;
		} ],
		[ qr/Do you want to install services\? \(y\/n\) \(default: n\)/, sub { 
			my $self = shift;
			$self->send("y\n");
			exp_continue;
		} ],
		[ qr/Please logout, then login to this machine to initialize the environment./, sub { 
			$install_complete = 1;
			exp_continue;
		} ],
		[ eof => sub { print "eof $remote_host\n"; } ],
		[ timeout => sub { print "timeout $remote_host\n";} ],
	);

}
