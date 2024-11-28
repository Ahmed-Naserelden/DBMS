source daemon/database.sh
source daemon/tables.sh
source session/info.sh

momQuery=("$@")

echo "${momQuery[@]}"

ret=$( deleteDB $c_db "${momQuery[2]}" )

echo $ret