#!/usr/bin/env bash

CURRENT_PATH=$(pwd)
HOSTS=()
PASSWORDS=()
PREFIX=true
PASSWORD=true
DEFAULT_HOST=true

source `dirname $(readlink -f $0)`/mulexe.conf

while [[ $# -gt 1 ]]; do
   key="$1"

   case $key in
      -c | --config)
         HOSTS=()
         PASSWORDS=()
         source $2
         shift 2
         ;;

      -h | --host)
         if [ $DEFAULT_HOST = true ]; then
            HOSTS=()
            PASSWORDS=()
            DEFAULT_HOST=false
         fi

         HOSTS+=($2)
         shift 2
         ;;

      -p | --password)
         PASSWORDS+=($2)
         shift 2
         ;;

      --enable-prefix)
         PREFIX=true
         shift 1
         ;;

      --disable-prefix)
         PREFIX=false
         shift 1
         ;;

      --enable-password)
         PASSWORD=true
         shift 1
         ;;

      --disable-password)
         PASSWORD=false
         shift 1
         ;;

      *)
         echo "Unknown parameter $1"
         exit
         ;;

   esac
done

COMMAND=$1

echo --------------------------------$(hostname)--------------------------------

if [ $PREFIX = true ]; then
   eval $COMMAND | awk -v PREFIX=[$(hostname)] '{print "\033[1;31m"PREFIX"\033[0m" $0}'
else
   eval $COMMAND | awk '{print "\033[1;31m"PREFIX"\033[0m" $0}'
fi

for i in $( seq 0 $(( ${#HOSTS[@]} - 1 )) ); do

    HOSTNAME=$(echo ${HOSTS[$i]} | cut -d@ -f 2)
    echo --------------------------------$HOSTNAME--------------------------------

    if [ $PASSWORD = true ]; then

       if [ $PREFIX = true ]; then
          sshpass -p ${PASSWORDS[$i]} ssh ${HOSTS[$i]} "cd $CURRENT_PATH; $COMMAND" | awk -v PREFIX=[$HOSTNAME]  '{print "\033[1;32m"PREFIX"\033[0m" $0}'
       else
          sshpass -p ${PASSWORDS[$i]} ssh ${HOSTS[$i]} "cd $CURRENT_PATH; $COMMAND" | awk '{print "\033[1;32m"PREFIX"\033[0m" $0}'
       fi

    else

       if [ $PREFIX = true ]; then
          ssh ${HOSTS[$i]} "cd $CURRENT_PATH; $COMMAND" | awk -v PREFIX=[$HOSTNAME]  '{print "\033[1;32m"PREFIX"\033[0m" $0}'
       else
          ssh ${HOSTS[$i]} "cd $CURRENT_PATH; $COMMAND" | awk '{print "\033[1;32m"PREFIX"\033[0m" $0}'
       fi

    fi
done
