//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2; //versione di solidity

  //0xd9145CCE52D386f254917e481eB44e9943F39138 ->hash contratto

contract SimpleStorage{ //object
    //Types: Boolean, Uint, Int, Address, Bytes
    //bool hasFavoriteNumber=false;
    //uint256 favoriteNumber= 5;
    //string favoriteNumberInText="Five";
    //int favoriteNumberINt=-5;
    //address myAddress=0xadfc57D26951b2dB05dB5DDf54e2861B50A1d8a8;
    //bytes32 favoriteBytes= "cat";
    uint256 public favoriteNumber; //this get initialized to zero

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public{
        favoriteNumber=_favoriteNumber; //variable are initialized to internal if it's not specified
    }
    
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }


  
}
