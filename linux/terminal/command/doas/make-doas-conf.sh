#! /usr/bin/env sh

# doas initial configuration script
# [doas - ArchWiki](https://wiki.archlinux.org/title/Doas)
# WARNING It is imperative that /etc/doas.conf is free of syntax errors!

# echo 'permit persist :wheel' > /etc/doas.conf
echo 'permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel'  > /etc/doas.conf

# NOTICE doas.conf must end with \n

sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0400 /etc/doas.conf

doas -C /etc/doas.conf && \
    echo "doas config ok" || \
    echo "doas config error"
