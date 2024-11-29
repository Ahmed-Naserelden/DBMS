#!/bin/bash
source daemon/tables.sh
source session/info.sh

c_db=$( current_user_db );


read -p "Enter table name: "  tb_name

if [[ -z "$tb_name" ]]; then
    echo "Table name required"
    exit 20;
fi

query=("$c_db" "$tb_name");


PS3=$'Choose an option: '
# PS3=$'1) Add Column\n2) Create\nChoose an option: '


select nexto in "Add Column" "create"; do
    case $nexto in

        "Add Column")
            read -p "Enter Column Name: " col_name;

            if [[ ! $col_name ]]; then
                echo "Name of column must not empty";
                continue;
            fi

            echo "select $col_name column data type: ";

            select data_type in "number" "string"; do
                
                

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


