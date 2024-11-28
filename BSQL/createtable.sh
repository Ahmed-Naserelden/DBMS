#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")
c_db=$(current_user_db);
query=("$c_db");

for((i=2; i < "${#momQuery[@]}"; ++i)){
    query+=("${momQuery[i]}");
}
# echo "${query[@]}"

ret=$(createTable "${query[@]}")
echo $ret

# create table department(department_id number, department_name string, mgr_id number);