#!/bin/sh 
PID=$(ps aux | grep -e 'rails' | grep -v grep | awk '{print $2}') && kill -s 9 $PID 2> /dev/null
PID=$(ps aux | grep -e 'middleman' | grep -v grep | awk '{print $2}') && kill -s 9 $PID 2> /dev/null