#!/bin/bash
# make sure the dependencies of PCLocator are installed
sudo apt-get update
sudo apt-get --yes --force-yes install autoconf
sudo apt-get --yes --force-yes install default-jre
pip install z3-solver
pip install sympy

dir="axtls_data"
file="src_list_file"
if ! [[ -d $dir ]]; then
    mkdir $dir
fi
axtls_dir="axtls-code"
axtls_filter="axtls_filter"
if ! [[ -d $axtls_dir ]]; then
    wget https://sourceforge.net/projects/axtls/files/2.1.5/axTLS-2.1.5.tar.gz
    tar -xvf axTLS-2.1.5.tar.gz
    rm axTLS-2.1.5.tar.gz  
    cp axtls_fix/bigint.c axtls-code/crypto/.
    cd axtls-code
    make linuxconf
    cd config
    sed -i 's:#define MUL_KARATSUBA_THRESH:#define MUL_KARATSUBA_THRESH 20:g' config.h
    sed -i 's:#define SQU_KARATSUBA_THRESH:#define SQU_KARATSUBA_THRESH 40:g' config.h
    cd ..
    make clean
    sed -i 's/\o14//g' config/scripts/config/zconf.tab.c
    cd ..
    cp -r axtls-code axtls-code-backup
else
    rm -r axtls-code
    cp -r axtls-code-backup axtls-code
fi
# find all cpp files and generate file list
echo
echo "###########################################################"
echo "Finding all c files in axTLS"
find ./$axtls_dir -name "*.[ch]" > $dir/$file

#python3 analyzeVar.py --path $dir --file $file --filter $axtls_filter --rtw_file requirements/RTW_axtls_Kconfig.txt --feature_map code_map/map_axtls --project "axtls"
python3 analyzeVar.py --path $dir --file $file --filter $axtls_filter --rtw_file requirements/RTW_axtls.txt --feature_map code_map/map_axtls --project "axtls"
echo "Completed analysis."
echo "###########################################################"