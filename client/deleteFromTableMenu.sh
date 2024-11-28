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
        # option
    columns=($( getTableColumns $c_db $tb ))
    
    condition=();

    operations=("=" "!=" "<" ">" "<=" ">=");
    echo "Select columns you need in condition: "
    select col in "${columns[@]}"; do
            condition+=("$col");
            echo "select condition operation: "
            select op in "${operations[@]}"; do
                
                if [[ ! $op ]]; then
                    echo "Enter valid $op"
                    continue
                fi;
                condition+=("$op")
                read -p "Enter valid value suitable for condition: " value
                condition+=("$value")
                
                query_result=$(deleteFromTable $c_db $tb "${condition[@]}");
                
                echo "$query_result"
                
                exit 0;

                break;
            done

        break
    done;

done;

