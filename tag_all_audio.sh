#! /bin/bash

ARTIST="Christopher Bent"
VENUE="Calvary Chapel Kuna"

for d in `ls -1d 2018*`
do
  FILE_DATE=`date --date="${d}" "+%d%m"`
  FILE_YEAR=`date --date="${d}" "+%Y"`

  for f in `ls -1 ${d}/processed/${d}_*.mp3`
  do
    TITLE=`mid3v2 -l $f | grep TIT2 | cut -d "=" -f 2`
    ALBUM=`mid3v2 -l $f | grep TALB | cut -d "=" -f 2`

    #mid3v2 -v --TPE1 "$ARTIST" --TCON "Speech" --TDRC "${FILE_YEAR}" --TDAT "${FILE_DATE}" --TPE3 "The Holy Spirit" --TALB "$TITLE" $f
    mid3v2 -l $f
    #mid3v2 --delete-frames="TXXX" $f
  done  
done
