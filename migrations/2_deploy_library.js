var SafeMath = artifacts.require('SafeMath.sol');
var Owned = artifacts.require('Owned.sol');

module.exports = function(deployer){
	deployer.deploy(SafeMath).then((d)=>{
		//console.log(d);
	});
	deployer.deploy(Owned);
	// deployer.deploy(IERC20);
	// deployer.deploy(ERC20);

}