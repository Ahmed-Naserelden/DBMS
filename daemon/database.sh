#!/bin/bash

# B2RADB_HOME="/home/biruni/Downloads/ITI-Intake-45/Bash/DBMS/B2RADB_HOME"
# CONFIG_FILE="/home/biruni/Downloads/ITI-Intake-45/Bash/DBMS/session/database"
# CONFIG_FILE=$DB_SESSION_FILE
# createDB <database>
source session/info.sh

# function take parmenters as
# createDB <database-name>
createDB(){
    DATABASE="$B2RADB_HOME/$1"

    if [[ ! -d $DATABASE ]]; then
        mkdir $DATABASE
        mkdir "$DATABASE/.metadata"
    else
        echo "database exist"
    fi
}

# dropDB = deleteDB
# function take parmenters as
# deleteDB <database-name>
deleteDB(){
    DATABASE="$B2RADB_HOME/$1"
    if [[ -d $DATABASE ]]; then
        rm -rf $DATABASE
        cur_db=$(current_user_db);
        if [[ "$1" == "$cur_db" ]]; then
            echo "" > $DB_SESSION_FILE;
        fi
    else
        echo "database not exist";
        exit 1;
    fi

}

# function take parmenters as
# renameDB <Old-db-name> <new-db-name>
renameDB(){
    OLD_NAME="$B2RADB_HOME/$1"
    NEW_NAME="$B2RADB_HOME/$2"
    if [[ -d $OLD_NAME ]]; then
        mv $OLD_NAME $NEW_NAME
    else
        echo "$1 database not exist"
        exist 1
    fi
}

# function take parmenters as 
# connectToDB <database>
connectToDB(){
    DATABASE="$B2RADB_HOME/$1"
    if [[ -d $DATABASE ]]; then
        echo -n "$1" > $DB_SESSION_FILE
    else
        echo "Database $1 Doesn't Exist";
    fi
}

listDB(){
    ls -1 $B2RADB_HOME
}

main(){
    select db in useDB createDB renameDB deleteDB listDB; do
        case $db in
            "useDB" )
                read -p "Enter DB: " db_name
                connectToDB $db_name
            ;;
            "createDB" )
                read -p "Enter DB Name: " db_name
                createDB $db_name
            ;;
            "renameDB" )
                read -p "Enter DB Name: " db_name
                read -p "Enter DB new Name: " new_name
                renameDB $db_name $new_name
            ;;
            "listDB" )
                listDB
            ;;
            "deleteDB" )
                read -p "Enter DB Name: " db_name
                deleteDB $db_name
            ;;
            
            * )
                break
            ;;
            
        esac
    done
}
# listDB
# main