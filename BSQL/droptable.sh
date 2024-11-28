#!/bin/bash
source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")

echo "${momQuery[@]}"

c_db=$(current_user_db);

ret=$( dropTable $c_db $3 )

echo $ret