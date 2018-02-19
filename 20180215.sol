pragma solidity ^0.4.19;

contract Test1 {
    address private owner = msg.sender;
    
    enum State {Locked,Unlocked,Restricted}
    
    struct Info{
        uint counter;
        uint timespan;
        address addr;
    }
    
    Info public info;
    State public state;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier checkState() {
        require(state != State.Locked);
        require(owner == msg.sender || state != State.Restricted);
        _;
    }
    
    function() public checkState {
    }
    
    function ChangeState(State _state) public onlyOwner{
        state = _state;
    }
    
    function Increment() public checkState {
        info = Info({counter:info.counter+1, timespan:now, addr:msg.sender});
    }
}

contract Test2 {
    address private owner = msg.sender;
    
    enum State {Locked,Unlocked,Restricted}
    
    struct Info{
        uint counter;
        uint timespan;
        address addr;
    }
    
    Info public info;
    State public state;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier checkState() {
        require(state != State.Locked);
        require(owner == msg.sender || state != State.Restricted);
        _;
    }
    
    function() public checkState {
    }
    
    function ChangeState(State _state) public onlyOwner{
        state = _state;
    }
    
    function Increment() public checkState {
        info = Info({counter:info.counter+1, timespan:now, addr:msg.sender});
    }
}

contract PokemonGame {
    address private owner = msg.sender;
    
    enum PokemonType {P1,P2,P3,P4,P5,P6,P7,P8,P9,P10}
    
    struct Info{
        PokemonType[] pokemons;
        uint lastTime;
    }
    
    mapping(address=>Info) public info;
    mapping(uint=>address[]) public pokemonOwners;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function catchPokemon(PokemonType pokemon) public {
        require(now - info[msg.sender].lastTime > 10 seconds);
        bool found = false;
        for(uint i=0;i<10;i++){
            if(info[msg.sender].pokemons[i]==pokemon){
                found = true;
                break;
            }
        }
        if(!found){
            info[msg.sender].pokemons.push(pokemon);
        }
        info[msg.sender].lastTime = now;
        pokemonOwners[uint(pokemon)].push(msg.sender);
    }
    
    function getPokemons(address person) public view returns(PokemonType[]) {
        return info[person].pokemons;
    }
    
    function getPokemonOwner(PokemonType pokemon) public view returns(address[]) {
        return pokemonOwners[uint(pokemon)];
    }
}