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

print "\nEnter the first command:  ";
chomp(my $root_cmd1 = <STDIN>);

print "Enter the second command (leave blank for nothing):  ";
chomp(my $root_cmd2 = <STDIN>);

print "Enter the third command (leave blank for nothing):  ";
chomp(my $root_cmd3 = <STDIN>);

my @hosts = (
	# RedHat
	##'ccsprd1',
	#'intblade03', 'intblade04', 'intblade05', 'intblade06',
	#'intblade07', 'intblade08', 'intblade09', 'intblade10', 'intblade11',
	#'intlin1dev', 'intlin1stg', 'intlin5dev', 'intlin6dev', 'intlin7dev',
	#'intportal01', 'lin3dev',
	##'linmailscan1prd', 'linmailscan2prd',
	#'linpsapp1stg', 'linpsapp2prd',
	#'linpsapp2stg', 'linpsas1prd', 'linpsas1stg', 'linpsdb1prd', 'linpsdb1stg',
	#'linpsweb1prd', 'linpsweb1stg', 'lintrf1prd', 'lintrf1stg', 'lintrf2prd',
	#'lintrf2stg', 'ltlin1prd', 'r54e1b2-lin', 'r54e1b3-lin', 'r54e1b4-lin',
	#'ssi1l1', 'ssi5l1', 'ssi5l2', 'ssi9l1', 'ssi9l2',
	#'ssicap5l1', 'ssicap5l2', 'ssicdb5l1', 'ssipsapp5l', 'ssipsapp9l',
	#'ssipsdb5l', 'ssipsdb9l',
	# SuSE
	"mstapp001", "mstapp002", "mstapp003", "mstapp004", "mstapp005",
	"mstapp006", "mstapp007", "mstapp008", "mstapp009", "mstapp010",
	"mstapp011", "mstapp012", "mstapp013", "mstapp014", "mstapp015",
	"mstapp016", "mstapp017", "mstapp018", "mstapp019", "mstapp020",
	"mstapp021",
	#"mstapp022",
	"mstapp023",
	#"mstapp024",
	"mstapp025", "mstapp026", "mstapp027", "mstapp028", "mstapp029",
	"mstapp030", "mstapp031", "mstapp032", "mstapp033", "mstapp034",
	"mstapp035", "mstapp036", "mstapp037", "mstapp038", "mstapp039",
	"mstapp040", "mstapp041", "mstapp042", "mstapp043", "mstapp044",
	"mstapp045", "mstapp046", "mstapp047",
	#"mstapp048",
	"mstapp049", "mstapp050", "mstapp051", "mstapp052", "mstapp053",
	"mstapp054", "mstapp055", "mstapp056", "mstapp057", "mstapp058",
	"mstapp059", "mstapp060", "mstapp061", "mstapp062", "mstapp063",
	"mstapp064", "mstapp065", "mstapp066", "mstapp067", "mstapp068",
	"mstapp069", "mstapp070", "mstapp071", "mstapp072",
	#'atslin2prd', 'atsnovl', 'digcerttest', 'egnp01prd', 'egnp02prd',
	#'egnp03prd', 'egnp04prd', 'egnp05prd', 'egnp06prd', 'ibmpoc01',
	#'ibmpoc02', 'ibmpoc03', 'ibmpoc04', 'ibmpoc05', 'ibmpoc06',
	#'intlin1test', 'intlin2dev', 'intlin3dev', 'intlin4dev', 'linasys1prd',
	#'lincasdapp1dev', 'lincasdapp1prd', 'lincasddb1prd', 'lincasddb1stg', 'lincasddb2prd',
	#'lincasdweb1prd', 'lincasdweb2prd', 'lindeg1prd', 'lindeg2prd', 'lindeg3prd',
	#'lindeg4prd', 'lindsk1dev', 'lindsk1prd', 'lindsk1stg', 'lindsk2prd',
	#'lindsk2stg', 'lindvr1dev', 'lindvr2prd', 'lindvr3prd', 'linedir2prd',
	#'linedir3prd', 'linetcps1dev', 'linetcps1stg', 'liniba1dev', 'liniba1lt',
	#'liniba1prd', 'liniba1stg', 'liniba2prd', 'liniba2stg', 'liniem1prd',
	#'liniem2prd', 'lininf1dev', 'lininf1prd', 'lininf2prd', 'linins1dev',
	#'linins1prd', 'linins2prd', 'linins3prd', 'linins4prd', 'linins5prd',
	#'linins6prd', 'linoda1prd', 'linoda2prd', 'linoda3prd', 'linoda4prd',
	#'linora1prd', 'linsod1prd', 'linsod1stg', 'linsod2prd', 'lintrf1dev',
	#'lintrf1trn', 'lintrf2dev', 'lintrf3dev', 'lintrf3prd', 'lintrf3stg',
	#'lintrf4dev', 'lintrf4prd', 'lintrf4stg', 'lintrf5dev', 'lintrf5prd',
	#'lintrf6prd', 'lintrf7dev', 'lintrf7prd', 'lintrf8prd', 'lintrf9prd',
	#'linweb10prd', 'linweb11prd', 'linweb1lt', 'linweb3stg', 'linweb4prd',
	#'linweb4stg', 'linweb5prd', 'linweb6prd', 'linweb6stg', 'linweb7prd',
	#'linweb7stg', 'linweb8prd', 'linweb8stg', 'linweb9prd', 'linweb9stg',
	#'linwsg1prd', 'linwsg1stg', 'linwsg2prd', 'linwsg2stg', 'modlin1prd',
	##'r54e1b1-lin',
	#'r54e1b8-lin', 'r54e2b1-lin', 'r54e2b2-lin', 'r54e2b3-lin',
	#'ratl3prd', 'ratl4prd', 'strcomm02-orangeline', 'tudev09', 'tudev10',
	#'tudev11', 'tudev12', 'tudev13', 'tudev14', 'tudev21',
	#'tudev22', 'tudev23', 'tudev24', 'tudev25', 'tudev26',
	#'tudev27', 'tudev28', 'tudev29', 'tudev30', 'tudev31',
	#'tudev32',
	# AIX
	#'tunim01',
	#'tuapp01', 'tuapp02', 'tuapp03', 'tuapp04', 'tuapp05',
	#'tuapp06', 'tuapp07', 'tuapp08', 'tuapp09', 'tuapp10',
); 

foreach my $remote_host (@hosts) {

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
#	$ssh_session->exp_internal(1);
#	$ssh_session->max_accum(80);
#	$ssh_session->raw_pty(1);
#	$ssh_session->slave->stty(qw(raw -echo));
	$ssh_session->log_file("/tmp/sudo_log");
	$ssh_session->log_group(0);
	$ssh_session->log_user(0);
	$ssh_session->log_stdout(1);
	$ssh_session->spawn("ssh -q $ssh_sudo_user\@$remote_host")
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
		[ qr/(\[root\@$remote_host\] \/ \#|^$remote_host:~ \#|\[root\@$remote_host.*\]\#|^$remote_host:.*\>)/,   sub {
			if ($command1_flag == 0 && $command2_flag == 0 && $command3_flag == 0) {
				my $self = shift;
				$self->send("$root_cmd1\n");
				$command1_flag = 1;
				exp_continue;
			} elsif ($command1_flag == 1 && $command2_flag == 0 && $command3_flag == 0) {
				my $self = shift;
				$self->send("$root_cmd2\n");
				$command2_flag = 1;
				exp_continue;
			} elsif ($command1_flag == 1 && $command2_flag == 1 && $command3_flag == 0) {
				my $self = shift;
				$self->send("$root_cmd3\n");
				$command3_flag = 1;
				exp_continue;
			} elsif ($command1_flag == 1 && $command2_flag == 1 && $command3_flag == 1) {
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
