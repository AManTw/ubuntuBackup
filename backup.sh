# !/bin/bash


BACKPATH="/mnt/jerryHDD/mybackup"
hb_day_1=10
hb_day_2=22
all_day_1=1
all_day_2=15

year=`date +%Y`
mon=`date +%m`
day=`date +%d`

rm_back(){

	#remove 2 month ago backup file
	echo "[BackUP-7] Remove 2 month age backup_File"
	if [ "$1" == "hb" ];then
		let mon_bk=$mon-2
		echo $mon_bk
		[ -e $BACKPATH/ubuntu_home_backup@$year-$mon_bk-*.tar.gz ]&& {
			echo "Remove" "$BACKPATH/ubuntu_home_backup@$year-$mon_bk-*.tar.gz"
			rm -f $BACKPATH/ubuntu_home_backup@$year-$mon_bk-*.tar.gz
		}
		[ -e $BACKPATH/ubuntu_book_backup@$year-$mon_bk-*.tar.gz ]&& { 
			echo "Remove" "$BACKPATH/ubuntu_book_backup@$year-$mon_bk-*.tar.gz"	
			rm -f $BACKPATH/ubuntu_book_backup@$year-$mon_bk-*.tar.gz
		}

	elif [ "$1" == "all" ];then
		let mon_bk=$mon-2
		[ -e $BACKPATH/ubuntu_backup@$year-$mon_bk-*.tar.gz ]&& {
			echo "Remove" "$BACKPATH/ubuntu_backup@$year-$mon_bk-*.tar.gz"
			rm -f $BACKPATH/ubuntu_backup@$year-$mon_bk-*.tar.gz
		}

	fi
	echo "[BackUP-8] Remove backup_File Done!!!"
	return 1


}


check_back(){
	echo "[BackUP-2] Check whether same month backup file."
	if [ "$1" == "hb" ];then
		echo "$BACKPATH/ubuntu_home_backup@$year-$mon-$hb_day_1.tar.gz"
		
		[ -e "$BACKPATH/ubuntu_home_backup@$year-$mon-$hb_day_1.tar.gz" ]&& \
		[ -e "$BACKPATH/ubuntu_book_backup@$year-$mon-$hb_day_1.tar.gz" ]&& return 0	

	elif [ "$1" == "all" ];then
		[ -e "$BACKPATH/ubuntu_backup@$year-$mon-$all_day_1.tar.gz" ]&& return 0
	fi
	echo "[BackUP-3] Check backfile  have done"
	#return 1
}

hb_copy(){

	echo "[BackUP-4] Now going to Back UP /home "
	tar -cvpzf $BACKPATH/ubuntu_home_backup@`date +%Y-%m-%d`.tar.gz  --exclude=/home/jerrychen/.cache/ /home

	echo "[BackUP-5] Now going to Back UP /boot "
	tar -cvpzf $BACKPATH/ubuntu_boot_backup@`date +%Y-%m-%d`.tar.gz --exclude=/home/jerrychen/.cache/ /boot

	echo "[BackUP-6] Back Up /home /boot Done !!"
}

all_copy(){

	echo "[BackUP-4] Now going to Back UP all file system /"
	tar -cvpzf $BACKPATH/ubuntu_backup@`date +%Y-%m-%d`.tar.gz --exclude=/proc --exclude=/tmp --exclude=/lost+found --exclude=/media --exclude=/mnt --exclude=/run /
	echo "[BackUP-5] Back Up Done !!"
}

do_main(){

	if [ "$1" = "help" ]; then
                echo $0 "[command]"
                echo "all -- Backup all files in /."
                echo "hb  -- Backup files in /home & /boot "
                echo
                exit 0
        fi


	echo "[BackUP-1] Starting Backup_check"
	echo $day $hb_day_1
	[ "$day" = "$hb_day_1" -o "$day" = "$hb_day_2" ]&& check_back hb && hb_copy && rm_back hb 
	[ "$day" = "$all_day_1" -o "$day" = "$all_day_2" ]&& check_back all && all_copy && rm_back all

	echo "[BackUP] Backup process done"
}

do_main $1 
