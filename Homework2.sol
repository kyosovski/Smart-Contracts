pragma solidity 0.4.19;

contract ServiceMarket {
    address private owner;
    uint private prize;
    uint private lastSale;
    uint private lastWithdraw;

    event ServiceIsBought(address indexed customer);
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier waitForNextSale() {
        require(now - lastSale >= 2 minutes);
        _;
        lastSale = now;
    }
    
    modifier oncePerHour() {
        require(now - lastWithdraw >= 1 hours);
        _;
        lastWithdraw = now;
    }

    function ServiceMarket() public {
        owner = msg.sender;
        prize = 1 ether;
        lastSale = 0;
        lastWithdraw = 0;
    }
    
    function buyService() public payable waitForNextSale {
        require(msg.value >= prize);
        if(msg.value > prize){
            uint change = msg.value - prize;
            uint newBalance = this.balance - change;
            msg.sender.transfer(change);
            assert(this.balance == newBalance);
        }
        ServiceIsBought(msg.sender);
    }

    function withdraw(uint money) public onlyOwner oncePerHour {
        require(money <= 5 ether && this.balance >= money);
        uint newBalance = this.balance - money;
        owner.transfer(money);
        assert(this.balance == newBalance);
    }
}