#!/bin/bash

. /usr/local/app/etc/const
. $CONFIG

merge_config() {
	local CONFIG=$USERDIR/config
	local OLDCFG=/usr/local/old_app.$old_version/userinfo/config
	local TMPCONFIG=/tmp/out.cfg

	. $CONFIG

	while IFS== read -r var val; do
		[[ "$var" == \#* ]] && echo $var $val && continue
		[ "$var" = '' ] && echo && continue
		[[ "$var" = declare* ]] && echo $var $val && continue
		[[ "$var" != *widget* ]] && . $OLDCFG
		echo "$var='${!var}'"
		. $CONFIG
	done < $CONFIG > $TMPCONFIG

	if [ -s $TMPCONFIG ]; then
		mv -f $CONFIG $USERDIR/backups/config_$(date +%H.%M.%S_%m-%Y)
		mv -f $TMPCONFIG $CONFIG
	fi
}

main() {
	merge_config
}

main $@
