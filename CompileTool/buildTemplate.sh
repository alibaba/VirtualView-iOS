#!/bin/bash

if ! command -v java >/dev/null 2>&1 ; then
    echo "java is not installed"
    exit 0
fi
if ! java -version 2>&1 | grep -q 'version "1\.8\.' ; then
    echo "java version is not 1.8.x"
    exit 0
fi

cd `dirname $0`
java -jar compiler.jar jarBuild
