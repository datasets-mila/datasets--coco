#!/bin/bash

pip install -r scripts/requirements_extract.txt
ERR=$?
if [ $ERR -ne 0 ]; then
   echo "Failed to install requirements: pip install: $ERR"
   exit $ERR
fi

mkdir -p extract/

for split in "2017/test2017.zip" "2017/train2017.zip" "2017/val2017.zip" \
	"2017/annotations/annotations_trainval2017.zip" \
	"2017/annotations/image_info_test2017.zip" \
	"2017/annotations/panoptic_annotations_trainval2017.zip" \
	"2017/annotations/stuff_annotations_trainval2017.zip"
do
	jug status -- scripts/extract.py "$split" --output "extract/"
	jug execute -- scripts/extract.py "$split" --output "extract/" >> extract.out 2>> extract.err
done

rm -r extract/__MACOSX/

rm files_count.stats
for dir in extract/*
do
	echo $(find $dir -type f | wc -l; echo $dir) >> files_count.stats
done

du -s extract/* > disk_usage.stats
