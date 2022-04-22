#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. ./VARIBLES.sh

for forScriptFile in $(ls $ScriptLocal/macos/config )
do
	chmod +x $ScriptLocal/macos/config/$forScriptFile
    . $ScriptLocal/macos/config/$forScriptFile
done