#!/bin/bash
if [[ -z ${1} ]]; then
  echo -e "\033[1;31mno module name provided \033[0m"
  exit 1
fi
echo `go version`
cp -av `dirname $0`/scaffold_go/. ./
go mod init github.com/clsrfish/${1}
go mod tidy
