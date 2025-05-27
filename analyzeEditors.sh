#!/bin/bash
# make sure the dependencies of PCLocator and busybox are installed
sudo apt-get update
sudo apt-get --yes --force-yes install autoconf
sudo apt-get --yes --force-yes install default-jre
pip install z3-solver
pip install sympy

busybox_version="busybox-1.37.0"
dir="bzbox_data"
file="src_list_file"
if ! [[ -d $dir ]]; then
    mkdir $dir
else
    rm -rf bzbox_data
    mkdir $dir
fi
bzbox_dir=$busybox_version
bzbox_filter="bzbox_filter"

if ! [[ -d $bzbox_dir ]]; then
    wget https://busybox.net/downloads/$busybox_version.tar.bz2
    tar -xvjf $busybox_version.tar.bz2
    rm $busybox_version.tar.bz2
    cd $busybox_version
    make defconfig
    make
    cd ..
    cp -r $busybox_version $busybox_version-backup
else
    rm -r $busybox_version
    cp -r $busybox_version-backup $busybox_version
fi

# filter these files
# echo "./busybox-1.37.0/coreutils/stty.c" >> $dir/$bzbox_filter

# transform these files
vim -c "set encoding=cp437" -c "set fileencoding=cp437" -c "wq" ./$busybox_version/modutils/modutils-24.c
sed -i 's:0xffffffffffffffff:0xffffffff:g' ./$busybox_version/networking/tls.c

bzbox_dir="$busybox_version/editors"
#bzbox_dir="$busybox_version"
# find all c files and generate file list
echo
echo "###########################################################"
echo "Finding all c files in busybox"
find ./$bzbox_dir -name "*.[ch]" > $dir/$file

python3 analyzeVar.py --path $dir --file $file --filter $bzbox_filter --rtw_file requirements/RTW_busybox_editors.txt --feature_map code_map/map_busybox_editors --project "busybox-editors"

echo "Completed analysis."
echo "###########################################################"

