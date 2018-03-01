#!/bin/sh

cd `dirname $0`
if [ -d "./build/out" ]; then
    cp ./build/out/*.out ${PROJECT_DIR}/${PROJECT_NAME}/Resources
fi
