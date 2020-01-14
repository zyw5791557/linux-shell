#!/usr/bin/expect -f

set timeout 30

set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set email [lindex $argv 3]
set known_hosts [lindex $argv 4]

spawn ssh -l $user $ip

expect {
  "yes/no" {send "yes\r"}
  "password:" {send "$password\r"}
}

expect "~"
send -- "chmod 600 .ssh/id_rsa .ssh/id_rsa.pub\r"
send -- "echo $known_hosts > .ssh/known_hosts\r"
send -- "git config --global user.name $user\r"
send -- "git config --global user.email $email\r"
send -- "exit\r"

expect eof

exit

