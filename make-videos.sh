#!/bin/bash
. functions.sh

#
# Ensure we have the import date arg
#
ensure_date_arg $1

#
# Parse the import date
#
parse_import_date $1

FILE_PATH=${IMPORT_DATE}/processed/${IMPORT_DATE}_2.mp3

stat ${FILE_PATH} &> /dev/null
if [ $? -ne 0 ]; then
  print_error "No files found to convert"
fi

#
# Read tags
#
TITLE="$(get_tag $FILE_PATH 'album') $(get_tag $FILE_PATH 'title')"
ARTIST=$(get_tag $FILE_PATH 'artist')

#
# Overlay image with Title/Author/Date
#
stat cck.png &> /dev/null
if [ $? -ne 0 ]; then
  print_error "cck.png could not be found"
fi
IMAGE_PATH=${IMPORT_DATE}/video/image.png
RECORD_DATE=`date --date="${IMPORT_DATE}" "+%m/%d/%Y"`
convert cck.png -resize 640x480 -pointsize 25 -gravity center -annotate +0+120 "${TITLE}" -pointsize 15 -gravity center -annotate +0+150 "${ARTIST}" -gravity center -annotate +0+175 "${RECORD_DATE}" ${IMAGE_PATH}

LOG_PATH=${IMPORT_DATE}/video/log
#
# Run background job to process videos
#
#for F in ./"$IMPORT_DATE"/processed/${IMPORT_DATE}_2.mp3
#do
  echo "FILE_PATH=${FILE_PATH}" 
  FILE_NAME=`echo ${FILE_PATH} | cut -d '/' -f3`
  echo "FILE_NAME=$FILE_NAME"
  NEW_FILE_NAME=${FILE_NAME/mp3/mp4}
  echo "NEW_FILE_NAME=$NEW_FILE_NAME"
  nohup ffmpeg -loop 1 -i "${IMAGE_PATH}" -i $FILE_PATH -c:a copy -c:v libx264 -shortest "${IMPORT_DATE}/video/$NEW_FILE_NAME" >> ${LOG_PATH} 2>&1 &
#done

echo "View ${LOG_PATH} to monitor background jobs"
