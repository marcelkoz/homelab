#!/usr/bin/env bash
# shell script to setup servers for ansible

USERNAME='ansible'
LOGIN_SHELL='/usr/bin/bash'
PASSWORD_FILE='./ansible_pass'
SUDO_GROUP='sudo' # or wheel, admin etc.

# quit on command fail
set -e

echo
echo '====== USER ======'
echo "Creating user '$USERNAME'"
useradd -m -s $LOGIN_SHELL "$USERNAME"
echo "Adding user '$USERNAME' to group '$SUDO_GROUP'"
usermod -a -G "$SUDO_GROUP" "$USERNAME"
echo "Setting password for '$USERNAME' from $PASSWORD_FILE"
echo "$USERNAME:$(cat $PASSWORD_FILE)" | chpasswd

echo
echo '====== SSH ======'
HOMEDIR=$(getent passwd "$USERNAME" | cut -d: -f6)
echo "Creating .ssh dir for '$USERNAME' at $HOMEDIR"
mkdir $HOMEDIR/.ssh
echo "Creating empty authorized_keys SSH file for '$USERNAME'"
touch $HOMEDIR/.ssh/authorized_keys
echo 'Setting ownership of .ssh dir to '$USERNAME''
chown -R "$USERNAME:$USERNAME" $HOMEDIR/.ssh

echo
echo 'Now create or copy an SSH key for ansible access'
echo "Once that is complete, delete this script and $PASSWORD_FILE"
