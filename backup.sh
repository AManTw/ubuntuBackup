# !/bin/bash


BACKPATH="/mnt/jerryHDD/mybackup"
hb_day_1=10
hb_day_2=21
all_day_1=1
all_day_2=17

year=`date +%Y`
mon=`date +%m`
day=`date +%d`

rm_back(){

	#remove 2 month ago backup file
	echo
	echo "[BackUP-7] Remove 2 month age backup_File"
	mon_bk=`date -d "$(date +%m) -2 month" +%m`
	year_bk=`date -d "$(date +%Y) -2 month" +%Y`
	echo $year_bk $mon_bk
	if [ "$1" == "hb" ];then

		[ -e $BACKPATH/home_backup_$year_bk-$mon_bk-*.tar.gz ]&& {
			echo "Remove" "$BACKPATH/home_backup_$year_bk-$mon_bk-*.tar.gz"
			rm -f $BACKPATH/home_backup_$year_bk-$mon_bk-*.tar.gz
		}
		[ -e $BACKPATH/boot_backup_$year_bk-$mon_bk-*.tar.gz ]&& { 
			echo "Remove" "$BACKPATH/boot_backup_$year_bk-$mon_bk-*.tar.gz"	
			rm -f $BACKPATH/boot_backup_$year_bk-$mon_bk-*.tar.gz
		}

	elif [ "$1" == "all" ];then
		[ -e $BACKPATH/ubuntu_backup__$year_bk-$mon_bk-*.tar.gz ]&& {
			echo "Remove" "$BACKPATH/ubuntu_backup_$year_bk-$mon_bk-*.tar.gz"
			rm -f $BACKPATH/ubuntu_backup_$year_bk-$mon_bk-*.tar.gz
		}

	fi
	echo "[BackUP-8] Remove backup_File Done!!!"
	echo
}


check_back(){
	echo
	echo "[BackUP-2] Check whether same month backup file."
	if [ "$1" == "hb" ];then
		
		if [ -e "$BACKPATH/home_backup_$year-$mon-$hb_day_1.tar.gz" ] && [ -e "$BACKPATH/boot_backup_$year-$mon-$hb_day_1.tar.gz" ]; then
			echo "FAIL HB EXIT"
			exit
		fi
		echo "$BACKPATH/home_backup_$year-$mon-$hb_day_1.tar.gz"
	
	elif [ "$1" == "all" ];then
		if [ -e "$BACKPATH/ubuntu_backup_$year-$mon-$all_day_1.tar.gz" ]; then 
			echo "FAIL ALL"
			exit
		fi
	fi
	echo 
	echo "[BackUP-3] Check backfile  have done"
	echo
}

hb_copy(){

	echo "[BackUP-4] Now going to Back UP /home "
	tar -cvpzf $BACKPATH/home_backup_`date +%Y-%m-%d`.tar.gz  --exclude=/home/jerrychen/.cache/ /home  > home.log

	echo "[BackUP-5] Now going to Back UP /boot "
	tar -cvpzf $BACKPATH/boot_backup_`date +%Y-%m-%d`.tar.gz --exclude=/home/jerrychen/.cache/ /boot > boot.log

	echo "[BackUP-6] Back Up /home /boot Done !!"
	#return 1
}

all_copy(){

	echo "[BackUP-4] Now going to Back UP all file system /"
	tar -cvpzf $BACKPATH/ubuntu_backup_`date +%Y-%m-%d`.tar.gz --exclude=/proc --exclude=/tmp --exclude=/lost+found --exclude=/media --exclude=/mnt --exclude=/run / > all.log
	echo "[BackUP-5] Back Up Done !!"
	#return 1 
}

do_main(){
	
	if [ "$1" = "help" ]; then
                echo $0 "[command]"
                echo "all -- Backup all files in /."
                echo "hb  -- Backup files in /home & /boot "
                echo
                exit 0
        fi

	cd /root/ubuntuBackup
	echo "[BackUP-1] Starting Backup_check"
	echo $day $hb_day_1
	[ "$day" = "$hb_day_1" -o "$day" = "$hb_day_2" ]&& check_back hb && hb_copy && rm_back hb 
	[ "$day" = "$all_day_1" -o "$day" = "$all_day_2" ]&& check_back all && all_copy && rm_back all

	echo "[BackUP] Backup process done"
}

do_main $1 
