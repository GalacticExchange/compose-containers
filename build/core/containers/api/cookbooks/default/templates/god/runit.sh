#!/bin/sh
set -e

exec 2>&1

#exec /opt/god/god start

CONF_FILE=/opt/god/master.conf
DAEMON=/usr/local/rvm/bin/boot_god  # CHANGE it from - which boot_god
PIDFILE=/var/run/god.pid
LOGFILE=/var/log/god/god.log
SCRIPTNAME=/etc/init.d/god
#DEBUG_OPTIONS=" --log-level debug --no-syslog  "
DEBUG_OPTIONS=" --no-syslog  "


#start_cmd="$DAEMON -l $LOGFILE -P $PIDFILE -c $CONF_FILE $DEBUG_OPTIONS -D"
start_cmd="$DAEMON $DEBUG_OPTIONS -c $CONF_FILE -l $LOGFILE  -D"
#start_cmd="$DAEMON $DEBUG_OPTIONS -c $CONF_FILE"
#echo $start_cmd


# trap
handle() {
        echo "$(date). got signal" >> /tmp/1.txt
        exit
}

#trap "handle" SIGTERM SIGHUP
#trap "handle" 1 2 13 15

#trap "echo Shutting Down " SIGTERM SIGHUP

#exec 2>&1

#trap 'kill -HUP %1' 1 2 13 15
#trap 'touch /tmp/3.txt'  1 2 13 15



#exec /etc/init.d/god start
#$start_cmd & wait
exec $start_cmd

