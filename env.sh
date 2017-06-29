#!/bin/bash
pushd `dirname $0` >/dev/null
SCRIPT_DIR=`pwd -P`
popd >/dev/null
export TAG_RELEASE="DaytonaBeach-2.0.0"
export TAG_DESCRIPTION="Official Daytona Bech Release version 2.0.0"
export OSSIMLABS_URL="https://github.com/ossimlabs"
export RADIANTBLUE_URL="https://github.com/radiantbluetechnologies"
export RADIANTBLUE_FILES=("omar-merge-to-master omar-elk-docker ossim_kakadu_jpip_server cucumber-oc2s isa o2-paas ossim-msp ossim-private")
export OSSIMLABS_FILES=("o2-delivery omar-git-mirror ossim-src omar omar-docs omar-disk-cleanup omar-config-server omar-eureka-server omar-turbine-server omar-zuul-server omar-base omar-ossim-base ossim ossim-ci ossim-gui ossim-oms ossim-planet ossim-plugins \
 ossim-vagrant ossim-video ossim-wms omar-avro omar-common omar-core omar-download omar-geoscript omar-hibernate-spatial omar-ingest-metrics\
 omar-jpip omar-mensa  omar-oms omar-openlayers omar-opir omar-ossimtools omar-raster omar-scdf-indexer omar-scdf-notifier-email omar-scdf-s3-extractor-filter omar-scdf-s3-filter omar-scdf-s3-uploader omar-scdf-stager omar-scdf-sqs omar-scdf-file-parser omar-scdf-downloader omar-scdf-aggregator omar-scdf-extractor omar-security omar-service-proxy\
 omar-services omar-sqs omar-stager omar-superoverlay omar-ui omar-video omar-wcs omar-wfs omar-oldmar omar-wms omar-wmts\
 tlv omar-scdf omar-scdf-stager omar-scdf-aggregator omar-scdf-sqs omar-scdf-extractor omar-scdf-zookeeper omar-scdf-kafka\
 omar-scdf-indexer omar-scdf-notifier-email omar-scdf-server omar-scdf-file-parser omar-scdf-downloader omar-scdf-s3-uploader omar-scdf-s3-filter \
 omar-scdf-s3-extractor-filter")

JSON_DATA=$(cat  << EOF
{"tag_name": "${TAG_RELEASE}", 
"target_commitish":"master",
"name":"${TAG_RELEASE}",
"body":"${TAG_DESCRIPTION}", 
"draft":false, 
"prerelease":false
}
EOF
)
###############################################################################
#
# got = git for OSSIM
#
# Convenience script for performing git operations on multiple OSSIMLABS repos.
# Up to four git parameters are handled, for example:
#
#    got commit -a
#    got log --oneline --graph
#
# Obviously, only commands that make sense to run on all repos will work. You
# can't commit a specific file for example.
#
# Run this script from ossimlabs parent directory (a.k.a. OSSIM_DEV_HOME)
#
###############################################################################
function checkoutFile {
  repoUrl=$1
  repo=$2
  target=$3
  #if [ ! -z $repoUrl -a ! -z $repo -a ! -z $target ] ; then
    git clone $repoUrl/$repo $target
  #else
  #  echo "Usage: checkoutFile <repoUrl> <repo> <target>"
  #  exit 1
  #fi
}

function mergeToMaster {
  FILES=$1
 for file in $FILES ; do
    if [ -e $file ] ; then
      echo "************ PUSHING DIRECTORY $file ************"
      pushd $file
      git checkout dev
      git pull --all
      git checkout master
      git pull --all
      git merge -m "Merging dev into master" dev
      git push
      git checkout dev
      popd
    else
      echo "************ Directory $file is not present. Skipping merge ************"
    fi
  done
 
}
