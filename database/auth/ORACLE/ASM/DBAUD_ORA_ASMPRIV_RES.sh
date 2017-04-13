#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by  ycl 20121217
###检查asm 挂载的文件系统是否是grid:onstall权限/660
#############################################################

#sh_dir=$sh_dir
#log_dir=$log_dir
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

        #更改目录权限
        chown $username $log_dir/oracle;
        tmp_dir=$log_dir/oracle
        if [[ -f $log_dir/oracle/DBAUD_ORA_ASMPRIV_RES2.out ]];then
       rm $log_dir/oracle/DBAUD_ORA_ASMPRIV_RES2.out
    fi

> $log_dir/DBAUD_ORA_ASMPRIV_RES.out
su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_asm_path.sql" >/tmp/log.out
rm -rf /tmp/log.out

for path in `cat $log_dir/oracle/DBAUD_ORA_ASMPRIV_RES2.out|grep -v 'SQL'`
do
vmod=`ls -l $path|awk '{print $1}'|sed 's/^.//g'|sed 's/\.$//g'`
vown=`ls -l $path|awk '{print $3}'`
vgroup=`ls -l $path|awk '{print $4}'`

if [ "$vmod" == "rw-rw----" -a "$vown" == "grid" -a "$vgroup" == "oinstall" ];then
resulta=`echo \`expr $resulta + 0\``
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo $path"的权限不满足(rw-rw----)(grid,oinstall)">>$log_dir/DBAUD_ORA_ASMPRIV_RES.out
fi
done
done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
