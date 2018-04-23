# Ethereum Workshop - Introduction to Ethereum

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

## Author & Contributors

* Mario Cao - Initial work

## References

* [White Paper · ethereum/wiki Wiki · GitHub](https://github.com/ethereum/wiki/wiki/White-Paper)
* [Ethereum Homestead Documentation — Ethereum Homestead 0.1 documentation](http://ethdocs.org/en/latest/index.html)
* [Geth · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/geth)
