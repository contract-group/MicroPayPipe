var SafeMath = artifacts.require('SafeMath.sol');
var Owned = artifacts.require('Owned.sol');
var IERC20 = artifacts.require('IERC20.sol');
var ERC20 = artifacts.require('ERC20.sol');
var TCoinToken = artifacts.require('TCoinToken.sol');
var MicroPaySystem = artifacts.require('MicroPaySystem.sol');


module.exports = async function(deployer,network,accounts){
	await deployer.deploy(SafeMath);
	await deployer.deploy(Owned);

	//deploy ERC20
	await deployer.link(SafeMath,ERC20);
	await deployer.deploy(ERC20);

	//deloy Token
	//deploy MicroPaySystem
	await deployer.link(ERC20,TCoinToken);
	await deployer.deploy(TCoinToken);

	//deploy MicroPaySystem

	await deployer.link(SafeMath,MicroPaySystem);
	await deployer.link(Owned,MicroPaySystem);
	let ta =await TCoinToken.new();
	await deployer.deploy(MicroPaySystem,ta.address);	
	//await deployer.deploy(MicroPaySystem,TCoinToken.address);	

	console.log("Contracts Deployed on :"+network);
	console.log("Acounts :"+accounts);
}