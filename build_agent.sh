#!/bin/bash

# The script expects the directory containing the .mop files to be provided as an argument

if [ -z "$1" ]; then
  echo "Please specify the directory"
  exit 1
fi

if ! [[ -d $1 ]]; then
  echo "$1 is not a directory"
  exit 1
fi

javamop -merge $1/*.mop
mkdir -p $1/classes/mop
rv-monitor -merge -d $1/classes/mop/ $1/*.rvm
javac $1/classes/mop/MultiSpec_1RuntimeMonitor.java
rm $1/classes/mop/MultiSpec_1RuntimeMonitor.java
javamopagent $1/MultiSpec_1MonitorAspect.aj $1/classes -n $1/JavaMOPAgent
rm -rf $1/classes
rm $1/*.rvm
rm $1/MultiSpec_1MonitorAspect.aj
