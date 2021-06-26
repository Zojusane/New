pragma solidity ^0.6.4;
/**
* this contract that every AA has one has to be the same name ETR_CA for function can search
by address. store the CA info and 
*/
contract ETR_CA{
  struct CAinfo{
    string shortname;
    //address CAcontract_addr;
    int8 CAscore;
  } 
  // store the all address mapping the message
  mapping (address => CAinfo) public Funder;
  address[] public CAContract_addr;
  // password for the right to store getting from the deploy-contract institution
  // string private password;
  // bool  validpassword = false;
  address public owner;
  address TOPaddr;//ETR_AA's address
  int8 credit;
  string name;
  bool public changeready;

  constructor(address _TOPaddr, string memory _name) public{
    owner = msg.sender;
    name = _name;
    credit = 100;
    TOPaddr =_TOPaddr;
  }

  // function setPassword_score (string memory val, uint checkscore) public{
  //  require (ow0xcD6a42782d230D7c13A74ddec5dD140e55499Df9ner == msg.sender); 
  //  password = val;
  //  validpassword = true;
  //  score2set = checkscore;
  // }

  function setFunder(string memory funder_name, address addressget, int8 score2set) public{
    require (owner == msg.sender && credit > 60 );
    bool newaccount = true;
    for(uint i = 0;i<CAContract_addr.length;i++){
      if (CAContract_addr[i] == addressget){
        newaccount = false;
        break;
      }
    }
    if (newaccount && score2set>60 && score2set<=100){
      Funder[addressget] = CAinfo(funder_name, score2set);
      CAContract_addr.push(addressget);
      ETR_STU etr_stu = ETR_STU(addressget);
      etr_stu.InitScore(score2set, credit);
    }
  }
  
  // function ChangeFunder (uint newscore, address changeaddr) public {
  //  require (owner == msg.sender);
  //  Funder[changeaddr].CA = newscore;
  // }
  
  function getLength () view public returns(uint len){
    len = CAContract_addr.length;
  }
  //CA get its score
  function getmyinfo () view public returns(int8 yourscore, int8 myownercredit){
    yourscore = Funder[msg.sender].CAscore;
    myownercredit = credit;
  }
  //AA可以添加一个属于自己的合约来操控自己的
  function getCAFunder () view public returns(address[] memory list){
    list = CAContract_addr;
  }
  
  function showFunder (uint index_out) view public returns(address showaddr, string memory showname, int8 showscore){
    showaddr = CAContract_addr[index_out];
    showname = Funder[showaddr].shortname;
    showscore = Funder[showaddr].CAscore;
  }

  function InitChange (address AAaddr) public{
    require(msg.sender == owner);
    bytes4 methodId = bytes4(keccak256("WillBeChanged()"));
    AAaddr.call(abi.encodeWithSelector(methodId));
    
  }

  function WillBeChanged () public returns(bool res){
    ETR_AA etr_aa = ETR_AA(TOPaddr); 
    if(etr_aa.AAornot(msg.sender)&& msg.sender!= owner){
      changeready = true;
      res = changeready;
    }
  }
  
  function AACAchange (int8 sign, uint8 losscredit, int8 newscore) public{
    require (Funder[msg.sender].CAscore!=0 && changeready);
    ETR_AA etr_aa = ETR_AA(TOPaddr);
    if (sign == -1){
        credit = credit - int8(losscredit);
    }else if(sign == 1){
        credit = credit + int8(losscredit);
    }
    if(credit>0 && credit<=100){
        etr_aa.AAcredit(credit);
    }
    if (newscore>0 && newscore<=100){
      Funder[msg.sender].CAscore = newscore;
    }
    changeready = false;
  }
  //  others can prove the CA is belonging to the network 
  function ProveCA (address CAaddr) view public returns(bool res){
    if(Funder[CAaddr].CAscore > 60){
      res = true;
    }
  }
  
  function CAAccess (address STUaddr) public{
    for(uint i = 0;i<CAContract_addr.length;i++){
      if (CAContract_addr[i] == msg.sender){
        ETR_AA etr_aa = ETR_AA(TOPaddr);
        etr_aa.AccessSTU(STUaddr);
        break;
      }
    }
  }
  
  function InitSignCA(address CAaddr) public{
    ETR_STU etr_stu = ETR_STU(CAaddr);
    etr_stu.InitSignature();
  }
  
  function SignCA(address CAaddr) public returns(uint8 number){ 
    require(msg.sender == owner);
    ETR_STU etr_stu = ETR_STU(CAaddr);
    number = etr_stu.Signature();
  }
  
  function InspectCA(bool STUornot,address STUaddr, int8 shapechange, bytes32 certhash, address CAaddr, int8 sign, uint8 extent, int8 newscore) public returns(bool res){
    require (msg.sender == owner);
    ETR_STU etr_stu = ETR_STU(CAaddr);
    res = etr_stu.Inspect(sign, extent, newscore, STUornot, STUaddr, shapechange, certhash);
  }

 // function search4cert () view public returns(bool res){
    
 // }  
}

interface ETR_AA {
  function AAcredit (int8 newcredit) external;
  function AccessSTU(address STUaddr) external returns(bool res); 
    function AAornot(address AAaddr) view external returns(bool res);
}

interface ETR_STU {
  function Signature() external returns(uint8 number);
  function Inspect (int8 sign, uint8 extent, int8 newscore, bool STUornot, address STUaddr, int8 shapechange, bytes32 certhash) external returns(bool res);
  function InitScore(int8 _score, int8 _AAcredit) external;
  function InitSignature() external;
}




