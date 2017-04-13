for i in `find -type f -name '*[RES|DET].sh'`; do
    sed -i 's/sh_dir=/#sh_dir=/' "$i"
    sed -i 's/log_dir=/#log_dir=/' "$i"
	sed -i '1a export LANG=en_US.utf8' "$i"
        sed -i '2a . `find . -name ora_parameter.cfg`' "$i"
	sed -i 's:/home/ap/opsware/agent/scripts/HEALTH_CHECK/ORACLE:\$sh_dir:g' "$i"
	sed -i 's:/home/ap/opsware/script/tmp:\$log_dir:g' "$i"
done
