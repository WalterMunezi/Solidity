// SPDX-License-Identifier: GPL -3
pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage{
    //this will get initialized to 0
    uint256 favouriteNumber;
    //structs are ways to define new types in solidity
    struct People{
        uint256 favouriteNumber;
        string name;
    }
    mapping(string=>uint256) public nameToFavouriteNumber;
    //To make a list of people we create an array
    People[] public people;
    //Function that adds a person to the People array
    function addPerson(uint256 _favouriteNumber,string memory _name) public {
        people.push(People(_favouriteNumber,_name ));
        nameToFavouriteNumber[_name]=_favouriteNumber;
    }
    
    function store(uint256 _favouriteNumber) public{
        favouriteNumber=_favouriteNumber;
    }
    //view key word means that we want to read the state of the blockchain therefore no charges are required for that
    //pure key word perfoms mathematical calculations without saving the state
    function retrieve() public view returns(uint256){
        return favouriteNumber;
    }
}