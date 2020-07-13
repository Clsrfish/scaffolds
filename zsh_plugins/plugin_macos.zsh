function notify() {
    title=${1}
    subtitle=${2}
    content=${3}
    sound="Pon"
    cmd=$(printf 'display notification "%s" with title "%s" subtitle "%s" sound name "%s"' "${content}" "${title}" "${subtitle}" "${sound}")
    osascript -e "$cmd"
}

function tingting_say() {
    say -v Ting-ting ${1}
}

function pbcopyfile() {
    if [ $(uname) != "Darwin" ]; then
        echo "$(uname) not supported"
        exit 1
    elif [ ! -f "${1}" ]; then
        echo "No such file or directory: ${1}"
        exit 1
    fi
    file_to_copy=$(
        cd $(dirname "$1")
        pwd -P
    )/$(basename "$1")
    osascript -e 'on run args' \
        -e 'set the clipboard to POSIX file (first item of args)' \
        -e 'return the clipboard' \
        -e end ${file_to_copy}
}
