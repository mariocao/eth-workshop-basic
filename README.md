# Ethereum Workshop - Introduction to Ethereum

## 4. Extra: Building a Private Network with multiple nodes

The objective of this section is to create an Ethereum Private Network in a local area network (LAN) by using a similar approach as the Ethereum Mainnet. Additionally, some application are used to review the Blockchain statistics and review its content.

Steps to follow:

1.  Define genesis block
2.  Bootstrap node (port 30300)
3.  Deploy first Ethereum node
4.  Network statistics (port 3000)
5.  Blockchain explorer (port 8000)
6.  Deploy other Ethereum nodes --> ALL (genesis block from step 1)

The deployed Network ID will be 12342 (test network). It is important that the _network ID_ matches the _chain ID_ described in the genesis block.

### 4.1 Genesis block

Create a genesis configuration file as `genesis.json`:

```
{
  "config": {
    "chainId": 12342,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 0,
    "eip158Block": 0,
    "ByzantiumBlock": 0,
    "ethash": {}
  },
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "difficulty": "0x0400000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x2d3d20576f726b7368686f70206279204d6172696f2043616f203d2d",
  "gasLimit": "0x47e7c5",
  "alloc": {}
}
```

### 4.2 Start bootstrap node

This step will be made only once in order to allow other nodes connect to it.
A bootstrap node will be deployed and it will be listening on port 30300.

Install go-ethereum tools:

```
git clone https://github.com/ethereum/go-ethereum
cd go-ethereum
make all
```

Generate the bootstrap node key:

```
cd build/bin
./bootnode --genkey=boot.key
```

Run the bootstrap application:

```
./bootnode -nodekey boot.key -verbosity 4 -addr :30300

INFO [04-21|19:19:46] UDP listener up                          self=enode://023f33aef556fe316ae2bc19297dcee60b62f00530ebca6c950deb2530511e2b1deb535ed1de3d5958e08b8297bd7713978f928b87efde074587e629635b1abf@[::]:30300
```

Identify the IPs being used by the node as:

```
ifconfig|grep netmask|awk '{print $2}'

127.0.0.1
192.168.0.114
```

Compose a reacheable address by using the external IP and the previous enode address, e.g.

```
enode://023f33aef556fe316ae2bc19297dcee60b62f00530ebca6c950deb2530511e2b1deb535ed1de3d5958e08b8297bd7713978f928b87efde074587e629635b1abf@192.168.0.114:3030
```

If no bootnode is deployed, then each peer has to add other peers manually or by using a pre-defined list. For example, from the console a node can be added as:

```
> admin.addPeer("enode://d366d2a2e2761b202402ad6c8bdb53202f496d388a2f9f3e2a15607dbce939158b4506d903933875f6fcf035dc7c0f965458598bbfda91ebdf94c27cd54d2548@127.0.0.1:30301")
```

### 4.3. Start the Ethereum Statistics

One of the most used Ethereum tool for blockchain statistics is the [Ethereum Network Stats](https://github.com/cubedro/eth-netstats).

![Ethereum Netstats](images/netstats.jpg?raw=true "Remix")

Install ethstats from the repository:

```
git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
npm install
sudo npm install -g grunt-cli
grunt
```

Start the server by:

```
WS_SECRET=secret npm start
```

Visit the following URL: http://localhost:3000

### 4.4. Setup First Ethereum node

First of all, initialize the genesis block as:

```
geth \
 --datadir="./01-chaindata" \
 --networkid=12342 \
 init genesis.json
```

Run the Ethereum node with:

* networkid: 12342
* port: 30303 (default)
* rpc: 8545 (default)
* eth stats: node1:secret@**<BOOTNODE_IP>**:3000
* bootstrap node from the section 4.2 with the right IP
* console

```
geth \
 --datadir='./01-chaindata' \
 --networkid=12342 \
 --rpc \
 --rpcaddr '127.0.0.1' --rpccorsdomain '*' \
 --ethstats node1:secret@127.0.0.1:3000 \
 --bootnodes 'enode://023f33aef556fe316ae2bc19297dcee60b62f00530ebca6c950deb2530511e2b1deb535ed1de3d5958e08b8297bd7713978f928b87efde074587e629635b1abf@192.168.0.114:30300' \
 console
```

Start mining by your personal account and check differences in website of ethstats:

```
> miner.setEtherbase("0x627306090abaB3A6e1400e9345bC60c78a8BEf57")
true
> miner.start()
```

### 4.5 Blockchain explorer

Another commonly used tool is the Blockchain Explorer. For example, [here](https://github.com/carsenk/explorer.git) there is an extension of the Etherparty Block explorer.

![Ethereum Block Explorer](images/explorer.png?raw=true "Remix")

The blockchain explorer connects directly to the first deployed node to the RPC port 8545.
It is important to configure the node to allow connections from the explorer by setting properly _rpccorsdomain_.

Install the explorer as:

```
git clone https://github.com/carsenk/explorer.git
cd explorer
npm install
```

Start the server:

```
npm start
```

### 4.6 Connect other nodes!

For example, initialize the second node as:

```
geth \
 --datadir="./02-chaindata" \
 --networkid=12342 \
 init genesis.json
```

Run the Ethereum node considering that there should not be any port conflict if they are running on the same machine:

* networkid: 2000
* port: 30403
* rpc: 9545
* eth stats: node2:secret@**<BOOTNODE_IP>**:3000
* bootstrap node
* console

```
geth \
 --datadir='./02-chaindata' \
 --networkid=12342 \
 --port=30403 \
 --rpc \
 --rpcport '9545' --rpcaddr '127.0.0.1' --rpccorsdomain '*' \
 --ethstats node2:secret@127.0.0.1:3000 \
 --bootnodes 'enode://023f33aef556fe316ae2bc19297dcee60b62f00530ebca6c950deb2530511e2b1deb535ed1de3d5958e08b8297bd7713978f928b87efde074587e629635b1abf@192.168.0.114:30300' \
 console
```

Check that the peers discovered themselves as:

```
> admin.peers
```

## Author & Contributors

* Mario Cao - Initial work

## References

* [White Paper · ethereum/wiki Wiki · GitHub](https://github.com/ethereum/wiki/wiki/White-Paper)
* [Ethereum Homestead Documentation — Ethereum Homestead 0.1 documentation](http://ethdocs.org/en/latest/index.html)
* [Geth · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/geth)
* [GitHub - ethereum/mist: Mist. Browse and use Ðapps on the Ethereum network.](https://github.com/ethereum/mist)
* [MetaMask](https://metamask.io/)
* [Remix IDE](http://remix.ethereum.org/)
* [Ethereum Network Stats](https://github.com/cubedro/eth-netstats)
* [Ethereum Block Explorer](https://github.com/carsenk/explorer.git)
