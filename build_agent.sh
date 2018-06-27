#!/bin/bash

# build_agent - takes a directory containing .mop files as an arguments and builds JavaMOP agent
# arg1: directory containing .mop files
# arg2 (OPTIONAL): '-excludeJars' can be specified to exclude jars for the RV-Monitor runtime and AspectJ Weaver from the agent


if [ -z "$1" ]; then
  echo "Please specify the directory"
  exit 1
fi

if ! [[ -d $1 ]]; then
  echo "$1 is not a directory"
  exit 1
fi

EXCLUDE_JARS=''
if  ! [ -z "$2" ]; then
  if [ "$2" = "-excludeJars" ]; then
    EXCLUDE_JARS="-excludeJars"
  else
    echo "$2 wrong argument"
    exit 1
  fi
fi

javamop -merge $1/*.mop
mkdir -p $1/classes/mop
rv-monitor -merge -d $1/classes/mop/ $1/*.rvm
javac $1/classes/mop/MultiSpec_1RuntimeMonitor.java
rm $1/classes/mop/MultiSpec_1RuntimeMonitor.java
javamopagent $1/MultiSpec_1MonitorAspect.aj $1/classes -n $1/JavaMOPAgent $EXCLUDE_JARS
rm -rf $1/classes
rm $1/*.rvm
rm $1/MultiSpec_1MonitorAspect.aj
