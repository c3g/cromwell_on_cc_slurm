#!/bin/bash

# update the pasword in the my.cnf and mysqlrootp wfiles

MYSQL_DIR=${HOME}


singularity instance start --bind ${HOME} \
    --bind ${MYSQL_DIR}/mysql/var/lib/mysql/:/var/lib/mysql \
    --bind ${MYSQL_DIR}/mysql/run/mysqld:/run/mysqld \
    $HOME/mysql.simg mysql
singularity run instance://mysql


singularity exec instance://mysql mysql -e "SET GLOBAL sql_mode = 'ANSI_QUOTES';"
singularity exec instance://mysql mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'cromwell_usr'@'%' IDENTIFIED BY '$CROMWELL_PW' WITH GRANT OPTION"
singularity exec instance://mysql mysql -e     "CREATE DATABASE cromwell_db;" 2>/dev/null
# shuting down 
# singularity exec instance://mysql mysql -e  "mysqladmin shutdown"
# singularity instance stop mysql

