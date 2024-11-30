#! /usr/bin/bash
source session/info.sh

shopt -s extglob
export lc_collate=c
PS3="Choose an option : " 

clear;


cur_db_=$(current_user_db )

echo "########################################################################################"
echo "################################# current DB ${cur_db_} ######################################"
echo "########################################################################################"
echo


display_table_menu=("List Tables" "Select From Table" "Insert into Table" "Update Table" "SQL Mode" "Delete From Table" "Create Table" "Drop Table" "Back")

select option in "${display_table_menu[@]}"; do 

	case $option in

		"Create Table")
			./client/createTableMenue.sh
		;;

		"List Tables")
			./client/listTableMenu.sh
		;;

		"Drop Table")
			./client/dropTableMenue.sh
		;;

		"Insert into Table")
			./client/insertIntoTableMenu.sh
		;;

		"Select From Table")
			./client/selectFromTableMenue.sh
		;;  

		"Delete From Table")
			./client/deleteFromTableMenu.sh
		;; 

		"Update Table")
			./client/updateTableMenu.sh
		;; 

		"SQL Mode")
			echo "write query in single line."; 
            read -p "isql> " query
            if [[ -z $query ]]; then
                continue;
            fi
            rest=$(echo "$query" | ./BSQL/bsql.sh | tail +11);
            echo "$rest";
			# echo "soon v2.1 ...";
		;;
			
		"Back")
			./client/menu.sh		
		;;
		*)
			echo UNKNOWN USER
		esac

done;