pragma solidity >=0.4.21;


import "./Owned.sol";
import "./SafeMath.sol";
import "./TCoinToken.sol";

/**
 * The MicroPaySystem contract does this and that...
 */
contract MicroPaySystem is Owned{

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
   * @dev Changed BandWidth Price
   * @param newPrice uint changed the traffic price
   */
  function ChangeBandWidthPrice(uint newPrice) public onlyOwner{
	PacketPrice = newPrice;	
  }

  /**
   * @dev 	Changed join MinPoolCostInToken
   * @param newCost uint
   */
  function ChangeMinPoolCost(uint newCost)public onlyOwner{
  	MinPoolCostInToken = newCost;
  }

  function ChangeMinMinerCost(uint newCost) public onlyOwner {
  	MinMinerCostInToken = newCost;
  }

  function ChangeDuration(uint daysAfter) public onlyOwner {
  	Duration = daysAfter * 1 days;
  }

  constructor(address ta )public {
  	token = TCoinToken(ta);

  	TokenDecimals = token.getDeccimal();

  	MinPoolCostInToken = 51200 * TokenDecimals;
  	MinMinerCostInToken = 512 * TokenDecimals;
  }

  /*********************************************************************
   *					User
   *********************************************************************/
  function BuyPacket(address user,uint tokenNo,address poolAddr) public{
  	require(token.balanceOf(msg.sender) > tokenNo);
  	MinerPool memory pool = MinerPools[poolAddr];
  	require(pool.mainAddr != address(0));

  	token.transferFrom(msg.sender,address(this),tokenNo);
  	uint newPackets = tokenNo.div(TokenDecimals).mul(PacketPrice);

  	Channel storage ch = MicroPaymentChannels[user][pool.mainAddr];
  	ch.mainAddr = user;
  	ch.payerAddr = msg.sender;
  	ch.remindPackets += newPackets;
  	ch.remindTokens += tokenNo;
  	ch.expiration = now + Duration;

  	allSubPools[user].push(pool.mainAddr);
  }

  /**
   * @dev Query User address Balance tokens
   * @param userAddress address 
   * 
   */
  function TokenBalance(address userAddress) public view returns (uint,uint){
  	return (token.balanceOf(userAddress),userAddress.balance);
  }
  /**
   * @dev user join miner pool address
   * @param userAddress address 
   *
   */
  function AllMySubPools(address userAddress)public view returns(address[] memory){
  	return allSubPools[userAddress];
  }

  /***********************************************************************************
   * 								Pool
   ***********************************************************************************/
  function RegAsMinerPool(uint gno,address mainAddr,bytes32 subAddr,
  	string memory name,string memory desc) public {
  	require(gno > MinPoolCostInToken);
  	require(token.balanceOf(msg.sender) > gno);

  	MinerPool storage pool = MinerPools[mainAddr];
  	require(pool.mainAddr == address(0));

  	token.transferFrom(msg.sender,address(this),gno);

  	pool.ID = uint32(MinerPoolsAddresses.length);
  	MinerPoolsAddresses.push(mainAddr);

  	pool.mainAddr = mainAddr;
  	pool.payer = msg.sender;
  	pool.subAddr = subAddr;
  	pool.guaranteedNo = gno;
  	pool.poolType = 0;
  	pool.shortName = name;
  	pool.detailInfos = desc;
  }

  /**
   * @dev Set Mining Pool Type
   * @param mainAddr address 
   * @param typ uint8 
   */
  function SetPoolType(address mainAddr,uint8 typ) public onlyOwner{
  	MinerPool storage pool = MinerPools[mainAddr];
  	require(pool.mainAddr != address(0));
  	pool.poolType = typ;
  }

  /**
   * @dev Get Mining Pool Size
   */
  function GetPoolSize()public view returns (uint){
  	return MinerPoolsAddresses.length;
  }

  function GetPoolAddress()public view returns(address[] memory){
  	return MinerPoolsAddresses;
  }

  /**
   * @dev changed Miner Pool infomation
   * @param mainAddr address miner pool address
   * @param name string  miner pool name
   * @param desc string  miner description
   */
  function ChangePoolSettings(address mainAddr,string memory name,string memory desc) public{
  	MinerPool storage pool = MinerPools[mainAddr];

  	require(pool.mainAddr == msg.sender || pool.payer == msg.sender);

  	if(bytes(name).length != 0) {
  	  pool.shortName = name;
  	}

  	if(bytes(desc).length != 0) {
  	  pool.detailInfos = desc;
  	}
  }

  /*********************************************************************************
   * 		Miner
   *********************************************************************************/

}
