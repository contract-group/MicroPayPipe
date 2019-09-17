pragma solidity >=0.4.19 <0.7.0;


import "../interface/IERC20.sol";
import "../lib/safemath.sol";

/**
 * The CountachToken is IERC20 contract 
 */
contract CountachToken is IERC20 {

	string 	public constant name 			= "Countach Tsai Token";
	string 	public constant symbol 		= "CT";
	uint8 	public constant decimals 	= 18;
	uint256	public constant	INITIAL_SUPPLY = 1024e6 * (10 ** uint256(decimals));

	using safemath for uint256;

	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowed;	
	
	uint256 private _totalSupply;

	constructor()public{
		_mint(msg.sender,INITIAL_SUPPLY);
	}

	/**
	 * @dev Get Token decimals uints
	 * 
	 */
	function getDecimal()public pure returns(uint){
		return 10 ** uint256(decimals);
	}

	/**
	 * @dev The CT Total supply amount
	 */
	function totalSupply ()
		public view returns(uint256) {
		return _totalSupply;
	}

	/**
	 * @dev Get the Balance of the specified address
	 * @param owner The address your will query balance of.
	 * @return An uint256 value ,web3 need use bignumber handle.
	 */
	function balanceOf(address owner) 
		public view returns(uint256){

		return _balances[owner];
	}

	/**
	 * @dev Transfer tokens to a specified account
	 * @param to The Receiving account
	 * @param value The amount will transfer
	 * @return the transfer is success
	 */
	function transfer(address to,uint256 value) public returns(bool){

		require (value <= _balances[msg.sender]);
		require (to != address(0));

		_balances[msg.sender] = _balances[msg.sender].sub(value);
		_balances[to] = _balances[to].add(value);
		emit Transfer(msg.sender,to,value);

		return true;
	}

	/**
	 * @dev Transfer tokens from one account to another account
	 * @param from The Transfer out account address
	 * @param to The Receiving account address ,can't 0 address
	 * @return transfer result is bool and emit event Transfer
	 */
	function transferFrom(address from,address to,uint256 value)
	public returns(bool){
		require(value <= _balances[from]);
		require(value <= _allowed[from][msg.sender]);

		require(to != address(0));

		_balances[from] = _balances[from].sub(value);
		_balances[to] = _balances[to].add(value);
		_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

		emit Transfer(from,to,value);

		return true;
	}

	/**
	 * @dev check the amount of tokens that an owner aloowed to a spender.
	 * @param owner The owner account address
	 * @param spender The spender account address 
	 * @return A amount which The spender account spend funds.
	 */
	function allowance(address owner,address spender) 
	public view returns(uint256){
		return _allowed[owner][spender];
	}

	/**
	 * @dev Approve the passed address to spend the specified amount tokens on behalf of msg.sender
	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
	 * @param spender The account address which will spend the funds.
	 * @param value The amount of tokens to be spent.
	 * @return the approve success or fail bool value
	 */
	function approve(address spender,uint256 value)
	public returns(bool){
		require(spender != address(0));
		_allowed[msg.sender][spender] = value;

		emit Approval(msg.sender,spender,value);
		return true;
	}
	
	/**
	 * @dev Internal function that mints an amount of tokens and assigned to an account.
	 * @param account the account address will be assigned some tokens.
	 * @param amount The tokens amount 
	 */
	function _mint(address account,uint256 amount) internal{
		require(account != address(0));
		_totalSupply = _totalSupply.add(amount);
		_balances[account] = _balances[account].add(amount);
		emit Transfer(address(0),account,amount);
	}
}
