#!/bin/bash
#set -x

# MySQL:
# https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-sql-distribution/1.16/domibus-msh-sql-distribution-1.16.zip

ZIP_SQL_URL="https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-sql-distribution/1.16"
ZIP_SQL_NAME="domibus-msh-sql-distribution-1.16.zip"

# ked skončí zmaž súbor
TEMP_DIR=$(mktemp -d)
trap 'chmod -R u+w "${TEMP_DIR}"; rm -rf "${TEMP_DIR}"' EXIT

SCRIPT_DIR=$(realpath "$(dirname "$0")")

DB_SERVER=localhost
DB_NAME=domibus
DB_USER=edelivery
DB_PWD=edelivery

echo "Download ... ${ZIP_SQL_NAME}"
wget -q -N ${ZIP_SQL_URL}/${ZIP_SQL_NAME} -P ${SCRIPT_DIR}

DB_EXISTS=$(mysql -h ${DB_SERVER} -u root -sN -e "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '${DB_NAME}'")
if [[ $DB_EXISTS == 1 ]]; then
	echo "Databáza DB.${DB_NAME} uz existuje"
	#exit 1
else
	echo "Vytvorenie databázy DB.${DB_NAME}"

	sudo mysql -h ${DB_SERVER} -u root <<EOF
# drop schema if exists domibus_schema
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS ${DB_USER}@localhost IDENTIFIED BY '${DB_PWD}';
GRANT ALL ON ${DB_NAME}.* TO ${DB_USER}@localhost;
# GRANT XA_RECOVER_ADMIN ON *.* TO ${DB_USER}@localhost;"
# GRANT SUPER ON *.* TO 'edelivery'@'localhost'
SET GLOBAL log_bin_trust_function_creators = 1;
FLUSH PRIVILEGES;
EOF

fi

echo "Extrahovanie SQL skriptov do TEMP"
SQL_SCRIPTS="sql-scripts/5.1.9/mysql"
unzip -qX ${SCRIPT_DIR}/${ZIP_SQL_NAME} ${SQL_SCRIPTS}/* -d ${TEMP_DIR}

echo "Vytvorenie tabuliek DB.${DB_NAME}"
SQL_CREATE_TABLES="mysql-5.1.9.ddl"
mysql -h ${DB_SERVER} -u ${DB_USER} --password=${DB_PWD} ${DB_NAME} < ${TEMP_DIR}/${SQL_SCRIPTS}/${SQL_CREATE_TABLES}

echo "Naplnenie tabuliek DB.${DB_NAME}"
SQL_FILL_DATA="mysql-5.1.9-data.ddl"
mysql -h ${DB_SERVER} -u ${DB_USER} --password=${DB_PWD} ${DB_NAME} < ${TEMP_DIR}/${SQL_SCRIPTS}/${SQL_FILL_DATA}

echo "Pridanie nastavení MySQL servera do my.cnf"
# max_allowed_packet=512M
# innodb_log_file_size=5120M
# default-time-zone='+00:00'