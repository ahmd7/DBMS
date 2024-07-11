#!/bin/bash
clear

echo -e "\t\t\t\t  _____    ____    __  __    _____ "
echo -e "\t\t\t\t |  __ \  |  _ \  |  \/  |  / ____|"
echo -e "\t\t\t\t | |  | | | |_) | | \  / | | (___  "
echo -e "\t\t\t\t | |  | | |  _ <  | |\/| |  \___ \ "
echo -e "\t\t\t\t | |__| | | |_) | | |  | |  ____) |"
echo -e "\t\t\t\t |_____/  |____/  |_|  |_| |_____/ "
echo -e "\t\t\t\t                                   "
echo -e "\t\t\t\t                                   "


check_name (){
if [ -z "$NAME" ]; then
	echo "No Argument supplied"
	return 0
elif echo "$NAME" | grep -q " " ; then
	echo "No spaces should be in the name"
	return 0
elif [[ $NAME =~ ^[0-9] ]]; then 
	echo "The Name shouldn't start with a number"
else
	return 1
fi	
}
 

echo -e "################################"
echo -e "# Choose What You Want[1]      #"
echo -e "# 1. Create Database           #"
echo -e "# 2. List Databases            #"
echo -e "# 3. Connect To Database       #"
echo -e "# 4. Drop Database             #"
echo -e "################################"
while :
do
echo "Enter a number:" && read main
if [ $main == 1 ]; then
	echo "Enter The Database Name:" && read NAME
	check_name 
        if [ $? == 1 ] ; then
		if [ -d ~/dbs/$NAME ] ; then
		echo "The Database $NAME Is Already Exists"
		else
		mkdir ~/dbs/$NAME
		echo "The Database $NAME Is Created"
	fi
	fi
elif [ $main == 2 ]; then
        ls ~/dbs/ | awk '{print $1}'
elif [ $main == 3 ]; then
        ./connect.sh
elif [ $main == 4 ]; then
        echo "Enter The Database Name:" && read NAME
        if [ -d ~/dbs/$NAME ] ; then
                rm -r ~/dbs/$NAME
                echo "The Database $NAME Is Deleted"
	else
		echo "There Isn't a DB named $NAME"
        fi
fi
done
