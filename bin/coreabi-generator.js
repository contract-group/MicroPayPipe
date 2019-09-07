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
var abiHandler = new AbiHandler('build/contracts');
abiHandler.generatorABI('true');
