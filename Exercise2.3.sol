pragma solidity 0.4.19;

contract Faucet {
    address private owner;
    uint private sendAmount;
    
    event Withdrawn(address indexed recvAddress, uint withdrawnMoney, uint remainingBalance);
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier checkBalance(uint money) {
        require(this.balance >= money);
        _;
    }

    function Faucet() public {
        owner = msg.sender;
        sendAmount = 1 ether;
    }
    
    function() public payable {//fallback method
    }
    
    function getBalance() public view returns(uint) {
        return this.balance;
    }
    
    function changeAmount(uint newAmount) public onlyOwner {
        sendAmount = newAmount;
    }
    
    function withDraw() public checkBalance(sendAmount) {
        //require(this.balance >= sendAmount);
        uint balanceBeforeTransfer = this.balance;
        msg.sender.transfer(sendAmount);
        uint remainingBalance = balanceBeforeTransfer - sendAmount;
        assert(this.balance == remainingBalance);
        Withdrawn(msg.sender, sendAmount, remainingBalance);
    }
    
    // The "money" parameter should be passed as a string: "10000000000000000000" (= 10 ether)
    function withDraw(uint money) public onlyOwner checkBalance(money) {
        //require(this.balance >= money);
        uint balanceBeforeTransfer = this.balance;
        owner.transfer(money);
        uint remainingBalance = balanceBeforeTransfer - money;
        assert(this.balance == remainingBalance);
        Withdrawn(owner, money, remainingBalance);
    }
    
    function send(address recvAddress) public checkBalance(sendAmount) {
        //require(this.balance >= sendAmount);
        uint balanceBeforeTransfer = this.balance;
        recvAddress.transfer(sendAmount);
        assert(this.balance == balanceBeforeTransfer - sendAmount);
    }
    
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}