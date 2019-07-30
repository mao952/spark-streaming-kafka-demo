#!/bin/bash

MODULE_NAME="demo"
DEPLOY_PATH="/dhome/demo"
JAR_NAME="demo.jar"

JAR_PATH="$DEPLOY_PATH/$JAR_NAME"
CONFIG_PATH="/opt/config/$MODULE_NAME/application.yml"

CUR_SHELL_NAME=`basename ${BASH_SOURCE}`
JAVA_MEM_OPTS=" -server -Xms2048m -Xmx2048m"

echo_help()
{
    echo -e "syntax: sh $CUR_SHELL_NAME start|stop|restart"
}

is_running(){
    PIDS=`ps --no-heading -C java -f --width 1000 | grep $JAR_NAME | awk '{print $2}'`
	if [ -z "$PIDS" ]; then
        return 1
	else
		return 0
    fi
}

invoke_start(){
  # check server
    PIDS=`ps --no-heading -C java -f --width 1000 | grep $JAR_NAME | awk '{print $2}'`
    if [ -n "$PIDS" ]; then
        echo -e "ERROR: The $JAR_NAME already started and the PID is ${PIDS}."
        exit 1
    fi

    echo "Starting the $JAR_NAME..."

    # start
	nohup java $JAVA_MEM_OPTS -jar $JAR_PATH --spring.config.location=file:$CONFIG_PATH 2>&1 &
 
    COUNT=0
    while [ $COUNT -lt 1 ]; do
        sleep 1
        COUNT=`ps  --no-heading -C java -f --width 1000 | grep "$JAR_NAME" | awk '{print $2}' | wc -l`
        if [ $COUNT -gt 0 ]; then
            break
        fi
    done
    PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$JAR_NAME" | awk '{print $2}'`
    echo "${JAR_NAME} Started and the PID is ${PIDS}."
}

invoke_stop(){
    PIDS=`ps --no-heading -C java -f --width 1000 | grep $JAR_NAME | awk '{print $2}'`
    if [ -z "$PIDS" ]; then
        echo "ERROR:The $JAR_NAME does not started!"
        exit 1
    fi
 
    echo -e "Stopping the $JAR_NAME..."
 
    for PID in $PIDS; do
        kill $PID > /dev/null 2>&1
    done
 
    COUNT=0
    while [ $COUNT -lt 1 ]; do
        sleep 1
        COUNT=1
        for PID in $PIDS ; do
            PID_EXIST=`ps --no-heading -p $PID`
            if [ -n "$PID_EXIST" ]; then
                COUNT=0
                break
            fi
        done
    done
 
    echo -e "${JAR_NAME} Stopped and the PID is ${PIDS}."
}

if [ -z $1 ];then
    echo_help
    exit 1
fi
if [ "$1" == "start" ];then
   invoke_start

elif [ "$1" == "stop" ];then
   invoke_stop

 elif [ "$1" == "restart" ];then
	if ( is_running ); then
		invoke_stop
		invoke_start
	else
		invoke_start
	fi
else
    echo_help
    exit 1
fi