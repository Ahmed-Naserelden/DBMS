#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@");

c_db=$(current_user_db);
query=("$c_db");

flage=1;
length=${#momQuery[@]};

# echo "${momQuery[@]}"

for(( i=1; i < $length; ++i )){
    if [[ "${momQuery[i]}" == "set" ]]; then
        continue;
    fi
    # if $flage  onely that will run even falge=0
    if [[ "$flage" == "1" && ( "${momQuery[i]}" == "=" || "${momQuery[i]}" == "<" || "${momQuery[i]}" == ">" || "${momQuery[i]}" == "<=" || "${momQuery[i]}" == ">=" ) ]]; then
        continue;
    fi

    if [[ "${momQuery[i]}" ==  "where" ]]; then
        flage=0;
    fi

    query+=("${momQuery[i]}");
}
# echo "${query[@]}"

updateTable "${query[@]}"

# update department set department_name = "hr", mgr_id = 22 where department_id = 1;

