#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")

c_db=$(current_user_db);

query=("$c_db");

for((i=2; i < "${#momQuery[@]}"; ++i)){
    if [[ "${momQuery[i]}" == "where" ]]; then
        continue;
    fi
    query+=("${momQuery[i]}");
}

# echo "${query[@]}"

ret=$( deleteFromTable "${query[@]}" );
echo "$ret"

# delete from employees where employee_id = 1;