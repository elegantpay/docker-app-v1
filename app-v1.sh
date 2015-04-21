#!/bin/bash
set -e

init_lock_file="/.init_lock"

if [ ! -f "$init_lock_file" ]; then
    SSHD_PORT=${SSHD_PORT:-22}
    sed -ri "s/Port\s+22/Port $SSHD_PORT/g" /etc/ssh/sshd_config    
    echo 'init_lock' > $init_lock_file

fi

/usr/bin/supervisord