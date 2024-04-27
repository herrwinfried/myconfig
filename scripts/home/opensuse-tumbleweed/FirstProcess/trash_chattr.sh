#!/bin/bash

if [ -f $XDG_DESKTOP_DIR/trash.desktop ]; then

    SUDO chattr +i $XDG_DESKTOP_DIR/trash.desktop

fi