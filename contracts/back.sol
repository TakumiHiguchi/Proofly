//Crypto Proof Source code
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

    string public _pointName = "branchPoint";
    string public _pointSymbol = "BRP";

    mapping (address=>uint256) public PointBalance;

    struct Work {
        string workhash;
        uint32 fee;
        uint32 transferFee;
        uint8 types;
        uint8 status;
        uint publishingtime;
    }
    //status 0:未承認,1:承認済みpublish 2:承認済み公開だが購入不可、3:非公開だが購入可、4日公開で購入不可
    Work[] works;
    
    uint workCount;
    
    mapping (uint => address) public workIndexToOwner;
    mapping (string => uint256) public workIdToWorkIndex;
    
    
    /*
     * Point関数
     */
    function showPointBalance(address _for) public view returns(uint){
        return(PointBalance[_for]);
    }
    
    function transferOfPoint(address _for,uint _amount) public payable{
        require(permission.transferOfPoint);
        require(_amount > 0 && PointBalance[msg.sender] >= _amount);
        
        PointBalance[msg.sender] -= _amount;
        PointBalance[_for] += (_amount - permission.transferFee);
        PointBalance[owner] += permission.transferFee;
    }
    
    
    
    /*
    * Work関数
    */
    function createNewWork(string memory _workhash,uint32 _fee,uint32 _transferfee,uint8 _type) public payable{
        require(_type <= permission.maxTypeId, "Error: This type is not defined.");
        require(workIdToWorkIndex[_workhash] == 0, "Error: This work already exists.");
        
        works.push( Work(_workhash,_fee,_transferfee,_type,0,block.timestamp) );
        
        //インデックスとidを紐付ける
        workIdToWorkIndex[_workhash] = workCount;
        
        //インデックスを所有者に
        workIndexToOwner[workCount] = msg.sender;
        
        workCount++;
    }
    
    function showWorkDetails(string memory _workhash) public view returns(uint,string memory,address,uint32,uint32,uint8,uint8,uint){
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        return(
            workId,
            _workhash,
            workOwner,
            works[workId].fee,
            works[workId].transferFee,
            works[workId].types,
            works[workId].status,
            works[workId].publishingtime
        );
    }
    
    function updateWorkFee(string memory _workhash,uint32 _fee) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(workOwner == msg.sender, "Error: You are not the owner of this work.");
        
        works[workId].fee = _fee;
    }
    
    function updateTransferFee(string memory _workhash,uint32 _fee) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(workOwner == msg.sender, "Error: You are not the owner of this work.");
        
        works[workId].transferFee = _fee;
    }
    
    function updateStatus(string memory _workhash,uint8 _status) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(_status <= 4, "Error: This status is not defined.");
        require(workOwner == msg.sender, "Error: You are not the owner of this work.");
        
        works[workId].status = _status;
    }
    
    function buyWork(string memory _workhash) public payable{
        uint workId = workIdToWorkIndex[_workhash];
        address workOwner = workIndexToOwner[workId];
        
        require(workOwner != msg.sender, "Error: You are the owner of this work.");
        require(works[workId].status == 1 || works[workId].status == 3, "Error: This work is not for sale.");
        require(PointBalance[msg.sender] >= (works[workId].transferFee + permission.workTransferFee));
        
        
        
        PointBalance[msg.sender] -= (works[workId].transferFee + permission.workTransferFee);
        PointBalance[workOwner] += works[workId].transferFee;
        PointBalance[owner] += permission.workTransferFee;
        
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



