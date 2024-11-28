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
    
    selectColumnsToUpdateAndItsNewValue=();

    for col in "${columns[@]}"; do

        echo "Do You Need to update $col: "
    
        select flage in yes no; do
    
            case $flage in
                yes )
                    selectColumnsToUpdateAndItsNewValue+=("$col");
                    read -p "Enter The new Value of $col: " newval
                    selectColumnsToUpdateAndItsNewValue+=("$newval")
                ;;
            esac;

            break;
        done;
    
    done; 


    operations=("=" "!=" "<" ">" "<=" ">=");
    echo "Have you a condition: "

    select cond in yes no; do
        case $cond in
            yes )
                echo "Select columns you need in condition: "
                select col in "${columns[@]}"; do
                        echo "select condition operation: "
                        select op in "${operations[@]}"; do
                            
                            read -p "Enter valid value suitable for condition: " value

                            query_result=$(updateTable $c_db $tb "${selectColumnsToUpdateAndItsNewValue[@]}" where $col $op $value );

                            exit 0;

                            break;
                        done

                    break
                done;

            ;;
        esac

        break;
    done;


    query_result=$(selectFromTable $c_db $tb "${selectColumnsToUpdateAndItsNewValue[@]}")
    # ./session/formatTable.sh .tempo
    # echo "" > .tempo

done;

