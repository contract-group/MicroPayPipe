pragma solidity >=0.4.24;

import "./IERC20.sol";
import "./SafeMath.sol";

/**
 * The ERC20 contract does this and that...
 */
contract ERC20 is IERC20 {
	using SafeMath for uint256;

	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowed;
	
	uint256 private _totalSupply;

	/**
	 *@dev Total amount of tokens in existence
	 */
	function totalSupply () public view returns(uint256){
		return _totalSupply;
	}

	/**
	 * @dev Get the balance of address
	 * @param owner the address to query the balance of
	 * @return An uint256 representing the amount owned
	 */
	function balanceOf(address owner) public view returns(uint256){
		return _balances[owner];
	}

	/**
	 * @dev Function to check the amount of tokens that an owner allowed to a spender
	 * @param owner address The address which owns the funds
	 * @param spender address 
	 * @return A uint256 specifying the amount of tokens
	 */
	function allowance (
		address owner,
		address spender
	)public view returns(uint256){
		return _allowed[owner][spender];
	}
	
	/**
	 * @dev Transfer token for a specified address
	 * @param to address token transfer to 
	 * @param amount the token amount transfer
	 */
	function transfer(address to,uint256 amount)public returns (bool){

		require (amount <= _balances[msg.sender]);

		require (to != address(0));
		
		_balances[msg.sender] = _balances[msg.sender].sub(amount);
		_balances[to] = _balances[to].add(amount);

		emit Transfer(msg.sender,to,amount);
		return true;
	}


	/**
	 * @dev Transfer tokens form one address to another address
	 * @param from address The outlay Tokens Address
	 * @param to address the inlay Tokens Address
	 * @param amount uint256 the value of tokens
	 */
	function transferFrom(
		address from,
		address to,
		uint256 amount
	)
	public returns(bool){

		require (amount <= _balances[from]);

		require (amount <= _allowed[from][msg.sender]);

		require (to != address(0));
		
		_balances[from] = _balances[from].sub(amount);
		_balances[to] = _balances[to].add(amount);
		_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(amount);

		emit Transfer(from,to,amount);
		
		return true;
	}

	/**
	 * @dev Approve the passed address to spend the specified amount of tokens
	 * @param spender The address which will spend the funds
	 * @param amount the amount of tokens to be spent
	 */
	function approve(address spender,uint256 amount) public returns(bool){
		require (spender != address(0));

		_allowed[msg.sender][spender] = amount;

		emit Approve(msg.sender,spender,amount);
		return true;
	}

	/**
	 * @dev		Increase the amount of tokens that an owner allowed to a spender
	 * @param	spender The address which will spend the funds
	 * @param	addedValue the amount of tokens to increase the allownce by
	 *
	 */
	function increaseAllowance(
		address spender,
		uint256 addedValue
	)public returns (bool){

		require (spender != address(0));

		_allowed[msg.sender][spender] = (
			_allowed[msg.sender][spender].add(addedValue));
		
		emit Approve(msg.sender,spender,_allowed[msg.sender][spender]);
		return true;
	}

	/**
	 * @dev 	decrease Allowance
	 * @param 	spender address 
	 * @param	subtractedValue uint256
	 *
	 */
	function decreaseAllowance(address spender,uint256 subtractedValue)
		public returns(bool)
	{
		require(spender != address(0));

		_allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));

		emit Approve(msg.sender,spender,_allowed[msg.sender][spender]);
		return true;
	}

	/**
	 * @dev Internal function that mints an amount of the token and assigns it to
	 * an account
	 * @param account address
	 * @param amount uint256 
	 */
	function _mint(address account,uint256 amount) internal {

		require(account != address(0));

		_totalSupply = _totalSupply.add(amount);
		_balances[account] = _balances[account].add(amount);

		emit Transfer(address(0),account,amount);
	}

	/**
	 * @dev Internal function that burns an amount of the token of a given
	 * @param account address
	 * @param amount uint256 
	 */
	function _burn(address account,uint256 amount) internal {
		require(account != address(0));
		require(amount <= _balances[account]);

		_totalSupply = _totalSupply.sub(amount);
		_balances[account] = _balances[account].sub(amount);
		emit Transfer(account,address(0),amount);
	}

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * @param account The account whose tokens will be burnt.
     * @param amount The amount that will be burnt.
     */
	function _burnFrom(address account,uint256 amount) internal {
		require(amount <= _allowed[account][msg.sender]);

		_allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);

		_burn(account,amount);
	}

}



