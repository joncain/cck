::###########################################################################
:: Program Summary:
::  1. Start a VLC process to run a video in full screen mode. Specify which
::  screen number (display/monitor) to run on.
::###########################################################################

::###########################################################################
:: Set up our variables
::###########################################################################
set title="Service Countdown Timer"
set video_path=C:\Users\proje\EasyWorship\countdown_timer.mp4
set screennumber=1

::###########################################################################
:: Set the window title and say what you're doing
::###########################################################################
title %title%
echo I'm starting countdown timer...

::###########################################################################
:: View links for the following commands to understand what the arguments mean.
:: - https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/start
::###########################################################################
start /b %title% vlc.exe %video_path% -f --video-on-top --no-video-title --qt-fullscreen-screennumber=%screennumber% vlc://quit

exit
