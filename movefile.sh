#!/bin/bash

printf "***************copy files to new folders*************\n"
printf "*******Please enter the old folder name**************\n"
read oldname
printf "**********Please enter new folder name****************\n"
read newname
#newname="$oldname""_new"

mkdir $newname
cp "$oldname"'/system.lt' $newname
cp "$oldname""/system.data" $newname
cp "$oldname""/system.in.init" $newname
cp "$oldname""/system.in.settings" $newname
cp "$oldname""/tip4p.lt"  $newname
cp "$oldname""/water_bridge.run"  $newname
cp "$oldname""/job.pbs"    $newname
cp "$oldname""/debug"  $newname
