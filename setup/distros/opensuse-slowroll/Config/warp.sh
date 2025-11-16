#!/bin/bash

sudo su -c "echo tun | tee /etc/modules-load.d/tun.conf"
