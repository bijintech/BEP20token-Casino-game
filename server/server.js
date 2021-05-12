const express = require('express');
const expressWs = require('express-ws');
const https = require('https')
const fs = require('fs')
const cors = require('cors');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const path = require('path');
const BET_INTERVAL = 45000;
/*const Web3 = require('web3');
const cron = require('node-cron');
const DICEABI = JSON.parse(fs.readFileSync('./diceAbi.json'));
const DICEADDRESS = "0x6228965Ca30d5897474B7a32091C16C7F89915f2";
const PRIVATE_KEY = "f9f7c48246c71df57a783935256568a028d0fea11a5d09ef4ef2be921362e039"
const OWNER_ADDR = "0x1F76F81c77d5228e1044DBd13CCD92455C1D54Df"
const GAS = 2000000;*/

global.History = require('./api/models/historyModel');
const routes = require('./api/routes/historyRoutes');

mongoose.Promise = global.Promise;
mongoose.set('useFindAndModify', false);
mongoose.connect(
    'mongodb://localhost/dice_betting', { useNewUrlParser: true }
);

/********** server monitoring block process and winsocket listening and sending ***********/
/*var web3 = new Web3(NETWORK_URL);

var diceContract = new web3.eth.Contract(DICEABI, DICEADDRESS);

let latestKnownBlockNumber = -1;
let blockTime = 6000000;

async function processBlock(blockNumber) {
    var blockNums = blockNumber - latestKnownBlockNumber;
    if (blockNums > 0 && latestKnownBlockNumber !== -1) {
        var mint = diceContract.methods.mint(blockNums * 10 * 100000000);
        var encodedABI = mint.encodeABI();
        var tx = {
            from: OWNER_ADDR,
            to: DICEADDRESS,
            gas: GAS,
            data: encodedABI
        };
        web3.eth.accounts.signTransaction(tx, PRIVATE_KEY).then(signed => {
            var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);
        });
    }

    latestKnownBlockNumber = blockNumber;
}

async function checkCurrentBlock() {
    const currentBlockNumber = await web3.eth.getBlockNumber()
    if (latestKnownBlockNumber !== -1 || currentBlockNumber > latestKnownBlockNumber) {
        processBlock(currentBlockNumber)
    }
    setTimeout(checkCurrentBlock, blockTime);
}

checkCurrentBlock();*/

/************ winsocket listening and sending ********************/
function getRandomDices(count) {
    var dices = [];
    for (let i = 0; i < count; i++) {
      dices.push(Math.floor(Math.random() * 6 + 1));
    }
    return dices;
}

let startTime = Date.now();
let randomDices = [];
let dicesList = [];
var onlineClients = 0;
var totalDices = 500000;
let maxWager = totalDices / 10;

const port = process.env.PORT || 3000;
const app = express();
var options = {
    key: fs.readFileSync('server.key', 'utf-8'),
    cert: fs.readFileSync('server.crt', 'utf-8'),
    //ca: fs.readFileSync('server.ca-bundle', 'utf-8')
  };
const httpsServer = https.createServer(options, app);
const wss = expressWs(app, httpsServer);

app.ws('/connect', function(ws, req) {
	ws.on('message', function(msg) {
        console.log(msg)
        if (msg == "connect request") {
            clients = (onlineClients > 0) ? (onlineClients + 1) : 1;
            maxWager = totalDices / 10 / clients;
            var obj = {time: (Date.now() - startTime), dices: randomDices, pastRecords: dicesList, maxWager: maxWager};
            var gameStatus = JSON.stringify(obj);
            ws.send(gameStatus)
        } else {
            /*var obj = JSON.parse(msg)
            if (obj.moveAmount > 0) {
                //take amount from client
                var stealToken = diceContract.methods.setBet(obj.walletAddress, Math.abs(obj.moveAmount) * 100000000);
                var encodedABI = stealToken.encodeABI();
                var tx = {
                    from: OWNER_ADDR,
                    to: DICEADDRESS,
                    gas: GAS,
                    data: encodedABI
                };
                web3.eth.accounts.signTransaction(tx, PRIVATE_KEY).then(signed => {
                    var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);
                }).catch((err) => {
                    console.log(err)
                });
            } else if (obj.moveAmount < 0) {
                //give amount to client
                var relaseToken = diceContract.methods.getBet(obj.walletAddress, Math.abs(obj.moveAmount) * 100000000);
                var encodedABI = relaseToken.encodeABI();
                var tx = {
                    from: OWNER_ADDR,
                    to: DICEADDRESS,
                    gas: GAS,
                    data: encodedABI
                };
                web3.eth.accounts.signTransaction(tx, PRIVATE_KEY).then(signed => {
                    var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);
                }).catch((err) => {
                    console.log(err)
                });
            }*/
        }
	});
});

/********** sending a randoming dice every 45 seconds ***************/
function sendUpdateDice() {
	//timer refresh
	startTime = Date.now();

    //prepare new dices and send to clients
    randomDices = getRandomDices(3);
    var aWss = wss.getWss('/');
    onlineClients = aWss.clients.length;
    //maxWager : 10% of total dice  / numbers of client who is online
    if (aWss.clients.length > 0)
        maxWager = 100000 / 10 / onlineClients;

    aWss.clients.forEach(function (client) {
        var obj = {time: (Date.now() - startTime), dices: randomDices, maxWager: maxWager};
        var updateGameStatus = JSON.stringify(obj);
        client.send(updateGameStatus);
    });

    //store recent record list up to 15
    if (dicesList.length < 15) {
        dicesList.unshift(randomDices);
    } else {
        dicesList.pop();
        dicesList.unshift(randomDices)
    }

    /*diceContract.methods.totalSupply().call(
    ).then((res) => {
        totalDices = res / 100000000
    })*/
}
sendUpdateDice()
setInterval(sendUpdateDice, BET_INTERVAL);

/********** rewarding every day ***************/
/*cron.schedule('0 59 23 * * *', function() {
    var rewardDaily = diceContract.methods.rewardDaily();
    var encodedABI = rewardDaily.encodeABI();
    var tx = {
        from: OWNER_ADDR,
        to: DICEADDRESS,
        gas: GAS,
        data: encodedABI
    };
    web3.eth.accounts.signTransaction(tx, PRIVATE_KEY).then(signed => {
        var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);
    }).catch((err) => {
        console.log(err)
    });
});*/

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

routes(app);
httpsServer.listen(port);

app.use((req, res) => {
    res.sendFile(path.join(__dirname + '/index.html'));
});

console.log(`Server started on port ${port}`);