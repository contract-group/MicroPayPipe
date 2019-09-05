var IERC20 = artifacts.require('IERC20.sol');
var ERC20 = artifacts.require('ERC20.sol');
var SafeMath = artifacts.require('SafeMath.sol');

module.exports = function(deployer){
	deployer.deploy(ERC20).then((d)=>{	
		//console.log(d);
		deployer.link(SafeMath,ERC20);
		//return deployer.deploy(ERC20,IERC20.address);
	});
}