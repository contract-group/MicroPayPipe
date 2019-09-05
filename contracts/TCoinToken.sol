pragma solidity >=0.4.24;

import "./ERC20.sol";

/**
 * The TCoinToken contract does this and that...
 */
contract TCoinToken is ERC20{
  string public constant 	name = "TCoin Token";
  string public constant 	symbol = "TCT";

  uint8 public constant		decimals = 18;
  uint256 public constant	INITIAL_SUPPLY = 4.2e8 * (10**uint256(decimals));


  constructor() public{
  	_mint(msg.sender,INITIAL_SUPPLY);
  }

  function getDeccimal () public pure returns (uint){
  	return 10 ** uint256(decimals);
  }
  
}


