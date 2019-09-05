var IERC20 = artifacts.require('IERC20.sol');
var ERC20 = artifacts.require('ERC20.sol');
var Owned = artifacts.require('Owned.sol');
var SafeMath = artifacts.require('SafeMath.sol');
var TCoinToken = artifacts.require('TCoinToken.sol');
var MicroPaySystem = artifacts.require('MicroPaySystem.sol');

module.exports = function(deployer){

	deployer.deploy(TCoinToken).then(
		(c)=>{
			return deployer.deploy(MicroPaySystem,TCoinToken.address);
	}).then((m)=>{
		deployer.link(SafeMath,MicroPaySystem);
	});


}