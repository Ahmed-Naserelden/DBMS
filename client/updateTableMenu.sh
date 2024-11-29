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
    
    selectColumnsToUpdateAndItsNewValue=();

    for col in "${columns[@]}"; do

        read -p "Do You Need to update $col, press(y/N): " flage

        if [[ $flage == "y" || $flage == "Y" ]]; then
            selectColumnsToUpdateAndItsNewValue+=("$col");
            read -p "Enter The new Value of $col: " newval
            selectColumnsToUpdateAndItsNewValue+=("$newval")
        fi

    done; 


    operations=("=" "!=" "<" ">" "<=" ">=");
    read -p "Have you condition, press (y/N): " cond
    if [[ "$cond" == "y" || "$cond" == "Y" ]] ; then

        echo "Select columns you need in condition: "
        select col in "${columns[@]}"; do
                if [[ ! $col ]]; then
                    echo "invalid number ";
                    continue;
                fi

                echo "select condition operation: "
                
                select op in "${operations[@]}"; do
                    
                    if [[ ! $op ]]; then
                        echo "invalid number ";
                        continue;
                    fi
                    read -p "Enter valid value suitable for condition: " value

                    query_result=$(updateTable $c_db $tb "${selectColumnsToUpdateAndItsNewValue[@]}" where $col $op $value );
                    echo "$query_result"
                    exit 0;

                    break;
                done

            break
        done;
    fi

    query_result=$(updateTable $c_db $tb "${selectColumnsToUpdateAndItsNewValue[@]}")
    
    echo "$query_result"
    # ./session/formatTable.sh .tempo
    # echo "" > .tempo

done;

