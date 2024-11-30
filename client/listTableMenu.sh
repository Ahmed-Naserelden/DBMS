#!/bin/bash
source daemon/tables.sh
source session/info.sh

c_db=$( current_user_db );

echo "Tables" > .tempo

ret_tables=$(listTables $c_db >> .tempo);

./session/formatTable.sh .tempo
echo "" > .tempo

# echo "${ret_tables[@]}" ;
