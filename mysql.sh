#!/bin/bash

echo "########################################################"
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password Cjptech@12"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password Cjptech@12"
apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5
cat <<- EOF > /etc/apt/sources.list.d/mysql.list
deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7
EOF
apt-get update
sudo apt-get -qq install expect > /dev/null
apt-get install -y mysql-server
#Restart all services
echo -e "\n"

if [[ $EUID -ne 0 ]]; then
echo "This script must be run as root" 1>&2
   exit 1
fi

#
# Check input params
#
if [ -n "${1}" -a -z "${2}" ]; then
    # Setup root password
    CURRENT_MYSQL_PASSWORD=''
    NEW_MYSQL_PASSWORD="${1}"
elif [ -n "${1}" -a -n "${2}" ]; then
    # Change existens root password
    CURRENT_MYSQL_PASSWORD="${1}"
    NEW_MYSQL_PASSWORD="${2}"
else
    echo "Usage:"
    echo "  Setup mysql root password: ${0} 'your_new_root_password'"
    echo "  Change mysql root password: ${0} 'your_old_root_password' 'your_new_root_password'"
    exit 1
fi

SECURE_MYSQL=$(expect -c "

set timeout 3
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"$CURRENT_MYSQL_PASSWORD\r\"

expect \"root password?\"
send \"y\r\"

expect \"New password:\"
send \"$NEW_MYSQL_PASSWORD\r\"

expect \"Re-enter new password:\"
send \"$NEW_MYSQL_PASSWORD\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"n\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

#
# Execution mysql_secure_installation
#
echo "${SECURE_MYSQL}"
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf
echo "create database cloudviews" | mysql --user=root --password=Cjptech@12
mysql -uroot -pCjptech@12 -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Cjptech@12';" 
exit 0
