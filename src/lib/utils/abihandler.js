/**
 * MetaMask Support
 *  |\_/|,,_____,~~`
 *  (.".)~~     )`~}}
 *   \o/\ /---~\\ ~}}
 *     _//    _// ~}
 * 
 * Copyright (c) 2019 naruto,developer-team
 * E-mail : developer-team@gmail.com
 * https://github.com/jnaruto/MicroPayPipe
 *
 */
"use strict";
const DEF_CONTRACTS_SRC = ".output";
const DEF_TARGET_SRC = "data/abis";
const DEF_TARGET_ABI = "core-abi.json";
const FILTER_TRUFFLE = "Migrations.json";


var fs = require('fs');
var path = require('path');
var sh = require('shelljs');

const DEF = {
  abiSrc:"build/contracts",
  targetDest:"data/abis",
  targetABI:"core-abi.json"
};

class AbiHandler {
  
  /**
   * options string set abiSrc
   * options object Json
   *
   */
  constructor (options) {
    this.version = '0.0.5';
    this.ROOT_HOME = process.cwd();
    this.ctx =Object.assign({},DEF);

    if(typeof options === 'string'){
      _setABISrc(this.ctx,options);
    }else if(typeof options === 'object'){
      if(typeof options.abiSrc === 'string')
        _setABISrc(this.ctx,options.abiSrc);

      if(typeof options.targetDest ==='string')
        _setTargetDest(this.ctx,options.targetDest);

      if(typeof options.targetABI ==='string')
        _setTargetABI(this.ctx,options.targetABI);
    }else{
      console.log('options invalid,initial instance used default.');
    }

    if(!fs.existsSync(this.ctx.abiSrc)){
      console.log("Contracts:"+this.ctx['abiSrc']);
      console.log("contracts abi directory not exists."+
        path.join(process.cwd(),this.ctx.abiSrc));
      //process.exit(1);
    }
    if(!fs.existsSync(this.ctx.targetDest)){
      sh.mkdir('-p',this.ctx.targetDest);
    }
    this.ctx['coreabi'] = path.join(this.ctx.targetDest,this.ctx.targetABI);

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

    fs.writeFile(this.ctx['coreabi'],JSON.stringify(coreABIs,null,'  '),err=>{
      if(err)console.log(err);
    });
  }

  getCtx(){
    return this.ctx;
  }
}

function _setABISrc(ctx,src){
  if(src.trim().length >0){
    ctx.abiSrc = src.trim();
  }
}

function _setTargetDest(ctx,dest){
  if(typeof dest ==='string' && dest.trim()>0){
    ctx.targetDest = dest.trim();
  }
}

function _setTargetABI(ctx,target){
  if(typeof target ==='string' && target.endsWith('.json')){
    ctx.targetABI = target;
  }
}



function _loadABIFiles(p){
  return fs
    .readdirSync(p).filter(
      fileName => (fileName.indexOf('.json') !==-1 && fileName != FILTER_TRUFFLE) )
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


