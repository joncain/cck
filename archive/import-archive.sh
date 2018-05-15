#!/bin/bash

#./import-archive.sh '/media/jon/2017-05-13 1045/Music' '*-2*Romans*.mp3'

home=`pwd`

path="$1"
pattern="$2"

cd "$path"
echo "home: $home"
echo "where to look: `pwd`"
echo "what to find: $pattern"
echo "-------------------------------------------------------"

for f in "$pattern"
do
  recording_date=`date "+%Y-%m-%d" --date="${f:4:2}-${f:0:2}-${f:2:2}"`
  album=`echo "$f" | cut -d " " -f 2`
  title=`echo "${f/.mp3/}" | awk '{ print $3 ":" $4 }'`
  
  if [ ! -e "$home/$recording_date" ]; then
    echo "mkdir \"$home/$recording_date\""
    mkdir "$home/$recording_date"
  fi

  if [ ! -e "$home/$recording_date/processed" ]; then
    echo "mkdir \"$home/$recording_date/processed\""
    mkdir "$home/$recording_date/processed"
  fi

  if [ ! -e "$home/$recording_date/processed/$f" ]; then
    file_path="$home/$recording_date/processed/${recording_date}_2.mp3"
    echo "cp $f $file_path"
    cp "$f" "$file_path"
    chmod 744 "$file_path"
    mid3v2 --delete-all "$file_path" 
    mid3v2 --TALB "$album" --TIT2 "$title" --TDRC "$recording_date" --TPE1 "Pastor Chris Bent" --TPE3 "The Holy Spirit" --TCON "Speech" "$file_path"
  fi

  #echo $f
  mid3v2 -l "$file_path" 
  echo "album: $album"
  echo "title: $title"
  echo
done

