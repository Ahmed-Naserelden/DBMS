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


display_table_menu=("Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "SQL Mode" "Back")

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
			echo "soon v2.1 ...";
		;;
			
		"Back")
			./client/menu.sh		
		;;
		*)
			echo UNKNOWN USER
		esac

done;