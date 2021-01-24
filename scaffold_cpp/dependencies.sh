#!/bin/bash
pwd
if [ -f build/dependencies.dot ]; then
    dot -v -Twebp -o build/dependencies.webp build/dependencies.dot
else
    echo "Could not find build/dependencies.dot"
    exit 1
fi
if [ -f build/dependencies.webp ]; then
    code build/dependencies.webp
else
    echo "Could not find build/dependencies.webp"
    exit 1
fi
