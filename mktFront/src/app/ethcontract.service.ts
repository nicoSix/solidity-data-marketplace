import { Injectable } from '@angular/core';
import * as Web3 from 'web3';
import * as TruffleContract from 'truffle-contract';


declare let require: any;
declare let window: any;
let tokenAbi = require('../../../build/contracts/Auction.json');

@Injectable({
providedIn: 'root'
})


export class EthcontractService {


private web3Provider: null;
private contracts: {};


    constructor() {

      if (typeof window.web3 !== 'undefined') {

        this.web3Provider = window.web3.currentProvider;
      }
     else {

      this.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
}


window.web3 = new Web3(this.web3Provider);
}

  createAuction(dt: string, at: string, it: string, maxPrice: number) {
    return new Promise((resolve, reject) => {
      window.web3.eth.createAuction(dt, at, it, maxPrice);
    });
  }

}
