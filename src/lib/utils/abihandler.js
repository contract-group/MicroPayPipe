/**
 * MetaMask Support
 *  |\_/|,,_____,~~`
 *  (.".)~~     )`~}}
 *	 \o/\ /---~\\ ~}}
 *     _//    _// ~}
 * 
 * Copyright (c) 2019 PPL,pangolin-team
 * E-mail : developer-team@pangolink.org
 * https://github.com/pangolin-lab/web3js-sdk
 *
 */
"use strict";
const DEF_CONTRACTS_SRC = "build/contracts";
const DEF_TARGET_SRC = "data";
const DEF_TARGET_ABI = "core-abi.json";

var fs = require('fs');
var path = require('path');
var sh = require('shelljs');

class AbiHandler {
  
  constructor (options) {
  	this.ROOT_HOME = process.cwd();
  	this.ctx ={};
  	if(typeof options === 'string'){
  	  this.ctx['abiSrc'] = _getABISource(options);
  	}

  	if(!fs.existsSync(this.ctx['abiSrc'])){
  	  console.log("Contracts:"+this.ctx['abiSrc']);
  	  console.log("contracts abi directory not exists."+process.cwd());
  	  //process.exit(1);
  	}
    if(!fs.existsSync(DEF_TARGET_SRC)){
      sh.mkdir('-p',DEF_TARGET_SRC);
    }

  	this.ctx['coreabi'] = path.join(DEF_TARGET_SRC,DEF_TARGET_ABI);
  }

  generatorABI(cover){
  	let isCover = typeof cover === 'bool' ? cover : true;
  	console.log("overwrite>>"+ isCover);
    let rs = _loadABIFiles(path.join(this.ROOT_HOME,this.ctx['abiSrc']))
    let coreABIs = {};
    for(var i=0,len = rs.length;i<len;i++){
      let contract = rs[i][0];

      let name = contract.contractName;
      if(!name || name.length <= 0)continue;
      let arr = contract.abi || [];

      coreABIs[name]={
        "contractName":name,
        "abi":arr
      };

      let caontractAddress = _getAddressFromJson(contract);
      if(caontractAddress){
        coreABIs[name].address=caontractAddress;
      }
    }

    //console.log(JSON.stringify(coreABIs,null,'  '));
    fs.writeFile(this.ctx['coreabi'],JSON.stringify(coreABIs,null,'  '),err=>{
      if(err)console.log(err);
    });
  }

  getCtx(){
  	return this.ctx;
  }
}

/**
 *
 */
function _getABISource(p){
  return p == null ?  DEF_CONTRACTS_SRC : p;
}

function _loadABIFiles(p){
  return fs
    .readdirSync(p).filter(fileName => fileName.indexOf('.json') !==-1 )
    .map(fileName=>[
      JSON.parse( fs.readFileSync(path.join(p,fileName)))
    ]);
}

function _getAddressFromJson(abi){
  if(!abi || !abi.networks)return false;
  let address = false;
  Object.keys(abi.networks).forEach((key)=>{
    let val = abi.networks[key];
    //console.log(val.address);
    if(val.address)address=val.address;
  });

  return address;
}

module.exports = AbiHandler;


