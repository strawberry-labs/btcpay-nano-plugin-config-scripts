#!/bin/bash
echo "Please enter the absolute path for the location for processing the set-up files. Make sure it has at least 150 GB free: "
read location

#get url for latest ledger file
wget -O ledger-link https://s3.us-east-2.amazonaws.com/repo.nano.org/snapshots/latest -q --show-progress

LEDGER_LINK="$(cat ledger-link)"

#download ledger file
wget -O ledger.7z $LEDGER_LINK -q --show-progress

apt install p7zip -y

cd $location

p7zip -d ~/btcpay-nano-plugin-config-scripts/ledger.7z 
 
mv ./data.ldb ~/Nano/data.ldb

cd ~

# Enable wallet rpc
sed -i 's/enable_control = false/enable_control = true/' ~/Nano/config-rpc.toml

# Disable node work gen
sed -i 's/work_threads = 1/work_threads = 0/' ~/Nano/config-node.toml

# Configure pippin wallet
sed -i \
  -e 's/host: 127.0.0.1/host: 0.0.0.0/' \
  -e 's/node_rpc_url: *http:\/\/\[::1\]:7076/node_rpc_url: "http:\/\/btcpayserver_nano_node:7076"/' \
  -e 's/node_ws_url: *""/node_ws_url: "ws:\/\/btcpayserver_nano_node:7078"/' \
  -e 's/work_peers: *\[\]/work_peers: ["https://uk1.public.xnopay.com/proxy"]/' \
  -e 's/receive_minimum: "1000000000000000000000000"/receive_minimum: "1"/' \
  -e 's/work_timeout: 30"/work_timeout: 120/' \
  ~/PippinData/config.yaml
 
docker restart btcpayserver_nano_node

docker restart btcpayserver_nano_pippin_wallet