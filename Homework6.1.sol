pragma solidity ^0.4.18;

//this contract is optimized, don't touch it.
contract Ownable {
    address public owner;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

//The objective is to have a contract that has members.
//The members are added by the owner and hold information about their address,
//timestamp of being added to the contract and amount of funds donated.
//Each member can donate to the contract.
//Many anti-patterns have been used to create them.
//Some logical checks have been missed in the implementation.
//Objective: lower the publish/execution gas costs as much as you can and fix the logical checks.

library MemberLib {
    struct Member {
        address adr;
        uint joinedAt;
        uint fundsDonated;
    }
    
    function init(Member storage self, address adr) public {
        require(self.adr == address(0));
        self.adr = adr;
        self.joinedAt = now;
        //self.fundsDonated = 0;
    }
    
    function donated(Member storage self, uint value) public {
        require(value > 0);
        self.fundsDonated += value;
        assert(self.fundsDonated>=value);
    }
}

contract Membered is Ownable{
    using MemberLib for MemberLib.Member;
    
    mapping(address => MemberLib.Member) members;
    
    modifier onlyMember {
        require(members[msg.sender].adr == msg.sender);
        _;
    }
    
    function addMember(address adr) public onlyOwner {
        members[adr].init(adr);
    }
    
    function donate() public onlyMember payable {
        members[msg.sender].donated(msg.value);
    }
}