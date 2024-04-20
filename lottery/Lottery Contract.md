---
tags:
  - blockchain
date: " 2024-04-09"
up: "[[Solidity]]"
status: "#idea"
---
# Lottery Contract

We are going to write a lottery contract. It will contain:
- `players`: the list of players that joined the lottery
- `prize pool`: the amoun of ether collected by the contract when the players joined

Players are recorded when they send money to the contract
![[Pasted image 20240409221849.png]]



At some point, a third party (like a manager), will call the contract to pick a winner. The manager just calls the contract, whereas is the contract to pick the winner from a player within the list of players

![[Pasted image 20240409222229.png]]
At some point, a third party (like a manager), will call the contract to pick a winner. The manager just calls the contract, whereas is the contract to pick the winner from a player within the list of players.

![[Pasted image 20240409222330.png]].
After money are sent to the winner, the contract will empty and start a new lottery game. 

# Design

The basic idea involes two `variables` and `functions`.
For the variables:
- `manager`: it is a storage variable that contains the address of the person who created the contract. It will be the only one able to call the function `pickWinner`
	- **type**: `address`
- `players`: array of addresses of persons that have sent money to the contract
	- **type**: `dinamic array of address`

For the functions:
- `enter`: the function to allow person to send money to the contract in order to join the lottery
- `pickWinner`: function that randomly pick a winner from the `player` array and send money to him/her

![[Pasted image 20240409222547.png]]

# Workflow

## Manager variable and Constructor 

1. Declare the variable `manager` as type `address`, and make it accessible to everyone (`public`). This variable will store an address.

2. To set `manager` to the address of the individual deploying the contract, create the **constructor function**. Inside it, assign `msg.sender` to `manager`. This action will fetch and then assign the creator's address. ([[Solidity#Global Variable|see more]])

```solidity
pragma solidity 0.4.17;

  

contract Lottery{
    address public  manager;
    // how do we set the value of manager to the address who created the contract?
    // by using the constractor function

    function Lottery() public{
        manager = msg.sender; // Contains the sender's address for the deployment transaction.

         }

}

```

## Player variable

1. Declare the variable `playes` as a `dinamic array of address`, and make it accessible to everyone (`public`). This variable will store list of addresses.

## Enter function

1. Define the type of the function as `payable` because it expects to recieve some ether (the player must send some ether for joining). ([[Solidity#Functions|see more]])
2. Push the address inside the dinamic array by using `msg.sender`

```R
 function enter() public payable {
        players.push(msg.sender) ;
    }
```

## Pick winner Funtion


## Validation with require statemet

1. Use [[Solidity#Require()|require()]] function
2. Use the `msg.value` to define the boolean function

```R
function enter() public payable { 
        require(msg.value > .01 ether)
        players.push(msg.sender) ;

    }
```

The goal of this function is to ==randomly== pick a player out of the list of players. With solodity, ==we do not get== access to a random generator... we have to define a **pseudo-random generator**:

### Generate a random number

![[Pasted image 20240416000500.png]]
We utilize the following inputs:

1. **Current block difficulty**: representing the time required for mining and validating a block.
2. **Transaction timestamp**: indicating the current time for selecting a winner.
3. **players's addresses**: denoting the addresses of participating players. 

These three elements are processed through the SHA algorithm to generate a unique number. Instead of embedding this function within `pick_winner()`, it's defined externally, allowing flexible access. As it serves an internal purpose, we designate it as `private` to restrict external visibility. Also, we designate it as `view return (unit)` as we want to return the generated pseudo number (with no specific sign).

- `sha3()`: a global function that hashes the passed arguments
- `block.difficulty`: global variable, access the current difficulty for mining a block
- `now`: the current time
- `player`: the array containing the addresses of players

Has the final goal is to return an integer, and as the `sha3()` outputs an hexidecimal number, we can convert it by using the function `uint``

```R
 function random() private view returns (uint){
        return unit(sha3(block.difficulty, now, palyers));
    }
}
```

### Pick a random winner
Once we have created the random function, we have a pseudo-random and very big number. It will be used to pick a player, but how?

![[Pasted image 20240416002225.png]]
1. call the **random function**: remeber, to reference to a function inside the contract `this` is not necessary
2. **modulo operator**: returns the reminder of a division
3. **player.length**: return the `length` of the player array

The value will always be between 0 and $length -1$.

```R
function pick_winner() public{
		uint index = random()%players.length; # create a local variable to store the index
       player[index];
    }
```

Now we can access the address of the winner by indexing the `player` array `player[index]`. 

### Transfer money to the winner
The winner should receive all the money collected within the lottery. In this case, we can use the method `.transfer()` applyed onto the `address` of the winner (for more clarifications, please see [[Solidity#Address|Address]]). Also, the winner should recive the montepremi. This is done by calling `this.balance` as parameter of the method 


```R
function pick_winner() public{
		uint index = random()%players.length; 
        player[index].transfer(this.balance);
    }
```

## Reset the contract
Last feature that we might be interested to add is the possibility to run automatically a new lottery after the winner has  been choosen.

![[Pasted image 20240416004803.png]]
When a contract is first created, the `players array` is empty. Thus, when pick a winner, we must ==re-set the state of the contract==, which in this case consist in empty out the `player` array.

`new address[](0)` creates a **dinamic array**. The `()` specifies that we want to create a new dinamic array with **size** = 0. So, it handles the new size of the array.
```R
function pick_winner() public{
        uint index = random() % players.length;
		players[index].transfer(this.balance);
		
        players = new address[](0);

    }
```

If we had specified `(5)` instead of 0, the array would have been re-created with 5 address, each of hex value `0x0000...`.

## Issue with pick winner function
Untill now, anyone can call the `pick_winner` function. From the statement of the project, only the `manager` should be able to end the lottery and pick each time the winner.

Just use a `require()` statement checking if the `address` of the sender corresponds to the `manager` address:

```R
function pick_winner() public{

		// check if manager
        require(msg.sender == manager);
        
        uint index = random() % players.length;
        players[index].transfer(this.balance);

    }
```

We could achieve the same functionality by using a [[Solidity#Function Modifier|modifier]].

```R
function pick_winner() onlyOwner public{
        uint index = random() % players.length;
        players[index].transfer(this.balance);
        players = new address[](0);

    }

modifier onlyOwner(){
        require(msg.sender == manager);
        _;
    }
```


# Related:

---
# Reference

1. dcpdkpòd ^b8d64f
2. kncsnmè
