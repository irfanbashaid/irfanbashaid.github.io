console.log(window);

let walletAddress = "";
let web3Instance;
let abiJSON = [
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getCurrentTime",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "isCandidate",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "no_of_votes",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "result",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "startVoting",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_candName",
				"type": "string"
			}
		],
		"name": "voting",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
];
let votingContractAddress = "0x4131f92ac65959de425f21a8b1f9ececeb557e15";
function update_wallet_balance() {
    web3Instance.eth.getBalance(walletAddress).then((data)=>{
        let balanceInEther = web3Instance.utils.fromWei(data, 'ether');
        document.getElementById('walletBalance').innerHTML = balanceInEther; 
    });
}

async function init() {
    let walletRes = await window.ethereum.enable();
    walletAddress = walletRes[0];
    document.getElementById('walletAddress').innerHTML = walletAddress; 
    web3Instance = new window.Web3(window.ethereum);
    update_wallet_balance();
    contractInstance = new web3Instance.eth.Contract(abiJSON,votingContractAddress); 
    no_of_votes("TRUMP");
    no_of_votes("BIDEN");
}
init();

async function voting(candidateName) {
    contractInstance.methods.voting(candidateName).send({from: walletAddress})
    .on('transactionHash', function(hash){
        console.log(hash);
    })
    .on('receipt', function(receipt){
        console.log(receipt);
        if(receipt.status) {
            return alert("Your vote is successfully registered");
        }
    });
}

async function result() {
    contractInstance.methods.result().call().then((data) => {
        alert(data);
    });
}

async function no_of_votes(candidateName) {
    contractInstance.methods.no_of_votes(candidateName).call().then((data) => {
        document.getElementById(candidateName+'VOTES').innerHTML = data; 
    });
}
