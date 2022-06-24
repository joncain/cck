cckcut() {
  FILE="${1}"
  START_TIME="${2}"
  END_TIME="${3}"
  
  ffmpeg -i "${FILE}" -ss ${START_TIME} -c copy -to ${END_TIME} "${FILE/\.mp4/}-cut.mp4"
}

cckconcat() {
  ffmpeg -f concat -safe 0 -i <(for f in ./*.mp4; do echo "file '$PWD/$f'"; done) -c copy concat.mp4
}

cckresize() {
  file="${1}"
  convert $file -resize 1280x720 image.png
}
