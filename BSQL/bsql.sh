#!/bin/bash

source daemon/database.sh
source daemon/database.sh
source session/info.sh

welcome (){
    echo "Welcome to the Biruni Database (BSQL) monitor.  Commands end with ; or \g."
    echo "Your BSQL connection id is 1"
    echo "Server version: 1.0.0-0ubuntu0.24.11.24 (Ubuntu)"
    echo 
    echo "Copyright (c) 2000, 2024, Biruni and/or its affiliates."
    echo "BSQL is a registered trademark of BSQL Corporation and/or its"
    echo "affiliates. Other names may be trademarks of their respective"
    echo "owners."
    echo 
    echo "Type 'help;' or '\h' for help. Type '\c' to clear the current input statement."
    echo 
}

main (){
welcome
while true; do
    echo -n "BSQL> " 
    momQuery="";
    query=""
    read query
    if [[ $query == "" ]]; then
        continue;
    fi
    
    while [[ "${query: -1}" != ";" ]] ; do
        momQuery="$momQuery $query";
        echo -n "   -> "
        read query
    done;
    
    momQuery="$momQuery $query";
    
    if [[ $momQuery == "" ]]; then
        continue;
    fi
    # echo $momQuery
    if [[ $( echo $momQuery | tr "A-Z" "a-z" ) == "exit;" || $( echo $momQuery | tr "A-Z" "a-z" ) == "exit ;" ]]; then
        echo "Bye"
        exit 0;
    fi




############################################################################################################################################################################
############################################################################################################################################################################
######################################################### CODING ###########################################################################################################
############################################################################################################################################################################
############################################################################################################################################################################
############################### Databases
##1. craete DATABASE
    # momQuery="SELECT * FROM table where employee_id = 20;"
    echo $momQuery

    
##2. DROP DATABASE
    

##4. SHOW DATABASES
    if [[ $momQuery =~ "show databases;" ]]; then
        listDB
    fi

############################################################################################################################################################################
############################################################################################################################################################################
############################### Tables
##1. CREATE TABLE

##2. DROP TABLE

##3. SELECT FROM TABLE

##4. DELETE FROM TABLE

##5. UPDATE TABLE

done;
}
main