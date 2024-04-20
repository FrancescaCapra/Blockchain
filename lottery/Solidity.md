---
tags:
  - blockchain
date: " 2024-04-07"
up: "[[Smart contract dev]]"
status: "#idea"
---
# Solidity

- strongly typed 
- similar to javascript
- several *gotchas*

When a contract is written, solidity writes the **contract definition**.  However, the solodity code is not direclty read in the ethereum network. The **contract definition** is compiled by a **solidity  compiler**, which creates two files: The **byte code** that is deployed in the network, and the **ABI** that serves to write application that can interact with our contract


![[Pasted image 20240407221857.png]]

![[Pasted image 20240407222209.png]]

# Contract Structure

Let's explain the structure of a contract with an example:

![[Pasted image 20240408203438.png]]


The keyword `contract` initializes a `class`, that in our case is named as `Inbox`.
The following line of code works as **class's property**: we have defined a storage variable called `message`. In solidity, we have also to specify the **type** of data that are going to be stored (in this case string), and how data are going to be accessed, in this case pubblic

As this can be seen as a class, the first function is the respective **constructor function**, as its name is equal to the **contract's names**

Second and third functions are not constructur but insted the will be called in the contract

In solidity, **function declaration** follows the following syntax
![[Pasted image 20240408204213.png]]


When declaring a function, it can be assigned with only one **type**. The most common type of function type are the followings:

![[Pasted image 20240408204444.png]]


with type `public` anyone in the network can call the function in the contract, whereas with `private` only the contract can call the function in the contract. However, both types do not add any security level.

During function declaration we can specify wether or not it can modify any of the contract data. In the case of `setMessage()`, the function accept a parameter that can modify the data in the contract. ==A function that modifies the value of a data in the contract  won't be able to return any data==.

`view` and `constat` means the same thing. If added to a function, it won't modify any data but it will return some specified data. In this case, `returns` keyword must be used: it specifies the ==type== of data that the function will return. It is used only when on `view` or `constat` function decladation.

If a function is declared as `pure`, it won't modify or view any data in the contract.
If a function is declared as `payable`,  when some outside source attemps to call it in the contract, this will cost some money.


# Functions

From the information discussed in the [[Ethereum#^19d4ca|Ethureum section]], it's evident that functions are influenced by whether they modify data on the blockchain. In our context, only the `setMessage` function necessitates a transaction for data modification.

![[Pasted image 20240408214856.png]]

This aspect affacts the way we call the two types of function and how they will behave.

The first method of invoking a function is by simply **calling** it. In this scenario, the function is _unable to alter the contract's data_; rather, it can only _return_ data. Since no changes are involved, no transaction is required, consequently avoiding the need for block mining. This results in a **fast operation** that is **cost-free**.

Whenever we intend to invoke a function that alters contract data, we must do so by ==sending a transaction to the specific function within the contract instance==. This enables the modification of contract data. However, as this process entails transactions and mining, it requires time for processing and incurs costs. When sending a transaction to a function, it returns the **transaction hash** rather than a direct **value back**. For instance, if a return message is included within `setMessage()`, it won't be effective in returning a value.


![[Pasted image 20240408215049.png]]

# Variable
Variables are declared by the following order:

`type` + `visibility` + `arbitrary name`
## Solidity Value Types

Whenever we declare a variable, it is imperative to specify its **data type**. For instance, in the initial version of the [[#Contract Structure|smart contract]], the variable `message` was initialized with the `string` data type.

Solidity provides distinct data **types** tailored for particular scenarios. For instance, the `address` data type is designated for variables intended to store addresses.

Below, we can see the **basi types** in solidity:

![[Pasted image 20240409223342.png]]

The number after `int` specifies the number of bits that are used to store a numebr, and this specifies how large a number can be when stored in a variable. The default size is `int256`.
![[Pasted image 20240409223737.png]]

All these rules also applies in `uint`.

![[Pasted image 20240409224010.png]]
Why is this important? because the larger is the value we store, the more we are going to pay. We pay for storage!

## Address
`address` are kind of special variable, can be seen as objects that allow us to perform some operations.

It stores an `hash` on which we can call different methods to work with:
- `address.transfer(qnt type)`: is a method that allows us to transfer some amount of money to the `address`. 
	- `qnt`: the amount of money to be transfered. To reference to the current balance of the contract, just use `this.balance`
- 


## Solidity visibility
A variable can be declared with either `public` or `private` visibility. However, it's important to note that the visibility type itself does not inherently enforce security measures. Rather, the decision often revolves around determining whether the variable should be readily accessible or kept more restricted.

## Global Variable

Remember that any time we want to create an instance of the smart contract, we create by our account a transaction that we sent to the network.

The **global variable** is reffered to be the ==message object==. This object has some properties on it that describes who sent the transaction to the network and details of the transaction.

>[!hint] Nota bene
>The ==msg object== is not available only when a smart contract is created, but also with any function invocation. 

![[Pasted image 20240409225356.png]]
![[Pasted image 20240409230611.png]]
The **msg object** encompasses several properties, among which are:
- `msg.data`: As demonstrated in [[Smart contract dev#Deployment of a smart contract| deployment of a smart contract]], each transaction directed towards the contract carries accompanying data.
	- During instance creation, this data typically consists of the bytecode.
	- In the context of function invocation or transfer, the data pertains to the arguments being transmitted to the respective function.
- `msg.gas`: this property defines the amount of gas available to run some code
- `msg.sender`: this property contains the address of the sender
- `msg.values`: this property cointains the value of money that a transaction included if any
![[Pasted image 20240409225329.png]]

## Solidity Reference types 

**Reference types** are data types that store a reference or address to a memory location rather than the actual data itself. This means that when manipulating a value of a reference type, you're actually manipulating the memory address that points to the data, rather than the data itself. 

In solidity, there are the following **reference types**:
- `fixed array`: it is an array that cointains a ==single type== of element and ==cannot== ever change its length
- `dinamic array`: it is an array that cointains a ==single type== of element and ==can== change its length
- `mapping`: collection of key value pairs (like dictionary). All key must be of the same type, and all values must be of the same type.
- `struct`:  collection of key value pairs (like dictionary).

An array is created by first specifying the [[#Solidity Value Types| value type]] of the element we want to store, followed by square brackets []. If the array is going to be of fixed size, we specify the length inside the square brackets [].

Arrays are zero indexed and to retrive an element in some position (eg.1), we use the syntex `array[1]`.

Mapping is defined by the syntax `mapping(key => value)` and by specifing the value type (==must be the same==) of key/value pair. We typically use this data structure to store a **collection of things** (eg. collection of cars)

Struct is defined by the syntax `struct{}`. We tipically use this data structure to represent a **singular thing** (eg. a car).

![[Pasted image 20240409231528.png]]
### How do I access to the length of an array?

1. use `.length` attribute
```R
...
function pushMyarray() public{
	 Myarray.push(1)

}
```


### How do I push an element in a array?

1. use `push()` function
```R
...
function pushMyarray() public{
	 Myarray.push(1)

}
```

### How do I retrive and entire array?

1. use keywords `views` and `returns`
2. specify the value of the array
```R
...
function getMyarray() public view returns(unit[]){
	return Myarray

}
```

### Nested dynamic arrays problem

In Solidity, creating **nested dynamic arrays** poses no issues. However, in the [[JavaScript]] realm, their usage is not supported due to the bridge between them.
![[Pasted image 20240409234305.png]]

`string` in solidity are managed by solidity as it was a **dinamic arrays**. This means that we cannot transfer **array of string** in javascript world.

# Require()

The `require` function in Solidity acts as a **validation function**. It accepts a boolean expression as an argument. If the result of the expression is false, the entire function execution is immediately halted. However, if the expression evaluates to true, the function continues executing as usual.

```R
require(msg.value > .01 ether)
```

Next to the value .01 we can specify the size of the currency (like wei, ....)

# Function Modifier
A `modifier` is a special type of function that you use to modify the behavior of other functions. Modifiers allow you to add ==extra conditions== or functionality to a function without having to rewrite the entire function.

```R
modifier onlyManager():
	reqiures(msg.sender == manager);
	_;
```

The `_;` symbol is a special symbol that is used in Solidity modifiers to indicate the end of the modifier and the beginning of the function that the modifier is modifying.

In this example, the `onlyManager` modifier has no parameters and includes a `require` statement that checks that the message sender is the contract owner. If the message sender is the contract owner, the function will be executed. If the message sender is not the contract owner, the function will not execute.

To use a `modifier`, attach it to a function by ==placing it== in the function definition. For example:

```R
function changeOwner(address newOwner) onlyOwner public {
    // function body
}
```

In this example, the `changeOwner` function has the `onlyOwner` modifier attached to it. This means that in order to execute the `changeOwner` function, the caller must be the contract owner.

# Block info
Solidity allow us to access some block data:
- `block.difficulty`: global variable, access the current difficulty for mining a bloc
# This
When `this.` is used, it referes to the ==contract's instance==
# Convert
- `uint()`: converts the arguments into an unit value

# Reset Contract state

Use `variable = new type `

```R
function enter() public payable {
        require(msg.value > 2 ether);
        players.push(msg.sender) ;

		// reset a dinamic array with a zero size d.array
        players = new address[](0);

    }
```
# Gotcha
- Whenever we define a storage variable with the keyword **public**, the smart contract automatically create a new function (with the same name of the storage variable) that retrives the value of the variable itselfe if called 
- In test network, transaction instantly process a transaction. Whereas, in real network transaction takes 15 second in average.
- When an `array` variable is declared as `public` at the beginning of the contract, the automatically generated function won't retrieve the entire array. Instead, it will only accept the index and then the element corresponding to that index. Consequently, we are required to work with individual elements rather than the entire array.
- to reference to a function inside the contract, `this` is not necessary
# Related:
- [[Lottery Contract]]
---
# Reference

1. dcpdkpòd ^b8d64f
2. kncsnmè
