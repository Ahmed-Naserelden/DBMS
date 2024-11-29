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
    echo "Welcome to the Elshiekh Database (BSQL) monitor.  Commands end with ; or \g."
    echo "Your BSQL connection id is 1"
    echo "Server version: 1.0.0-0ubuntu0.24.11.24 (Ubuntu)"
    echo 
    echo "Copyright (c) 2024, 2024, Biruni and/or its affiliates."
    echo "Elshiekh-SQL is a registered trademark of BSQL Corporation and/or its"
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
welcome
while true; do
    # set -f
    echo -n "isql> " 
    momQuery="";
    query=""
    # read -e query

    read -e query || break  # Break on EOF


    if [[ -z $query ]]; then
        continue
    fi


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

    momQuery=$( splitor "${momQuery}" )
    momQuery=($( convert_to_array "${momQuery}" ))

    for (( i=0; i < ${#momQuery[@]}; ++i )); do
        word="${momQuery[i]}"
        # echo "first char in word ${word:0:1}"
        if [[ $word == \"*\" || $word == \'*\' ]]; then  
            continue
        fi
        momQuery[$i]=$(echo "${momQuery[i]}" | tr '[:upper:]' '[:lower:]')
    done

    if [[ "${momQuery[0]}" == "create" &&  "${momQuery[1]}" == "database" ]]; then
        ./BSQL/createdatabase.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "use" ]]; then
        connectToDB "${momQuery[1]}"
    elif [[ "${momQuery[0]}" == "drop" && "${momQuery[1]}" == "database" ]]; then
        ./BSQL/dropdatabase.sh "${momQuery[@]}";
    elif [[ "${momQuery[0]}" == "delete" && "${momQuery[1]}" == "from" ]]; then
        ./BSQL/deletefromtable.sh "${momQuery[@]}";
    elif [[ "${momQuery[0]}" == "drop" && "${momQuery[1]}" == "table" ]]; then
        ./BSQL/droptable.sh "${momQuery[@]}";
    elif [[ "${momQuery[0]}" == "update" ]]; then
        ./BSQL/updatetable.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "show" &&  "${momQuery[1]}" == "databases" ]]; then
        listDB
    elif [[ "${momQuery[0]}" == "show" &&  "${momQuery[1]}" == "tables" ]]; then
        listTables  "${momQuery[2]}"
    elif [[ "${momQuery[0]}" == "create" &&  "${momQuery[1]}" == "table" ]]; then
        ./BSQL/createtable.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "select" ]]; then
        ./BSQL/select.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "insert" && "${momQuery[1]}" == "into" ]]; then
        ./BSQL/insert.sh "${momQuery[@]}"
    elif [[ "${momQuery[0]}" == "clear" ]]; then
        clear
    else
        echo "${momQuery[0]}: command not found"; 
    fi

done;
}
main