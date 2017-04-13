#!/bin/sh
export LANG=en_US
filepath=/home/ap/opscloud/cj_shell
oracle_check()
{
ps -ef |grep ora_smon |grep -v grep|awk  '{print $1, substr($NF,10)}' > $filepath/ins.list

UID_NAME=`cat $filepath/.uid_name`
echo "table:CJ_DB_INSTANCE"
for i in `cat -n $filepath/ins.list|awk '{print $1}'`
do
v_para=`cat $filepath/ins.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
INSTANCE=`echo $v_para|awk '{print $2}'`

su - ${username} -c "export ORACLE_SID=$INSTANCE;sqlplus / as sysdba <<EOF
set echo off
set linesize 300
set feedback off;
set head off
set pagesize 1000
select 'dbfile='||file_name||','||bytes/1024/1024||','||tablespace_name xx from dba_data_files
union
select 'dbfile='||file_name||','||bytes/1024/1024||','||tablespace_name xx from dba_temp_files;
select 'haname='||value  xx from v\\\$parameter where name = 'db_name';
select 'dbname='||name xx from v\\\$database;
select 'dbstatus='||status xx from v\\\$instance;
select 'tbname='||tablespace_name||','||sum(bytes/1024/1024) xx from dba_data_files
group by tablespace_name
union
select 'tbname='||tablespace_name||','||sum(bytes/1024/1024) xx from dba_temp_files
group by tablespace_name;
select 'dbid='||dbid xx from v\\\$database;
EOF" > $filepath/oracle_${INSTANCE}.log

PORT_NUM=`su - ${username} -c "lsnrctl status"|grep "(PORT="|head -1|awk -F'=' '{print $NF}'|sed 's/)*//g'`
DATABASE_NAME=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbname='|grep -v 'xx'|cut -d"=" -f2`
HA_NAME=`cat $filepath/oracle_${INSTANCE}.log|grep 'haname='|grep -v 'xx'|cut -d"=" -f2`
SOFT_NAME="ORACLE"
SOFT_VERSION=`su - $username -c "sqlplus -v"  2>/dev/null |grep -iv mail|grep Release|awk '{print $3}'` 
MANUFACTURER="ORACLE"
DBID=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbid='|grep -v 'xx'|cut -d"=" -f2`
echo "INSTANCE_NAME:"$INSTANCE
echo "UID_NAME:"$UID_NAME
echo "DATABASE_NAME:"$DATABASE_NAME
echo "DBID:"$DBID
echo "PORT:"$PORT_NUM
echo "HA_NAME:"$HA_NAME
echo "SOFT_NAME:"$SOFT_NAME
echo "SOFT_VERSION:"$SOFT_VERSION
echo "MANUFACTURER:"$MANUFACTURER
echo ","
done|sed '$d'
echo ";"
 
echo "table:CJ_TABLESPACE"
for i in `cat -n $filepath/ins.list|awk '{print $1}'`
do
v_para=`cat $filepath/ins.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
INSTANCE=`echo $v_para|awk '{print $2}'`
STATUS=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbstatus='|grep -v 'xx'|cut -d"=" -f2`

if [ $STATUS == 'OPEN' ]
then
DBID=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbid='|grep -v 'xx'|cut -d"=" -f2`
DATABASE_NAME=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbname='|grep -v 'xx'|cut -d"=" -f2`
cat $filepath/oracle_${INSTANCE}.log|grep "tbname="|grep -v 'xx'|awk -F"=" '{print $2}'|while read line
do
echo "UID_NAME:"$UID_NAME
echo "DBID:"$DBID
echo "TABLESPACE_NAME:"`echo $line|cut -d"," -f1`
echo "TABLESPACE_SIZE:"`echo $line|cut -d"," -f2`
echo "DATABASE_NAME:"$DATABASE_NAME
echo ","
done
fi
done|sed '$d'
echo ";"

echo "table:CJ_DATA_FILE"
for i in `cat -n $filepath/ins.list|awk '{print $1}'`
do
v_para=`cat $filepath/ins.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
INSTANCE=`echo $v_para|awk '{print $2}'`
STATUS=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbstatus='|grep -v 'xx'|cut -d"=" -f2`
if [ $STATUS == 'OPEN' ]
then
DBID=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbid='|grep -v 'xx'|cut -d"=" -f2`
DATABASE_NAME=`cat $filepath/oracle_${INSTANCE}.log|grep 'dbname='|grep -v 'xx'|cut -d"=" -f2`
cat $filepath/oracle_${INSTANCE}.log|grep "dbfile="|grep -v 'xx'|awk -F"=" '{print $2}'|while read line
do
echo "UID_NAME:"$UID_NAME
echo "DBID:"$DBID
echo "DATA_FILE_NAME:"`echo $line|cut -d"," -f1`
echo "DATA_FILE_SIZE:"`echo $line|cut -d"," -f2`
echo "TABLESPACE_NAME:"`echo $line|cut -d"," -f3`
echo ","
done
fi
done|sed '$d'
echo ";"
}

if [ `ps -ef|grep pmon|grep -v grep|wc -l` -gt 0 ]
then
    oracle_check
fi

