pragma solidity ^0.6.4;
/**
 * The ETR_STU contract does this and that...
 */
contract ETR_STU {
  int8 score;
  int8 AAcredit;
  uint8 numSigned = 0;
  uint8[3] Loss = [5,10,15];
  address AAaddr;
  address public owner;
  string name;
  bool[] signedYet;
  address[] AA_list;

  constructor(address addr, string memory _name) public { 
    owner = msg.sender;
    AAaddr = addr;
    name = _name;
  }
  
  function InitScore(int8 _score, int8 _AAcredit) public{
    require(msg.sender == AAaddr);
    score = _score;
    AAcredit = _AAcredit;
  }
  
  function InitSignature () public{
    //require (msg.sender == AAaddr);
    address TOPaddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;//ETR_AA's address
    ETR_AA etr_aa = ETR_AA(TOPaddr);
    AA_list = etr_aa.getAAFunder();
    for(uint i = 0;i < AA_list.length;i++){
      signedYet.push(false);
    }
  }
  
  function Signature () public returns(uint8 number){
    for (uint i = 0;i < AA_list.length;i++){
      if (msg.sender == AA_list[i] && msg.sender != AAaddr && signedYet[i] == false){
        signedYet[i] = true;
        numSigned++;
        break;
      }
    }
    number = numSigned;
  }
  //三个AA签名成功后，进行对此CA和对用的AA重新评分，STUornot为真时，对学生证书进行状态调整
  function Inspect (int8 sign, uint8 extent, int8 newscore, bool STUornot, address STUaddr, int8 shapechange, bytes32 certhash) public returns(bool res){
    ETR_CA etr_ca = ETR_CA(AAaddr);
    if (numSigned>=3){
        res = true;
      for(uint i = 0;i < AA_list.length;i++){
        if (msg.sender == AA_list[i] && msg.sender!=AAaddr && signedYet[i] ==true){
            numSigned = 0;
            if(sign!=0){
              etr_ca.AACAchange(sign, Loss[extent], newscore);
              (score, AAcredit) = etr_ca.getmyinfo();
              
            }
          for (uint j = 0;j < AA_list.length;j++){
                signedYet[j] = false;
          }
                if(STUornot){
                    STU_SELF self = STU_SELF(STUaddr);
                    self.EnsureCert(shapechange, certhash);
                }
          break;
        }
      }
    }else{
        res = false;
    }
  }
  
  function ShowCredit() view public returns(address showaddr,int8 showscore, int8 showcredit, string memory showname){
    showname = name;
    showscore = score;
    showcredit = AAcredit;
    showaddr = AAaddr;
  }

  function Access (address STUaddr) public{
    require (msg.sender == owner);
    ETR_CA etr_ca = ETR_CA(AAaddr);
    etr_ca.CAAccess(STUaddr);
  }
  // CA发放证书函数，hash值由swarm得出，将证书保存在swarm中
  function Grant (address STUaddr, bytes32 certhash) public returns(bool res){
    require (msg.sender == owner);
    STU_SELF self = STU_SELF(STUaddr);
    res = self.GetCert(AAaddr, AAcredit, score, certhash);
  }
  
  function Revocation(address STUaddr, bytes32 certhash) public returns(bool res){
      require(msg.sender == owner);
      STU_SELF self = STU_SELF(STUaddr);
      res = self.BeRevoked(certhash);
  }

}


interface ETR_CA {
  function getmyinfo() view external returns(int8 yourscore, int8 myownercredit);
  function AACAchange (int8 sign, uint8 losscredit, int8 newscore) external;
  function CAAccess (address STUaddr) external;
}

interface ETR_AA {
    function getAAFunder() view external returns(address[] memory list);
}

interface STU_SELF{
  function EnsureCert(int8 shapechange, bytes32 certhash) external;
  function GetCert(address AAaddr, int8 AAcredit, int8 CAscore, bytes32 certhash) external returns(bool res);
  function BeRevoked(bytes32 certhash) external returns(bool res);
  
}
