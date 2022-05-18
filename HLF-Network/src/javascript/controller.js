/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';
const { Gateway, Wallets } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');
const path = require('path');

const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection-org1.json');

exports.test = async function (req, res, next) {
    console.log("-in cont")
    Invoke("CheckForOrg", [], res);
}
exports.createBar = async function (req, res, next) {
	var BarLocation         = req.body.barLocation;
	var BarSerialNumber     = req.body.barSerialNumber;
	var Purity  	        = req.body.purity;
	var BarRefiner   	    = req.body.barRefiner;
	var BarHallmarkVerfied  = req.body.barHallmarkVerfied;
    var BarWeightInGms		= req.body.barWeightInGms;
    
    var args = [BarLocation,BarSerialNumber,Purity,BarRefiner,BarHallmarkVerfied,BarWeightInGms,"23-09-2021","test"];

    Invoke("CreateBar", args, res);
}
exports.queryBar = async function (req, res, next) {
    var BarSerialNumber = req.query.barSerialNumber;
    var args = [BarSerialNumber];
    Query("QueryBar", args, res);
}
exports.getBarList = async function (req, res, next) {
    var BarSerialNumber = req.boby.barSerialNumber
    var agrs =[BarSerialNumber]
    QueryAll("GetBarList",agrs,res);
}
exports.getBar = async function (req, res, next) {
    var BarSerialNumber = req.query.barSerialNumber;
    var args = [BarSerialNumber];

    Query("GetBar",args,res)
} 
exports.createBuy = async function (req, res, next) {		                  
	var OrderId            =  req.body.orderId;           
    var Amount             =  req.body.amount;        
    var AmountWithFees     =  req.body.amountWithFees;        
    var Stage              =  req.body.stage;         
	var PaymentStatus      =  req.body.paymentStatus;              
	var EstimatedGrams     =  req.body.estimatedGrams;              
    var UserId             =  req.body.userId;       
  

    var args = [OrderId,Amount,AmountWithFees,Stage,PaymentStatus,EstimatedGrams,UserId];

    Invoke("CreateBuy", args, res);
}
exports.getBuyList = async function (req, res, next) {
    QueryAll("GetBuyList",res)
}
exports.queryBuy = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("QueryBuy", args, res);
}
exports.getBuy = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("GetBuy",args,res)
} 
exports.createSell = async function (req, res, next) {		                  
	var OrderId            =  req.body.orderId;           
    var Grams             =  req.body.grams;                      
	var EstimatedAmount     =  req.body.estimatedAmount;              
    var UserId             =  req.body.userId;       
  

    var args = [OrderId,Grams,EstimatedAmount,UserId];

    Invoke("CreateSell", args, res);
}
exports.getSellList = async function (req, res, next) {
    QueryAll("GetSellList",res)
}
exports.querySell = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("QuerySell", args, res);
}
exports.getSell = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("GetSell",args,res)
} 
exports.createSend = async function (req, res, next) {		                  
	var OrderId            =  req.body.orderId;           
    var Grams              =  req.body.grams;                      
	var SenderUserId       =  req.body.senderUserId;              
    var ReceiverUserId     =  req.body.receiverUserId;       
  

    var args = [OrderId,Grams,SenderUserId,ReceiverUserId];

    Invoke("CreateSend", args, res);
}
exports.getSendList = async function (req, res, next) {
    QueryAll("GetSendList",res)
}
exports.querySend = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("QuerySend", args, res);
}
exports.getSend = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("GetSend",args,res)
} 
exports.createTrade = async function (req, res, next) {		                  
	var OrderId            =  req.body.orderId;           
    var Grams              =  req.body.grams;                      
	var UserId       =  req.body.userId;                   

    var args = [OrderId,Grams,UserId];

    Invoke("CreateTrade", args, res);
}
exports.getTradeList = async function (req, res, next) {
    QueryAll("GetTradeList",res)
}
exports.queryTrade = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("QueryTrade", args, res);
}
exports.getTrade = async function (req, res, next) {
    var OrderId = req.query.orderId;
    var args = [OrderId];

    Query("GetTrade",args,res)
}
async function Invoke(funcName,args,res){
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection-org2.json');
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet2');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`Wallet path`, JSON.stringify(ccp));

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('user2');
        if (!identity) {
            console.log(`An identity for the user user1 does not exist in the wallet`);
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user2', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('ehrchannel');

        // Get the contract from the network.
        const contract = network.getContract('dsg');
        if(args.length == 6 ){
       
        await contract.submitTransaction(funcName,args[0],args[1],args[2],args[3],args[4],args[5]);
        }else if(args.length == 8){
     
            await contract.submitTransaction(funcName,args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);   
        }
    else if(args.length == 7){
     
        await contract.submitTransaction(funcName,args[0],args[1],args[2],args[3],args[4],args[5],args[6]);   
    } else if(args.length == 5){
     
        await contract.submitTransaction(funcName,args[0],args[1],args[2],args[3],args[4]);   
    }else if(args.length == 4){
     
        await contract.submitTransaction(funcName,args[0],args[1],args[2],args[3]);   
    }else if(args.length == 3){
     
        await contract.submitTransaction(funcName,args[0],args[1],args[2]);   
    }else if(args.length == 2){
     
        await contract.submitTransaction(funcName,args[0],args[1]);   
    }else if(args.length == 1){
     
        await contract.submitTransaction(funcName,args[0]);   
    }   
    else if(args.length == 0){
     console.log("0 args")
        await contract.submitTransaction(funcName);   
    }  
        console.log({message:'Success'});
        res.send({message:'Success'});

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`failure: ${error}`);
        res.send(`failure: ${error}`);

    }
}
async function QueryAll(funcName,res){
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('user1');
        if (!identity) {
            console.log(`An identity for the user user1does not exist in the wallet`);
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('ehrchannel');

        // Get the contract from the network.
        const contract = network.getContract('dsg');

        // Evaluate the specified transaction.
        // queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
    
        const result = await contract.evaluateTransaction(funcName);
let p = JSON.parse(result)
        console.log({Result:p});
        res.send({Result:p});

    } catch (error) {
        console.error(`failure: ${error}`);
        res.send(`failure: ${error}`);

    }
}
async function Query(funcName,args,res){
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('user1');
        if (!identity) {
            console.log(`An identity for the user user1does not exist in the wallet`);
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('ehrchannel');

        // Get the contract from the network.
        const contract = network.getContract('dsg');

        // Evaluate the specified transaction.
        // queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
        if(args.length == 1 ){
       
        const result = await contract.evaluateTransaction(funcName,args[0]);
        let p = JSON.parse(result)
        console.log({Result:p});
        res.send({Result:p});
        }else if(args.length == 6 ){
       
            const result = await contract.evaluateTransaction(funcName,args[0],args[1],args[2],args[3],args[4],args[5]);
            let p = JSON.parse(result)
            console.log({Result:p});
            res.send({Result:p});
        }else if(args.length == 4 ){
       
            const result = await contract.evaluateTransaction(funcName,args[0],args[1],args[2],args[3]);
            let p = JSON.parse(result)
            console.log({Result:p});
            res.send({Result:p});
        }else if(args.length == 5 ){
       
            const result = await contract.evaluateTransaction(funcName,args[0],args[1],args[2],args[3],args[4]);
            let p = JSON.parse(result)
            console.log({Result:p});
            res.send({Result:p});
        }else if(args.length == 3 ){
       
            const result = await contract.evaluateTransaction(funcName,args[0],args[1],args[2]);
            let p = JSON.parse(result)
            console.log({Result:p});
            res.send({Result:p});
        }else if(args.length == 2 ){
       
            const result = await contract.evaluateTransaction(funcName,args[0],args[1]);
            let p = JSON.parse(result)
            console.log({Result:p});
            res.send({Result:p});
        }
    } catch (error) {
        console.error(`failure: ${error}`);
        res.send(`failure: ${error}`);

    }
}