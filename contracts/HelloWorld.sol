//Crypto Proof Source code
//
pragma solidity ^0.6.2;

contract HelloWorld {
    
    struct obj {
        bytes32 contentid;
        uint readingfee;
        uint downloadfee;
        uint publishingtime;
        bool publish;
    }
     
    
    mapping (address=>obj) public objs;
    mapping (uint=>uint) public asd;
    
    constructor() public{
    }
    

    
    function addobj(string memory c,uint rf,uint df,uint pt,bool t) public payable{
        objs[msg.sender] = obj(keccak256(abi.encodePacked(keccak256(abi.encodePacked(c)))),rf,df,pt,t);
        asd[1]=1000;
    }
    function showobj() public view returns(bytes32,uint,uint,uint,bool){
        return(objs[msg.sender].contentid,objs[msg.sender].readingfee,objs[msg.sender].downloadfee,objs[msg.sender].publishingtime,objs[msg.sender].publish);
    }
    function sh(uint _ru) public view returns(uint){
        return asd[_ru];
    }
}

contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public{
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}
struct obj {
    bytes32 contentid;
    uint readingfee;
    uint downloadfee;
    uint publishingtime;
    bool publish;
}


mapping (address=>uint256) public userBalance;
