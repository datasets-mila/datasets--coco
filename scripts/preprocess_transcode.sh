#!/bin/bash
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

source scripts/utils.sh echo -n

_SNAME=$(basename "$0")

mkdir -p logs/

[[ -e "bin/ffmpeg" ]] || exit_on_error_code "ffmpeg is not present in $PWD/bin/"

python3 -m pip install -r scripts/requirements_pybenzinaconcat.txt

# Add favored ffmpeg to PATH
export PATH="$(cd bin/; pwd):${PATH}"

# Make extract, transcode dirs
mkdir -p .tmp/extract/
mkdir -p .tmp/queue/
mkdir -p .tmp/upload/

mkdir -p bcachefs_content/
jug_exec --jugdir=".tmp/jugdata/" -- cp -rat bcachefs_content/ extract/annotations/
! jug status scripts/preprocess_transcode.py -- \
	--torchvision extract/ \
	--tmp .tmp/ \
	--force-bmp \
	1>>logs/${_SNAME}.out_$$ 2>>logs/${_SNAME}.err_$$
FFREPORT="file=logs/${_SNAME}.ffmpeg_$$" jug execute scripts/preprocess_transcode.py -- \
	--torchvision extract/ \
	--tmp .tmp/ \
	--force-bmp \
	2>>logs/${_SNAME}.err_$$ || \
	exit_on_error_code "Failed to extract and transcode images to H.265"

./scripts/stats.sh bcachefs_content/*/
