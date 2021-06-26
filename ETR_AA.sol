pragma solidity ^0.6.4;


/**
 * The ETR_AA contract saves the government eth address and AA 
 contract address
 */
contract ETR_AA {
  //the AA infomation struct
  struct AAinfo {
    string shortname;
    //address contract_addr;
    int8 credit;
  } 
  struct MAYblack{
      bool blackornot;
      uint times;
  }
  // store the all address mapping the message
  mapping (address => AAinfo) public Funder;
  mapping(address=> MAYblack) public callbacktime;
  address[] public Funder_addrlist;
  address[] public STU_addrlist;
  address[] public Sender_addrlist;
  // password for the right to store getting from the deploy-contract institution
  //string private password;
  //bool  validpassword = false;
  address public owner;
  constructor() public {
    owner = msg.sender;
  }
  event InspectNotice(bytes32 certhash, address addrSTU, address addrCA, address addrAA);    
  // function setPassword (string memory val) public{
  //  require (owner == msg.sender); 
  //  password = val;
  //  validpassword = true;
  // }
  //加入AA机构，由政府权威机关掌控
  
  function setFunder(string memory funder_name, address addressget) public{
    require (owner == msg.sender);
    bool newaccount = true;
    Funder[addressget] = AAinfo(funder_name, 100);
    for(uint i = 0;i<Funder_addrlist.length;i++){
      if (Funder_addrlist[i] == addressget){
        newaccount = false;
        break;
      }
    }
    if (newaccount){
      Funder_addrlist.push(addressget);
    }
  }
  //删除机构
  function DeleteFunder (address wrongf) public{
    require (owner == msg.sender);
    for(uint i = 0;i<Funder_addrlist.length;i++){
      if (wrongf == Funder_addrlist[i]){
        Funder_addrlist[i] = address(0);
        break;
      }
    }
    delete Funder[wrongf];
  }
  //删除学生
  function DeleteSTU (address wrongs) public{
    require (owner == msg.sender);
    for (uint i = 0;i<STU_addrlist.length;i++){
      if (wrongs == STU_addrlist[i]){
        STU_addrlist[i] == address(0);
        break;
      }
    }
  }
  //由其他AA调用此函数修改AA机构的信誉值
  function AAcredit (int8 newcredit) public{
    require (Funder[msg.sender].credit!=0);
    Funder[msg.sender].credit = newcredit;
  }

  // function AAprove (address theowner) public returns(address Govern){
  //   require (Funder[theowner].contract_addr == msg.sender);
  //   Govern = owner;
  // }

  function getLength () view public returns(uint len){
    len = Funder_addrlist.length;
  }
  
  function getAAFunder () view public returns(address[] memory list){
    list = Funder_addrlist;
  }

  function AAornot(address AAaddr) view public returns(bool res){
    if (Funder[AAaddr].credit>60){
      res = true;
    }

  } 
  //在web端显示
  function showFunder (uint index_out) view public returns(address showaddr, string memory showname, int8 showcredit) {
    showaddr = Funder_addrlist[index_out];
    showname = Funder[showaddr].shortname;
    //showcontract = Funder[showaddr].contract_addr;
    showcredit = Funder[showaddr].credit;
  } 
  //一般人调用可以查看STU是否加入网络，AA机构调用可加入新的STU
  function AccessSTU (address STUaddr) public returns(bool res){
    bool exist = false;
    bool AddorCheck = false;
    for(uint j = 0;j<STU_addrlist.length;j++){
      if (STU_addrlist[j] == STUaddr){
        exist = true;
        break;
      }
    }
    for(uint i = 0;i<Funder_addrlist.length;i++){
      if (msg.sender == Funder_addrlist[i]){
        AddorCheck = true;
        if(!exist){
          STU_addrlist.push(STUaddr);
        }
        break;
      }
    }
    if (!AddorCheck){
      if (exist){
        res = true;
      }
    }
  }
  
  function Shield(address sender, bool blackin) public returns(bool res, uint _times){
    uint i;
    for(i = 0;i<Sender_addrlist.length;i++){
        if(sender == Sender_addrlist[i] ){
            if(msg.sender ==owner){
                callbacktime[sender].blackornot = blackin;
                res = callbacktime[sender].blackornot;
                _times = callbacktime[sender].times;
            }else{
                res = callbacktime[sender].blackornot;
                _times = callbacktime[sender].times;
            }
            break;
        }
    }
    if (i == Sender_addrlist.length){
        callbacktime[sender] = MAYblack(blackin, 0);
    }
    
  }
  
  function Notice(bytes32 certhash, address CAaddr, address AAaddr, address sender) public returns (bool res){
    uint j;
    for(uint i = 0;i<STU_addrlist.length;i++){
        if (msg.sender == STU_addrlist[i]){
            for(j = 0;j<Sender_addrlist.length;j++){
                if(sender == Sender_addrlist[j]){
                    break;
                }
            }
            if(j == (Sender_addrlist.length)){
                callbacktime[sender] = MAYblack(false, 1);
                Sender_addrlist.push(sender);
                emit InspectNotice(certhash, msg.sender, CAaddr, AAaddr);
            }else{
                if(!callbacktime[sender].blackornot){
                    res = true;
                    emit InspectNotice(certhash, msg.sender, CAaddr, AAaddr);
                    (callbacktime[sender].times)++;
                }
                else{
                    res = false;
                }
            }
            break;
        }
    }
  }



 // function search4cert () view public returns(bool res){
    
 // }
}









