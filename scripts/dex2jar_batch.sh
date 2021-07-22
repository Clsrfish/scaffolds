#!/bin/sh

CWD=${1}
if [ -z ${CWD} ]; then
    CWD=$(pwd)
fi

if [ ! -x $(which bbe) ]; then
    echo "Bbe not found in path, plz install it via 'brew install bbe'"
    exit 1
fi

if [ ! -x $(which d2j-dex2jar) ]; then
    echo "Dex2jar not found in path, plz install it via 'brew install dex2jar'"
    exit 1
fi

if [ -d ${CWD}/dex_bbe ]; then
    rm -r ${CWD}/dex_bbe
fi

if [ -d ${CWD}/dex2jar ]; then
    rm -r ${CWD}/dex2jar
fi

function bbeTransform() {
    if [ ! -d ${CWD}/dex_bbe ]; then
        mkdir -p ${CWD}/dex_bbe
    fi
    local dex_file_path=${1}
    local dex_file=${dex_file_path##*/}
    local dex_file_name=${dex_file%.*}
    local bbe_dex_file_path=${CWD}/dex_bbe/${dex_file_name}.dex
    bbe -b '4:3' -e 'r 0 036' -o ${bbe_dex_file_path} ${dex_file_path}
    echo ${bbe_dex_file_path}
}

function dex2jar() {
    local dex_file_path=${1}
    local dex_file=${dex_file_path##*/}
    local dex_file_name=${dex_file%.*}

    echo "Dex 2 jar: ${dex_file}"
    if [ ! -d ${CWD}/dex2jar ]; then
        mkdir -p ${CWD}/dex2jar
    fi
    d2j-dex2jar -d -f ${dex_file_path} -o ${CWD}/dex2jar/${dex_file_name}.jar
}

# merge all jar files under ${1}
function mergeJars() {
    local jar_path=${1}
    if [ -z ${jar_path} ]; then
        exit 1
    fi
    if [ -d ${CWD}/jar_path ]; then
        rm -r ${CWD}/jar_path
    fi

    if [ ! -d ${CWD}/jar_path ]; then
        mkdir -p ${CWD}/jar_path
    fi
    cd ${CWD}/jar_path
    echo "Unzipping jars..."
    for jf in $(ls ${jar_path}/*.jar); do
        jar -xf ${jf}
    done
    echo "Zipping jars..."
    jar -cf ${jar_path}/classes-merged.jar .
    open ${jar_path}
}

for dex in $(ls ${CWD}/*.dex); do
    bbe_dex=$(bbeTransform ${dex})

    dex2jar ${bbe_dex}
    echo "\n"
done

mergeJars ${CWD}/dex2jar
