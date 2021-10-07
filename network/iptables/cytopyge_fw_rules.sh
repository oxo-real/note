#!/bin/sh

iface=$(ip -o -4 route show to default | awk '{print $5}')
exip=$(dig @resolver1.opendns.com myip.opendns.com +dnssec +short)
inip=$(ip a show dev $i | grep 'inet ' | awk '{print $2}')


# clear iptables
iptables --flush


# default policies

## drop all incoming traffic
iptables --policy INPUT DROP

## accept all outgoing traffic
iptables --policy OUTPUT ACCEPT

## drop all forwarded traffic
### this is a router functionality
### when you have two network interfaces
iptables --policy FORWARD DROP

## accept all traffic on the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

## create stateful firewall
### accept all packets belonging to a related / already established connection
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## refuse spoofed packets
### prevent dos attack
iptables -A INPUT -s $inip -j DROP


# specific rules

## drop incoming ping requests
iptables -A INPUT -p icmp --icmp-type -s $inip -d
