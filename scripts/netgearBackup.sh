#!/usr/bin/expect -f

set deviceUser [lindex $argv 0]
set devicePass [lindex $argv 1]
set device [lindex $argv 2]
set serverUser [lindex $argv 3]
set serverPass [lindex $argv 4]
set server [lindex $argv 5]
set stamp [clock format [clock seconds] -format %Y-%m-%d]

spawn ssh $deviceUser@$device
expect "*password: "
send "$devicePass\r"
expect "*>"
send "enable\r"
# startup-config
expect "*#"
send "copy nvram:startup-config sftp://$serverUser@$server/home/$serverUser/$device/$stamp/startup-config\r"
expect "Password:"
send "$serverPass\r"
expect "Are you sure you want to start? (y/n) "
send "y"
# errorlog
expect "File transfer operation completed successfully."
send "copy nvram:errorlog sftp://$serverUser@$server/home/$serverUser/$device/$stamp/errorlog\r"
expect "Password:"
send "$serverPass\r"
expect "Are you sure you want to start? (y/n) "
send "y"
# log
expect "File transfer operation completed successfully."
send "copy nvram:log sftp://$serverUser@$server/home/$serverUser/$device/$stamp/log\r"
expect "Password:"
send "$serverPass\r"
expect "Are you sure you want to start? (y/n) "
send "y"
# Log out
expect "File transfer operation completed successfully."
send "exit\r"
expect "*>"
send "quit\r"
expect "Connection to $device closed."
exit