#!/bin/bash

# wget -O ledger.7z https://mynano.ninja/api/ledger/download -q --show-progress
wget -O test https://github.com/strawberry-labs/BTCPay-Nano-Plugin/blob/master/LICENSE -q --show-progress
 
# p7zip -d ledger.7z
 
# mv data.ldb Nano/data.ldb

mv test ~/Nano/test
 
# docker restart nano-node