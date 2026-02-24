#!/bin/bash

# debug 
#set -x

# Downloading Resources
# Tomcat:
# https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.1.9/
# - domibus-msh-distribution-5.1.9-tomcat-full.zip
# - domibus-msh-distribution-5.1.9-tomcat-war.zip
# - domibus-msh-distribution-5.1.9-tomcat-configuration.zip
# Other:
# https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.1.9/
# - domibus-msh-distribution-5.1.9-sample-configuration-and-testing.zip
# - domibus-msh-distribution-5.1.9-default-jms-plugin.zip
# - domibus-msh-distribution-5.1.9-default-ws-plugin.zip
# - domibus-msh-distribution-5.1.9-default-fs-plugin.zip
# MySQL:
# https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-sql-distribution/1.16/
# - domibus-msh-sql-distribution-1.16.zip
#
# MySQL JDBC driver:
# https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-9.6.0.zip
# https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j_9.6.0-1ubuntu24.04_all.deb


ZIP_DOMIBUS_URL="https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.1.9"

DOMIBUS_NAME="domibus"
INSTALL_DIR=~/opt
DOMIBUS_DIR=${INSTALL_DIR}/${DOMIBUS_NAME}
SCRIPT_DIR=$(realpath "$(dirname "$0")")

# stiahni inštalačné súbory
ZIP_FILES+=("domibus-msh-distribution-5.1.9-tomcat-full.zip")
ZIP_FILES+=("domibus-msh-distribution-5.1.9-tomcat-war.zip")
ZIP_FILES+=("domibus-msh-distribution-5.1.9-tomcat-configuration.zip")
ZIP_FILES+=("domibus-msh-distribution-5.1.9-sample-configuration-and-testing.zip")
ZIP_FILES+=("domibus-msh-distribution-5.1.9-default-jms-plugin.zip")
ZIP_FILES+=("domibus-msh-distribution-5.1.9-default-ws-plugin.zip")
ZIP_FILES+=("domibus-msh-distribution-5.1.9-default-fs-plugin.zip")

ZIP_JDBC_URL="https://dev.mysql.com/get/Downloads/Connector-J"
ZIP_JDBC_NAME="mysql-connector-j-9.6.0.zip"
JDBC_NAME="mysql-connector-j-9.6.0"



# FUNCTION:  zkontroluj či result je 'N'. Ak ano ukonči
VerifyResult() {
	if [[ "$result" != "" ]]; then
		echo ""
	fi
	if [[ "$result" == [Nn] ]]; then
		echo "Instalacia prerušená"
		exit 1
	fi
}

# ---------------------------------------
if [ -d ${DOMIBUS_DIR} ]; then
	read -n 1 -p "Zmazať existujucu instalaciu DOMIBUS na PC? [Y/n] " result
	VerifyResult $result
	
	rm -rf ${DOMIBUS_DIR}
fi


# ---------------------------------------
for ZIP_FILE in "${ZIP_FILES[@]}"; do
	echo "Download ... ${ZIP_FILE}"
	wget -q -N ${ZIP_DOMIBUS_URL}/${ZIP_FILE} -P ${SCRIPT_DIR}
	#wget -q -nc ${ZIP_DOMIBUS_URL}/${ZIP_FILE} -P ${SCRIPT_DIR}
done

read -n 1 -p "Nainstalovat DOMIBUS na PC? [Y/n] " result
VerifyResult $result

# ---------------------------------------
# rozbal domibus do cielovaho adresara
read -n 1 -p "Rozbaliť DOMIBUS do ${DOMIBUS_DIR}? [Y/n] " result
VerifyResult $result

DOMIBUS_FULL=${SCRIPT_DIR}/"domibus-msh-distribution-5.1.9-tomcat-full.zip"
unzip -q ${DOMIBUS_FULL} "${DOMIBUS_NAME}/*" -d ${INSTALL_DIR}

# ---------------------------------------
echo "Download ... ${ZIP_JDBC_NAME}"
wget -q -N ${ZIP_JDBC_URL}/${ZIP_JDBC_NAME} -P ${SCRIPT_DIR}

echo "Add MySQL JDBS driver ... ${ZIP_JDBC_NAME}"
unzip -j -q ${SCRIPT_DIR}/${ZIP_JDBC_NAME} "${JDBC_NAME}/${JDBC_NAME}.jar" -d ${DOMIBUS_DIR}/lib

# ---------------------------------------
# read -n 1 -p "Vytvoriť MySQL databázu DOMIBUS? [Y/n] " result
# VerifyResult $result
# source ${SCRIPT_DIR}/domibus_install_mysql.sh
# ---------------------------------------
echo "Instalacia ukončená"
exit 0