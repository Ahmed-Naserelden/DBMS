#!/bin/bash
source daemon/tables.sh
source session/info.sh

c_db=$( current_user_db );


read -p "Enter table name: "  tb_name

query=("$c_db" "$tb_name");


PS3=$'Choose an option: '
# PS3=$'1) Add Column\n2) Create\nChoose an option: '

select nexto in "Add Column" "create"; do
    case $nexto in

        "Add Column")
            read -p "Enter Column Name: " col_name;

            echo "select $col_name column data type: ";

            select data_type in "string" "number"; do
                
                

                query+=("$col_name" "$data_type");
                
                break;

                
            done;

        ;;

        "create")
            ret=$(createTable "${query[@]}");
            echo "$ret"
            break;
        ;;

    esac;
    echo "Press a number to choose an option."

done;


