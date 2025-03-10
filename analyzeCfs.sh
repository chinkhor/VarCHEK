#!/bin/bash
# make sure the dependencies of PCLocator are installed
sudo apt-get update
sudo apt-get --yes --force-yes install autoconf
sudo apt-get --yes --force-yes install default-jre
pip install z3-solver
pip install sympy

dir="cfs_data"
file="src_list_file"
if ! [[ -d $dir ]]; then
    mkdir $dir
fi
cfs_dir="cFS"
cfs_filter="cfs_filter"
if ! [[ -d $cfs_dir ]]; then
    echo "Installing cFS"
    bash ./create_cfs.sh
    cp -r $cfs_dir $cfs_dir-backup
else
    sudo rm -r $cfs_dir
    cp -r $cfs_dir-backup $cfs_dir
fi

# analysis cFS cfe time module
cfs_dir="cFS/cfe/modules/time/fsw/src"
# find all cpp files and generate file list
echo "Finding all c files in cFS time module"
find ./$cfs_dir -name "*.[ch]" > $dir/$file

python3 analyzeVar.py --path $dir --file $file --filter $cfs_filter --rtw_file requirements/RTW_cfs.txt --feature_map code_map/map_cfs --project "cfs"
echo "Completed analysis."
