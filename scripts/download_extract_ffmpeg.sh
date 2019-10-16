#!/bin/bash

# This script is meant to be used with the command 'datalad run'

function exit_on_error_code {
	err=$?
	if [ $err -ne 0 ]
	then
		>&2 echo "$(tput setaf 1)error$(tput sgr0): $1: $err"
		exit $err
	fi
}

mkdir -p bin/

wget -O bin/md5sums https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz.md5
for file_url in "https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz bin/ffmpeg-4.2.1-amd64-static.tar.xz"
do
        echo ${file_url} | git-annex addurl -c annex.largefiles=anything --raw --batch --with-files
done
(cd bin/; md5sum -c md5sums)
exit_on_error_code "Failed to download ffmpeg"

tar -C bin/ -xf bin/ffmpeg-4.2.1-amd64-static.tar.xz
exit_on_error_code "Failed to extract ffmpeg"

(cd bin/; ln -sf ffmpeg-4.2.1-amd64-static/ffmpeg .)
