# Ethereum Workshop - Introduction to Ethereum

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

## Author & Contributors

* Mario Cao - Initial work

## References

* [White Paper · ethereum/wiki Wiki · GitHub](https://github.com/ethereum/wiki/wiki/White-Paper)
* [Ethereum Homestead Documentation — Ethereum Homestead 0.1 documentation](http://ethdocs.org/en/latest/index.html)
* [Geth · ethereum/go-ethereum Wiki · GitHub](https://github.com/ethereum/go-ethereum/wiki/geth)
* [GitHub - ethereum/mist: Mist. Browse and use Ðapps on the Ethereum network.](https://github.com/ethereum/mist)
* [MetaMask](https://metamask.io/)
* [Remix IDE](http://remix.ethereum.org/)
