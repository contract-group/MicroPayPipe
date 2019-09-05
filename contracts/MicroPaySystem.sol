pragma solidity >=0.4.21;


import "./owned.sol";
import "./safemath.sol";
import "./TCoinToken.sol";

/**
 * The MicroPaySystem contract does this and that...
 */
contract MicroPaySystem is owned{

  struct MinerPool {
	uint32	ID;
	uint8	poolType;
	address	mainAddr;
	address	payer;
	bytes32	subAddr;
	uint 	guaranteedNo;
	string	shortName;
	string 	detailInfos;		
  }

  struct Channel {
	address mainAddr;
	address	payerAddr;
	uint 	remindTokens;
	uint 	remindPackets;
	uint256	expiration;	
  }

  using SafeMath for uint256;

  uint public PacketPrice = 16000000; //(16MB Bytes) /-->/1M=1000KB = 1,000,000 Bytes;

  uint public MinPoolCostInToken;
  uint public MinMinerCostInToken;
  uint public TokenDecimals;
  uint public Duration = 30 days;
	
  TCoinToken public token;

  mapping (address => MinerPool) public MinerPools;
  address[] public MinerPoolsAddresses;

  mapping (address => mapping (address => Channel)) public MicroPaymentChannels;

  mapping (address => address[])public allSubPools;
	
	
  /**************************************************************************
   * Basic
   **************************************************************************/
	

  /**
   *
   *
   */
  function myFunction () returns(bool res) internal {
			
  }
			

}
