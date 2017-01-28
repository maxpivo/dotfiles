#!/usr/bin/env bash

setTagValue() {
  # http://wiki.bash-hackers.org/commands/builtin/read
  # http://wiki.bash-hackers.org/syntax/shellvars#ifs
  # http://www.tldp.org/LDP/abs/html/x17837.html#HERESTRINGSREF
  IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
}

evDate() {
    date +$'date\t%H:%M'
}

setDate() {
    segmentDate=$(date +"^fg($colGrey200)%H:%M^fg($colGrey500), %Y-%m-^fg($colGrey200)%d")
}

evVolume() {
    local value=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')
    echo -e "volume\t$value"
}

setVolume() {
    segmentVolume="^fg($colGrey700) Vol ^fg($colBlue300)$1"
}

setWindowtitle() {    
    # "${segmentWindowtitle//^/^^}"
    segmentWindowtitle="^bg()^fg($colYellow500) $1"    
}

setMPD() {
    # format="^fg(#$colYellow900)[%artist% ^fg()- ]^fg(#$colBlue500)[%title%|%file%]"
    format="^fg(#$colYellow900)[%artist% ^fg()- ]^fg(#$colBlue500)[%title%]"
    segmentMPD=$(mpc current -f "$format")
}

setWIFI() {  
    WIFI=$(iw dev | grep Interface | awk '{print $2}')
  
    if [ \"$WIFI\" ]; then 
        SSID=$(iw dev $WIFI link | grep SSID: | awk '{print $2}');
    fi
}  

evMemory() {
    local mem_total=$(free | awk 'FNR == 2 {print $2}')
    local mem_used=$(free | awk 'FNR == 2 {print $3}')
    local value=$[$mem_used * 100 / $mem_total]
    echo -e "memory\t$value"
}

setMemory() {
    segmentMemory="^fg($colGrey700) Mem ^fg($colBlue300)$1%"
}

evDisk() {
    local value=$(df /home -h | awk  'FNR == 2 {print $5}' | sed s/%//)
    echo -e "disk\t$value"
}

setDisk() {
    segmentDisk="^fg($colGrey700) Disk ^fg($colBlue300)$1%"
}

evCPU() {
    local value=$(sh ~/.config/herbstluftwm/bash/assets/chunk_cpu_usage.sh)
    echo -e "cpu\t$value"
}

setCPU() {
    segmentCPU="^fg($colGrey700) CPU ^fg($colBlue300)$1%"
}

evNet() {
    local value=$(sh ~/.config/herbstluftwm/bash/assets/chunk_net_speed.sh)
    echo -e "net\t$value"
}

setNet() {
    segmentNet="^fg($colGrey700) Net ^fg($colBlue300)$1"
}
