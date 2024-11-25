#!/bin/bash

a=12
awk -v a="$a" 'BEGIN {
    FS=":";
    

}{
    
}END {
}' /home/biruni/Downloads/ITI-Intake-45/Bash/DBMS/B2RADB_HOME/hr/employees