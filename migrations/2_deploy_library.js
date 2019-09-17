
var IERC20 = artifacts.require('IERC20');
var safmath = artifacts.require('safemath');
var CountachToken = artifacts.require('CountachToken');

const OPTS = {
	overwrite:false
}

module.exports = async function(deployer,network,accounts){
	await deployer.deploy(safmath);
	//await deployer.deploy(IERC20);

	//deploy ERC20
	await deployer.link(safmath,CountachToken);
	await deployer.deploy(CountachToken);

	//await deployer.deploy(MicroPaySystem,TCoinToken.address);	

	console.log("Contracts Deployed on :"+network);
	console.log("Acounts :"+accounts);
}