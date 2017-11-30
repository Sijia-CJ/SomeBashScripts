#!/bin/bash

printf "Create system.data file using moltemplate\n"
printf "call this file at the folder you want to operate\n"
path=${PWD}
cp *.lt $data
cd $data
src/moltemplate.sh -atomstyle "full"  system.lt  
cp /***fill_your_own***/lammps/tools/moltemplate/system.data $path
cd $path
printf "all done\n"

	

