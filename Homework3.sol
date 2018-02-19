pragma solidity ^0.4.19;

contract BalancesContract {
    enum States { Crowdsale, Open }
    
    struct TokenHolderBalance {
        uint balance;
        bool everHeldTokens;
    }
    
    address private owner = msg.sender;
    uint private initialSale = now;
    uint private tokenPrize = 1 ether / 5;
    States private state = States.Crowdsale;
    mapping(address => TokenHolderBalance) private balances;
    address[] public currentOrPastTokenHolders;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    //function update(uint newBalance) public {
    //    balances[msg.sender] = newBalance;
    //}
    
    function buy() public payable {
        require(state == States.Crowdsale);
        if (now - initialSale > 5 minutes){
            state = States.Open;
        }
        else {
            require(msg.value >= tokenPrize);
            if(msg.value > tokenPrize){
                uint change = msg.value - tokenPrize;
                uint newBalance = this.balance - change;
                msg.sender.transfer(change);
                assert(this.balance == newBalance);
                
                if(balances[msg.sender].everHeldTokens == false){
                    currentOrPastTokenHolders.push(msg.sender);
                }
                
                balances[msg.sender] = TokenHolderBalance({balance: balances[msg.sender].balance+1, everHeldTokens: true});
            }
        }
    }
    
    //function transfer() public {
    //    require(state == States.Open);
    //}

    function withdraw() public onlyOwner {
        require(now - initialSale > 1 years);
        if (this.balance > 0){
            owner.transfer(this.balance);
        }
        assert(this.balance == 0);
    }
}