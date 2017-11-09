#!/bin/bash
xrandr -q | head -n -4

read -p "Enter number or resolution:" res
xrandr -s $res
