#!/bin/bash
sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist
sudo lsof -Pni:69
echo "to push files, create an empty destination file with correct perms"
echo "touch /private/tftpboot/filename"
echo "chmod 766 /private/tftpboot/filename"
echo
echo "to stop tftp, run the following command"
echo "sudo launchctl unload -F /System/Library/LaunchDaemons/tftp.plist"
