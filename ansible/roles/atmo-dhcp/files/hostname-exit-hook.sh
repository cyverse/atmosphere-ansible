#!/bin/bash

LOG=/var/log/atmo/dhcp_hostname.log

# Sync OS time using the host's hardware time
echo $(date +"%m%d%y %H:%M:%S") "Syncing system time with hardware time" >> $LOG
echo "     DEBUG: Date BEFORE sync:" $(date) >> $LOG
hwclock -s
echo "     DEBUG: Date AFTER sync:" $(date)  "hwclock exit status: $?" >> $LOG

# Function: get_hostname()
# Description: Gets the hostname, depending on the distro
get_hostname() {
   local is_centos5=0
   if [ -e /etc/redhat-release ]; then
      s=$(grep 'CentOS release 5' /etc/redhat-release)
      if [ $? -eq 0 ]; then
         is_centos5=1
      fi
   fi

   if [ $is_centos5 -eq 1 ]; then
      hostname_value=$(curl -s 'http://169.254.169.254/openstack/latest/meta_data.json' | python -c'from simplejson.tool import main; main()' | sed -n -e '/"public-hostname":/ s/^.*"\(.*\)".*/\1/p')
   else
      hostname_value=$(curl -s 'http://169.254.169.254/openstack/latest/meta_data.json' | python -mjson.tool | sed -n -e '/"public-hostname":/ s/^.*"\(.*\)".*/\1/p')
   fi
}

# This function will lookup the ip address 
reverse_lookup ()  {
  if [ -n "$1" ]; then
    local ip=$1
    local htemp=$(dig -x $ip +short)
    echo $(date +"%m%d%y %H:%M:%S") "	   DEBUG: hostname returned from dig = $htemp" >> $LOG
    if [ $? -eq 0 -a -n "$htemp" ]; then
      hostname_value=$(echo $htemp | sed 's/\.$//')
    fi
  fi
}

MAX_ATTEMPTS=5

retry=0
hostname_value=""

echo $(date +"%m%d%y %H:%M:%S") "dhclient hostname hook started" >> $LOG

while [ $retry -lt $MAX_ATTEMPTS -a -z "$hostname_value" ]; do
    ((retry++))
    echo $(date +"%m%d%y %H:%M:%S") "	Attempt #${retry}" >> $LOG
    # Note: gobal hostname_value is returned
    get_hostname
    sleep 1
done

# attempt external ip resolution through dyndns
if [[ -z $hostname_value ]]; then
  myip=$(timeout -s SIGTERM 10 curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g')
  if [ $? -eq 0 -a -n "$myip" ]; then
    echo $(date +"%m%d%y %H:%M:%S") "	attempting to set using dyndns (found ip = $myip) " >> $LOG
    reverse_lookup $myip
    if [ -n hostname_value ]; then
    	echo $(date +"%m%d%y %H:%M:%S") "	   success" >> $LOG
    fi
  fi
fi


# attempt external ip resolution through ipify
if [[ -z $hostname_value ]]; then
  myip=$(curl https://api.ipify.org)
  if [ $? -eq 0 -a -n "$myip" ]; then
    echo $(date +"%m%d%y %H:%M:%S") "	attempting to set using ipify (found ip = $myip) " >> $LOG
    reverse_lookup $myip
    if [ -n hostname_value ]; then
    	echo $(date +"%m%d%y %H:%M:%S") "	   success" >> $LOG
    fi
  fi
fi

# retest hostname value
if [[ -z $hostname_value ]]; then
    echo $(date +"%m%d%y %H:%M:%S") "	Hostname could not be determined. using `hostname`" >> $LOG
else
    if [[ $hostname_value  == 129.114.5.* ]]; then
       hostname "austin5-"$(echo $hostname_value | awk 'BEGIN {FS="."};{print $4}')".cloud.bio.ci"
    else
       hostname $hostname_value
    fi
    echo $(date +"%m%d%y %H:%M:%S") "   Hostname has been set to `hostname`" >> $LOG
fi
