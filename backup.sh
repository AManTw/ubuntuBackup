# !/bin/bash


BACKPATH="/mnt/jerryHDD/mybackup"
hb_day_1=10
hb_day_2=20
all_day_1=1
all_day_2=15

year=`date +%Y`
mon=`date +%m`
day=`date +%d`

rm_back(){

	#remove 2 month ago backup file
	if [ "$1" == "hb" ];then
                let mon_bk=$mon-2
       		[ -e $BACKPATH/ubuntu_home_backup@$year-$mon_bk-*.tar.gz ]&& rm $BACKPATH/ubuntu_home_backup@$year-$mon_bk-*.tar.gz
                [ -e $BACKPATH/ubuntu_book_backup@$year-$mon_bk-*.tar.gz ]&& rm $BACKPATH/ubuntu_book_backup@$year-$mon_bk-*.tar.gz

        elif [ "$1" == "all" ];then
		let mon_bk=$mon-2
                [ -e $BACKPATH/ubuntu_backup@$year-$mon_bk-*.tar.gz ]&& rm $BACKPATH/ubuntu_backup@$year-$mon_bk-*.tar.gz

        fi
        echo "Remove 2 month age backup_File Done!!!"
        return 1


}


check_back(){
	echo "Before"
	if [ "$1" == "hb" ];then
		#let mon_bk=$mon-1
		[ -e "$BACKPATH/ubuntu_home_backup@$year-$mon-$day.tar.gz" ]&& \
		[ -e "$BACKPATH/ubuntu_book_backup@$year-$mon-$day.tar.gz" ]&& return 1	
		
	elif [ "$1" == "all" ];then
		
		[ -e "$BACKPATH/ubuntu_backup@$year-$mon-$day.tar.gz" ]&& return 1

	fi
	echo "AFTER"
	return 0
}

hb_copy(){

	echo "[BackUP] Now going to Back UP /home "
	tar -cvpzf $BACKPATH/ubuntu_home_backup@`date +%Y-%m-%d`.tar.gz /home
	
	echo "[BackUP] Now going to Back UP /boot "
	tar -cvpzf $BACKPATH/ubuntu_boot_backup@`date +%Y-%m-%d`.tar.gz /boot

	echo "[BackUP] Back Up /home /boot Done !!"
}

all_copy(){
	
	echo "[BackUP] Now going to Back UP all file system /"
	tar -cvpzf $BACKPATH/ubuntu_backup@`date +%Y-%m-%d`.tar.gz --exclude=/proc --exclude=/tmp --exclude=/boot --exclude=/home --exclude=/lost+found --exclude=/media --exclude=/mnt --exclude=/run /
	echo "[BackUP] Back Up Done !!"
}

do_main(){
	echo "[BackUP] Starting Backup_check"
	
	[ "$day" = "$hb_day_1" -o "$day" = "$hb_day_2" ]&& check_back hb && hb_copy && rm_back
	[ "$day" = "$all_day_1" -o "$day" = "$all_day_2" ]&& check_back all && all_copy && rm_back
	
	if [ -z "$1"  ]; then

        echo $0 "[command]"
        echo "all -- Backup all files in /."
        echo "hb  -- Backup files in /home & /boot "
        echo
        exit 0
	fi

	[ "$1" = "all"  ]&& check_back all && all_copy && rm_back
	[ "$1" = "hb"  ]&& check_back hb && hb_copy && rm_back	

 
	echo "[BackUP] Backup process done"
}

do_main $1 
