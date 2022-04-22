#!/bin/bash

mkdir -p $HomePWD/source

mkdir -p $HomePWD/.config
mkdir -p $HomePWD/.config/powershell
cp -r $ScriptLocal/data/home/.alias* $HomePWD
cp -r $ScriptLocal/data/home/.config $HomePWD/

mkdir -p $HomePWD/.poshthemes
cp -r $ScriptLocal/data/default.omp.json $HomePWD/.poshthemes
wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json -O $HomePWD/.poshthemes/default.omp.json
chmod u+rw $HomePWD/.poshthemes/*.omp.*