#!/bin/bash
#echo "Please enter the absolute path for the location for processing the set-up files. Make sure it has at least 150 GB free: "
#read location

#get url for latest ledger file
echo -e "\nFetching ledger link file \n"
wget -O ledger-link https://s3.us-east-2.amazonaws.com/repo.nano.org/snapshots/latest -q --show-progress

LEDGER_LINK="$(cat ledger-link)"

#download ledger file
echo -e "\nDownloading nano ledger file \n"
#wget -O ledger.7z $LEDGER_LINK -q --show-progress
wget -O data.ldb $LEDGER_LINK -q --show-progress

#echo -e "\nInstalling p7zip \n"
#apt install p7zip -y

#cd $location

#echo -e "\nUnzipping the ledger file \n"
#p7zip -d ~BTCPayServer/btcpay-nano-plugin-config-scripts/ledger.7z 

echo -e "\nMoving nano ledger file to the Nano folder \n"
mv ./data.ldb ~/Nano/data.ldb

#cd ~

# Enable wallet rpc
echo -e "\nEditing the nano config-rpc.toml file \n"
sed -i 's/enable_control = false/enable_control = true/' ~/Nano/config-rpc.toml

# Disable node work gen
echo -e "\nEditing the nano config-node.toml file \n"
echo -e "[node]\nwork_threads = 0" >> ~/Nano/config-node.toml

# Configure pippin wallet
echo -e "\nEditing the pippin config file \n"
sed -i \
  -e 's/host: 127.0.0.1/host: 0.0.0.0/' \
  -e 's/node_rpc_url: *http:\/\/\[::1\]:7076/node_rpc_url: "http:\/\/btcpayserver_nano_node:7076"/' \
  -e 's/node_ws_url: *""/node_ws_url: "ws:\/\/btcpayserver_nano_node:7078"/' \
  -e 's/work_peers: *\[\]/work_peers: ["https:\/\/uk1.public.xnopay.com\/proxy"]/' \
  -e 's/receive_minimum: "1000000000000000000000000"/receive_minimum: "1"/' \
  -e 's/work_timeout: 30/work_timeout: 120/' \
  ~/PippinData/config.yaml
 
echo -e "\nRestarting nano node and pippin \n"
docker restart btcpayserver_nano_node

docker restart btcpayserver_nano_pippin_wallet