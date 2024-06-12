#!/bin/bash

# MySQL root credentials
MYSQL_ROOT_USER='root'
MYSQL_ROOT_PASSWORD='root_possword'

# Darabase and user details

DB_NAME='hbhb_dev_db'
DB_USER='hbnb_dev'
DB_PASSWORD='hbnb_dev_pwd'

#Check if database exists

DB_EXISTS=$(mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" > /dev/null; echo "$?")

# Create database if it doesn't exist
if [ $DB_EXISTS -eq 1 ]; then
    mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME;"
    echo "Database $DB_NAME created."
else
    echo "Database $DB_NAME already exists."
fi

# Check if user exists
USER_EXISTS=$(mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$DB_USER');" | grep "1" > /dev/null; echo "$?")

# Create user if it doesn't exist
if [ $USER_EXISTS -eq 1 ]; then
    mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    echo "User $DB_USER created."
else
    echo "User $DB_USER already exists."
fi

# Grant privileges
mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "GRANT SELECT ON performance_schema.* TO '$DB_USER'@'localhost';"
mysql -u $MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

echo "Privileges granted."
