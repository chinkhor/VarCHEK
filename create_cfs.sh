#!/bin/bash
git clone https://github.com/nasa/cFS.git
cd cFS
git submodule init
git submodule update
cp cfe/cmake/Makefile.sample Makefile
cp -r cfe/cmake/sample_defs sample_defs
make SIMULATION=native prep
make
make install
cd ..

