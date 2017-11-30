#!/bin/bash
address='username@server_address:'
local_pre='/stripe/oncluster/'
local_suf='result0101/'
remote_pre='stripe/' 
remote_suf='ST_half/'
printf "********Type '.' to skip all renames\n"
read skip

if [ "$skip" != '.' ];then
	printf "********Local folder:$local_pre<$local_suf>  Press enter to keep it. \n"
	read temp
	if [ "$temp" != "" ]; then
		if [ "${temp:${#temp}-1:1}" != '/' ]; then
			temp=$temp"/"
		fi
		local_suf=$temp;
	fi
fi


if [ "$skip" != '.' ];then
	printf "********Remote folder: $remote_pre<$remote_suf>  Press enter '.' to keep it. \n"
	read temp
	if [ "$temp" != "" ]; then
                if [ "${temp:${#temp}-1:1}" != '/' ]; then
                        temp=$temp"/"
                fi
		remote_suf=$temp;
	fi
fi

name="time*.out"
if [ -d "$HOME$local_pre$local_suf" ]; 
then
	printf "folder $HOME$local_pre$local_suf exists. Overwriting\n"
else
	mkdir $HOME$local_pre$local_suf
	#printf "created local Path : $local_pre$local_suf \n\n"
fi

printf "*******to skip download, type '.'\n"
read skip2
if [ "$skip2" != '.' ];then
	printf "********COPYING:scp $address$remote_pre$remote_suf$name $HOME$local_pre$local_suf\n ************\n"
	scp $address$remote_pre$remote_suf$name $HOME$local_pre$local_suf
fi


subfolder='T3_case'

if [ "$skip" != '.' ];then
	printf "********subfolder name prefix: <$subfolder>1,2,3. Press enter to keep it.\n"
	read temp
	if [ "$temp" != ""  ]; then
		subfolder=$temp;
	fi
fi

for i in $(seq -f "%02g" 1 3)
do
	if [ -d "$HOME$local_pre$local_suf$subfolder$i" ]; 
	then
		printf "folder exists.$HOME$local_pre$local_suf$subfolder$i Overwritingr\n"
	else
		mkdir "$HOME$local_pre$local_suf$subfolder$i"
	fi
	let s="$i*8-8"
	let e="$i*8-1"
	for j in $(seq -f "%02g" $s $e)
	do
		mv "$HOME$local_pre$local_suf""time$j.out" "$HOME$local_pre$local_suf$subfolder$i"
	done
	mv "$HOME$local_pre$local_suf""timeAvg$i.out" "$HOME$local_pre$local_suf$subfolder$i"
	printf " file moved to $subfolder$i successfully\n"
done
if [ -d "$HOME$local_pre$local_suf""plots" ]; then
	printf "$HOME$local_pre$local_suf""plots exists. Overwriting.\n"
else
	mkdir "$HOME$local_pre$local_suf""plots" 
fi


printf "*******Output filefolder names to $HOME$local_pre""names.dat \n"
echo "$HOME$local_pre$local_suf" > "$HOME$local_pre""names.dat"

for i in $(seq -f "%02g" 1 3)
do
	echo "$HOME$local_pre$local_suf$subfolder$i""/" >>  "$HOME$local_pre""names.dat"
done

tail -1 "$HOME$local_pre$local_suf$subfolder$i""/time23.out" >> "$HOME$local_pre""names.dat"


printf "*******Output plots to $HOME$local_pre$local_suf""plots****** \n"
printf "*******Might take some time ******************\n"
matlab -nodisplay  <xfillplot_1.m > "$HOME$local_pre$local_suf""plots/matlab.out"
matlab -nodisplay  <xfillplot_2.m >> "$HOME$local_pre$local_suf""plots/matlab.out"
matlab -nodisplay  <xfillplot_3.m >> "$HOME$local_pre$local_suf""plots/matlab.out"


printf "*******Displaying matlab.out\n"
tail -2 "$HOME$local_pre$local_suf""plots/matlab.out"

