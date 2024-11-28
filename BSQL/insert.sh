#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")

c_db=$(current_user_db);
length=${#momQuery[@]}
query=();
query+=($c_db);
query+=("${momQuery[2]}")
# echo "${momQuery[@]}";

values=$(( (length - 3) / 2 + 1 ));
finish=$(( values + 2 ));

for ((i=3; i < $finish ; ++i)){
    col="${momQuery[i]}";
    val="${momQuery[i + values]}";
    query+=("$col" "$val");
    # echo $col $val
}
echo "${query[@]}"

ret=$( insertToTable "${query[@]}" );
echo "$ret"


# insert into employees (employee_id, first_name,salary) values (23, "Maqboul", 23434);
# insert into department (department_id, department_name, mgr_id) values (2, "PR",2);