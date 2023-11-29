#! /usr/bin/env sh

# setup external network (internet) without dhcp or nm
# static ip and bridge network
# NOTICE wifi has no bridge

# usage: connect $bridge_name $bridge_cidr_ip $eth_dev_name $gateway_ip

# example: connect br0 192.168.1.10/24 enp1s0 192.168.1.1

# create bridge
ip link add name $bridge_name type bridge

# assign bridge to ethernet device
ip link set $eth_dev_name master $bridge_name

# set bridge and ethernet device up
ip link set $bridge_name up
ip link set $eth_dev_name up

# assign a static ip to bridge
ip address add $bridge_cidr_ip dev $bridge_name

# adding a default gateway to the bridge device
ip route add default via $gateway_ip dev $bridge_name

# backup dns configuration
cp /etc/resolv.conf /etc/resolv$(date '+%s').conf

# setup domain nameserver
echo 'nameserver 192.168.0.1 9.9.9.9 9.9.8.8' > /etc/resolv.conf
