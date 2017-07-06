#!/usr/bin/env bash

# hide cursor
tput civis  -- invisible
# type' tput cnorm' to show

clear

DIR=$(dirname "$0")
conky -c ${DIR}/conky.lua 

