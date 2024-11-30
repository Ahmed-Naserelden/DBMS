#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")
# echo "${momQuery[@]}"


c_db=$(current_user_db);
query=("$c_db");
query+=("$3");



##############
####### Determine the primary key
##########
primarykey=3;
for(( i=5; i < "${#momQuery[@]}"; ++i)){
    if [[ "${momQuery[$i]}" == "primary" && "${momQuery[i+1]}" == "key" ]]; then
        primarykey=$(($i - 2));
        break;
    fi
}

# echo "primary key $primarykey"

query+=("${momQuery[primarykey]}");
query+=("${momQuery[primarykey + 1]}");


for((i=3; i < "${#momQuery[@]}"; ++i)){
    if [[ "$i" == "$primarykey" ]]; then
        (( i += 3));
        continue;
    fi
    query+=("${momQuery[i]}");
}


# echo "${query[@]}"


ret=$(createTable "${query[@]}")
echo $ret

# create table department( department_id number, department_name string, mgr_id number);

# create table department( department_id number, department_name string, mgr_id number primary key );