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
    local iconDate="$preIcon$postIcon"
    local date=$(date +"%Y-%m")
    local day=$(date +"%d")
    local iconTime="$preIcon$postIcon"
    local time=$(date +"%H:%M")
    
    case $theme in
      'bright-arrow') 
         segmentDate=" $iconTime ^fg($colGrey200)$time, "
         segmentDate+="$iconDate ^fg($colGrey500)$date-^fg($colGrey200)$day"    
      ;;
      'dark-arrow')
         segmentDate=" $iconTime ^fg($colGrey200)$time, "
         segmentDate+="$iconDate ^fg($colGrey500)$date-^fg($colGrey200)$day" 
      ;;
      'bright-colorful')
         segmentDate=" $iconTime ^fg($colGrey900)$time, "
         segmentDate+="$iconDate ^fg($colGrey600)$date-^fg($colGrey900)$day"    
      ;;
      *)  # 'dark-colorful'
         segmentDate=" $iconTime ^fg($colGrey200)$time, "
         segmentDate+="$iconDate ^fg($colGrey500)$date-^fg($colGrey200)$day"    
      ;;
    esac    
}

evVolume() {
    local value=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')
    echo -e "volume\t$value"
}

setVolume() {
    local icon="$preIcon$postIcon"
    segmentVolume="$icon $labelColor Vol $valueColor$1"
}

setWindowtitle() {
    local icon="$preIcon$postIcon"
    # "${segmentWindowtitle//^/^^}"
    
    case $theme in
      'bright-arrow') 
         segmentWindowtitle=" $icon ^bg()^fg($colGrey700) $1"
      ;;
      'dark-arrow')
         segmentWindowtitle=" $icon ^bg()^fg($colGrey500) $1"
      ;;
      'bright-colorful')
         segmentWindowtitle=" $icon ^bg()^fg($colGrey700) $1"
      ;;
      *)  # 'dark-colorful'
         segmentWindowtitle=" $icon ^bg()^fg($colGrey500) $1"
      ;;
    esac    
}

setMPD() {
    case $theme in
      'bright-arrow') 
         local format="^fg(#$colGrey900)[%artist% ^fg()- ]^fg(#$colGrey300)[%title%]"
      ;;
      'dark-arrow')
         local format="^fg(#$colGrey100)[%artist% ^fg()- ]^fg(#$colYellow500)[%title%]"
      ;;
      'bright-colorful')
         local format="^fg(#$colBlue500)[%artist% ^fg()- ]^fg(#$colPink700)[%title%]"
      ;;
      *)  # 'dark-colorful'
         local format="^fg(#$colBlue300)[%artist% ^fg()- ]^fg(#$colYellow500)[%title%]"
      ;;
    esac

    local iconPlay="$preIcon$postIcon"
    local iconPause="$preIcon$postIcon"
    segmentMPD="$iconPlay "$(mpc current -f "$format")
}

evSSID() {
    local wifi=$(iw dev | grep Interface | awk '{print $2}')
    
    local value=""
    if [ \"$wifi\" ]; then 
        value=$(iw dev $wifi link | grep SSID: | awk '{print $2 $3}')
    fi
    echo -e "ssid\t$value"
}

setSSID() {  
   local icon="$preIcon$postIcon"
   segmentSSID="$icon $valueColor$1"
}  

evMemory() {
    local mem_total=$(free | awk 'FNR == 2 {print $2}')
    local mem_used=$(free | awk 'FNR == 2 {print $3}')
    local value=$[$mem_used * 100 / $mem_total]
    echo -e "memory\t$value"
}

setMemory() {
    local icon="$preIcon$postIcon"
    segmentMemory="$icon $labelColor Mem $valueColor$1%"
}

evDisk() {
    local value=$(df /home -h | awk  'FNR == 2 {print $5}' | sed s/%//)
    echo -e "disk\t$value"
}

setDisk() {
    local icon="$preIcon$postIcon"
    segmentDisk="$icon $labelColor Disk $valueColor$1%"
}

evCPU() {
    helperCPU
    local value=$cpu_util
    echo -e "cpu\t$value"
}

setCPU() {
    local icon="$preIcon$postIcon"
    segmentCPU="$icon $labelColor CPU $valueColor$1%"
}

evNet() {
    local value="$RX_text $TX_text"
    echo -e "net\t$value"
}

setNet() {
    helperNet
    local iconUp="$preIcon$postIcon"
    local iconDown="$preIcon$postIcon"
    segmentNet="$labelColor Net $iconUp $valueColor$TX_text $iconDown $valueColor$RX_text"
}

evUptime() {
    local value=$(uptime -p)
    echo -e "uptime\t$value"
}

setUptime() {
    #  Uptime
    local icon="$preIcon$postIcon"
    segmentUptime="$icon $labelColor Uptime $valueColor$1"
}

evHost() {
    # I prefer $(uname -r)
    local value=$(uname -n)
    echo -e "host\t$value"
}

setHost() {
    #  Machine
    #  Home
    local icon="$preIcon$postIcon"
    segmentHost="$icon $labelColor Host $valueColor$1"
}

evUpdates() {
    local value=$(pacman -Qu | wc -l)
    echo -e "updates\t$value"
}

setUpdates() {
    local icon="$preIcon$postIcon"
    segmentUpdates="$icon $labelColor Updates $valueColor$1"
}

helperNet() {
  local interface=$(iw dev | grep Interface | awk '{print $2}')

  if [ "$interface" ]; then 

    # Read first datapoint
    read TX_prev < /sys/class/net/$interface/statistics/tx_bytes
    read RX_prev < /sys/class/net/$interface/statistics/rx_bytes

    sleep 1

    # Read second datapoint

    read TX_curr < /sys/class/net/$interface/statistics/tx_bytes
    read RX_curr < /sys/class/net/$interface/statistics/rx_bytes

    # compute 
    local TX_diff=$((TX_curr-TX_prev))
    local RX_diff=$((RX_curr-RX_prev))

    # printout var
    TX_text=$(echo "scale=1; $TX_diff/1024" | bc | awk '{printf "%.1f", $0}')
    RX_text=$(echo "scale=1; $RX_diff/1024" | bc | awk '{printf "%.1f", $0}')
  fi; 
}

helperCPU() {
  # Read /proc/stat file (for first datapoint)
  read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

  # compute active and total utilizations
  local cpu_active_prev=$((user+system+nice+softirq+steal))
  local cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))

  # echo 'cpu_active_prev = '.cpu_active_prev

  sleep 1

  # Read /proc/stat file (for second datapoint)
  read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

  # compute active and total utilizations
  local cpu_active_cur=$((user+system+nice+softirq+steal))
  local cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))

  # compute CPU utilization (%)
  cpu_util=$((100*( cpu_active_cur-cpu_active_prev ) / (cpu_total_cur-cpu_total_prev) ))
}
