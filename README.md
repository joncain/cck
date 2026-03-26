# Commands for Video Editing

## cckcut
This command will crop a video file at the supplied start/end time and output a new file
```bash
cckcut path-to-my-video-file start-time end-time
```
For example if I have a video file named `cck-sunday.mp4` and I want to crop the video to start at the 5m 40s mark and end at the 52m 03s mark the command would be:
```bash
cckcut cck-sunday.mp4 5:40 52:03
```
The output file is suffixed with `-cut` so it would output a file named `cck-sunday-cut.mp4`

## cckmake
This command will create a video from a still image and an MP3 file
```bash
cckmake path-to-my-audio-file path-to-my-image
```
For example if I have an MP3 file named `audio.mp3` and a still image named `matthew.png` the command would be:
```bash
cckmake audio.mp3 matthew.png
```
The output file is always named `make.mp4`
