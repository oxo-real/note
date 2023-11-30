#! /usr/bin/env sh

# setup external network (internet) without dhcpcd or nm
# static ip and bridge network
# NOTICE wifi has no bridge

# usage: network_init $bridge_name $bridge_cidr_ip $eth_dev_name $gateway_ip

# example: network_init br0 192.168.1.10/24 enp1s0 192.168.1.1

bridge_name=$1
bridge_cidr_ip=$2
eth_dev_name=$3
gateway_ip=$4

# create bridge
sudo ip link add name $bridge_name type bridge

# assign bridge to ethernet device
sudo ip link set $eth_dev_name master $bridge_name

# set bridge and ethernet device up
sudo ip link set $bridge_name up
sudo ip link set $eth_dev_name up

# assign a static ip to bridge
sudo ip address add $bridge_cidr_ip dev $bridge_name

# adding a default gateway to the bridge device
sudo ip route add default via $gateway_ip dev $bridge_name

# backup dns configuration
#sudo cp /etc/resolv.conf /etc/resolv$(date '+%s').conf

# setup domain nameserver
#sudo echo "nameserver $gateway_ip 9.9.9.9 9.9.8.8" > /etc/resolv.conf
