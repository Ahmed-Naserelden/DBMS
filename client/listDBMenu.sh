#!/bin/bash
source daemon/database.sh
source session/info.sh


ret_databases=($(listDB));

echo "${ret_databases[@]}";
