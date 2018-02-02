pragma solidity 0.4.19;

contract MathFunctions {
    function Add(int x, int y) public pure returns (int){
        return x+y;
    }
    
    function Subtract(int x, int y) public pure returns (int){
        return x-y;
    }
    
    function Multiply(int x, int y) public pure returns (int){
        return x*y;
    }
    
    function Devide(int x, int y) public pure returns (int){
        if(y==0)
            return 0;
            
        return x/y;
    }
    
    function Raise(uint x, uint y) public pure returns (uint){
        return x**y;
    }
    
    function RaiseInt(int x, uint y) public pure returns (int){
        if(x >= 0)
            return int(uint(x)**y);

        int res = int(uint(-x)**y);
        if(y%2==0)
            return res;
            
        return -res;
    }
    
    function GetRemainder(int x, int y) public pure returns (int){
        return x%y;
    }
}