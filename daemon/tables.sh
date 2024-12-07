#!/bin/bash
source middleware/lowercase.sh
source session/info.sh
# B2RADB_HOME="/home/biruni/Downloads/ITI-Intake-45/Bash/DBMS/B2RADB_HOME"

getTableColumns(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"

    table_columns=($(awk -F : '{print $1}' $METADATA));

    echo "${table_columns[@]}";
}

find_index(){
    ele=$1;
    shift;
    arr=$@;

    if [[ "$ele" == "*" ]]; then
        IDXS=();
        for ((i=1; i <= $#; ++i)); do
            IDXS+=("$i");
        done

        echo "${IDXS[@]}";
        exit 0;

    else
        for ((i=1; i <= $#; ++i)); do
            vcol=$(echo "${arr[@]}" | cut -d ' ' -f$i);
            if [[ "$vcol" == "$ele" ]]; then
                # Exit after finding the element
                echo "$i";
                exit 0;
            fi
        done
    fi
    echo "-1"
    exit 1;
}

# function take parmenters as 
# list_tables [database]
listTables(){
    DATABASE="$B2RADB_HOME/$1"
    if [[ ! $1 ]]; then
        DATABASE="$B2RADB_HOME/$(current_user_db)"
    fi

    # check DATABASE name is valid
    # ...
    if [[ ! -d $DATABASE ]]; then
        echo "$1 Database Not Exist";
        exit 1;
    fi

    if [[ $(current_user_db) == "" ]]; then
        echo "USE DB FIRST";
    
    else
        echo "$(ls -1 $DATABASE)"
    fi

}
# listTables hr
# function take parmenters as 
# createTable <data-base> <table-name> <col-1>2 <datatype-1> <col-2> <datatype-2> ... <col-n> <datatype-n>
# col 1 will be primary key by default
createTable(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    
    # check METADATA name and DATABASE name is valid
    # ...
    if [[ ! -d $DATABASE ]]; then
        echo "$1 Database Not Exist";
        exit 1;
    fi

    if [[ -f $TABLE ]]; then
        echo "$2 Table Exist";
        exit 1;
    fi
    # ...
    ###################################################

    declare -A column_exist

    touch $TABLE
    touch $METADATA


    HEADER="";


    for(( i=3; i <= $#; i+=2)); do
        column=$(lowercase ${@:i:1})
        datatype=$(lowercase ${@:i+1:1});

        if [[ "${column_exist[$column]}" == "1" ]]; then
            rm $TABLE
            rm $METADATA
            echo "$column Column exists before."
            exit 2;
        fi

        column_exist[$column]="1";

        echo $column:$datatype >> $METADATA;
    
        if [[ $HEADER != "" ]]; then
            HEADER="$HEADER:"
        fi
        HEADER="$HEADER$column";
    done;

    # check above code run correctly 
    # ...
    # code
    # .....
    # .....
    ###################################################
    echo $HEADER > $TABLE;
}

# function take parmenters as 
# dropTables <database> <tablename>
dropTable(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    
    # check METADATA name and DATABASE name is valid
    # ...
    if [[ ! -d $DATABASE ]]; then
        echo "$1 Database Not Exist";
        exit 1;
    fi

    if [[ ! -f $TABLE ]]; then
        echo "$2 Table Not Exist";
        exit 1;
    fi

    rm $TABLE $METADATA
}

# ==============================================================================================================
# function take parmenters as 
# check_column_value <data-base> <table-name> <col name> <value>
check_column_value(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    column_name=$3
    value=$4

    # 1. check if table contains column with same name 
    # 2. check if column data type compatable with value type
    # 3. return the 0 if ok else 1

    column_data_type=$(sed -n "/$column_name/p"  $METADATA | cut -d: -f2);
    if [[ ! $column_data_type ]]; then
        echo "$column_name Column Not Found";
        exit 1;
    fi

    case $column_data_type in 
        'number' )
            case $value in
            ''|*[!0-9]*)
                echo "Invalid Value For $column_name Column(data-type: $column_data_type)";
                exit 45;
            ;;
            esac
            exit 0;
        ;;
        'string' )
            echo "String";
        ;;
        * )
            echo "$column_data_type doesn't supported."
            exit 1;
        ;;
    esac

    echo $column_name $value $column_data_type 
    exit 0;
}

# function take parmenters as 
# insertToTable <data-base> <table-name> <col 1> <value 1> ... <col n> <value n>
insertToTable(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    
    # check table name and DATABASE name is valid
    # ...
    # code
    # .....

    if [[ ! -d $DATABASE ]]; then
        echo "$1 Database Not Exist";
        exit 1;
    fi
    if [[ ! -f $TABLE ]]; then
        echo "$2 Table Not Exist";
        exit 1;
    fi

    # hold the columns that exist in table
    table_columns=($(awk -F : '{print $1}' $METADATA));
    declare -A recored_column_value_pair

    # ...
    # 1. check columns & its data types
    # 2. arrange the columns valuse according to its order in table
    # 3. add values as record with columns order to isert into table
    # 4. check if primary key is null or exist before
    # 5. 

    for(( i=3; i <= $#; i+=2)); do
        column=$(lowercase ${@:i:1})
        value=${@:i+1:1};

        # echo $column $value
        # 1. check columns & its data types
        col_val_are_valid=$(check_column_value $1 $2 $column $value);
        
        if [[ $? == 0 ]]; then
            recored_column_value_pair[$column]=$value;
        else
            echo $col_val_are_valid
            exit 1;
        fi
    done;

    # 3. add values as record with columns order to isert into table
    RECORD=""
    f=0
    for i in ${table_columns[@]}; do
        if [ $f -eq 1 ]; then
            RECORD="$RECORD:"
        fi

        RECORD="$RECORD${recored_column_value_pair[$i]}"
        f=1
    done

    # 4. check primary key

    primarykey=$(echo $RECORD | cut -d: -f1);

    if [[ ! $primarykey ]]; then
        echo "Primary Cant be null value."
        exit 1;
    fi
    
    # echo "primary key" $primary

    flage=$(cut -d: -f1 $TABLE | grep $primarykey);

    if [[ $flage ]]; then
        echo "$primarykey Primary key exist before."
        exit 1;
    fi

    # insert into table 
    echo $RECORD >> $TABLE;
    exit 0;
}

# ret=$( insertToTable hr employees employee_id 23 first_name "Maqboul" salary 23434 );
# echo $ret

# function take parmenters as 
# selectFromTable <database> <table> <col1> <col2> ... <colN> where <col> = 1 
selectFromTable(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    
    condition="-1";
    # select * from employees;
    # set -f
    # echo "=== $3";
    # set +f
    column_indexes=();
    table_columns=($(awk -F : '{print $1}' $METADATA));

    # get columns that get as parm indexes in table
    for ((i=3; i <= $#; ++i)){
        col_par=${@:i:1}
        if [[ $col_par == "where" ]]; then
            condition=$(( i + 1));
            break;
        fi
        idx=($(find_index "$col_par" "${table_columns[@]}"));
        # echo "${idx[@]}"

        if [[ $idx == "-1" ]]; then 
            echo "$col_par Columns Not Found.";
            exit 1;
        fi
        column_indexes+=("${idx[@]}");
    }

    if [[ $condition != "-1" ]]; then # that is mean query containes where condition
        
        condition_col=${@:$condition:1};
        operation=${@:$((condition+1)):1};
        condtion_val=${@:$((condition+2)):1};

        #check column that used in where is correct
        condition_col_idx=$(find_index "$condition_col" "${table_columns[@]}" );
        if [[ $condition_col_idx == "-1" ]]; then 
            echo "$col_par Columns Not Found.";
            exit 1;
        fi

        # echo "where $condition_col $operation $condtion_val;";
    fi    

        # echo "Operation $operation"
        awk -v cond_col_idx="${condition_col_idx}" -v op="$operation" -v con_val="$condtion_val" 'BEGIN{
            FS=":";
            OFS=" ";
        }{
            if (NR == 1){
                print
                next;
            }
            if( ! $cond_col_idx ){
                next;
            }

            # Check condition on the specified column
            condition_met = (op == "=" && $cond_col_idx == con_val) || 
                    (op == "!=" && $cond_col_idx != con_val) || 
                    (op == ">"  && $cond_col_idx > con_val)  || 
                    (op == "<="  && $cond_col_idx <= con_val)  || 
                    (op == ">="  && $cond_col_idx >= con_val)  || 
                    (op == "<"  && $cond_col_idx < con_val) || (op == "");

            if (condition_met) {
                print
            }


            # if(op == "=" || op == "<=" || op == ">="){
            #     if($cond_col_idx == con_val){
            #         print
            #     }
            # }
            # else if(op == ">" || op == ">="){
            #     if($cond_col_idx > con_val){
            #         print
            #     }
            # }
            # else if(op == "<" || op == "<="){
            #     if($cond_col_idx < con_val){
            #         print
            #     }
            # }else if (op == "!="){
            #     if($cond_col_idx != con_val){
            #         print
            #     }
            # }else{
            #     print
            # }
        }END{
        }' $TABLE | cut -d: -f"${column_indexes[*]}"
    

}
# selectFromTable hr employees
# selectFromTable hr employees employee_id first_name where first_name "!=" "";

# function take parmenters as 
#                                             
# insertToTable <data-base> <table-name>  <co1> [ <, >, =, <=, >= ] <val>

deleteFromTable(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    
    # check table name and DATABASE name is valid
    # ...
    if [[ ! -d $DATABASE ]]; then
        echo "$1 Database Not Exist";
        exit 1;
    fi

    if [[ ! -f $TABLE ]]; then
        echo "$2 Table Not Exist";
        exit 1;
    fi
    
    condition_col=$3
    operation=$4
    condtion_val=$5


    if [[ ! $3 || ! $4 || ! $5 ]]; then
        echo "Not Valid Condition";
        exit 1;
    fi

    table_columns=($(awk -F : '{print $1}' $METADATA));

    #  check codition_col is valid column
    #check column that used in where is correct
    condition_col_idx=$(find_index "$condition_col" "${table_columns[@]}" );
    if [[ $condition_col_idx == "-1" ]]; then 
        echo "$col_par Columns Not Found.";
        exit 1;
    fi



    awk -v cond_col_idx="${condition_col_idx}" \
        -v op="$operation" \
        -v con_val="$condtion_val"\
        'BEGIN{
            FS=":";
            OFS=":";
            split(updated_cols, cols, " ");
            split(updated_vals, vals, " ");

        }{
            if (NR == 1){
                print 
                next;
            }
            # Check condition on the specified column
            condition_met = (op == "=" && $cond_col_idx == con_val) || 
                    (op == "!=" && $cond_col_idx != con_val) || 
                    (op == ">"  && $cond_col_idx > con_val)  || 
                    (op == "<="  && $cond_col_idx <= con_val)  || 
                    (op == ">="  && $cond_col_idx >= con_val)  || 
                    (op == "<"  && $cond_col_idx < con_val);

            if (condition_met && $cond_col_idx != "") {
                next
                # continue;
                # # Update specified columns
                # for (i in cols) {

                #     $cols[i] = vals[i];
                #     # print $cols[i]
                # }
            }

            print 

        }END{
        }' $TABLE  > tmp_table && mv tmp_table "$TABLE";
}

# deleteFromTable hr employees employee_id "=" 20;

# function take parmenters as 
# updateTable <database> <table> <col 1> <val 1> ...  <col n> <val n> where col = val
updateTable(){
    DATABASE="$B2RADB_HOME/$1"
    TABLE="$DATABASE/$2"
    METADATA="$B2RADB_HOME/$1/.metadata/$2"
    
    # check table name and DATABASE name is valid
    # ...
    # code
    # .....
    if [[ ! -d $DATABASE ]]; then
        echo "$1 Database Not Exist";
        exit 1;
    fi

    if [[ ! -f $TABLE ]]; then
        echo "$2 Table Not Exist";
        exit 1;
    fi
    # ...

    column_indexes=();
    updated_values=();
    table_columns=($(awk -F : '{print $1}' $METADATA));
    condition="-1"
    # get columns that get as parm indexes in table
    for ((i=3; i <= $#; i+=2)){
        col_par=${@:i:1}
        value=${@:i+1:1};


        if [[ $col_par == "where" ]]; then
            condition=$(( i + 1));
            break;
        fi

        # check datatype of columns
        # 1. check columns & its data types
        # echo " check columns "
        col_val_are_valid=$(check_column_value $1 $2 $col_par $value);
        # echo " result = > > > $col_val_are_valid"
        status=$?
        # echo "ret = $status"
        if [[ $status -ne 0 ]]; then
        
            echo "error in data type: $col_par $value"
            # echo $col_val_are_valid
            exit 1;
        fi

        idx=$(find_index "$col_par" "${table_columns[@]}");

        if [[ $idx == "-1" ]]; then 
            echo "$col_par Columns Not Found.";
            exit 1;
        fi
        column_indexes+=($idx);
        updated_values+=($value);
    }

    if [[ $condition != "-1" ]]; then # that is mean query containes where condition
        
        condition_col=${@:$condition:1};
        operation=${@:$((condition+1)):1};
        condtion_val=${@:$((condition+2)):1};

        #check column that used in where is correct
        condition_col_idx=$(find_index "$condition_col" "${table_columns[@]}" );
        if [[ $condition_col_idx == "-1" ]]; then 
            echo "$col_par Columns Not Found.";
            exit 1;
        fi

    fi

    awk -v cond_col_idx="${condition_col_idx}" \
        -v op="$operation" \
        -v con_val="$condtion_val"\
        -v updated_cols="${column_indexes[*]}"\
        -v updated_vals="${updated_values[*]}" \
        'BEGIN{
            FS=":";
            OFS=":";
            split(updated_cols, cols, " ");
            split(updated_vals, vals, " ");

        }{
            if (NR == 1){
                print 
                next;
            }
            # Check condition on the specified column
            condition_met = (op == "=" && $cond_col_idx == con_val) || 
                    (op == "!=" && $cond_col_idx != con_val) || 
                    (op == ">"  && $cond_col_idx > con_val)  || 
                    (op == "<="  && $cond_col_idx <= con_val)  || 
                    (op == ">="  && $cond_col_idx >= con_val)  || 
                    (op == "<"  && $cond_col_idx < con_val) || (op == "");

            if (condition_met) {
                # Update specified columns
                for (i in cols) {

                    $cols[i] = vals[i];
                    # print $cols[i]
                }
            }

            print 

        }END{
        }' $TABLE > tmp_table && mv tmp_table "$TABLE";
}

# updateTable hr employees salary 999999 first_nam where salary "<" 5000
# updateTable hr employees first_name ahmed where employee_id = 1 
# updateTable hr employees salary 10100 where employee_id = 1 
# updateTable hr employees first_name ahmed where employee_id = 1 
# createTable socet actor ator_id number actorname string


