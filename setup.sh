#/bin/bash

WWW_USER=vagrant
WWW_GROUP=vagrant
WWW_DIR=/var/www/html
RUNALYZE_DIR="${WWW_DIR}/runalyze"
DB_NAME=runalyze
DB_USER=runalyze
DB_PASSWORD=runalyze123


echo "INSTALLING PACKAGES"
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install git composer gettext mysql-server mysql-client apache2 php5-mysql libapache2-mod-php5 php-gettext


echo "CONFIGURING LOCALES"
locale-gen de_DE.UTF-8


echo "SETTING UP APACHE"
chown "${WWW_USER}:${WWW_GROUP}" "${WWW_DIR}"
sed -i -e "s/^export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=${WWW_USER}/g" \
       -e "s/^export APACHE_RUN_USER=www-data/export APACHE_RUN_GROUP=${WWW_GROUP}/g" \
       /etc/apache2/envvars
service apache2 restart


echo "INSTALLING RUNALYZE"
if [ -d "${RUNALYZE_DIR}/.git" ] ; then
    (cd "${RUNALYZE_DIR}" ; sudo -u "${WWW_USER}" git pull)
else
    sudo -u "${WWW_USER}" git clone https://github.com/Runalyze/Runalyze.git "${RUNALYZE_DIR}"
fi
sudo -u "${WWW_USER}" composer --working-dir="${RUNALYZE_DIR}" install --prefer-dist
sudo -u "${WWW_USER}" php "${RUNALYZE_DIR}/build/build.php" translations
sed -e "s/{config::host}/localhost/g" \
    -e "s/{config::port}/3306/g" \
    -e "s/{config::database}/${DB_NAME}/g" \
    -e "s/{config::username}/${DB_USER}/g" \
    -e "s/{config::password}/${DB_PASSWORD}/g" \
    -e "s/{config::prefix}/runalyze_/g" \
    -e "s/{config::debug}/false/g" \
    -e "s/{config::garminkey}//g" \
    "${RUNALYZE_DIR}/inc/install/config.php" > "${RUNALYZE_DIR}/data/config.php"

echo "SETTING UP DATABASE"
sed -i 's/^bind-address/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
mysql -e "DROP DATABASE IF EXISTS ${DB_NAME}" mysql
mysql -e "CREATE DATABASE ${DB_NAME}" mysql
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* To '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'" mysql
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* To '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}'" mysql
mysql -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" < "${RUNALYZE_DIR}/inc/install/structure.sql"
    
