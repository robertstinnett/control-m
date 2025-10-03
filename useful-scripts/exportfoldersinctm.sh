
#!/bin/bash
# Script to export folders in Control-M into individual JSON files
# Robert Stinnett, September 2025
# Requires ctm 
#          jq
#          sed
#
# Usage: [./exportfolders env folderpattern]
#

ctmserver=$1
folderpattern=$2

# Throw it into a subfolder called folderjson
if [ ! -d "folderjson" ]; then
  mkdir folderjson
fi

cd folderjson

ctm deploy folders::get -s "server=$ctmserver&folder=$folderpattern" | jq -r ". | keys"  > folderlist.dat
sed -i '$ d' folderlist.dat
sed -i '1,1d' folderlist.dat
while IFS="" read -r p || [ -n "$p" ]
do
        updated_folder=$(echo "$p" | tr -d "\"")
        updated_folder=${updated_folder//[,]/}
        echo Getting $updated_folder
        ctm deploy jobs::get -s "server=$ctmserver&folder=$updated_folder" > $updated_folder.json
done < folderlist.dat
