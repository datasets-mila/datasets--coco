####
COCO
####

`<https://cocodataset.org/>`_

********
Overview
********

For efficiently downloading the images, we recommend using `gsutil rsync
<#gsutil-rsync>`__ to avoid the download of large zip files.  Please follow the
instructions in the `COCO API Readme
<https://github.com/cocodataset/cocoapi>`__ to setup the downloaded COCO data
(the images and annotations should go in coco/images/ and coco/annotations/).
By downloading this dataset, you agree to our `Terms of Use <#termsofuse>`__.

gsutil-rsync
============

Our data is hosted on Google Cloud Platform (GCP). gsutil provides tools for
efficiently accessing this data. You do *not* need a GCP account to use gsutil.
Instructions for downloading the data are as follows:

:(1) Install gsutil via:        curl https://sdk.cloud.google.com \| bash
:(2) Make local dir:            mkdir val2017
:(3) Synchronize via:           gsutil -m rsync gs://images.cocodataset.org/val2017 val2017

The splits are available for download via rsync are: train2014, val2014,
test2014, test2015, train2017, val2017, test2017, unlabeled2017. Simply replace
'val2017' with the split you wish to download and repeat steps (2)-(3).
Finally, you can also download all the annotation zip files via:

:(4) Get annotations:           gsutil -m rsync gs://images.cocodataset.org/annotations [localdir]

The download is multi-threaded, you can control other options of the download
as well (see `gsutil rsync
<https://cloud.google.com/storage/docs/gsutil/commands/rsync>`__).  Please do
not contact us with help `installing gsutil
<https://cloud.google.com/storage/docs/gsutil_install>`__ (we note only that
you do not need to run gcloud init).

:2020 Update:   All data for all challenges stays unchanged.
:2019 Update:   All data for all challenges stays unchanged.
:2018 Update:   Detection and keypoint data is unchanged. New in 2018, complete
                stuff and panoptic annotations for all 2017 images are
                available. Note: *if you downloaded the stuff annotations prior
                to 06/17/2018, please re-download.*
:2017 Update:   The main change in 2017 is that instead of an 83K/41K train/val
                split, based on community feedback the split is now 118K/5K for
                train/val. The same exact images are used, and no new
                annotations for detection/keypoints are provided. However, new
                in 2017 are stuff annotations on 40K train images (subset of
                the full 118K train images from 2017) and 5K val images. Also,
                for testing, in 2017 the test set only has two splits (dev /
                challenge), instead of the four splits (dev / standard /
                reserve / challenge) used in previous years. Finally, new in
                2017 we are releasing 120K unlabeled images from COCO that
                follow the same class distribution as the labeled images; this
                may be useful for semi-supervised learning on COCO.

********
COCO API
********

The COCO API assists in loading, parsing, and visualizing annotations in COCO.
The API supports multiple annotation formats (please see the `data format
<#format-data>`__ page). For additional details see: `CocoApi.m
<https://github.com/cocodataset/cocoapi/blob/master/MatlabAPI/CocoApi.m>`__,
`coco.py
<https://github.com/cocodataset/cocoapi/blob/master/PythonAPI/pycocotools/coco.py>`__,
and `CocoApi.lua
<https://github.com/cocodataset/cocoapi/blob/master/LuaAPI/CocoApi.lua>`__ for
Matlab, Python, and Lua code, respectively, and also the `Python API demo
<https://github.com/cocodataset/cocoapi/blob/master/PythonAPI/pycocoDemo.ipynb>`__.

Throughout the API "ann"=annotation, "cat"=category, and "img"=image.

:``getAnnIds``:         Get ann ids that satisfy given filter conditions.
:``getCatIds``:         Get cat ids that satisfy given filter conditions.
:``getImgIds``:         Get img ids that satisfy given filter conditions.
:``loadAnns``:          Load anns with the specified ids.
:``loadCats``:          Load cats with the specified ids.
:``loadImgs``:          Load imgs with the specified ids.
:``loadRes``:           Load algorithm results and create API for accessing them.
:``showAnns``:          Display the specified annotations.

********
MASK API
********

COCO provides segmentation masks for every object instance. This creates two
challenges: storing masks compactly and performing mask computations
efficiently. We solve both challenges using a custom Run Length Encoding (RLE)
scheme. The size of the RLE representation is proportional to the number of
boundaries pixels of a mask and operations such as area, union, or intersection
can be computed efficiently directly on the RLE.  Specifically, assuming fairly
simple shapes, the RLE representation is O(√n) where n is number of pixels in
the object, and common computations are likewise O(√n). Naively computing the
same operations on the decoded masks (stored as an array) would be O(n).

The MASK API provides an interface for manipulating masks stored in RLE format.
The API is defined below, for additional details see: `MaskApi.m
<https://github.com/cocodataset/cocoapi/blob/master/MatlabAPI/MaskApi.m>`__,
`mask.py
<https://github.com/cocodataset/cocoapi/blob/master/PythonAPI/pycocotools/mask.py>`__,
or `MaskApi.lua
<https://github.com/cocodataset/cocoapi/blob/master/LuaAPI/MaskApi.lua>`__.
Finally, we note that a majority of ground truth masks are stored as polygons
(which are quite compact), these polygons are converted to RLE when needed.

:``encode``:      Encode binary masks using RLE.
:``decode``:      Decode binary masks encoded via RLE.
:``merge``:       Compute union or intersection of encoded masks.
:``iou``:         Compute intersection over union between masks.
:``area``:        Compute area of encoded masks.
:``toBbox``:      Get bounding boxes surrounding encoded masks.
:``frBbox``:      Convert bounding boxes to encoded masks.
:``frPoly``:      Convert polygon to encoded mask.

********
FiftyOne
********

`FiftyOne <https://fiftyone.ai>`__ is an open-source tool facilitating
visualization and access to COCO data resources and serves as an evaluation
tool for model analysis on COCO.

COCO can now be downloaded from the `FiftyOne Dataset Zoo
<https://voxel51.com/docs/fiftyone/user_guide/dataset_zoo/index.html>`__:

::

   dataset = fiftyone.zoo.load_zoo_dataset("coco-2017")

FiftyOne also provides methods allowing you to download and visualize specific
subsets of the dataset with only the labels and classes that you care about in
a couple of lines of code.

::

   dataset = fiftyone.zoo.load_zoo_dataset(
       "coco-2017",
       split="validation",
       label_types=["detections", "segmentations"],
       classes=["person", "car"],
       max_samples=50,
   )

   # Visualize the dataset in the FiftyOne App
   session = fiftyone.launch_app(dataset)

Once you start training models on COCO, you can use `FiftyOne's COCO-style
evaluation <https://voxel51.com/docs/fiftyone/integrations/coco.html>`__ to
understand your model performance with detailed analysis, `visualize individual
false positives
<https://voxel51.com/docs/fiftyone/user_guide/using_views.html#evaluation-patches>`__,
`plot PR curves
<https://voxel51.com/docs/fiftyone/user_guide/evaluation.html#map-and-pr-curves>`__,
and `interact with confusion matrices
<https://voxel51.com/docs/fiftyone/user_guide/plots.html#confusion-matrices>`__.

For additional details see the FiftyOne and COCO integration `documentation
<https://voxel51.com/docs/fiftyone/integrations/coco.html>`__.
