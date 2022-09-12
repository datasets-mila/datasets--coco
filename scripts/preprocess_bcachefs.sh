#!/bin/bash
source scripts/utils.sh echo -n

# this script is meant to be used with 'datalad run'
set -o errexit -o pipefail

_SNAME=$(basename "$0")

mkdir -p logs/

echo
echo "============================================"
echo
echo "Run the following command to follow the image creation progression:"
echo -e "\\ttail -f logs/${_SNAME}.*_$$ | less +F"
echo
echo "============================================"
echo

if [[ -f "coco.img" ]]
then
	SIZE=-1
fi

[[ -f .tmp/disk.img.md5sums.checksums ]] && rm .tmp/disk.img.md5sums.checksums
NAME=coco.img CONTENT_SRC=extract/ SIZE=$SIZE TMP_DIR=.tmp/ ./bcachefs/scripts/make_disk_image.sh \
	1>>logs/${_SNAME}.out_$$ 2>>logs/${_SNAME}.err_$$

git-annex add coco.img coco.img.md5sums

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums
