#!/bin/bash
sudo snapper -c home create-config /home
sudo snapper -c home create --description "New config"

sudo snapper -c home create-config /opt
sudo snapper -c home create --description "New config"