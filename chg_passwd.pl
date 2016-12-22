#!/usr/bin/perl
use strict;												# Use strict pragma throughout code
use Expect;												# Use the Expect.pm perl module

my $logfile = "password.change.info";			# Name and location of the logfile
my $timeout = "20";									# Expect timeout threshold
my $ssh_sudo_login_user = "";						# Remote machine ssh/sudo login name
															#		(must be same across all machines)
my $cur_ssh_sudo_password = "";					# Remote machine ssh/sudo password
my $passwd_chg_user = "";							# User for which the password will be changed for
my $new_ssh_sudo_password = "";	# Final new password for affected user
my ($tmppass, $pass_match_err, $pass_charac_err, $pass_reuse_err, $user_exist_err);	# Variable declarations
my %remote_host_new_password = (					# Hash that contains server names and final passwords
	usadvxcp2 => $new_ssh_sudo_password,
	usadvxcp1 => $new_ssh_sudo_password,
	xcpbackup => $new_ssh_sudo_password,
	adsmsrvr => $new_ssh_sudo_password,
	ieftpnd1 => $new_ssh_sudo_password,
	ieftpnd2 => $new_ssh_sudo_password,
	ieftp3 => $new_ssh_sudo_password,
	ieftp5 => $new_ssh_sudo_password,
	ieftp6 => $new_ssh_sudo_password,
	qaaixc082 => $new_ssh_sudo_password,
	qaaixc083 => $new_ssh_sudo_password,
	qaaixc085 => $new_ssh_sudo_password,
	ieftpint2 => $new_ssh_sudo_password,
	ieasnd001 => $new_ssh_sudo_password,
	ieasnd002 => $new_ssh_sudo_password,
	ieasws001 => $new_ssh_sudo_password,
	ieasws002 => $new_ssh_sudo_password,
	ieftpbk => $new_ssh_sudo_password,
	profsrvr => $new_ssh_sudo_password,
	rout959 => $new_ssh_sudo_password,
	rout968 => $new_ssh_sudo_password,
	pkigw => $new_ssh_sudo_password,
	pkireg => $new_ssh_sudo_password,
	cinema1 => $new_ssh_sudo_password,
	cinema2 => $new_ssh_sudo_password,
	ddamqtst => $new_ssh_sudo_password,
	ddamq01 => $new_ssh_sudo_password,
	ddamq02 => $new_ssh_sudo_password,
	bsdas => $new_ssh_sudo_password,
);

# Steps through each defined server from above above
while ((my $remote_host, my $new_password) = each(%remote_host_new_password)) {
	$pass_match_err = 0;								# Init/reset the password match error flag
	$pass_charac_err = 0;							# Init/reset the password characteristic error flag
	$pass_reuse_err = 0;								# Init/reset the password resue error flag
	$user_exist_err = 0;								# Init/reset the user does not exist error flag
	my @pass_array = ("qaz12wsx", "edc34rfv", "tgb56yhn", "ujm78iko");	# Temp password array
	push(@pass_array, $new_password);			# Add the final password to end of temp password array

	foreach (@pass_array) {							# Steps through each value of the temp pass array
		$tmppass = "$_";								# Set the $tmppass variable to the current iteration
		my $spawn_ok;									# Flag that determines if the session opened correctly
		my $sudo_executed_flag = 0;				# Init/reset the sudo command execution flag
		my $pass_changed = 0;						# Init/reset the password changed flag
		my $ssh_session = new Expect;				# Create and declare the Expect object to work with

		#$ssh_session->exp_internal(1);			# Display debugging information
		$ssh_session->spawn("ssh -l $ssh_sudo_login_user $remote_host")	# Spawn the SSH session
			or die "Cannot spawn ssh: $!\n";;
		$ssh_session->expect($timeout,			# Start "Expecting" on output of spawned SSH session
			[
			'\'s password\:',							# If `'s password:` is found:
			sub {
				my $cmd = shift;
				$cmd->send("$cur_ssh_sudo_password\n");	# Send login password
				exp_continue;										# Continue the "Expect" object
			}
			],
			[
			']\$',										# If `]$` (non-root command prompt) is found:
			sub { 
				my $cmd = shift;
				if ($sudo_executed_flag != 1) {	# If sudo command has not been executed then
					$cmd->send("sudo -k\n");		# 		Send sudo pwd revocation to clean up session
					$cmd->send("sudo su -\n");		# 		Send sudo login command
					$sudo_executed_flag = 1;		# 		Set sudo command execution flag to true
				}
				exp_continue;							# Continue the "Expect" object
			}
			],
			[
			'^Password\:',								# If `Password:` is found at the beginning of line:
			sub { 
				my $cmd = shift;
				$cmd->send("$cur_ssh_sudo_password\n");	# Send current ssh/sudo password
				exp_continue;							# Continue the "Expect" object
			}
			],
			[
			'^3004-687 User',
			sub { 										# If user does not exist error is detected:
				$user_exist_err = 1;					# Set user does not exist flag to true
				@pass_array = "";						# Clear the password array to exit 'foreach' loop
				my $cmd = shift;
				$cmd->soft_close();					# Close the "Expect" object cleanly
			}
			],
			[
			'\[\/\]\#',									# If `[/]#` (root command prompt) is found:
			sub { 
				if ($pass_changed == 0) {			# If password has NOT been changed then:
					my $cmd = shift;
					$cmd->send("passwd $passwd_chg_user\n");	# Send change password command
					exp_continue;										# Continue the "Expect" object
				} elsif ($pass_changed == 1) {	# If password has been changed then:
					if ($passwd_chg_user ne "root") {			# If user that had pwd chg'ed is NOT 'root'
						my $cmd = shift;
						$cmd->send("pwdadm \-c $passwd_chg_user\n");	# Remove the ADMCHG flag for user
						$pass_changed = 2;									# Ensure the this is only done once
						exp_continue;										# Continue with "Expect" object
					}
				} else {									# Clean up after everything else has been done
					my $cmd = shift;
					$cmd->send_slow(1, "\n");		# Send a single carriage return to ensure all
				}											# 		commands have been sent successfully
			}
			],
			[
			'^3004-600 The password entry does not match\, please try again.',
			sub { 										# If password match error is detected:
				$pass_match_err = 1;					# Set password match error to true
				my $cmd = shift;
				$cmd->soft_close();					# Close the "Expect" object cleanly
			}
			],
			[
			'^3004-602 The required password characteristics are\:',
			sub { 										# If password characteristic error is detected:
				$pass_charac_err = 1;				# Set password characteristic error to true
				my $cmd = shift;
				$cmd->soft_close();					# Close the "Expect" object cleanly
			}
			],
			[
			'^3004-314 Password was recently used and is not valid for reuse.',
			sub { 										# If password reuse error is detected:
				$pass_reuse_err = 1;					# Set password reuse error to true
				my $cmd = shift;
				$cmd->soft_close();					# Close the "Expect" object cleanly
			}
			],
			[
			'\'s New password\:',			# If `'s New password:` (response to 'passwd' cmd) is found:
			sub {
				my $cmd = shift;
				$cmd->send("$tmppass\n");	# Send new password (temp/final) in response
				exp_continue;					# Continue the "Expect" object
			}
			],
			[
			'^Enter the new password again\:',
			sub { 						# If `Enter the new password again:` is found at begin of line:
				my $cmd = shift;
				$cmd->send("$tmppass\n");	# Send new password (temp/final) a second time to verify
				$pass_changed = 1;			# Set $pass_changed to true
				exp_continue;					# Continue the "Expect" object
			}
			],
			[
			'^Re-enter',				# If `Re-enter` (an odd case for USADVXCP2) is found:
			sub { 
				my $cmd = shift;
				$cmd->send("$tmppass\n");	# Send new password (temp/final) a second time to verify
				$pass_changed = 1;			# Set $pass_changed to true
				exp_continue;					# Continue the "Expect" object
			}
			],
			[
			eof =>						# Detect premature EOF conditions and log to logfile
			sub {
				if ($spawn_ok) {
					`echo "An error has occured on \`date\` on $remote_host." >> $logfile`;
					`echo "ERROR: premature EOF in login." >> $logfile`;
					#die "ERROR: premature EOF in login.\n";
				} else {
					`echo "An error has occured on \`date\` on $remote_host." >> $logfile`;
					`echo "ERROR: could not spawn ssh." >> $logfile`;
					#die "ERROR: could not spawn ssh.\n";
				}
			}
			],
			[
			timeout =>					# Detect a timeout condition and log to logfile
			sub {
				`echo "A timeout has occurred on \`date\` trying to connect to $remote_host." >> $logfile`;
				#die "TIMEOUT!!!.\n";
			}
			],
			'-re', qr'\[\/\]\#',		# Wait for shell prompt `[/]#` and close "Expect" object
		);

		if ($passwd_chg_user eq $ssh_sudo_login_user) {
			$cur_ssh_sudo_password = $tmppass;	# Set ssh/sudo login password to the temp password
		}

	}

	if ($pass_charac_err) {			# Report various error conditions via logfile
		`echo "\`date\`:  [ERROR] PASS_CHARAC_ERR  The password for '$passwd_chg_user' could not be changed on $remote_host." >> $logfile`;
	} elsif ($pass_reuse_err) {
		`echo "\`date\`:  [ERROR] PASS_REUSE_ERR  The password for '$passwd_chg_user' could not be changed on $remote_host." >> $logfile`;
	} elsif ($pass_match_err) {
		`echo "\`date\`:  [ERROR] PASS_MATCH_ERR  The password for '$passwd_chg_user' could not be changed on $remote_host." >> $logfile`;
	} elsif ($user_exist_err) {
		`echo "\`date\`:  [ERROR] USER_EXIST_ERR  The user '$passwd_chg_user' does not exist on $remote_host." >> $logfile`;
	} else {
		`echo "\`date\`:  [INFO]  The password for '$passwd_chg_user' was changed on $remote_host." >> $logfile`;
	}

}

`echo >> $logfile`;					# Echo a blank line in logfile
