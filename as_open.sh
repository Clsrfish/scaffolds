#!/bin/sh

AS_DIR=${HOME}/ByteDance/Projects

alias ANDROID_STUDIO="open -a /Applications/Android\ Studio.app"

select proj in $(ls -Al ${AS_DIR} | grep '^d' | awk '{print $9}') "Quit"; do
    if [[ ${proj} == "Quit" ]]; then
        echo "Quit."
        break
    elif [[ -z ${proj} ]]; then
        echo "Invalid project:${proj}, please try again."
    else
        ANDROID_STUDIO ${AS_DIR}/${proj}
        cd ${AS_DIR}/${proj}
        break
    fi
done

unalias ANDROID_STUDIO
