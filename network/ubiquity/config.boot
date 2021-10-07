firewall {
    all-ping enable
    broadcast-ping disable
    group {
        address-group HOME_GROUP {
            address 192.168.3.0/24
            description "Home Group"
        }
        address-group MULTIPLE_GROUP {
            address 192.168.3.0/24
            address 192.168.4.0/24
            address 192.168.6.0/24
            address 192.168.7.0/24
            description "Multiple Groups"
        }
        address-group OPENDNS_SERVER_GROUP {
            address 208.67.222.222
            address 208.67.220.220
            description "OpenDNS Servers"
        }
        address-group WIFI_GUEST_GROUP {
            address 192.168.6.0/24
            description "Wifi Guest Group"
        }
        address-group WIFI_IOT_GROUP {
            address 192.168.7.0/24
            description "Wifi IOT Group"
        }
        address-group WIRED_IOT_GROUP {
            address 192.168.4.0/24
            description "Wired IOT Group"
        }
        address-group WIRED_SEPARATE_GROUP {
            address 192.168.5.0/24
            description "Wired Separate Group"
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name HOME_OUT {
        default-action accept
        description "Home Out"
        rule 1 {
            action accept
            description "Allow Wired IOT Replies"
            log disable
            protocol all
            source {
                group {
                    address-group WIRED_IOT_GROUP
                }
            }
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop Rest of Wired IOT Traffic"
            log disable
            protocol all
            source {
                group {
                    address-group WIRED_IOT_GROUP
                }
            }
        }
        rule 3 {
            action accept
            description "Allow Wifi Guest Replies"
            log disable
            protocol all
            source {
                group {
                    address-group WIFI_GUEST_GROUP
                }
            }
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 4 {
            action drop
            description "Drop Rest of Wifi Guest Traffic"
            log disable
            protocol all
            source {
                group {
                    address-group WIFI_GUEST_GROUP
                }
            }
        }
        rule 5 {
            action accept
            description "Allow Wifi IOT Replies"
            log disable
            protocol all
            source {
                group {
                    address-group WIFI_IOT_GROUP
                }
            }
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 6 {
            action drop
            description "Drop Rest of Wifi IOT Traffic"
            log disable
            protocol all
            source {
                group {
                    address-group WIFI_IOT_GROUP
                }
            }
        }
    }
    name WAN_IN {
        default-action drop
        description "WAN to internal"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "WAN to router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WIFI_GUEST_LOCAL {
        default-action drop
        description "Wifi Guest Local"
        rule 1 {
            action accept
            description "Allow DHCP"
            destination {
                port 67-68
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Allow DNS"
            destination {
                port 53
            }
            log disable
            protocol tcp_udp
        }
    }
    name WIFI_IOT_LOCAL {
        default-action drop
        description "Wifi IOT local"
        rule 1 {
            action accept
            description "Allow DHCP"
            destination {
                port 67-68
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Allow Only OpenDNS"
            destination {
                group {
                    address-group OPENDNS_SERVER_GROUP
                }
                port 53
            }
            log disable
            protocol tcp_udp
        }
    }
    name WIRED_IOT_LOCAL {
        default-action drop
        description "Wired IOT Local"
        rule 1 {
            action accept
            description "Allow DHCP"
            destination {
                port 67-68
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Allow Only OpenDNS"
            destination {
                group {
                    address-group OPENDNS_SERVER_GROUP
                }
                port 53
            }
            log disable
            protocol tcp_udp
        }
    }
    name WIRED_SEPARATE_IN {
        default-action accept
        description "Wired Separate In"
        rule 1 {
            action drop
            description "Block Multiple Networks"
            destination {
                group {
                    address-group MULTIPLE_GROUP
                }
            }
            log disable
            protocol all
        }
    }
    name WIRED_SEPARATE_LOCAL {
        default-action drop
        description ""
        rule 1 {
            action accept
            description "Allow DHCP"
            destination {
                port 67-68
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Allow DNS"
            destination {
                port 53
            }
            log disable
            protocol tcp_udp
        }
    }
    name WIRED_SEPARATE_OUT {
        default-action drop
        description "Wired Separate Out"
        rule 1 {
            action drop
            description "Drop Home Network"
            log disable
            protocol all
            source {
                group {
                    address-group HOME_GROUP
                }
            }
        }
        rule 2 {
            action drop
            description "Drop Wired IOT Network"
            log disable
            protocol all
            source {
                group {
                    address-group WIRED_IOT_GROUP
                }
            }
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address dhcp
        description Internet
        duplex auto
        firewall {
            in {
                name WAN_IN
            }
            local {
                name WAN_LOCAL
            }
        }
        speed auto
    }
    ethernet eth1 {
        address 192.168.4.1/24
        description "Wired IOT Net"
        duplex auto
        firewall {
            local {
                name WIRED_IOT_LOCAL
            }
        }
        speed auto
    }
    ethernet eth2 {
        address 192.168.5.1/24
        description "Wired Separate Net"
        duplex auto
        firewall {
            in {
                name WIRED_SEPARATE_IN
            }
            local {
                name WIRED_SEPARATE_LOCAL
            }
            out {
                name WIRED_SEPARATE_OUT
            }
        }
        speed auto
    }
    ethernet eth3 {
        description "Home Net"
        duplex auto
        speed auto
    }
    ethernet eth4 {
        description "Home Net"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    loopback lo {
    }
    switch switch0 {
        address 192.168.3.1/24
        description "Home Net"
        firewall {
            out {
                name HOME_OUT
            }
        }
        mtu 1500
        switch-port {
            interface eth3 {
            }
            interface eth4 {
            }
            vlan-aware disable
        }
        vif 6 {
            address 192.168.6.1/24
            description Wifi_Guest_Net
            firewall {
                local {
                    name WIFI_GUEST_LOCAL
                }
            }
            mtu 1500
        }
        vif 7 {
            address 192.168.7.1/24
            description Wifi_IOT_Net
            firewall {
                local {
                    name WIFI_IOT_LOCAL
                }
            }
            mtu 1500
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update enable
        shared-network-name LAN1 {
            authoritative enable
            subnet 192.168.4.0/24 {
                default-router 192.168.4.1
                dns-server 208.67.222.222
                dns-server 208.67.220.220
                domain-name WiredIOTnet
                lease 86400
                start 192.168.4.38 {
                    stop 192.168.4.243
                }
            }
        }
        shared-network-name LAN2 {
            authoritative enable
            subnet 192.168.3.0/24 {
                default-router 192.168.3.1
                dns-server 192.168.3.1
                domain-name HomeNet
                lease 86400
                start 192.168.3.38 {
                    stop 192.168.3.243
                }
            }
        }
        shared-network-name SecureNetDHCP {
            authoritative enable
            subnet 192.168.5.0/24 {
                default-router 192.168.5.1
                dns-server 195.121.1.34
                dns-server 195.121.1.66
                domain-name SeparateNet
                lease 86400
                start 192.168.5.38 {
                    stop 192.168.5.243
                }
            }
        }
        shared-network-name Wifi_Guest_DHCP {
            authoritative enable
            subnet 192.168.6.0/24 {
                default-router 192.168.6.1
                dns-server 208.67.222.222
                dns-server 208.67.220.220
                domain-name WifiGuestNet
                lease 86400
                start 192.168.6.38 {
                    stop 192.168.6.243
                }
            }
        }
        shared-network-name Wifi_IOT_DHCP {
            authoritative enable
            subnet 192.168.7.0/24 {
                default-router 192.168.7.1
                dns-server 208.67.222.222
                dns-server 208.67.220.220
                domain-name WifiIOTnet
                lease 86400
                start 192.168.7.38 {
                    stop 192.168.7.243
                }
            }
        }
        use-dnsmasq enable
    }
    dns {
        forwarding {
            cache-size 400
            listen-on switch0
        }
    }
    gui {
        http-port 80
        https-port 443
        older-ciphers enable
    }
    nat {
        rule 1 {
            description "Exclude OpenDNS Wifi Guest"
            destination {
                group {
                    address-group OPENDNS_SERVER_GROUP
                }
                port 53
            }
            disable
            exclude
            inbound-interface switch0.6
            inside-address {
                port 53
            }
            log disable
            protocol tcp_udp
            type destination
        }
        rule 2 {
            description "Force OpenDNS Wifi Guest"
            destination {
                port 53
            }
            disable
            inbound-interface switch0.6
            inside-address {
                address 208.67.220.220
            }
            log disable
            protocol tcp_udp
            type destination
        }
        rule 5010 {
            description "masquerade for WAN"
            outbound-interface eth0
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    unms {
        disable
    }
}
system {
    domain-name home.local
    host-name ubnt
    login {
        user <user_name> {
            authentication {
                encrypted-password <password> 
            }
            level admin
        }
    }
    name-server 9.9.9.9
    name-server 149.112.112.112
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    offload {
        hwnat enable
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
    traffic-analysis {
        dpi enable
        export enable
    }
}


/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "config-management@1:conntrack@1:cron@1:dhcp-relay@1:dhcp-server@4:firewall@5:ipsec@5:nat@3:qos@1:quagga@2:system@4:ubnt-pptp@1:ubnt-unms@1:ubnt-util@1:vrrp@1:webgui@1:webproxy@1:zone-policy@1" === */
/* Release version: v1.9.7+hotfix.4.5024279.171006.0255 */
