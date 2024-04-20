---
tags:
  - blockchain
date: " 2024-04-02"
up: "[[Ethereum]]"
status: "#idea"
---
- [[Ethereum]]

# Smart contract
A smart contract is an account controlled by code. A contract account has the following elements:

| Field   | Description                                                                                                 |
| ------- | ----------------------------------------------------------------------------------------------------------- |
| balance | Amount of ether this account owns                                                                           |
| storage | Data storage for this contract and related to this contract (to the application that we are trying to make) |
| code    | Raw machine code for this contract                                                                          |
Contract account differes from an **external account** because it is created in a specific ethereum netowork and cannot be access from different networks. In order to run a contract account in a different network, we have to **deploy** it in that specific network. 

When deploying a contract (source code) on the [[Ethereum]] network, multiple contract instances are generated depending on how many times we deploy it. Consequently, the contract source code functions akin to a class, while each deployment represents an instance. If we wish to implement changes made to the source code, we must redeploy the contract.

Smart contract are programmed by [[Solidity]]

# Deployment of a smart contract
When creating a contract, it initiates a transaction similar to that of an [[Ethereum#Ethereum transaction|external account]] sending funds to another. However, instead of transferring money, the transaction's purpose is to deploy a new contract onto a specific network.

The transaction object encompasses the following properties:
![[Pasted image 20240408213557.png]]
- `to`: In external-to-external transactions, this field indicates the recipient's address. However, in the case of contract creation, this field remains **blank**.
- `data`: This property exclusively pertains to contract creation, storing the bytecode of the contract. Security measures for code confidentiality are not inherent.
- `v, r, s`: These parameters are utilized to retrieve the address of the individual who created the contract.
- `value`: By assigning a value, the contract will possess an initial balance.
- [[Ethereum#Gas| gasPrice/startGas]]

# Set up EHT private

1. [[Install Ethereum]]
2. [[Create directory structure]]
3. [[Create accounts with keypairs]](public/private)
4. [[Create a genesis configuration]] with the account details
5. [[Create genesis blocks]] for each node
6. [[Running a Bootnode]]
7. [[Running a miner]]: this is based on the type of consensun algorithm choosen
8. [[Running peer nodes]]
9. Attaching to a node


# Truffle

[[Truffle]] is a world class development environment, testing framework and asset pipeline for blockchains using the Ethereum Virtual Machine (EVM), aiming to make life as a developer easier.


![[Pasted image 20240409220731.png]]


# Related:

---
# Reference

1. dcpdkpòd ^b8d64f
2. kncsnmè
