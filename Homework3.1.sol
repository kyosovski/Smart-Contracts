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
    address[] private currentOrPastTokenHolders;
    
    event TokensAreBought(address indexed person, uint time, uint tokens);
    event TokensAreTransfered(address indexed from, address indexed to, uint time, uint tokens);
    event MoneyAreWithdrawn(address indexed from, uint time, uint amount);
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier checkState {
        if (state == States.Crowdsale && now - initialSale > 5 minutes){
            state = States.Open;
        }
        _;
    }
    
    function GetState() public checkState returns(States) {
        return state;
    }
    
    function GetBalance(address person) public view returns(uint) {
        return balances[person].balance;
    }
    
    function GetCurrentOrPastTokenHolders() public view returns(address[]) {
        return currentOrPastTokenHolders;
    }
    
    function buyOneToken() public payable checkState {
        require(state == States.Crowdsale);
        require(msg.value >= tokenPrize);
        if (msg.value > tokenPrize){
            uint change = msg.value - tokenPrize;
            uint newBalance = this.balance - change;
            msg.sender.transfer(change);
            assert(this.balance == newBalance);
        }
        if(balances[msg.sender].everHeldTokens == false){
            currentOrPastTokenHolders.push(msg.sender);
        }	
        balances[msg.sender] = TokenHolderBalance({balance: balances[msg.sender].balance + 1, everHeldTokens: true});
        TokensAreBought(msg.sender, now, 1);
    }
    
    function buy(uint tokens) public payable checkState {
        require(tokens > 0);
        require(state == States.Crowdsale);
        require(msg.value >= tokens * tokenPrize);
        if (msg.value > tokens * tokenPrize){
            uint change = msg.value - (tokens * tokenPrize);
            uint newBalance = this.balance - change;
            msg.sender.transfer(change);
            assert(this.balance == newBalance);
        }
        if(balances[msg.sender].everHeldTokens == false){
            currentOrPastTokenHolders.push(msg.sender);
        }	
        balances[msg.sender] = TokenHolderBalance({balance: balances[msg.sender].balance + tokens, everHeldTokens: true});
        TokensAreBought(msg.sender, now, tokens);
    }
    
    function transfer(address recv, uint tokens) public checkState {
        require(tokens > 0);
        require(state == States.Open);
        require(balances[msg.sender].balance >= tokens);
        balances[msg.sender].balance -= tokens;
        balances[recv].balance += tokens;
        TokensAreTransfered(msg.sender, recv, now, tokens);
    }
    
    function withdraw() public onlyOwner checkState {
        require(state == States.Open);
        require(now - initialSale > 1 years);
        uint amount = this.balance;
        if (this.balance > 0){
            owner.transfer(this.balance);
        }
        assert(this.balance == 0);
        MoneyAreWithdrawn(owner, now, amount);
    }
}