//This function will be called when the whole page is loaded
window.onload = function(){
	if (typeof web3 === 'undefined') {
		//If there is no web3 variable
		displayMessage("Error! Are you sure that you are using metamask?");
		$("#initAddress").hide();
	} else {
		displayMessage("Welcome to our DAPP!");
		$("#initAddress").show();
	}
};

var contractInstance;
var abi = [{"constant":true,"inputs":[{"name":"person","type":"address"}],"name":"getPokemonsByPerson","outputs":[{"name":"","type":"uint8[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"pokemon","type":"uint8"}],"name":"getPokemonHolders","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"pokemon","type":"uint8"}],"name":"catchPokemon","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"by","type":"address"},{"indexed":true,"name":"pokemon","type":"uint8"}],"name":"LogPokemonCaught","type":"event"}];
var address;// = "0xf12b5dd4ead5f743c6baa640b0216200e89b60da";
var acc;

var waitingForEvent = false;

function onInitButtonPressed(){
	address = document.getElementById("inputAddress").value;
	if(address && address.startsWith("0x")){
		displayMessage("Welcome to our DAPP!");
		init();
	}
	else{
		displayMessage("Wrong address format. Address should start with '0x'.");
	}
};

function init(){
	if(!address)
		return;
	
	$("#initAddress").hide();
	showContent();

	var Contract = web3.eth.contract(abi);
	contractInstance = Contract.at(address);
	contractInstance.LogPokemonCaught({fromBlock: 0, toBlock: 'latest'}, function(err, res){
		if(!waitingForEvent)
			return;
		waitingForEvent = false;
		if(!err){
			displayMessage("A pokemon '" + res.args.pokemon.valueOf() + "' was caught by '" + res.args.by.valueOf()) + "'";
		}
		showContent();
	});
	
	updateAccount();
};

function updateAccount(){
	//In metamask, the accounts array is of size 1 and only contains the currently selected account.
	//The user can select a different account and so we need to update our account variable.
	acc = web3.eth.accounts[0];
};

function displayMessage(message, error){
	var el = document.getElementById("message");
	el.innerHTML = message;
	if(error)
		console.error(error);
};

function getTextInput(){
	var el = document.getElementById("input");
	return el.value;
};

function onButtonPressed(){
	if(!address)
		return;
	
	var pokemon = getTextInput();
	
	updateAccount();

	showLoader();
	waitingForEvent = true;

	contractInstance.catchPokemon(pokemon, {"from": acc}, function(err, res){
		if(err){
			waitingForEvent = false;
			displayMessage("Something went wrong. Are you sure that you haven't already caught the same pokemon and have waited 15 seconds from the last one?");
			showContent();
		}
	});
};

function onSecondButtonPressed(){
	if(!address)
		return;
	
	updateAccount();

	var input = getTextInput();
	
	if(input.startsWith("0x")){
		var person = input;
		contractInstance.getPokemonsByPerson.call(person, {"from": acc}, function(err, res) {
			if(!err){
				var pokemons = res.valueOf();
				displayMessage("Pokemons owned by person '" + person + "' are: [" + pokemons + "]");
			} else {
				displayMessage("Something went horribly wrong. Deal with it:", err);
			}
		});
	} else{
		var pokemon = input;
		contractInstance.getPokemonHolders.call(pokemon, {"from": acc}, function(err, res) {
			if(!err){
				var holders = res.valueOf();
				displayMessage("Pokemon '" + pokemon + "' holders are: [" + holders + "]");
			} else {
				displayMessage("Something went horribly wrong. See error logs for more info.", err);
			}
		});
	}
};

function showLoader(){
	$("#message").hide();
	$("#container").hide();
	$("#loader").show();
};

function showContent(){
	$("#loader").hide();
	$("#message").show();
	$("#container").show();
};