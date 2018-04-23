# Ethereum Workshop - Introduction to Ethereum

This workshop will take you through the process of building a Ethereum network. It is meant that you have a basic knowledge of Ethereum and CLIs.

Topics to be covered:

* Ethereum node (geth)
* Wallets (Mist, Metamask)
* Smart Contracts (Remix)
* Private Ethereum Network (config)
* Auxiliary tools (bootnode, ethstats, explorer)

## 1. Setting up Ethereum

### 1.1. Install an Ethereum node

Install geth

Info: [Installing Geth · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/Installing-Geth)

For MacOs users:

```
brew tap ethereum/ethereum
brew install ethereum
```

URL:
[Installation Instructions for Mac · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Mac)

Test the installation and check geth version (1.8.4-stable):

```
geth version
```

### 1.2. Setting up your own Private Ethereum Network

Create the first blockchain block, called _Genesis_, and save it under `genesis.json`:

```
{
    "config": {
        "chainId": 12342,
        "homesteadBlock": 0,
        "eip155Block": 0,
        "eip158Block": 0
    },
    "difficulty": "0x400",
    "gasLimit": "0x2100000",
    "alloc": {}
}
```

Script to generate genesis blocks can be found [here](https://raw.githubusercontent.com/ethereum/genesis_block_generator/master/mk_genesis_block.py).

Notice that we added a low difficulty for testing purposes.
More info about the parameters can be found [here](https://ethereum.stackexchange.com/questions/2376/what-does-each-genesis-json-parameter-mean).

Initialize the genesis block as and store all blockchain data into the folder _chaindata_:

```
geth --networkid 12342 --datadir ./chaindata init ./genesis.json
```

### 1.3. Pre-allocating ether to your account

To ease the access to the private blockchain, accounts can be pre-founded in the genesis block.

Create an account for pre-funding by using geth as:

```
geth account new --datadir ./chaindata

Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase:
Repeat passphrase:
Address: {34ea76abaae5f9c4fef8bc8195632ec92be437df}
```

The account keys are stored in chaindata/keystore.

Update the genesis.json by setting the **alloc** field with the previously created account address:

```
{
    "config": {
        "chainId": 15,
        "homesteadBlock": 0,
        "eip155Block": 0,
        "eip158Block": 0
    },
    "difficulty": "0x400",
    "gasLimit": "0x2100000",
    "alloc": {
        "34ea76abaae5f9c4fef8bc8195632ec92be437df":
         { "balance": "100000000000000000000" }
    }
}
```

Note: the balance is defined in **Wei**, which is a denomination (just as a _cent_ or _penny_). 1 ether = 10^18 wei.

As you may notice, the chaindata folder already contains data from the previous initialization. Therefore, remove the previous initialized chaindata:

```
geth removedb --datadir ./chaindata
```

Re-run the init command:

```
geth --networkid 12342 --datadir ./chaindata init ./genesis.json
```

### 1.4. Running an Ethereum Node

Run the Ethereum node:

```
geth --identity "MyTestNetNode" --datadir ./chaindata --nodiscover --networkid 12342
```

### 1.5. Interacting through the console

Attach to the Ethereum node by using IPC (Inter-process Communications):

```
geth attach ./chaindata/geth.ipc

Welcome to the Geth JavaScript console!

instance: Geth/MyTestNetNode/v1.8.4-stable/darwin-amd64/go1.10.1
coinbase: 0xe73f4d6cbd66ae26bd03cb208df78484e8255d72
at block: 0 (Thu, 01 Jan 1970 01:00:00 CET)
 datadir: /Users/mariocao/Data/Personal/git/ethereum-basic-workshop/section-1/chaindata
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

>
```

Alternatively, you could run the console directly while executing _geth_:

```
geth --identity "MyTestNetNode" --datadir ./chaindata --nodiscover --networkid 12342 console
```

As it can be seen, geth provides several management APIs as for example:

* admin: Geth node management
* debug: Geth node debugging
* miner: Miner and DAG management
* personal: Account management
* txpool: Transaction pool inspection
* web3: JS application API

More information:

* [Management APIs · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/Management-APIs)
* [JavaScript API · ethereum/wiki Wiki · GitHub](https://github.com/ethereum/wiki/wiki/JavaScript-API)

Type for example:

```
web3.fromWei(eth.getBalance(eth.accounts[0]), "ether")
```

You will see that the previously configured account has been prefunded with 100 ethers.

## 2. Interacting with the Ethereum Node

### 2.1. Mist Browser and Ethereum Wallet

Mist is an Ethereum browser which already includes the Ethereum Wallet embedded.

![Mist Browser Screenshot](images/mist.png?raw=true "Mist")

Download and install Mist from [Releases · ethereum/mist · GitHub](https://github.com/ethereum/mist/releases).

Important: if not otherwise specified, Mist tries to synchronize with the Ethereum main network, i.e. download the entire blockchain.

In order to open it directly connected to the development network by providing the IPC path:

```
open -a /Applications/Mist.app --args --rpc <FULL_PATH>/chaindata/geth.ipc
```

It is important to provide the `<FULL_PATH>`or otherwise it will not connect to the private ethereum network.

Discover the application:

* Check your pre-funded account balance
* Create a new account (not wallet contract)
* Send ETH to the new account

Wait... why is it not working?
We forgot something really important... mining!

### 2.2. Enabling mining in the Ethereum node

Access the Ethereum node and enable mining:

```
geth attach ./chaindata/geth.ipc
```

The pending transactions in the node can be reviewd by:

```
txpool.status
txpool.content
```

As it can be seen, there are pending transactions. To enable mining, just type:

```
miner.start()
```

If etherbase is not set, then:

```
miner.setEtherbase("0x34ea76abaae5f9c4fef8bc8195632ec92be437df")
```

It can be stopped anytime by:

```
miner.stop();
```

Now, the previous transfer should be executed!

Question: Did you notice anything regarding the number of confirmations?

### 2.3. Deploying Smart Contracts

Now, it's time to deploy small Smart Contracts by using Mist.

Note: "Wallet Contracts" are Smart Contracts provided by the application.

#### Greeter

In the "Contracts" section, deploy a new Smart Contract.

Paste the following code into the Solidity Contract Source Code editor.

```
pragma solidity ^0.4.18;

contract Greeter {

    /* Define variable greeting of the type string */
    string greeting;

    /* This runs when the contract is executed */
    function Greeter(string _greeting) public {
        greeting = _greeting;
    }

    /* Main function */
    function greet() public constant returns (string) {
        return greeting;
    }
}
```

Select the contract to deploy (there is only 1) and write the constructor arguments, e.g. "Ahoy, matey!".

After deployed, the contract will have a function that returns the configured greeting.

#### Hello World

The previous Smart Contract was so simple, that there was only 1 function accessible.

The following Smart Contract is also simple, but allows to modify a counter by using 2 functions (to add and substract) and 1 to read.

```
pragma solidity ^0.4.18;

contract HelloWorld {

    //state variable we assigned earlier
    uint256 counter = 5;

    //increases counter by 1
    function add() public {  
        counter++;
    }

    //decreases counter by 1
    function subtract() public {
        counter--;
    }

    //read the counter
    function read() public constant returns (uint256) {
        return counter;
    }
}
```

This contract allows users to interact with the Smart Contract by writing into it and modifying the counter value.

Try it out by going to the _Contracts_ section and executing some of the previous functions to modify the counter.

### 2.4. Metamask

One of the most used application to interact with Ethereum is Metamask.

![Metamak Screenshot](images/metamask.png?raw=true "Metamask")

Install [MetaMask](https://metamask.io/) browser extension (for Chrome, Firefox and Opera).

By default, Metamask will try to connect to the Main network.

The first step is to connect Metamask with the private Ethereum network. For that reason, on the top-left side, choose "Localhost".

But, wait... it does not work!
The reason is because Metamask tries to connect using RPC and the Ethereum node has it not enabled by default.

#### Enable RPC on Ethereum Node

Run the Ethereum node with RPC 8545:

```
geth --identity "MyTestNetNode" --datadir ./chaindata --nodiscover --networkid 12342 --rpc
```

#### Retry to connect

Connect to the localhost port 8545 (default) and discover the application by:

1.  Create an account
2.  Send ether between Mist and Metamask accounts

Note: Mist must be restarted because the geth process was stopped and restarted.

## 3. Basic Smart Contract Development

One of the first and commonly used Ethereum IDE is Remix, an online tool for developing and deploying Smart Contracts.

![Remix Screenshot](images/remix.png?raw=true "Remix")

Go to [Remix - Solidity IDE](http://remix.ethereum.org/) and create 2 files for the 2 previous Smart Contracts in the editor.

### 3.1. Compile Solidity

Compile the Smart Contracts in the Remix application by clicking in the _Start to Compile_ button.

### 3.2. Run Smart Contracts

There are 3 environments:

* Javascript VM (browser)
* Injected Web3 (e.g. Metamask)
* Web3 Provider (geth RPC)

Note: Javascript VM is local and not connected to geth testnet.

In the Remix IDE:

1.  Select the Smart Contracts
2.  Run them!
3.  Execute their functions
4.  Check the logs in Remix
5.  Check the logs in Geth

Finally, take a look to the Analysis tool included in the Remix IDE as it checks security, gas & economy and miscelaneous considerations.

#### Web3 Provider

To connect through Web3 provider, geth has to be executed with a CORS (Cross-origin resource sharing) parameter:

```
geth --datadir=./chaindata/ --rpc --rpccorsdomain 'http://remix.ethereum.org'
```

Then, while deploying smart contracts, the selected accounts should be unlocked. In that way, the Remix application will be able to send transactions automatically.

```
geth attach ./chaindata/geth.ipc
> personal.unlockAccount("0x34ea76abaae5f9c4fef8bc8195632ec92be437df","password")
```

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
