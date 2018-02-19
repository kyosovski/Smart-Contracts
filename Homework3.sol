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
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
	
	modifier checkState {
        if (now - initialSale > 5 minutes){
			state = States.Open;
		}
        _;
    }
	
	function GetState() public checkState returns(States) {
		return state;
	}
	
	function GetBalance(address addr) public checkState returns(uint) {
		return balances[addr].balance;
	}
	
	function GetCurrentOrPastTokenHolders() public checkState returns(address[]) {
		return currentOrPastTokenHolders;
	}
    
    function buy() public payable checkState {
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
		balances[msg.sender] = TokenHolderBalance({balance: balances[msg.sender].balance+1, everHeldTokens: true});
    }
    
    function transfer(address recv, uint tokens) public checkState {
        require(state == States.Open);
		require(balances[msg.sender].balance >= tokens);
		balances[msg.sender].balance -= tokens;
		balances[recv].balance += tokens;
    }

    function withdraw() public onlyOwner checkState {
		require(state == States.Open);
        require(now - initialSale > 1 years);
        if (this.balance > 0){
            owner.transfer(this.balance);
        }
        assert(this.balance == 0);
    }
}