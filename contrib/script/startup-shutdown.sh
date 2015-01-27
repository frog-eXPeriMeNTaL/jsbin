#!/bin/bash -l

# Set the variables for creating the /var/run directory
RUN_DIR=/var/run/jsbin
USER=jsbin
GROUP=jsbin
RUN_DIR_PERMS=0775
SOURCE_DIR=/srv/node/jsbin/
JSBIN_LOG=/var/log/jsbin/jsbin.log
JSBIN_ERROR=/var/log/jsbin/error.log
JSBIN_PID=/var/run/jsbin/jsbin.pid
APP_HOME=/srv/node/jsbin
NODE_BIN_DIR=/home/jsbin/.nvm/v0.10.35/bin
NODE_PATH=/home/jsbin/.nvm/v0.10.35/lib/node_modules
# forever specific settings
FOREVER_LOG=/var/log/jsbin/forever.log
MIN_UPTIME=5000
SPIN_SLEEP_TIME=2000

if [[ $1 == start ]]; then
        #Setup path for the node modules
        PATH=$NODE_BIN_DIR:$PATH
        
        #Check to see if jsbin is running
        JSBIN_ID=`forever list | grep jsbin | awk '{print $2}' | sed 's/[^0-9]//g'`
        if [[ -z $JSBIN_ID ]]; then
                PORT=3000 forever start --minUptime $MIN_UPTIME --spinSleepTime $SPIN_SLEEP_TIME --sourceDir $SOURCE_DIR --workingDir $APP_HOME -a -o $JSBIN_LOG -e $JSBIN_ERROR -c node .
        else
                echo "jsbin is already running, please stop before attempting to start"
                forever list | grep $JSBIN_ID | grep jsbin
        fi
elif [[ $1 == stop ]]; then
        #Setup path for the node modules
        PATH=$NODE_BIN_DIR:$PATH

        JSBIN_ID=`forever list | grep jsbin | awk '{print $2}' | sed 's/[^0-9]//g'`
        if [[ -z $JSBIN_ID ]]; then
                echo "JSBIN isn't running"
        else
                forever stop $JSBIN_ID
        fi
elif [[ $1 == status ]]; then
        #Setup path for the node modules
        PATH=$NODE_BIN_DIR:$PATH

        JSBIN_ID=`forever list | grep jsbin | awk '{print $2}' | sed 's/[^0-9]//g'`
        if [[ -z $JSBIN_ID ]]; then
                echo "JSBIN isn't running"
        else
                forever list | grep $JSBIN_ID | grep jsbin
        fi
fi
