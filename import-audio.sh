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

if [ $? -ne 0 ]; then
  print_error "Import date \"$1\" could not be parsed"
else
  echo "IMPORT_DATE=$IMPORT_DATE"
fi

#
# Get the source path (Phone)
#
SRC_BUS=`lsusb | grep Samsung | cut -d ' ' -f 2`
SRC_DEV=`lsusb | grep Samsung | cut -d ' ' -f 4 | tr -d :`
SRC_PATH="/run/user/1000/gvfs/mtp:host=%5Busb%3A${SRC_BUS}%2C${SRC_DEV}%5D/Phone/Download"

#
# Ensure we have a valid source path
#
echo "SRC_PATH=$SRC_PATH"
if [ ! -e $SRC_PATH ]; then
  print_error "Directory $SRC_PATH cannot be found"
fi

#
# Ensure we have files to copy before we create the destination
#
(stat "$SRC_PATH"/ZOOM000*.MP3) &> /dev/null
if [ $? -ne 0 ]; then
  print_error "No files found to copy"
fi

#
# If the destinatio already exists, ask to overwrite
#
if [ -e ./"$IMPORT_DATE" ]; then
  echo "The dir './$IMPORT_DATE' already exists. Would you like to overwrite? (y/n)"
  read CHOICE
  if [ $CHOICE != "y" ]; then
    echo "Aborting import"
    exit 0
  fi
fi

#
# Create destination paths
#
echo "Creating directories"
mkdir -p ./"$IMPORT_DATE"/raw
mkdir -p ./"$IMPORT_DATE"/processed
mkdir -p ./"$IMPORT_DATE"/video

DEST_PATH="./$IMPORT_DATE/raw"
echo "DEST_PATH=$DEST_PATH"

echo "Copying files"
cp "$SRC_PATH"/ZOOM000*.MP3 "$DEST_PATH"

echo "Renaming files"
for F in ./"$IMPORT_DATE"/raw/ZOOM000*.MP3
do
  NEW_FILE_PATH="${F/ZOOM000/"${IMPORT_DATE}_"}"
  echo "Renaming $F to $NEW_FILE_PATH"
  mv "$F" "$NEW_FILE_PATH"
done

exit 0
