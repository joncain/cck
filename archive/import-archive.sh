#!/bin/bash

#./import-archive.sh '/media/jon/2017-05-13 1045/Music' '*-2*Romans*.mp3'

home=`pwd`

path="$1"
pattern="$2"
mode="$3"

cd "$path"
echo "home: $home"
echo "where to look: `pwd`"
echo "what to find: $pattern"
echo "-------------------------------------------------------"
echo

for f in ${pattern}
do

  echo "Processing: $f"
  echo "-------------------------------------------------------"
  recording_date=`date "+%Y-%m-%d" --date="${f:4:2}-${f:0:2}-${f:2:2}"`
  album=`echo "$f" | cut -d " " -f 2`
  title=`echo "${f/.mp3/}" | awk '{ print $3 ":" $4 }'`
  file_path="$home/$recording_date/processed/${recording_date}_2.mp3"

  if [ ! -d "$home/$recording_date" ]; then
    echo "mkdir \"$home/$recording_date\""
    if [ "$mode" != "p" ]; then
      mkdir "$home/$recording_date"
    fi
  fi

  if [ ! -d "$home/$recording_date/processed" ]; then
    echo "mkdir \"$home/$recording_date/processed\""
    if [ "$mode" != "p" ]; then
      mkdir "$home/$recording_date/processed"
    fi
  fi

  if [ ! -e "$home/$recording_date/processed/${recording_date}_2.mp3" ]; then
    echo "cp $f $file_path"
    if [ "$mode" != "p" ]; then
      cp "$f" "$file_path"
      chmod 744 "$file_path"
      mid3v2 --delete-all "$file_path" 
      mid3v2 --TALB "$album" --TIT2 "$title" --TDRC "$recording_date" --TPE1 "Pastor Chris Bent" --TPE3 "The Holy Spirit" --TCON "Speech" "$file_path"
    fi
  fi

  if [ "$mode" != "p" ]; then
    mid3v2 -l "$file_path" 
  else
    echo "album: $album"
    echo "title: $title"
  fi

  echo
done

