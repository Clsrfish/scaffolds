#!/bin/sh

AS_DIR=${HOME}/ByteDance/Projects

select proj in $(ls -Al ${AS_DIR} | grep '^d' | awk '{print $9}') "Quit"; do
    if [[ ${proj} == "Quit" ]]; then
        echo "Quit."
        break
    elif [[ -z ${proj} ]]; then
        echo "Invalid project:${proj}, please try again."
    else
        androidstudio ${AS_DIR}/${proj}
        cd ${AS_DIR}/${proj}
        break
    fi
done
