#!/bin/bash
testfile=$1/disk.test
if [ -f ${testfile} ]
then
    rm ${testfile}
fi
# 5G
dd if=/dev/zero bs=1024k of=${testfile} count=5120

dd if=${testfile} bs=1g of=/dev/null count=5

rm ${testfile}