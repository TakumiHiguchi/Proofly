//Proof Source code
//author: Takumi Higuchi ()

pragma solidity ^0.6.2;

contract control {

    address public owner;
    
    int public totalPoint;
    
    struct Permission{
        bool transferOfPoint;
        uint transferFee;
        uint workTransferFee;
        uint maxTypeId;
    }
    
    Permission permission;
    
    constructor() public{
      owner = msg.sender;
      permission.transferOfPoint = true;
      permission.transferFee = 0;
      permission.workTransferFee = 0;
      permission.maxTypeId = 0;
      
      
    }
    
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }
    

}

contract Core is control{

    struct Work {
        string workhash;
        string author;
        uint8 types;
        uint8 status;
        uint publishingtime;
    }
    //status 0:未承認,1:承認済み公開 2:承認済み非公開
    Work[] works;
    
    uint workCount;
    
    mapping (uint => address) public workIndexToOwner;
    mapping (string => uint256) public workIdToWorkIndex;
    
    
    
    /*
    * Work関数
    */
    function createNewWork(string memory _workhash, string memory _author, uint8 _type, uint8 _agree) public payable returns(uint){
        require(_type <= permission.maxTypeId, "Error: This type is not defined.");
        require(workIdToWorkIndex[_workhash] == 0, "Error: This work already exists.");
        require(_agree == 1, "Error: You have not accepted the terms.");
        
        works.push( Work(_workhash,_author,_type,0,block.timestamp) );
        
        //インデックスとidを紐付ける
        workIdToWorkIndex[_workhash] = workCount;
        
        //インデックスを所有者に
        workIndexToOwner[workCount] = msg.sender;
        
        workCount++;
        
        return(block.timestamp);
    }
    
    function showWorkDetails(string memory _workhash) public view returns(uint,string memory,address,string memory,uint8,uint8,uint){
        uint workId = workIdToWorkIndex[_workhash];
        require(workId == 0, "Error: This work does not exist.");
        address workOwner = workIndexToOwner[workId];
        
        return(
            workId,
            works[workId].workhash,
            workOwner,
            works[workId].author,
            works[workId].types,
            works[workId].status,
            works[workId].publishingtime
        );
    }
    

    
    function updateStatus(string memory _workhash,uint8 _status) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(_status <= 2, "Error: This status is not defined.");
        require(workOwner == msg.sender, "Error: You are not the owner of this work.");
        
        works[workId].status = _status;
    }
    
    function buyWork(string memory _workhash) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(workOwner != msg.sender, "Error: You are the owner of this work.");
        require(works[workId].status == 1 || works[workId].status == 3, "Error: This work is not for sale.");
        
        
        //所有者の上書き
        workIndexToOwner[workId] = msg.sender;
    }
    
    
    function transferOfWork(address _for,string memory _workhash) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(workOwner == msg.sender, "Error: You are not the owner of this work.");
        
        //所有者の上書き
        workIndexToOwner[workId] = _for;
    }
    
    //onlyOwner
    
    function activateWork(string memory _workhash,uint8 _status) public payable onlyOwner{
        uint workId = workIdToWorkIndex[_workhash];
        works[workId].status = _status;
    }
    
//書き換えと削除の関数追加
}


