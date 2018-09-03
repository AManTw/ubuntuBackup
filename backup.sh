# !/bin/bash


BACKPATH="/mnt/jerryHDD/mybackup"
hb_day_1=10
hb_day_2=20
all_day_1=1
all_day_2=15

year=`date +%Y`
mon=`date +%m`
day=`date +%d`
echo $year $mon $day

rm_back(){

	#remove 2 month ago backup file

}


check_back(){
	echo "Before"
	if [ "$1" == "hb" ];then
		let mon=$mon-1
		[ -e "$BACKPATH/ubuntu_home_backup@$year-$mon-$day.tar.gz" ]	
		
	elif [ "$1" == "all" ];then
		

	fi
	echo "AFTER"
}

hb_copy(){

	echo "hb"
	
	#tar -cvpzf $BACKPATH/ubuntu_home_backup@`date +%Y-%m-%d`.tar.gz /home
	#tar -cvpzf $BACKPATH/ubuntu_boot_backup@`date +%Y-%m-%d`.tar.gz /boot
}

all_copy(){

	#tar -cvpzf $BACKPATH/ubuntu_backup@`date +%Y-%m+%d`.tar.gz --exclude=/proc --exclude=/tmp --exclude=/boot --exclude=/home --exclude=/lost+found --exclude=/media --exclude=/mnt --exclude=/run /
	echo "all"
}

do_main(){
	echo "Starting Backup_check"
	[ "$day" == "$hb_day1" -o "$day" == "$hb_day2" ]&& check_back hb && hb_copy

	[ "$day" == "$all_day1" -o "$day" == "$all_day2" ]&& check_back all && all_copy
	echo "Backup process done"
}

do_main
