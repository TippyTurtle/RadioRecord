#!/bin/sh

# CapitalFM London Capital Breakfast 6am - 10am Monday - Friday
#
# You need to have the following installed:
# streamripper
# ffmpeg
# 

################## Set Timezone to Location of Broadcast ##################
export TZ="Europe/London"

################## Set Variables ##################
date=`date +%Y-%m-%d`
StreamName='CapitalFM-Capital Breakfast'
OutputDir=/var/www/html/Radio/

url=http://media-sov.musicradio.com:80/Capital
useragent=' Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36'

# Duration in Seconds
duration=3600
# duration=14520
# duration=600

################## Setup Storage ##################
mkdir -p ''"$OutputDir"''
mkdir -p ''"$OutputDir$StreamName"'/MP3/'
cd ''"$OutputDir"''

################## XXX "Record" Broadcast XXX ##################
streamripper ''"$url"'' -D ''"$StreamName"'/%A-%T&q' -d ''"$OutputDir"'' -l "$duration" -a ''"$StreamName $date"'.aac' -o always -u ''"$useragent"''

################## After I am done, Clean up misc files ##################
rm -f "$OutputDir"*.log
rm -f "$OutputDir"*.cue
rm -f ''"$OutputDir$StreamName"'/ - .aac'

################## Concat All the Broken Pieces ##################
## mv "$OutputDir${StreamName} ${date}.aac" "$OutputDir${StreamName} ${date}(9).aac"
## find "${OutputDir}" -regex '${OutputDir}${StreamName} ${date}.*' -printf "%T+ file '%p'\n" | sort | cut -d' ' -f2- >> ${OutputDir}ConCat.txt
## rm $OutputDir${StreamName}\ ${date}(*
## rm ${OutputDir}ConCat.txt

################## AFTER everything is sorted, this will put the LATEST sym link down ##################
rm -f -- ''"$OutputDir"'Latest-'"$StreamName"'.aac'
ln -s ''"$OutputDir$StreamName"' '"$date"'.aac' ''"$OutputDir$StreamName-Latest"'.aac'

################## Convert individual songs into MP3 ##################

for CurrentFile in "${OutputDir}${StreamName}/"*.aac; do 
  b=$(basename "$CurrentFile")
  echo "$MyCount $b XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  ffmpeg -hide_banner -loglevel error -n -threads 1 -i "$CurrentFile" -ac 2 -ab 192k ''"$OutputDir$StreamName"'/MP3/'"${b%.aac}"'.mp3'
  rm "$CurrentFile"
  MyCount=$((MyCount+1))
done

