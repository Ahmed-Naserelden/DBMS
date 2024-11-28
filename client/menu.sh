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
echo "################################# Welcome to DBMS ######################################"
echo "########################################################################################"
echo




PS3="Choose an option : " 

display_menu=("Create Database" "List Databases" "Connect To Database" "Drop DB" "SQL Mode" "Exit")

select option in "${display_menu[@]}"; do 
    case $option in
        "Create Database")
            read -p "Please Enter Database Name : " DB_NAME
            createDB $DB_NAME
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
        "SQL Mode")
            echo "soon v2.1 ...";
            ;;
        "Exit")
            break
            ;;
        *)  
            echo UNKNOWN USER
        ;;
    esac
done




    # if [[ "$option" ==  "Create Database" ]]; then
    #     echo ""
    # elif [[ "$option" == "Connect To Database" ]]; then
    #     echo ""
    # elif [[ "$option" == "SQL Mode"  ]]; then
    #     echo ""
    # elif [[ "$option" == "Drop DB" ]]; then
    #     echo ""
    # elif [[ "$option" == "Exit" ]]; then
    #     echo ""
    # else
    #     echo ""
    # fi


