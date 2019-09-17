pragma solidity >=0.4.19 <0.7.0;

/**
 * The safemath library does safty calc
 */
library safemath {

  function add(uint256 a,uint256 b )
  internal pure returns(uint256){
  	uint256 c = a + b;
  	require(c >= a);

  	return c;
  }

  function sub(uint256 a,uint256 b)
  internal pure returns(uint256){
  	require(b <= a);
  	uint256 c = a - b;

  	return c;
  }

  function mul(uint256 a, uint256 b) 
  	internal pure returns(uint256){
  	if(a == 0){
  		return 0;
  	}
  	uint256 c = a * b;
  	require (c / b == a);
  	
  	return c;
  }
  
  function div(uint256 a,uint256 b) 
  internal pure returns(uint256 ){
  	require(b > 0);
  	uint256 c = a / b;

  	return c;
  }

  function mod(uint256 a,uint256 b)
  internal pure returns(uint256){
  	require (b != 0);

  	return a % b;
  }

}
