#!/bin/bash

swapon /swap

#After the conatiners are up, run this script to set up radios and set them up

move_iface_pid() {
  PID=$(docker inspect --format='{{.State.Pid}}' $2)
  PHY=phy$(iw $1 info | grep wiphy | awk '{print $2}')
  #echo move $1 is $PHY to $2 is $PID
  iw phy $PHY set netns $PID
}

set_iface_radio_group() {
  PHY=phy$(iw $1 info | grep wiphy | awk '{print $2}')
  echo $2 > /sys/kernel/debug/ieee80211/$PHY/hwsim/group
}

modprobe -r mac80211_hwsim
modprobe mac80211_hwsim radios=32

ATTACKER_PID=$(docker inspect --format='{{.State.Pid}}' t1_attacker)
ip link set hwsim0 netns $ATTACKER_PID

set_iface_radio_group wlan0 2
set_iface_radio_group wlan1 2
set_iface_radio_group wlan2 2

move_iface_pid "wlan0" "t1_ap"
move_iface_pid "wlan1" "t1_sta2"
move_iface_pid "wlan2" "t1_attacker"

set_iface_radio_group wlan3 4
set_iface_radio_group wlan4 4
set_iface_radio_group wlan5 4
set_iface_radio_group wlan6 4

move_iface_pid "wlan3" "t1_ap"
move_iface_pid "wlan4" "t2_ap"
move_iface_pid "wlan5" "t2_sta3"
move_iface_pid "wlan6" "t2_sta4"

set_iface_radio_group wlan7 8
set_iface_radio_group wlan8 8
set_iface_radio_group wlan9 8

move_iface_pid "wlan7" "t2_sta4"
move_iface_pid "wlan8" "t3_ap"
move_iface_pid "wlan9" "t3_sta3"

set_iface_radio_group wlan10 16
set_iface_radio_group wlan11 16
set_iface_radio_group wlan12 16
set_iface_radio_group wlan13 16
set_iface_radio_group wlan14 16
set_iface_radio_group wlan31 32
move_iface_pid "wlan10" "t3_sta3"
move_iface_pid "wlan11" "t4_ap"
#.4.1 is .5.2
move_iface_pid "wlan31" "t4_ap"
move_iface_pid "wlan12" "t4_sta3"
#extra one for scanner for mdns scan service
move_iface_pid "wlan13" "t4_sta3"
move_iface_pid "wlan14" "t4_sta4"

set_iface_radio_group wlan15 32
set_iface_radio_group wlan16 32
set_iface_radio_group wlan26 64

move_iface_pid "wlan15" "t5_ap"
move_iface_pid "wlan26" "t5_ap"
move_iface_pid "wlan16" "t5_sta3"

set_iface_radio_group wlan27 128
set_iface_radio_group wlan17 64
set_iface_radio_group wlan18 64

move_iface_pid "wlan17" "t6_ap"
move_iface_pid "wlan27" "t6_ap"
move_iface_pid "wlan18" "t6_sta3"

set_iface_radio_group wlan28 256
set_iface_radio_group wlan19 128
set_iface_radio_group wlan20 128

move_iface_pid "wlan19" "t7_ap"
move_iface_pid "wlan28" "t7_ap"
move_iface_pid "wlan20" "t7_sta3"

set_iface_radio_group wlan29 512
set_iface_radio_group wlan21 256
set_iface_radio_group wlan22 256

move_iface_pid "wlan21" "t8_ap"
move_iface_pid "wlan29" "t8_ap"
move_iface_pid "wlan22" "t8_sta3"

set_iface_radio_group wlan30 1024
set_iface_radio_group wlan23 512
set_iface_radio_group wlan24 512

move_iface_pid "wlan30" "t9_ap"
move_iface_pid "wlan23" "t9_ap"
move_iface_pid "wlan24" "t9_sta3"

set_iface_radio_group wlan25 1024
move_iface_pid "wlan25" "t10_ap"


echo run execs now
docker exec -d t1_sta2 /go.sh
docker exec -d t1_attacker /go.sh
docker exec -d t1_ap /go.sh

docker exec -d t2_ap /go.sh
docker exec -d t2_sta3 /go.sh
docker exec -d t2_sta4 /go.sh

docker exec -d t3_ap /go.sh
docker exec -d t3_sta3 /go.sh

docker exec -d t4_ap /go.sh
docker exec -d t4_sta3 /go.sh
docker exec -d t4_sta4 /go.sh

for((i=5;i<10;i++))
do
  docker exec -d t${i}_ap /go.sh
  docker exec -d t${i}_sta3 /go.sh
done
docker exec -d t10_ap /go.sh

