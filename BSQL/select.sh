#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")
query=()

c_db=$(current_user_db);
length=${#momQuery[@]}

query+=("$c_db");
# query+=("");

from=0;
for((i=0; i < "$length"; ++i)){

    if [[ $from -eq 1 ]]; then
        query[1]="${momQuery[i]}";
        from=2;
        # echo "From=2"
        continue;
    elif [[ "${momQuery[i]}" == "from" ]]; then
        # echo "From=1";
        from=1;
        continue;
    fi
    # echo "$from" "${momQuery[i]}"

    query+=("${momQuery[i]}");
}

# echo "${query[@]}"

ret=$( selectFromTable "${query[@]}" > .tempo );
./session/formatTable.sh .tempo
echo "" > .tempo


# new_length=$((length - 3)) # to remove from <table>
# ret=$( selectFromTable "$c_db" "${momQuery[-1]}" "${momQuery[@]:1:new_length}" > .tempo );
# ./session/formatTable.sh .tempo
# echo "" > .tempo

# select employee_id, first_name, salary from employees;
# select employee_id, first_name, salary from employees where salary < 5291;



# select empyee_id, first_name, salary from employees;