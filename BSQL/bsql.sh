#!/bin/bash

source daemon/database.sh
source daemon/tables.sh
source session/info.sh


splitor(){
    # IFS=',=<>()'
    # Set the separators
    input=$1;
    length=${#input};

    # echo ${input:11} ${input:2:1} ${input:3:1}
    query="";
    for ((i = 1; i <= $length; i++)); do
        char="${input:i:1}"

        if [[ "$char" == ";" ]]; then
            break;
        fi
        # select employee_id, first_name 
        # from employees
        # where salary = 10;

        # insert into employees (employee_id, first_name, salary)
        # values (121, "Ahmed Amer", 323234);

        # create table students(
        #   student_id number,
        #   student_name string
        # );

        # update employees
        # set salary= 1000;
        
        # Check if the current character matches any of the separators
        if [[ "$char" == "(" || "$char" == ")" || "$char" == "," ]]; then
            # Replace separator with a space
            if [[ "${query: -1}" != " " ]]; then
                query="$query ";
            fi
            continue
        fi

        if [[ "$char" == "<" || "$char" == ">" ]]; then

            if [[ "${query: -1}" == "=" ]]; then
                echo "Opertion Errors ";
                continue;
            fi

            if [[ "${query: -1}" != " " ]]; then
                query="$query $char";
                continue;
            fi
            
        elif [[ "$char" == "=" ]]; then
            if [[  "${query: -1}" == "<" || "${query: -1}" == ">" ]]; then
                query="$query$char ";
            elif [[ "${query: -1}" == "=" ]]; then
                echo "Opertion Errors ";
                break;
            else
                query="$query $char";
            fi
            continue;
        elif [[ "${query: -1}" == "<" || "${query: -1}" == ">" ]]; then
            
            if [[ "$char" == "=" ]]; then
                query="$query$char ";
            else
                query="$query $char";
            fi
            continue;
            
        elif [[  "${query: -1}" == "=" ]]; then
            if [[ "${query: -1}" == "<" || "${query: -1}" == ">" ]]; then
                query="$query$char ";
                continue;
            fi
            query="$query $char";
            continue;
        fi
        # select employee_id , first_name from employees where salary = 10;
        
        query="$query$char";  # Print character without a newline
    done
    echo "$query"
}

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

convert_to_array() {
    input="$1"
    IFS=' ' read -r -a array <<< "$input"
    
    # Print the array as space-separated elements
    echo "${array[@]}"
}

main (){

    HISTFILE="~/.bsql_history"  # File to store command history
    touch "$HISTFILE"         # Ensure the history file exists
    history -r "$HISTFILE"    # Load the history file
welcome
while true; do
    set -f
    echo -n "Elshikh-SQL> " 
    momQuery="";
    query=""
    read -e query
    if [[ $query == "" ]]; then
        continue;
    fi
    
    while [[ "${query: -1}" != ";" ]] ; do
        momQuery="$momQuery $query";
        echo -n "   -> "
        read -e query
    done;

    set +f
    
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
##1. craete DATABASE;
    # momQuery="SELECT * FROM table where employee_id = 20;"
    # echo $momQuery
    momQuery=$( splitor "${momQuery}" )
    momQuery=($( convert_to_array "${momQuery}" ))
    # echo " ======== ${momQuery} ${momQuery[1]} ${momQuery[2]}"

    if [[ "${momQuery[0]}" == "create" &&  "${momQuery[1]}" == "database" ]]; then
        echo "${momQuery[@]}"
        ./BSQL/createdatabase.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "use" ]]; then
        connectToDB "${momQuery[1]}"
    elif [[ "${momQuery[0]}" == "drop" && "${momQuery[1]}" == "database" ]]; then
        echo "${momQuery[@]}"
        ./BSQL/dropdatabase.sh "${momQuery[@]}";
    
    elif [[ "${momQuery[0]}" == "delete" && "${momQuery[1]}" == "from" ]]; then
        echo "${momQuery[@]}"
        ./BSQL/deletefromtable.sh "${momQuery[@]}";
    elif [[ "${momQuery[0]}" == "drop" && "${momQuery[1]}" == "table" ]]; then
        echo "${momQuery[@]}"
        ./BSQL/droptable.sh "${momQuery[@]}";
    
    elif [[ "${momQuery[0]}" == "update" ]]; then
        # echo "${momQuery[@]}"
        ./BSQL/updatetable.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "show" &&  "${momQuery[1]}" == "databases" ]]; then
        listDB
    elif [[ "${momQuery[0]}" == "show" &&  "${momQuery[1]}" == "tables" ]]; then
        listTables  "${momQuery[2]}"
    elif [[ "${momQuery[0]}" == "create" &&  "${momQuery[1]}" == "table" ]]; then
        echo "${momQuery[@]}"
        ./BSQL/createtable.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "select" ]]; then
        echo "${momQuery[@]}"
        ./BSQL/select.sh "${momQuery[@]}"

    elif [[ "${momQuery[0]}" == "insert" && "${momQuery[1]}" == "into" ]]; then
        # echo "From bsql.sh"
        echo "${momQuery[@]}"
        ./BSQL/insert.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "clear" ]]; then
        clear
    else
        echo "${momQuery[0]}: command not found"; 
    fi

##2. DROP DATABASE
    

##4. SHOW DATABASES
    # if [[ $momQuery =~ "show databases;" ]]; then
    #     # listDB
    #     echo
    # fi

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