#!/bin/bash

VOICE=Anna
INPUTFILE=$1
INPUTFILE_CONVERTED=input_converted.aiff
SPOKEN_TITLE=spoken-title.aiff
RESULT_AIFF=result.aiff
RESULT_MP3=`echo "$INPUTFILE" | cut -d'.' -f1`_with_spoken_title.mp3

function removeTmpFiles {
  	rm -f $INPUTFILE_CONVERTED
	rm -f $SPOKEN_TITLE
	rm -f $RESULT_AIFF
}

#check if chosen voice is installed
echo Looking for voice $VOICE
if say -v ? | grep $VOICE; then
    echo Voice $VOICE found
else
    echo 'Voice '$VOICE' not found, please istall voice using'
    echo 'System Preferences -> Accessibility -> Speech, then click on System Voice -> customize'
fi

title=$(ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 $INPUTFILE)

removeTmpFiles
rm -f $RESULT_MP3

echo Generatign sound for $title

say -v Anna $title -o $SPOKEN_TITLE

#convert to aiff
ffmpeg -i $INPUTFILE $INPUTFILE_CONVERTED

#concatenate files
ffmpeg -i $SPOKEN_TITLE -i $INPUTFILE_CONVERTED -filter_complex [0:a][1:a]concat=n=2:v=0:a=1 -ab 320000 -ar 44100 $RESULT_AIFF

#convert to mp3
ffmpeg -i $RESULT_AIFF -f mp3 -acodec libmp3lame $RESULT_MP3

removeTmpFiles


