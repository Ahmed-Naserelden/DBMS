#!/bin/bash
source daemon/tables.sh
source session/info.sh

c_db=$( current_user_db );

ret_tables=($(listTables $c_db) "back" )

# echo "${ret_tables[@]}"
echo "Select Table from $c_db Database";
select tb in "${ret_tables[@]}"; do

    if [[ "$tb" == "back" ]]; then
        ./client/tableMenu.sh
        break;
    fi

    ret=$(dropTable "$c_db" "$tb");
    
    echo "$ret";
    break;

done;

