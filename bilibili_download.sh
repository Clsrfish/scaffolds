#!/bin/sh

BILIBILI_DOWNLOAD_PATH=/sdcard/Android/data/tv.danmaku.bili/download
CACHE_ENTRY_FILE="cache_entry.txt"

function check_tool_installed() {
    which ${1} >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "${1} is not found in your PATH."
        exit 1
    fi
    return 0
}

function select_target_device() {
    device_count=$(adb devices | grep -v '^$' | awk '{if (NR>1){print $1}}' | wc -l)
    if [ $device_count -le 0 ]; then
        echo "No device is connected."
        exit 1
    fi
    echo "Please select target device:"
    PS3=":"
    select choice in $(adb devices | grep -v '^$' | awk '{if (NR>1){print $1 "@" $2}}') "Quit"; do
        if [[ ${choice} == "Quit" ]]; then
            echo "Quit."
            exit 0
        elif [[ -z ${choice} ]]; then
            echo "Invalid choice, please try again."
        else
            echo "Device ${choice} selected."
            TARGET_DEVICE=$(echo ${choice} | awk -F "@" '{print $1}')
            break
        fi
    done
    return 0
}

function select_target_cache() {
    cache_count=$(adb -s ${TARGET_DEVICE} shell ls ${BILIBILI_DOWNLOAD_PATH} | wc -l)
    if [[ ${cache_count} -le 0 ]]; then
        echo "No cache found, exit."
        exit 0
    fi
    echo "Please select target cache:"
    PS3=":"
    select choice in $(adb -s ${TARGET_DEVICE} shell ls ${BILIBILI_DOWNLOAD_PATH}) "Quit"; do
        if [[ ${choice} == "Quit" ]]; then
            echo "Quit."
            exit 0
        elif [[ -z ${choice} ]]; then
            echo "Invalid choice, please try again."
        else
            echo "Cache ${choice} selected."
            TARGET_CACHE=${choice}
            break
        fi
    done
    return 0
}

function pull_cache_2_local() {
    if [[ -e ${TARGET_CACHE} ]]; then
        rm -r ${TARGET_CACHE}
    fi
    echo "Start downloading cache, please keep your device connected until finished."
    adb -s ${TARGET_DEVICE} pull ${BILIBILI_DOWNLOAD_PATH}/${TARGET_CACHE} ${TARGET_CACHE}
    echo "Cache files have been downloaded, your device can now be disconnected."
    return 0
}

CURRENT_VIDEO_TITLE=""
CURRENT_VIDEO_TYPE_TAG=""
CURRENT_VIDEO_PART_TITLE=""
REG_JS='let result = require("fs").readFileSync(process.argv[2]).toString().match(new RegExp("(?<=" + process.argv[1] + "\": ?\").*?(?=\",?)"));if (result != null) {console.log(result[0]);}'

function parse_video_info() {
    echo "Parsing video info from ${1}"
    entry_content=$(cat $1)
    PRE_IFS=$IFS
    IFS=$'\n'
    CURRENT_VIDEO_TITLE=$(node -e ${REG_JS} title ${1})
    CURRENT_VIDEO_TYPE_TAG=$(node -e ${REG_JS} type_tag ${1})
    CURRENT_VIDEO_PART_TITLE=$(node -e ${REG_JS} part ${1})
    IFS=${PRE_IFS}
    echo ${CURRENT_VIDEO_TITLE}
    echo ${CURRENT_VIDEO_TYPE_TAG}
    echo ${CURRENT_VIDEO_PART_TITLE}

    return 0
}

function rm_files() {
    for file in ${@}; do
        if [[ -e ${file} ]]; then
            echo "rm ${file}"
            rm -r ${file}
        fi
    done
}
VIDEO_TYPE_FLV="lua.flv.bili2api.80"
VIDEO_TYPE_80="80"
function convert_flv_video() {
    echo "Converting lua.flv.bili2api.80 file type."
    split_filenames=${1}/lua.flv.bili2api.80/split_files
    input_files="${split_filenames}_"
    tmp_files=(${split_filenames} ${input_files})
    rm_files ${tmp_files[@]}
    # find *.blv files
    for file in $(ls ${1}/lua.flv.bili2api.80/*.blv); do
        echo ${file}
        fullname="${file##*/}"
        filename="${fullname%.*}"
        echo ${filename} >>${split_filenames}
    done
    sort -n ${split_filenames} -o ${split_filenames}
    # generate intput files
    # relative to the txt file
    for name in $(cat ${split_filenames}); do
        echo "file '${name}.blv'" >>${input_files}
    done
    # process with ffmpeg
    ffmpeg -f concat -i ${input_files} -c copy "${TARGET_CACHE}_output/${2}_${CURRENT_VIDEO_PART_TITLE}.flv"

    rm_files ${tmp_files[@]}
    return 0
}

function convert_80_video() {
    echo "Converting 80 file type."
    ffmpeg -i ${1}/80/video.m4s -i ${1}/80/audio.m4s -vcodec copy -acodec copy "${TARGET_CACHE}_output/${2}_${CURRENT_VIDEO_PART_TITLE}.mp4"
    return 0
}

# TODO: cnvert danmaku.xml to ass
function convert_danmaku_2_ass() {
    return 0
}

check_tool_installed adb
adb --version | head -n 1
check_tool_installed ffmpeg
ffmpeg -version | head -n 1
check_tool_installed node
node -v | head -n 1

select_target_device
select_target_cache
pull_cache_2_local

echo "Generating cache entry file."
rm_files ${TARGET_CACHE}/${CACHE_ENTRY_FILE}
ls ${TARGET_CACHE} >${TARGET_CACHE}/${CACHE_ENTRY_FILE}
for entry in $(cat ${TARGET_CACHE}/${CACHE_ENTRY_FILE}); do
    if [[ "${entry}" == ${CACHE_ENTRY_FILE} ]]; then
        continue
    fi
    parse_video_info ${TARGET_CACHE}/${entry}/entry.json
    entry_prefix=$(printf "%03d" ${entry})
    if [[ ! -e "${TARGET_CACHE}_output" ]]; then
        mkdir "${TARGET_CACHE}_output"
    fi
    if [[ ${CURRENT_VIDEO_TYPE_TAG} == ${VIDEO_TYPE_FLV} ]]; then
        # flv
        convert_flv_video ${TARGET_CACHE}/${entry} ${entry_prefix}
    elif [[ ${CURRENT_VIDEO_TYPE_TAG} == ${VIDEO_TYPE_80} ]]; then
        # 80
        convert_80_video ${TARGET_CACHE}/${entry} ${entry_prefix}
    else
        # not supported
        echo "Not supported cache format."
        break
    fi
    echo ""
done
rm_files ${TARGET_CACHE}/${CACHE_ENTRY_FILE}
