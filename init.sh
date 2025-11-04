#!/bin/bash

#get url for latest ledger file
wget -O ledger-link https://s3.us-east-2.amazonaws.com/repo.nano.org/snapshots/latest -q --show-progress

LEDGER_LINK="$(cat ledger-link)"

#download ledger file
wget -O ledger.7z $LEDGER_LINK -q --show-progress

# wget -O test https://github.com/strawberry-labs/BTCPay-Nano-Plugin/blob/master/LICENSE -q --show-progress

apt install p7zip -y
 
p7zip -d ledger.7z
 
mv data.ldb ~/Nano/data.ldb

# # mv test ~/Nano/test
 
docker restart btcpayserver_nano_node