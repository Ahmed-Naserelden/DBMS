#!/bin/bash

source daemon/database.sh
source session/info.sh
# source client/tableMenu.sh
clear


# createTable hr employees employee_id NUMBer last_name stRing
# createTable hr departments department_id NUMBer department_name string
# list_tables hr
# dropTable socet departments
# insertToTable hr employees employee_id 19 salary 58925 

echo "########################################################################################"
echo "################################# Welcome $USER to DBMS ###############################"
echo "########################################################################################"


PS3="Choose an option : " 

display_menu=("Connect To Database" "List Databases" "Create Database"  "Drop DB" "Clear" "Exit")

select option in "${display_menu[@]}"; do 
    case $option in
        "Create Database")
            read -p "Please Enter Database Name : " DB_NAME
            
            if [[ -z "$DB_NAME" ]]; then
                echo "DB name required"
                continue;
            fi

            res=$(createDB $DB_NAME);
            echo "$res";
        ;;

        "List Databases")
            ./client/listDBMenu.sh
        ;;
        
        "Connect To Database")
            ./client/connectToDB.sh
        ;;

        "Drop DB")
            ./client/dropDBMenu.sh
        ;;

        "Clear")
            clear;
        ;;

        "Exit")
            
            exit 0;
            ;;
        *)  
            continue;
        ;;
    esac
done;

