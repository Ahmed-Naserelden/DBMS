#!/bin/bash
source daemon/database.sh
source session/info.sh

momQuery=("$@")
c_db=$(current_user_db);

echo "${momQuery[@]}"
ret=$(createDB "${momQuery[2]}");
echo $ret