#!/bin/bash
. constants

PREP_THREADS=10
RUN_THREADS=2
NUM_TABLES=10
SIZE_TABLES=10000
REPORT_INTERVAL=5
TIME=60

printf "$RED[$(date)] Dropping 'sysbench' schema if present and preparing test dataset:$NORMAL\n"
mysql -h127.0.0.1 -P16033 -uroot -p$MYSQL_PWD -e"DROP DATABASE IF EXISTS sysbench; CREATE DATABASE IF NOT EXISTS sysbench"

printf "$POWDER_BLUE[$(date)] Running Sysbench Benchmarks against ProxySQL:"
sysbench /usr/share/sysbench/oltp_read_write.lua --table-size=$SIZE_TABLES --tables=$NUM_TABLES --threads=$PREP_THREADS \
 --mysql-db=sysbench --mysql-user=root --mysql-password=$MYSQL_PWD --mysql-host=127.0.0.1 --mysql-port=16033 --db-driver=mysql prepare

sleep 5

sysbench /usr/share/sysbench/oltp_read_write.lua --table-size=$SIZE_TABLES --tables=$NUM_TABLES --threads=$RUN_THREADS \
 --mysql-db=sysbench --mysql-user=root --mysql-password=$MYSQL_PWD --mysql-host=127.0.0.1 --mysql-port=16033 \
 --time=$TIME --report-interval=$REPORT_INTERVAL --db-driver=mysql run

printf "$POWDER_BLUE$BRIGHT[$(date)] Benchmarking COMPLETED!$NORMAL\n"
