pragma solidity 0.4.19;

contract MathFunctions {
    int number1;
    
    function MathFunctions() public {
        ResetState();
    }
    
    function Add(int number2) public {
        number1 = number1+number2;
    }
    
    function Subtract(int number2) public {
        number1 = number1-number2;
    }
    
    function Multiply(int number2) public {
        number1 = number1*number2;
    }
    
    function Devide(int number2) public {
        if(number2==0)
            return;
            
        number1 = number1/number2;
    }
    
    function Raise(uint number2) public {
        if(number1 >= 0){
            number1 = int(uint(number1)**number2);
            return;
        }

        int res = int(uint(-number1)**number2);
        if(number2%2==0)
            number1 = res;
        else
            number1 = -res;
    }
    
    function RemainderBy(int number2) public {
        number1 = number1%number2;
    }
    
    function ToAbsolute() public {
        if(number1 < 0)
            number1 = -number1;
    }
    
    function GetState() public view returns (int){
        return number1;
    }
    
    function ResetState() public {
        number1 = 0;
    }
}