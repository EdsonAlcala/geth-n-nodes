#!/bin/bash

privateKeys=()

#### Copy keys from files to array ##################

for i in {1..4}
do 
  pk=`cat keys/key$i`
  echo "Key $i $pk"
  privateKeys[i-1]=$pk
done

echo '[0] Preparing keys'

#### Create main directory ##################

nnodes=${#privateKeys[@]}

#### Create directories for each node's configuration ##################

echo '[1] Configuring for '$nnodes' nodes.'

n=1
for pk in ${privateKeys[*]}
do
    qd=qdata_$n
    mkdir -p $qd/logs
    mkdir -p $qd/dd/geth
    let n++
done

### Copy private keys to nodekey in each folder
n=1
for key in ${privateKeys[*]}
do
    qd=qdata_$n
    touch $qd/nodekey
    echo $key >> $qd/nodekey
    let n++
done

#### Make static-nodes.json and store keys #############################

echo '[2] Creating Enodes and static-nodes.json.'

echo "[" > static-nodes.json
n=1
for key in ${privateKeys[*]}
do
    qd=qdata_$n

    # Generate the node's Enode and key
    enode=`cat $qd/nodekey`
    echo "The current nodekey is '$enode'"
    enode=`bootnode -nodekey $qd/nodekey -writeaddress`

    # Add the enode to static-nodes.json
    sep=`[[ $n < $nnodes ]] && echo ","`
    echo '  "enode://'$enode'@0.0.0.0:3300'$n'?discport=0"'$sep >> static-nodes.json
    let n++
done
echo "]" >> static-nodes.json

#### Create accounts, keys and genesis.json file #######################

echo '[3] Creating Ether accounts and genesis.json.'

cat > genesis.json <<EOF
{
  "alloc": {
EOF

n=1
for privkey in ${privateKeys[*]}
do
    qd=qdata_$n

    # Generate an Ether account for the node
    touch $qd/password.txt
    account=`geth --datadir=$qd/dd --password $qd/password.txt account import $qd/nodekey | cut -c 11-50`
    echo "The account generated is '$account'"

    # Add the account to the genesis block so it has some Ether at start-up
    sep=`[[ $n < $nnodes ]] && echo ","`
    cat >> genesis.json <<EOF
    "${account}": {
      "balance": "1000000000000000000000000000"
    }${sep}
EOF

    let n++
done

cat >> genesis.json <<EOF
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "config": {
      "chainId": 2017,
      "homesteadBlock": 1,
      "byzantiumBlock": 1,
      "eip150Block": 2,
      "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
      "eip155Block": 3,
      "eip158Block": 3,
      "eip211Block": 3
  },
  "gasLimit": "0x2FEFD800",
  "difficulty": "0x1",
  "extraData"  : "",
  "mixhash"    : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "nonce": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "gasUsed": "0x0",
  "number": "0x0" 
}
EOF

#### Copy static-nodes.json to their respective folder #######################
n=1
for privkey in ${privateKeys[*]}
do
    qd=qdata_$n
    cp ./static-nodes.json $qd/dd
    let n++
done

#### Remove static-nodes.json #######################

rm -f ./static-nodes.json

