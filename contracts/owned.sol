pragma solidity >=0.4.21;

/**
 * 
 * The Owned contract ensures that only the creator (deployer) of a 
 * contract can perform certain tasks.
 */
contract Owned {
	address public owner;

 	constructor () public {
 		owner = msg.sender;
 	}

 	modifier onlyOwner {

 		require (msg.sender == owner);
 		_;
 	}

 	function transferOwnership (address newOwner) onlyOwner public {
 		owner = newOwner;
 	}
 	
}
