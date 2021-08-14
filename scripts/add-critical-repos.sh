#! /usr/bin/env -S bash -ex

###
### Refresh packages and get the basics ready
###

sudo apt update
sudo apt install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     gpg-agent \
     software-properties-common    
sudo apt dist-upgrade


###
### i2pd — https://repo.i2pd.xyz/.help/readme.txt
###

wget -q -O - https://repo.i2pd.xyz/.help/add_repo | sudo bash -s -


###
### Tor — https://support.torproject.org/apt/tor-deb-repo/
###

wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | sudo gpg --import
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

sudo cat > /etc/apt/sources.list.d/tor.list << EOF
deb [arch=$(dpkg --print-architecture)]     https://deb.torproject.org/torproject.org buster main
#deb-src [arch=$(dpkg --print-architecture)] https://deb.torproject.org/torproject.org buster main
EOF

sudo apt update && sudo apt install -y tor deb.torproject.org-keyring


###
### Whonix — https://www.whonix.org/wiki/Whonix_Packages_for_Debian_Hosts
###

curl --tlsv1.3 --proto =https --max-time 180 --output /tmp/patrick.asc https://www.whonix.org/patrick.asc
sudo gpg --import /tmp/patrick.asc
sudo apt-key --keyring /etc/apt/trusted.gpg.d/derivative.gpg add /tmp/patrick.asc
rm /tmp/patrick.asc

#echo "deb [arch=$(dpkg --print-architecture)] tor+http://deb.dds6qkxpwdeubwucdiaord2xgbbeyds25rbsgr73tbfpqpt4a6vjwsyd.onion buster main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list
echo "deb [arch=$(dpkg --print-architecture)] https://deb.Whonix.org buster main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list


###
### Docker — https://withblue.ink/2020/06/24/docker-and-docker-compose-on-raspberry-pi-os.html
###

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt install -y --no-install-recommends \
    docker-ce \
    cgroupfs-mount

sudo apt install -y python3-pip libffi-dev
sudo pip3 install docker-compose


###
### Node.js — https://github.com/nodesource/distributions
###

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo apt install -y nodejs


###
### Yarn — https://classic.yarnpkg.com/en/docs/install/#debian-stable
###

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb [arch=$(dpkg --print-architecture)] https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn


###
### sysbench — https://github.com/akopytov/sysbench#linux
###

curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash
sudo apt install -y sysbench

