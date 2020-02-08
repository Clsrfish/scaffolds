#!/bin/bash
if [[ `uname` != Darwin ]]
then 
    echo "only macOS supported"
    exit 1
fi

if [ $# != 1 ]
then
  echo 'Invalid input args.only one image parameter should be passed in...'
  exit 1
fi
if [ ! -f $1 ]
then
  echo $1' is not a file...'
  exit 1
fi
file=$1
name=${file%.*}
suffix=${file##*.}
if [ ${suffix} != 'png' -a ${suffix} != 'PNG' ]
then
  echo 'Invalid input. only png file is accepted...'
  exit 1
fi

sips -s format jpeg --out ${name}.jpg ${file} 
