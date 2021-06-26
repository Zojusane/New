if(typeof web3 !== 'undefined'){
	web3 = new Web3(web3.currentProvider);
}else{
web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8545"))
}
var account;
// var account2;
web3.eth.getAccounts().then((f) => {
    account = f[0];  
})
abi = JSON.parse('[{"inputs": [{"internalType": "int8","name": "newcredit","type": "int8"}],"name": "AAcredit","outputs": [],"stateMutability": "nonpayable","type": "function"},{"inputs": [{"internalType": "address","name": "STUaddr","type": "address"}],"name": "AccessSTU","outputs": [{"internalType": "bool","name": "res","type": "bool"}],"stateMutability": "nonpayable","type": "function"},{"inputs": [{"internalType": "address","name": "wrongf","type": "address"}],"name": "DeleteFunder","outputs": [],"stateMutability": "nonpayable","type": "function"},{"inputs": [{"internalType": "address","name": "wrongs","type": "address"}],"name": "DeleteSTU","outputs": [],"stateMutability": "nonpayable","type": "function"}, {"inputs": [{"internalType": "bytes32","name": "certhash","type": "bytes32"},{"internalType": "address","name": "CAaddr","type": "address"},{"internalType": "address","name": "AAaddr","type": "address"},{"internalType": "address","name": "sender","type": "address"}],"name": "Notice","outputs": [{"internalType": "bool","name": "res","type": "bool"}],"stateMutability": "nonpayable","type": "function"}, {"inputs": [],"stateMutability": "nonpayable","type": "constructor"}, {"anonymous": false,"inputs": [{"indexed": false,"internalType": "bytes32","name": "certhash","type": "bytes32"  }, {"indexed": false, "internalType": "address", "name": "addrSTU", "type": "address"}, {"indexed": false, "internalType": "address", "name": "addrCA", "type": "address"}, {"indexed": false, "internalType": "address", "name": "addrAA", "type": "address"} ], "name": "InspectNotice", "type": "event"}, {"inputs": [{"internalType": "string", "name": "funder_name", "type": "string"}, {"internalType": "address", "name": "addressget", "type": "address"} ], "name": "setFunder", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "sender", "type": "address"}], "name": "Shield", "outputs": [{"internalType": "bool", "name": "res", "type": "bool"}], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "AAaddr", "type": "address"}], "name": "AAornot", "outputs": [{"internalType": "bool", "name": "res", "type": "bool"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "callbacktime", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "Funder", "outputs": [{"internalType": "string", "name": "shortname", "type": "string"}, {"internalType": "int8", "name": "credit", "type": "int8"} ], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "Funder_addrlist", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "getAAFunder", "outputs": [{"internalType": "address[]", "name": "list", "type": "address[]"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "getLength", "outputs": [{"internalType": "uint256", "name": "len", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "owner", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "Sender_addrlist", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "Sender_shield", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "index_out", "type": "uint256"}], "name": "showFunder", "outputs": [{"internalType": "address", "name": "showaddr", "type": "address"}, {"internalType": "string", "name": "showname", "type": "string"}, {"internalType": "int8", "name": "showcredit", "type": "int8"} ], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "STU_addrlist", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"} ] '); 
contract = new web3.eth.Contract(abi);

$(document).ready(function(){
    try{
        contract.options.address ="";//fillin the ETR_AA contract address
        contract.methods.owner().call({ from: account }).then((f) => {
            let owner = f;
            let _owner = document.getElementById("ownerofall");
            _owner.innerHTML = owner;
        })
        let _contract = document.getElementById("contractofall");
        _contract.innerHTML = contract.options.address;
        contract.methods.getLength().call({ from: account }).then((f) => {
            let len = f;
            for (let index = 0; index < len; index++) {
                contract.methods.showFunder(index).call({ from: account }).then((f) => {
                    $("#showpart").append("<tr><th>" + (index+1) + "</th><td>" + f.showname + "</td><td>" + f.showaddr + "</td><td>" + f.showcredit + "</td></tr>")
                })
            }
        })
    }
    catch(err){
        alert('Something  is wrong');
    }
});

// update this contract address with your contract address

// function Setpwd(){
//     pwd = $("#pwd").val();
//     contract.methods.setPassword(pwd).send({from:account});
//     $("#pwd").val("");
// }

function Zero(){
    $("#addname").val("");
    $("#addAddr").val("");
    $("#addAddr2").val("");
    $("#alert").val("");
}

function Zero2(){
    $("#confirmAA").val("");
    $("#confirmSTU").val("");
    $("#alert2").val("");
}

function Zero3(){
    $("#delateAA").val("");
    $("#delateSTU").val("");
    $("#BlackList").val("");
    $("#alert3").val("");
}

function setAA() {
    $("#alert").val("");
    let shortname = $("#addname").val().trim();
    let contractaddr = $("#addAddr").val().trim();
    let contractaddr2 = $("#addAddr2").val().trim();    
    if (contractaddr == contractaddr2) {
        try{
            contract.methods.setFunder(shortname, contractaddr).send({ from: account, gas: 1500000 });
            // contract.methods.getLength().call().then((f)=>{
            //         let lastone = f;
            //         contract.methods.showFunder(lastone).call({from:account}).then((f)=>{
            //             $("#showpart").append("<tr><th>"+(lastone+1)+"</th><td>"+f.showname+"</td><td>"+f.showaddr+"</td><td>"+f.showcredit+"</td></tr>")
            //         })
            // });
            
        }
        catch(err){
            ale.innerHTML = 'Please input the corract data or you not the owner';
        }
    }else{
        ale.innerHTML = 'Please input the same address'; 

    }  
}

function ConfirmAA(){
     let AAaddr = $("#confirmAA").val().trim();
     try{
        contract.methods.AAornot(AAaddr).call().then((f)=>{
            if(f == true){
                $("#alert").val("It is the oneof AA addresses");
            }else{
                $("#alert").val("NOT ANY OF AAs");
            }
        })
     }catch(error){
        $("#alert").val("Please input the right address");
     }
}
function ConfirmSTU(){
    let STUaddr = $("#confirmSTU").val().trim();
     try{
        contract.methods.AccessSTU(STUaddr).call().then((f)=>{
            if(f == true){
                $("#alert").val("It is the oneof STU addresses");
            }else{
                $("#alert").val("NOT ANY OF STUs");
            }
        })
     }catch(error){
        $("#alert").val("Please input the right address");
     }
}
function DelateAA(){
    
}
function DelateSTU(){

}
function ADDBLACK(){
    
}

