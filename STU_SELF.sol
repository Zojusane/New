pragma solidity ^0.6.4;
/**
 * The STU_SELFcontract does this and that...
 */
contract STU_SELF{
  string public name;
  address  public owner;
  address changer;
  bytes32[] certhash_list;
  bool Getornot;
  struct Shapeofcert{
    int8 shape;
    int8 AAcredit;
    int8 CAscore;
    bool rightto;
    address AAaddr;
    address CAaddr;
  }
  mapping(bytes32=>Shapeofcert) Cert;
  event InspectNotice(bytes32 certhash, address addrSTU, address addrCA, address addrAA);    
  constructor(string memory _name) public{
    name = _name;
    owner = msg.sender;    
  }

  function GetCert (address AAaddr, int8 AAcredit, int8 CAscore, bytes32 certhash) public returns(bool res) {
    uint i;
    address TOPaddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    ETR_AA etr_aa = ETR_AA(TOPaddr);
    if (etr_aa.AAornot(AAaddr)){
      ETR_CA etr_ca = ETR_CA(AAaddr);
      if(etr_ca.ProveCA(msg.sender)){
        for(i=0; i<certhash_list.length;i++){
            if(certhash == certhash_list[i]){
                break;
            }
        }
        if(i == certhash_list.length){
            certhash_list.push(certhash);
            Cert[certhash] = Shapeofcert(1, AAcredit, CAscore, false, AAaddr, msg.sender);
            res = true;
        }  
      }
    }
  }
  
  function Refercert () view public returns(bytes32[] memory certlist){
    certlist = certhash_list;
  }

  function Refercertshape(bytes32 certhash) view public returns(int8 shape, int8 AAcredit, int8 CAscore, address AAaddr, address CAaddr){
    shape = Cert[certhash].shape;
    AAcredit = Cert[certhash].AAcredit;
    CAscore = Cert[certhash].CAscore;
    AAaddr = Cert[certhash].AAaddr;
    CAaddr = Cert[certhash].CAaddr;
  }
  
  function BeRevoked(bytes32 certhash) public returns(bool res){
    if(Cert[certhash].CAaddr == msg.sender && !Cert[certhash].rightto){
        delete Cert[certhash];
        for(uint i=0;i<certhash_list.length;i++){
            if (certhash ==certhash_list[i]){
                certhash_list[i]=bytes32(0);
            }
        }
        res = true;
    }else{
        res = false;
    }
  }
  
  function GiveRight (address Entepraddr, bytes32[] memory certlist) public returns(bool res){
    require (msg.sender == owner);
    changer = Entepraddr;
    for(uint i = 0; i<certlist.length; i++){
        if(Cert[certlist[i]].shape == 1){
            Cert[certlist[i]].rightto = true;
            res = true;
        }else
        {
            res = false;
        }
    }
  }
  
  function TestRight () view public returns(bool res){
    require(msg.sender == changer);
    res = true;
  }
  
  function ChangeCert(bytes32[] memory certlist) public returns(bool cannot){
    address TOPaddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    require(msg.sender == changer);
    ETR_AA etr_aa = ETR_AA(TOPaddr);
    bytes32 certhash;
    for(uint i = 0; i<certlist.length; i++){
        certhash = certlist[i];
        if (Cert[certhash].shape == 1 &&Cert[certhash].rightto){
            if(etr_aa.Notice(certhash, Cert[certhash].CAaddr,Cert[certhash].AAaddr, msg.sender)){
                Cert[certhash].shape = 2;
                changer = address(0);
            }
        }else{
            cannot = true;
        }
    }
  }

  function EnsureCert(int8 shapechange, bytes32 certhash) public{
    require (msg.sender == Cert[certhash].CAaddr);
    if (shapechange == 2){
        Cert[certhash].shape = shapechange;
    }
    if (shapechange == 0){
      delete Cert[certhash];
    }
  }
}

interface ETR_AA{
    function AAornot(address AAaddr) view external returns(bool res);
    function Notice(bytes32 certhash, address CAaddr, address AAaddr, address sender) external returns(bool res);
}
interface ETR_CA{function ProveCA (address CAaddr) view external returns(bool res);}

