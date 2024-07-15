#!/bin/bash
clear
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

echo -e "\t\t\t\t  _____    ____    __  __    _____ "
echo -e "\t\t\t\t |  __ \  |  _ \  |  \/  |  / ____|"
echo -e "\t\t\t\t | |  | | | |_) | | \  / | | (___  "
echo -e "\t\t\t\t | |  | | |  _ <  | |\/| |  \___ \ "
echo -e "\t\t\t\t | |__| | | |_) | | |  | |  ____) |"
echo -e "\t\t\t\t |_____/  |____/  |_|  |_| |_____/ "
echo -e "\t\t\t\t                                   "
echo -e "\t\t\t\t                                   " 
db=$1
echo -e  "\t\t\t\thello from $db"
echo -e "##################################"
echo -e "# Choose What You Want[ 1 - 8 ]  #"
echo -e "# 1. Create Table                #"
echo -e "# 2. List Tables                 #"
echo -e "# 3. Drop Table                  #"
echo -e "# 4. Insert into Table           #"
echo -e "# 5. Select From Table           #"
echo -e "# 6. Delete From Table           #"
echo -e "# 7. Update Table                #"
echo -e "# 8. Back                        #"
echo -e "##################################"
while :
do
echo "Enter a number:" && read main
case $main in 
1) echo "Enter Table Name:" && read NAME
	check_name
	if [ $? == 1 ] ; then
                if [ -f ~/dbs/$db/$NAME ] ; then
                echo "The Table $NAME Is Already Exists"
                else
                touch ~/dbs/$db/$NAME
                echo "The Table $NAME Is Created"
        fi
        fi
	echo "The first column will be the PK, Enter the number of colums :" && read NUM
	echo >> ~/dbs/$db/$NAME
        echo >> ~/dbs/$db/$NAME
	for ((i=1 ; i<=$NUM ; i++ ))
	do
	echo "Enter the column number $i name:" && read column
	echo "Enter the  data type( int | string ):" && read type
	if [[ $type == "int" || $type == "string" ]]; then
	sed -i "1s/$/$column /" ~/dbs/$db/$NAME
        sed -i "2s/$/$type /" ~/dbs/$db/$NAME
	else
	echo "Enter the word int or string"
	rm ~/dbs/$db/$NAME
	break
	fi
	done
 ;;
2) ls ~/dbs/$db | awk '{print $1}';;
3) echo "Enter The Table Name:" && read NAME
        if [ -f ~/dbs/$db/$NAME ] ; then
                rm  ~/dbs/$db/$NAME
                echo "The TABLE $NAME Is Deleted"
        else
                echo "There Isn't a TABLE named $NAME"
        fi ;;
4) read -p "Enter table name:" NAME
N=$(tail -1 ~/dbs/$db/$NAME | wc -w)
add=""
for (( i=1 ; i<=$N ; i++ ))
do
read -p "Enter $(awk -v i="$i" '{print $i}' ~/dbs/$db/$NAME | head -1 ) column value:" input 
add="$add $input"
done
echo $add >> ~/dbs/$db/$NAME
 ;;
5)
read -p "Enter table name:" NAME
while : 
do
echo "You are now viewing table $NAME"
            echo "1: SELECT * from $NAME"
            echo "2: Select by column"
            echo "3: Select row where column equals a value"
            echo "4: exit"
read -p "Enter a number[1-4]: " NUM
case $NUM in
1)N=$(cat ~/dbs/$db/$NAME | wc -l) 
i=$((N-2))
tail -$i ~/dbs/$db/$NAME;;
2)N=$(tail -1 ~/dbs/$db/$NAME | wc -w)
for (( i=1 ; i<=$N ; i++ ))
do
echo "$i :  $(awk -v i="$i" '{print $i}' ~/dbs/$db/$NAME | head -1 )"
done
N=$(cat ~/dbs/$db/$NAME | wc -l)
i=$((N-2))
read -p "Enter the number of column: " input
awk -v input="$input" '{print $input}' ~/dbs/$db/$NAME | tail -$i ;;
3)read -p "Search value: " input
grep "$input" ~/dbs/$db/$NAME
 ;;
4) break;;
esac
echo "#####################################################################"
done;;
6)
read -p "Enter table name:" NAME
while : 
do
            echo "You are now viewing table $NAME"
            echo "1: DELETE all data from $NAME"
            echo "2: Delete row where column equals a value"
            echo "3: quit"
read -p "Enter a number[1-3]: " NUM
case $NUM in
1)echo "$(head -2 ~/dbs/$db/$NAME)" > ~/dbs/$db/$NAME;;
2) read -p "Enter the value:" input
sed -i "/$input/d" ~/dbs/$db/$NAME;;
3) break;;
esac
echo "#####################################################################"
done;;
7)
read -p "Enter table name:" NAME
while : 
do
            echo "You are now updating table $NAME"
            echo "1: UPDATE a single record"
            echo "2: UPDATE the entire record"
            echo "3: quit"
read -p "Enter a number[1-3]: " NUM
case $NUM in
1)N=$(tail -1 ~/dbs/$db/$NAME | wc -w)
for (( i=1 ; i<=$N ; i++ ))
do
echo "$i :  $(awk -v i="$i" '{print $i}' ~/dbs/$db/$NAME | head -1 )"
done
N=$(cat ~/dbs/$db/$NAME | wc -l)
i=$((N-2))
read -p "Enter the number of column: " column
read -p "Enter the value of main key: " match
read -p "Enter the value of new word: " newword
row=$(awk '{print $1}' ~/dbs/$db/$NAME | awk "/$match/ {print NR}")
awk -v r=$row -v c=$column -v new=$newword '{
    if (NR == r) {
        $c = new
    }
    print
}' ~/dbs/$db/$NAME > tmp && mv tmp ~/dbs/$db/$NAME


 ;;
2) read -p "Enter the value:" input
sed -i "/$input/d" ~/dbs/$db/$NAME
N=$(tail -1 ~/dbs/$db/$NAME | wc -w)
add=""
for (( i=1 ; i<=$N ; i++ ))
do
read -p "Enter $(awk -v i="$i" '{print $i}' ~/dbs/$db/$NAME | head -1 ) column value:" input
add="$add $input"
done
echo $add >> ~/dbs/$db/$NAME
 ;;


3) break;;
esac
echo "#####################################################################"
done;;
8)./main.sh;;
esac
echo "#####################################################################"
done
