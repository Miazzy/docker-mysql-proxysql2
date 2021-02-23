ProxySQL / Orchestrator / MySQL Docker Testing
==============================================

This repository contains a docker-compose.yml used to launch a small cluster consisting of 3x
MySQL 5.7 containers (1x Master and 2x Slaves), 3x Orchestrator nodes connected via RAFT and 
a ProxySQL 1.4.x container all connected via a frontend / backend network. ProxySQL is automatically 
configured with 2x hostgroups, a writer hostgroup used as the default hostgroup and a reader 
hostgroup for all SELECT statements.

Once the cluster is initialised, replication is started and a sysbench dataset is prepared. After
that a short sysbench test is executed automatically. To launch a new cluster for the FIRST TIME please
execute the following command:

```bash
# To start with benchmarks:
sudo ./docker-compose-init.bash

# To skip benchmarking:
sudo ./docker-compose-init.bash nobench
```

Thereafter you can just start and stop the cluster with regular `docker-compose` commands, for example:

```bash
sudo docker-compose stop
sudo docker-compose start
```

To stop the instances and destroy the containers execute:

```bash
sudo ./docker-compose-destroy.bash
```

The MySQL, Orchestrator and ProxySQL hosts have separate directories with their respective configuration
in the conf directory. You can override any of the MySQL 5.7 variables by editing the `my.cnf` located
in the respective subdirectory under `conf` for each container (i.e. `conf/mysql/mysql1/my.cnf`,
`conf/mysql/mysql2/my.cnf` or `conf/mysql/mysql3/my.cnf`). Its also possible to edit the ProxySQL and
Orchestrator config files as needed.

Note that you'll want the following pre-requisites installed on your host machine:
- docker-ce / docker-ee (17.12+ required)
- docker-compose (1.19+ required)
- mysql-client (5.7+ required)
- sysbench (1.0.12+ recommended if benchmarking)
- orchestrator-client (3.0.8+ recommended if administering Orchestrator via CLI)
- jq (required for Orchestrator)

In addition if you prefer not to use docker-compose you'll also find some scripts for launching the 
MySQL and ProxySQL instances without docker-compose in the `legacy/` directory:
- legacy/docker-mysql.bash
- legacy/docker-proxysql.bash

If you would like to run the benchmark just execute:

```bash
bin/docker-benchmark.bash
```

This script will drop / create the sysbench database, create a test dataset and run the benchmark. You can
edit the file and tailor this behaviour as you would like. Please be aware that this is called during the 
provisioning stage so its best to make a copy of the file with your own benchmarks.

