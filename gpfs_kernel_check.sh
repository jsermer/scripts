#!/bin/bash
#GPFS kernel tunables check
( echo $HOSTNAME; sysctl -n -e net.core.netdev_max_backlog net.core.rmem_max net.core.wmem_max net.ipv4.tcp_rmem net.ipv4.tcp_wmem vm.min_free_kbytes) | tr "[:space:]" "," | tr "\n" ","; echo
