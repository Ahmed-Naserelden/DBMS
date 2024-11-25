#!/bin/bash

source daemon/database.sh
source daemon/database.sh
source session/info.sh

# createTable hr employees employee_id NUMBer last_name stRing
# createTable hr departments department_id NUMBer department_name string
# list_tables hr
# dropTable socet departments
# insertToTable hr employees employee_id 19 salary 58925 

display_menu=("Create Database" "List Databases" "Connect To Database" "Drop Table" "Exit")

select option in "${display_menu[@]}"
do 
case $option in
"Create Database")
	read -p "Please Enter Database Name : " DB_NAME
        if [ -e  $DB_NAME ]
        then 
            echo " DB IS ALREADY EXIST "
        else  
            mkdire $DB_NAME
            echo "DB IS CREATED SUCCESSFULLY "
        fi   

	;;
"List Databases")
    listDB
	;;
"Connect To Database")
    read -p "Enter DB: " database
    connectToDB $database
	;;
"Drop Table")

    curdatabase=$(current_user_db)
    read -p "Enter Table name: " tablename
    ret=$(dropTable $curdatabase $tablename) 
    echo $ret
	;;
"Exit")
break
;;
*)
	echo UNKNOWN USER
esac
done