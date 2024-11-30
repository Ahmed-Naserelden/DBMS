#!/bin/bash
source daemon/database.sh
source session/info.sh


ret_databases=$(listDB);

# echo "${ret_databases[@]}";

echo "Databases" > .tempo

ret_tables=$(listDB >> .tempo);

./session/formatTable.sh .tempo
echo "" > .tempo