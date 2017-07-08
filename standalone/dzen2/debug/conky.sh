#!/usr/bin/env bash

generated_output() {
    DIR=$(dirname "$0")
    conky -c ${DIR}/conky.lua
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# execute

clear
generated_output


