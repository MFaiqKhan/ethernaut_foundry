# Ethernaut Examples and its scripts: with explaination:

## 1. Level 1: The FallBack:
In this level, we have to get ownership and empty the contract ,
so we can get the flag.

there is a receive function specify in the contract, which have require statement stating that value send to the contract through sendTransaction(window object in ethereum to send transaction to contract) directly and value should be greater than 0 and you should already be a contributor to the contract , so first we actually contribute to the contract through calling contribute function than we call the receive function with value greater than 0, that will give ownership to us and we can withdraw the onlyOwner function and drain the contract and get the flag.

## 2. Level 2: Fallout:

In this level, we have to get ownership and empty the contract , its a 0.6.0 version of solidity, and have old school constructor function, like 
```solidity
function fallout() public payable {
    owner = msg.sender;
    allocations[msg.sender] = msg.value;
}
```
so the above contract is named as fallout and constructor also have the same name plus it is the first function in the  
contract (old school constructor function), so we can call the constructor function by calling the fallout function and we can get ownership and empty the contract and get the flag.
But there is a problwm with this contract and it is that , the name of the constructor function is not same as the contract name, so it is just a function and not a constructor function, and anybody can call this function and get ownership and empty the contract and get the flag, so we can call this function from any other contract and get the flag.
So constructor was named __fal1out__ and contract was named __fallout__, it wasn't a constructor function, it was just a function, so we can call this function from any other contract and get the flag.

## 3. Level 3: Coin Flip:

The problem is here is of "Randomness",  Factor variable inside the contract is already an issue as it is fixed.
you cant know the blockhash of the next block, so you cant predict the result of the coin flip, thats why we have minus 1 , to get the previous blockhash. So its a onChain Randomness is very hard to predict,  In ethereum every thing is deterministic state transistion, every thing is determined for next move.
We will make an attacker Contract, which will first call the flip function in its own contract than take the result of the coin flip and call the flip function in the target contract with the same result, so we can win the game and get the flag.

## 4. Level 4: Telephone:

we have to change thw owner, here tx.origin shouldn't be equal to owner and only then we can change the owner.
tx.origin will only be account address, on the other hand msg.sender can also be a contract address. 



