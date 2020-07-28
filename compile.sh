#!/usr/bin/bash 

script_path="Data/scripts"
output_path="Data/outputs"
bin_path="$(pwd)/outputs"

function compile(){
	for file in `ls $1`
	do
		filePath=$1"/"$file
		fileName=${file%.*}

		if [ -d $filePath ]
		then
			compile $filePath
		else
			printf "[%-s] \t%-s \t[%s]\n" $filePath "<-->" ${filePath%%.*}".luc"
			dst_file=${filePath%%.*}".luc"
			$(pwd)/luajit.exe -b $filePath ${dst_file}

			dst_path=${1/scripts/outputs}
			mkdir -p $dst_path
			mv ${dst_file} ${dst_path}
		fi
	done
}



if [ -d $output_path ]
then
	rm $output_path -rf
fi
mkdir -p $output_path

find Data/scripts/ -name "*.luc" | xargs rm -rf

find Data/scripts/ -type f | egrep "\.(lua)$" | xargs sed -i "s#\.lua#\.luc#g"

compile ${script_path}

mv ${script_path} $(pwd)
mv $output_path ${script_path}

sed -i "s#lua#luc#g" "$(pwd)/Data/CommandLine.txt"
rm CoreData.pak Data.pak -rf
./PackageTool.exe CoreData CoreData.pak -c
./PackageTool.exe Data Data.pak -c
sed -i "s#luc#lua#g" "$(pwd)/Data/CommandLine.txt"

rm ${script_path} -rf
mv "$(pwd)/scripts" ${script_path}

find Data/scripts/ -type f | egrep "\.(lua)$" | xargs sed -i "s#\.luc#\.lua#g"


if [ -d $bin_path ]
then
	rm $bin_path -rf
fi
mkdir -p $bin_path
mkdir -p "$bin_path/logs"
mv *.pak $bin_path
cp Urho3DPlayer.exe "$bin_path/launch.exe" -axrf
