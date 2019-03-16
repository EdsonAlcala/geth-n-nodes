#!/bin/bash

#### Initialize nodes #######################

ARGS_MINER="--nodiscover --syncmode full --mine --minerthreads 1 --etherbase=0x0000000000000000000000000000000000000000 --verbosity 5 --debug --metrics --gasprice 0 --targetgaslimit 804247552 --nat none"
ARGS="--nodiscover --syncmode full --verbosity 5 --debug --metrics --gasprice 0 --targetgaslimit 804247552 --nat none"
RPC_ARGS="--rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3"

#### Start node 1 #######################
geth --datadir qdata_1/dd init genesis.json
nohup geth --datadir qdata_1/dd --nodekey qdata_1/nodekey --networkid 2017 --identity "Node 1 (Miner)" $ARGS_MINER $RPC_ARGS --rpccorsdomain "*" --rpcport 22001 --port 33001 --unlock 0 --password qdata_1/password.txt 2>>qdata_1/logs/geth.log &

#### Start node 2 #######################
geth --datadir qdata_2/dd init genesis.json
nohup geth --datadir qdata_2/dd --nodekey qdata_2/nodekey --networkid 2017 --identity "Node 2" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22002 --port 33002 --unlock 0 --password qdata_2/password.txt 2>>qdata_2/logs/geth.log &

#### Start node 3 #######################
geth --datadir qdata_3/dd init genesis.json
nohup geth --datadir qdata_3/dd --nodekey qdata_3/nodekey --networkid 2017 --identity "Node 3" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22003 --port 33003 --unlock 0 --password qdata_3/password.txt 2>>qdata_3/logs/geth.log &

#### Start node 4 #######################
geth --datadir qdata_4/dd init genesis.json
nohup geth --datadir qdata_4/dd --nodekey qdata_4/nodekey --networkid 2017 --identity "Node 4" $ARGS $RPC_ARGS --rpccorsdomain "*" --rpcport 22004 --port 33004 --unlock 0 --password qdata_4/password.txt 2>>qdata_4/logs/geth.log &


echo "All nodes configured."

exit 0