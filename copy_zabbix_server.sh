#!/bin/bash

ROPT="-v -az --delete"

#RSYNC
rsync $ROPT --password-file=/home/admin/client.scrt /etc/zabbix/ test@172.17.192.240::Arhiv/etc_zabbix
rsync $ROPT --password-file=/home/admin/client.scrt /usr/share/zabbix test@172.17.192.240::Arhiv/usr_share_zabbix
rsync $ROPT --password-file=/home/admin/client.scrt /etc/httpd/ test@172.17.192.240::Arhiv/etc_httpd

#STOP ZABBIX
systemctl stop zabbix-server
sleep 3

#PSQL
pg_dump -h localhost -U zabbix zabbix > /tmp/arhiv.dump
#tar -czvf /tmp/arhiv.tar.gz -C /tmp/arhiv.dump
rsync $ROPT --password-file=/home/admin/client.scrt /tmp/arhiv.dump test@172.17.192.240::Arhiv/psql

#START ZABBIX
systemctl start zabbix-server

#TAR
#tar -czvf /backup/zabbix_server.tar.gz -C /backup/ zabbix_server