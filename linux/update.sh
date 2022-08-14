#!/bin/sh
abspath=$(readlink -f $0)
dirpath=`dirname $abspath`
cd $dirpath

pwsh -ExecutionPolicy RemoteSigned -File ../bin/update.ps1