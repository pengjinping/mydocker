#!/bin/bash

HOSTNAME="127.0.0.1"
PORT="3306"
USERNAME="root"
PASSWORD=""

DB_NAME="slave_test"
SLAVE_USER="slave"
SLAVE_PWD="123456"

MYSQL_CMD="mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}"
DROP_SQL="DROP database IF EXISTS ${DB_NAME}"
CREATE_SQL="create database IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"

echo ${MYSQL_CMD}

# 删除数据库
echo ${DROP_SQL}
echo ${DROP_SQL} | ${MYSQL_CMD}
if [ $? -ne 0 ]
then
 echo "drop databases ${DB_NAME} failed ..."
 exit 1
fi

# 创建数据库
echo ${CREATE_SQL}
echo ${CREATE_SQL} | ${MYSQL_CMD}
if [ $? -ne 0 ]
then
 echo "drop databases ${DB_NAME} failed ..."
 exit 1
fi

SET_POLICY="set global validate_password_policy=0"
echo ${SET_POLICY}
echo ${SET_POLICY} | ${MYSQL_CMD}
if [ $? -ne 0 ]
then
 echo "set failed ..."
 exit 1
fi

# 创建用户并且授权
CREATE_USER="CREATE USER 'slave5'@'%' IDENTIFIED BY 'king#slave@516128'"
CREATE_GRANT="GRANT REPLICATION SLAVE, REPLICATION CLIENT ON 'slave_test'."*" TO 'slave5'@'%'"

echo ${CREATE_USER}
echo ${CREATE_USER} | ${MYSQL_CMD}
if [ $? -ne 0 ]
then
 echo "create user slave failed ..."
 exit 1
fi

echo ${CREATE_GRANT}
echo ${CREATE_GRANT} | ${MYSQL_CMD}
if [ $? -ne 0 ]
then
 echo "create user slave failed ..."
 exit 1
fi