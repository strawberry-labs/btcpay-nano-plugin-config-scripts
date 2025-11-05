#!/bin/bash

#get url for latest ledger file
wget -O ledger-link https://s3.us-east-2.amazonaws.com/repo.nano.org/snapshots/latest -q --show-progress

LEDGER_LINK="$(cat ledger-link)"

#download ledger file
wget -O ledger.7z $LEDGER_LINK -q --show-progress

apt install p7zip -y
 
p7zip -d ledger.7z
 
mv data.ldb ~/Nano/data.ldb

# Enable wallet rpc
sed -i 's/enable_control = false/enable_control = true/' ~/Nano/config-rpc.toml

# Configure pippin wallet
sed -i \
  -e 's/host: 127.0.0.1/host: 0.0.0.0/' \
  -e 's/node_rpc_url: *http:\/\/\[::1\]:7076/node_rpc_url: "http:\/\/btcpayserver_nano_node:7076"/' \
  -e 's/node_ws_url: *""/node_ws_url: "ws:\/\/btcpayserver_nano_node:7078"/' \
  -e 's/work_peers: *\[\]/work_peers: ["btcpayserver_nano_work_gen:7000"]/' \
  ~/PippinData/config.yaml
 
docker restart btcpayserver_nano_node

docker restart btcpayserver_nano_pippin_wallet