#!/bin/bash

# Function: cyverse_get_hostname()
# Description: Gets the hostname, depending on the distro
cyverse_public_ip() {
   local is_centos5=0
   if [ -e /etc/redhat-release ]; then
      s=$(grep 'CentOS release 5' /etc/redhat-release)
      if [ $? -eq 0 ]; then
         is_centos5=1
      fi
   fi

   if [ -z "$CYVERSE_PUBLIC_IP" ]; then
      if [ $is_centos5 -eq 1 ]; then
         CYVERSE_PUBLIC_IP=$(curl -s 'http://169.254.169.254/openstack/latest/meta_data.json' | python -c'from simplejson.tool import main; main()' | sed -n -e '/"public-ip":/ s/^.*"\(.*\)".*/\1/p')
      else
         CYVERSE_PUBLIC_IP=$(curl -s 'http://169.254.169.254/openstack/latest/meta_data.json' | python -mjson.tool | sed -n -e '/"public-ip":/ s/^.*"\(.*\)".*/\1/p')
      fi
   fi

   # attempt external ip resolution through dyndns
   if [ -z "$CYVERSE_PUBLIC_IP" ]; then
      CYVERSE_PUBLIC_IP=$(curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g')
   fi

   # attempt external ip resolution through ipify
   if [ -z "$CYVERSE_PUBLIC_IP" ]; then
      CYVERSE_PUBLIC_IP=$(curl -s https://api.ipify.org)
   fi

   export CYVERSE_PUBLIC_IP
}

alias myip='cyverse_public_ip;echo $CYVERSE_PUBLIC_IP'
