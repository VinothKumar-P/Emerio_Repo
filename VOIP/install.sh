#!/bin/bash

sudo apt-get update
sudo apt-get install debconf-utils
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password laravel'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password laravel'
sudo apt-get -y install mysql-server php5-mysql
sudo mysql_install_db
sudo /usr/bin/mysql_secure_installation
#nginx install
echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list sudo apt-key adv
--keyserver keyserver.ubuntu.com --recv-keys C300EE8C
sudo apt-get update
sudo apt-get install nginx
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/teachedison
#php install
sudo apt-get install php5-fpm curl php5-cli php5-curl php5-mcrypt openssl git
sudo apt-get install php5-gd
sudo php5enmod mcrypt
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g'/etc/php5/fpm/php.ini
sudo service php5-fpm restart
sudo service nginx restart
#config git
git config --global user.name "username"
git config --global user.email"example@mail.com"
sudo git clone clone_url /VOIP
#composer install
curl -sS https://getcomposer.org/installer | sudo php5 -- --install-dir=/usr/local/bin --filename=composer
#install laravel
cd /VOIP
sudo composer install
#mysql database
MYSQL=`which mysql`
Q1="CREATE DATABASE IF NOT EXISTS dbname;"
Q2="CREATE USER homestead@localhost IDENTIFIED BY 'secret';"
Q3="GRANT ALL PRIVILEGES ON dbname.* TO homestead@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
$MYSQL -uroot -p -e "$SQL"

#laravel table migration
php artisan migrate
