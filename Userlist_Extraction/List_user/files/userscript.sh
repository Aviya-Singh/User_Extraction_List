#!/bin/bash
rm -rf /tmp/ansible/userlist /tmp/ansible/sudofile1 /tmp/ansible/sudo_user  /tmp/ansible/finallist* /tmp/ansible/all_userlist /tmp/ansible/all_sudo_user
touch /tmp/ansible/userlist
host=$(hostname)
#date=`date`
echo all_users_$host >> /tmp/ansible/userlist
echo sudo_users_$host >> /tmp/ansible/sudo_user
awk -F':' '{ print $1}' /etc/passwd >> /tmp/ansible/userlist
awk -F' ' '{ print $1}' /etc/sudoers >> /tmp/ansible/sudofile1
awk 'BEGIN { while ( getline < "/tmp/ansible/userlist" ) arr[$0]++ }( $1 in arr )' /tmp/ansible/sudofile1  >> /tmp/ansible/sudo_user
rm -rf /tmp/ansible/sudofile1
awk  '{ printf( "%s ", $1 ); } END { printf( "\n" ); }' /tmp/ansible/userlist >/tmp/ansible/all_userlist
awk  '{ printf( "%s ", $1 ); } END { printf( "\n" ); }' /tmp/ansible/sudo_user >/tmp/ansible/all_sudo_user
rm -rf /tmp/ansible/userlist /tmp/ansible/sudo_user
cat /tmp/ansible/all_userlist /tmp/ansible/all_sudo_user > "/tmp/ansible/finallist"
rm -rf /tmp/ansible/all_userlist /tmp/ansible/all_sudo_user
cat /tmp/ansible/finallist | tr -s '[:blank:]' ',' > "/tmp/ansible/finallist.$(date +%F_%R).$(hostname)"
rm -rf /tmp/ansible/finallist
