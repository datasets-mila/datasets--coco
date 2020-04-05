#!/bin/bash

# This script is meant to be used with the command 'datalad run'

for file_url in "http://images.cocodataset.org/zips/train2014.zip 2014/train2014.zip" \
		"http://images.cocodataset.org/zips/val2014.zip 2014/val2014.zip" \
		"http://images.cocodataset.org/zips/test2014.zip 2014/test2014.zip" \
		"http://images.cocodataset.org/annotations/annotations_trainval2014.zip 2014/annotations/annotations_trainval2014.zip" \
		"http://images.cocodataset.org/annotations/image_info_test2014.zip 2014/annotations/image_info_test2014.zip" \
\
		"http://images.cocodataset.org/zips/test2015.zip 2015/test2015.zip" \
		"http://images.cocodataset.org/annotations/image_info_test2015.zip 2015/annotations/image_info_test2015.zip" \
\
		"http://images.cocodataset.org/zips/train2017.zip 2017/train2017.zip" \
		"http://images.cocodataset.org/zips/val2017.zip 2017/val2017.zip" \
		"http://images.cocodataset.org/zips/test2017.zip 2017/test2017.zip" \
		"http://images.cocodataset.org/zips/unlabeled2017.zip 2017/unlabeled2017.zip" \
		"http://images.cocodataset.org/annotations/annotations_trainval2017.zip 2017/annotations/annotations_trainval2017.zip" \
		"http://images.cocodataset.org/annotations/stuff_annotations_trainval2017.zip 2017/annotations/stuff_annotations_trainval2017.zip" \
		"http://images.cocodataset.org/annotations/panoptic_annotations_trainval2017.zip 2017/annotations/panoptic_annotations_trainval2017.zip" \
		"http://images.cocodataset.org/annotations/image_info_test2017.zip 2017/annotations/image_info_test2017.zip" \
		"http://images.cocodataset.org/annotations/image_info_unlabeled2017.zip 2017/annotations/image_info_unlabeled2017.zip"
do
	echo ${file_url} | git-annex addurl -c annex.largefiles=anything --raw --batch --with-files
done

md5sum 2014/* 2014/annotations/* 2015/* 2015/annotations/* 2017/* 2017/annotations/* > md5sums
