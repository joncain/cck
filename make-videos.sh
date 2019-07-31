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

ROOT=$2
NOTE="${3}"
LOG_PATH=${ROOT}/${IMPORT_DATE}/video/log
FILE_PATH=${ROOT}/${IMPORT_DATE}/processed/${IMPORT_DATE}_1.mp3
GRAPHIC_PATH=graphics/cck.png
IMAGE_PATH=${ROOT}/${IMPORT_DATE}/video/image.png
GRAVITY=center
X_OFFSET=0

if [ ! -e ${FILE_PATH} ]; then
  print_error "${FILE_PATH} could not be found"
fi

if [ ! -e $GRAPHIC_PATH ]; then
  print_error "${GRAPHIC_PATH} could not be found"
fi

if [ -e graphics/title-slides/${IMPORT_DATE}.png ]; then
  GRAPHIC_PATH=graphics/title-slides/${IMPORT_DATE}.png
  GRAVITY=east
  X_OFFSET=50
fi

#
# Read tags
#
TITLE="$(get_tag $FILE_PATH 'album') $(get_tag $FILE_PATH 'title')"
ARTIST=$(get_tag $FILE_PATH 'artist')

#
# Ensure the video dir exists
#
if [ ! -d ${ROOT}/${IMPORT_DATE}/video ]; then
  echo "Create video directory"
  mkdir ${ROOT}/${IMPORT_DATE}/video
fi

#
# Overlay image with Title/Author/Date
#
RECORD_DATE=`date --date="${IMPORT_DATE}" "+%m/%d/%Y"`
convert \
  ${GRAPHIC_PATH} -resize 640x360 \
  -pointsize 25 -gravity $GRAVITY -annotate +${X_OFFSET}+70 "${TITLE}" \
  -pointsize 15 -gravity $GRAVITY -annotate +${X_OFFSET}+100 "${ARTIST}" \
  -gravity $GRAVITY -annotate +${X_OFFSET}+120 "${RECORD_DATE}" \
  -gravity $GRAVITY -annotate +${X_OFFSET}+140 "calvarykuna.org" \
  -pointsize 10 -gravity $GRAVITY -annotate +${X_OFFSET}+160 "${NOTE}" \
  ${IMAGE_PATH}

echo "FILE_PATH=${FILE_PATH}" 
FILE_NAME=${FILE_PATH##*/}
echo "FILE_NAME=$FILE_NAME"
NEW_FILE_NAME=${FILE_NAME/mp3/mp4}
echo "NEW_FILE_NAME=$NEW_FILE_NAME"

#
# Run background job to process videos
#
nohup ffmpeg -loop 1 -i "${IMAGE_PATH}" -i $FILE_PATH -c:a copy -c:v libx264 -shortest "${ROOT}/${IMPORT_DATE}/video/$NEW_FILE_NAME" >> ${LOG_PATH} 2>&1 &
PID=$!
echo "View ${LOG_PATH} to monitor background jobs for pid ${PID}"
