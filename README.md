# Ethereum Workshop - Introduction to Ethereum

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

## Author & Contributors

* Mario Cao - Initial work

## References

* [White Paper · ethereum/wiki Wiki · GitHub](https://github.com/ethereum/wiki/wiki/White-Paper)
* [Ethereum Homestead Documentation — Ethereum Homestead 0.1 documentation](http://ethdocs.org/en/latest/index.html)
* [Geth · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/geth)
* [GitHub - ethereum/mist: Mist. Browse and use Ðapps on the Ethereum network.](https://github.com/ethereum/mist)
* [MetaMask](https://metamask.io/)
