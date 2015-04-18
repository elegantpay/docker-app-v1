#!/bin/bash
set -e

init_lock_file="~/.init_lock"

if [ ! -f "$init_lock_file" ]; then
    SSHD_PORT=${SSHD_PORT:-22}
    MYSQL_PORT=${MYSQL_PORT:-3306}

    sed -ri "s/Port\s+22/Port $SSHD_PORT/g" /etc/ssh/sshd_config
    sed -ri "s/MYSQL_PORT/$MYSQL_PORT/g" /etc/mysql/my.cnf
    
    touch $init_lock_file

fi

/usr/bin/supervisord