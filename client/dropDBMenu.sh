#!/bin/bash
source daemon/database.sh
source session/info.sh


ret_databases=($(listDB));

# echo "${ret_databases[@]}";


select db in "${ret_databases[@]}"; do

    if [[ -n "$db" ]]; then
        res=$(deleteDB "$db")
        echo "$res";
        echo "" > $DB_SESSION_FILE
        ./client/menu.sh
        break;
    fi
    echo "No option selected. Press a number to choose an option."
done;
