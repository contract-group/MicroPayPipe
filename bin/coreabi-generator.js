/**
 * MetaMask Support
 *  |\_/|,,_____,~~`
 *  (.".)~~     )`~}}
 *	 \o/\ /---~\\ ~}}
 *     _//    _// ~}
 * 
 * Copyright (c) 2019 jnaruto,develop-team
 * E-mail : developer-team
 * 
 *
 */
const AbiHandler = require('../src/lib/utils/abihandler.js');
let options = {
	abiSrc:".abis/coin",
	targetDest:"data/abis"
};
var abiHandler = new AbiHandler(options);

abiHandler.generatorABI(true);
