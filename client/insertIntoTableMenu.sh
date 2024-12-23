#!/bin/bash
source daemon/tables.sh
source session/info.sh

c_db=$( current_user_db );

ret_tables=($(listTables $c_db) "back" )

# echo "${ret_tables[@]}"
echo "Select Table from $c_db Database";
select tb in "${ret_tables[@]}"; do

    if [[ ! $tb ]]; then
        echo "invalid number";
        continue;
    fi

    if [[ "$tb" == "back" ]]; then
        ./client/tableMenu.sh
        break;
    fi
        # option
    columns=($( getTableColumns $c_db $tb ))
    
    
    columnsAndValuesToInsert=();

    for col in "${columns[@]}"; do

        read -p "Enter value of $col column: " value;

        columnsAndValuesToInsert+=("$col" "$value")
    
    done; 
    # echo "Do you want insert new record ?"
    # echo "${columnsAndValuesToInsert[@]}"
    query_result=$(insertToTable $c_db $tb "${columnsAndValuesToInsert[@]}")
    echo "$query_result"
    # ./session/formatTable.sh .tempo
    # echo "" > .tempo
    break;

done;

