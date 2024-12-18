#! /usr/bin/env sh

# doas initial configuration script

echo 'permit persist :wheel' > /etc/doas.conf

# NOTICE doas.conf must end with \n

chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

doas -C /etc/doas.conf && \
    echo "doas config ok" || \
    echo "doas config error"

# WARNING It is imperative that /etc/doas.conf is free of syntax errors!
