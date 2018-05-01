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

LOG_PATH=${IMPORT_DATE}/video/log
FILE_PATH=${IMPORT_DATE}/processed/${IMPORT_DATE}_2.mp3
GRAPHIC_PATH=graphics/cck.png
IMAGE_PATH=${IMPORT_DATE}/video/image.png

if [ ! -e $FILE_PATH ]; then
  print_error "${FILE_PATH} could not be found"
fi

if [ ! -e $GRAPHIC_PATH ]; then
  print_error "${GRAPHIC_PATH} could not be found"
fi

#
# Read tags
#
TITLE="$(get_tag $FILE_PATH 'album') $(get_tag $FILE_PATH 'title')"
ARTIST=$(get_tag $FILE_PATH 'artist')

#
# Ensure the video dir exists
#
if [ ! -d ${IMPORTDATE}/video ]; then
  echo "Create video directory"
  mkdir ${IMPORT_DATE}/video
fi

#
# Overlay image with Title/Author/Date
#
RECORD_DATE=`date --date="${IMPORT_DATE}" "+%m/%d/%Y"`
convert ${GRAPHIC_PATH} -resize 640x360 -pointsize 25 -gravity center -annotate +0+80 "${TITLE}" -pointsize 15 -gravity center -annotate +0+110 "${ARTIST}" -gravity center -annotate +0+135 "${RECORD_DATE}" ${IMAGE_PATH}

echo "FILE_PATH=${FILE_PATH}" 
FILE_NAME=`echo ${FILE_PATH} | cut -d '/' -f3`
echo "FILE_NAME=$FILE_NAME"
NEW_FILE_NAME=${FILE_NAME/mp3/mp4}
echo "NEW_FILE_NAME=$NEW_FILE_NAME"

#
# Run background job to process videos
#
nohup ffmpeg -loop 1 -i "${IMAGE_PATH}" -i $FILE_PATH -c:a copy -c:v libx264 -shortest "${IMPORT_DATE}/video/$NEW_FILE_NAME" >> ${LOG_PATH} 2>&1 &

echo "View ${LOG_PATH} to monitor background jobs"
