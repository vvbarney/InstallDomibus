#!/bin/sh
#Please change CATALINA_HOME to the right folder
export CATALINA_HOME=/home/vlado/opt/domibus
export CATALINA_TMPDIR=<temp_directory_path>
export JAVA_OPTS="$JAVA_OPTS -Xms128m -Xmx1024m"
export JAVA_OPTS="$JAVA_OPTS -Ddomibus.config.location=$CATALINA_HOME/conf/domibus"

#JAVA_OPTS="$JAVA_OPTS -Xms4096m -Xmx4096m -Ddomibus.config.location=$CATALINA_HOME/conf/domibus"

