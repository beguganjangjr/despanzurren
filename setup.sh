#!/bin/bash

# Install rclone static binary
# Install rclone static binary
wget -q --no-check-certificate https://github.com/xinxin8816/heroku-aria2c-21vianet/raw/master/rclone.zip
unzip -q rclone.zip
export PATH=$PWD:$PATH
chmod 777 /app/rclone

#Inject Rclone config
wget -q https://github.com/begulatuk/heroku_download/raw/master/accounts.rar
wget -q https://www.rarlab.com/rar/rarlinux-x64-5.9.0.tar.gz
tar xf rarlinux-x64-5.9.0.tar.gz
export PATH=$PWD/rar:$PATH
unrar -p"${SA_SECRET}" e accounts.rar /app/accounts/

# Install aria2c static binary
wget -q https://github.com/P3TERX/Aria2-Pro-Core/releases/download/1.35.0_2021.02.19/aria2-1.35.0-static-linux-amd64.tar.gz
tar xf aria2-1.35.0-static-linux-amd64.tar.gz
export PATH=$PWD:$PATH

# Create download folder
mkdir -p downloads

# DHT
wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht.dat
wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat

# Tracker
file="trackers.txt"
echo "$(curl -Ns https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt)" > trackers.txt
echo "$(curl -Ns https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ip.txt)" >> trackers.txt
echo "$(curl -Ns https://newtrackon.com/api/live)" >> trackers.txt
tmp=$(sort trackers.txt | uniq) && echo "$tmp" > trackers.txt
sed -i '/^$/d' trackers.txt
sed -i ":a;N;s/\n/,/g;ta" trackers.txt
tracker_list=$(cat trackers.txt)
if [ $file ] ; then
    rm -rf $file

fi
echo "trackers added"
echo "bt-tracker=$tracker_list" >> aria2c.conf

echo $PATH > PATH
