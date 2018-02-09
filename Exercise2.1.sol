pragma solidity 0.4.19;

//keccak-256

contract Exercise2 {
    uint variable;
    address owner;
    uint time;
    
    event ddd(uint time, uint newstate);
    
    function Exercise2(uint _v) public {
        variable = _v;
        owner = msg.sender;
        time = now;
    }
    
    function increment() public returns (uint) {
        if(owner == msg.sender && now-time>15 seconds){
            variable++;
            time=now;
            ddd(now, variable);
        }
            
        return variable;
    }
}