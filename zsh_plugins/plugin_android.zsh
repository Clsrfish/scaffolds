#!/bin/bash

alias driodsystrace='python ${ANDROID_HOME}/platform-tools/systrace/systrace.py'
alias debug_gradle="export GRADLE_OPTS=\"-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005\""
alias undebug_gradle="unset GRADLE_OPTS"

function kill_java_process() {
    jps
    for p in $(jps | grep -v 'Jps' | awk '{print $1}'); do
        kill -9 ${p}
    done
}

function adb_device_serials() {
    echo $(adb devices | grep -v '^$' | awk '{if (NR>1){print $1}}')
}

function adb_device_count() {
    count=$(adb devices | grep -v '^$' | awk '{if (NR>1){print $1}}' | wc -l)
    echo ${count}
}

# exit if no devices connected
function any_device() {
    count=$(adb_device_count)
    if [ ${count} -le 0 ]; then
        echo "No device is connected"
        exit 1
    fi
}

# append device's serial to file name
function convert_path_for_serial() {
    if [ -z ${1} ]; then
        echo "Output path required"
        exit 1
    fi

    if [ -z ${2} ]; then
        echo "Device serial required"
        exit 1
    fi

    file_name=${1##*/}
    if [ -z ${file_name} ]; then
        output_path=${1}
    else
        output_path="$(dirname ${1})/"
    fi

    if [ ! -d ${output_path} ]; then
        echo "Creating directory ${output_path}"
        mkdir -p ${output_path}
        if [ $? -ne 0 ]; then
            exit 1
        fi
    fi

    serial=${2}

    file_suffix=$(echo ${serial//./})
    file_suffix=$(echo ${file_suffix//:/})

    base_file_name=${file_name%.*}
    extension=${file_name##*.}
    if [ ${file_name} = ${extension} ]; then
        extension=''
    fi

    output_file=${file_suffix}
    if [ ! -z ${file_name} ]; then
        output_file="${base_file_name}_${output_file}"
    fi
    if [ ! -z ${extension} ]; then
        output_file="${output_file}.${extension}"
    fi

    output_file="${output_path}${output_file}"

    echo "${output_file}"
}

function adb_cap() {
    any_device

    if [ -z ${1} ]; then
        echo "Output path required"
        exit 1
    fi

    for serial in $(adb_device_serials); do
        output_file=$(convert_path_for_serial ${1} ${serial})

        echo "Saving ${serial}'s screenshot to ${output_file}"
        adb -s ${serial} shell screencap -p >"${output_file}"
    done
}

function adb_cap_open() {
    any_device
    tmp_file=/tmp/screenshot.png
    adb_cap ${tmp_file}
    for serial in $(adb_device_serials); do
        convert_path_for_serial ${tmp_file} ${serial} | xargs open
    done
}

function adb_cap_pb() {
    any_device
    tmp_file=/tmp/screenshot.png
    adb_cap ${tmp_file}
    device_count=$(adb_device_count)
    if [ ${device_count} -gt 1 ]; then
        echo "More than one device/emulator, please select one:"
        select choice in $(adb devices | grep -v '^$' | awk '{if (NR>1){print $1 "@" $2}}') "Quit"; do
            if [[ ${choice} == "Quit" ]]; then
                echo "Quit."
                exit 0
            elif [[ -z ${choice} ]]; then
                echo "Invalid choice, please try again."
            else
                echo "Device ${choice} selected."
                serial=$(echo ${choice} | awk -F "@" '{print $1}')
                break
            fi
        done
    else
        serial=$(adb devices | grep -v '^$' | awk '{if (NR>1){print $1}}')
    fi
    tmp_file=$(convert_path_for_serial ${tmp_file} ${serial})
    pbcopyfile ${tmp_file}
}

function adb_install() {
    any_device
    for did in $(adb_device_serials); do
        echo "Installing ${1} on ${did}"
        adb -s ${did} install -r "${1}"
    done
}

function adb_top_activity() {
    any_device
    for serial in $(adb_device_serials); do
        echo -n "Top ${serial}:\n"
        adb -s ${serial} shell dumpsys activity top | grep ACTIVITY
        echo -n "\n"
    done
}

function adb_fix_inspector() {
    any_device
    for serial in $(adb_device_serials); do
        adb -s ${serial} shell settings delete global debug_view_attributes
    done
}
