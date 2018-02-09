pragma solidity 0.4.19;

//keccak-256
//out of gas exception


contract Exercise2 {
    address owner;
    
    event ownerchanged(address indexed oldowner, address indexed newowner);
    
    modifyer onlyOwner{
        require(msg.owner == owner);
        _;
    }
    
    function Exercise2() public {
        owner = msg.sender;
    }
    
    function change(address newowner) public {
        if(owner == msg.sender){
            address old = owner;
            owner = newowner;
            ownerchanged(old, owner);
        }
    }
    
    function change2(address newowner) public onlyOwner {
        address old = owner;
        owner = newowner;
        ownerchanged(old, owner);
    }
}