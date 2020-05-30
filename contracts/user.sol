//Crypto Proof Source code
//author: Takumi Higuchi ()

pragma solidity ^0.6.2;

contract control {

    address public owner;
    
    struct Permission{
        bool transferFromPointToPoint;
        bool transferFromPointToCoin;
        bool transferFromCoinToPoint;
        bool transferFromCoinToCoin;
    }
    Permission permission;
    
    constructor() public{
      owner = msg.sender;
      permission.transferFromPointToPoint=true;
      permission.transferFromPointToCoin=true;
      permission.transferFromCoinToPoint=true;
      permission.transferFromCoinToCoin=true;
    }
    
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

}

contract point is control{
    string private _pointName = "branchPoint";
    string private _pointSymbol = "BRP";

    mapping (address=>int256) public userPointBalance;
    mapping (uint256=>int256) public ouserPointBalance;
    
    function showPointBalance() public view returns(int){
        return(userPointBalance[msg.sender]);
    }
    
    function showOuserPointBalance(uint _id) public view onlyOwner returns(int){
        return(ouserPointBalance[_id]);
    }
    
    function changePoint(address _for,int _amount) public payable onlyOwner{
        require(userPointBalance[_for] != 0);
        
        userPointBalance[_for] += _amount;
    }
    

    
    
}


contract coin is point{
    string private _coinName = "branchCoin";
    string private _coinSymbol = "BRC";
    
    mapping (address=>uint256) public userBalance;
    mapping (uint256=>uint256) public ouserBalance;
    
    function showBalance() public view returns(uint){
        return(userBalance[msg.sender]);
    }
    
    function showOuserBalance(uint _id) public view onlyOwner returns(uint){
        return(ouserBalance[_id]);
    }
    
    
}

contract user is coin{
    //ユーザーには、①Ethereumアドレスを用いて作成するアカウント。②ownerが作成する閲覧のみのアカウント。③ownerが作成する販売まで行うことができるアカウントの3つの種類があります。
    //それぞれのユーザーの権限や構造体の中のメンバの詳細については、Crypto Proofのdeveloper referenceをご確認ください。
    
    struct User{
        string name;
        string description;
        int score;
        uint activityAmount;
        uint lastActivityTime;
    }
    
    mapping (address=>User) public users;
    
    function createNewuser(string memory _name,string memory _description) public payable{
        require(userBalance[msg.sender] == 0);
        require(bytes(_name).length < 50);
        require(bytes(_description).length < 300);
        
        users[msg.sender]=User(_name,_description,0,0,block.timestamp);
        userBalance[msg.sender] = 0;
        userPointBalance[msg.sender] = 0;
    }
    
    function updateName(string memory _name) public payable{
        require(bytes(_name).length < 50);
        
        users[msg.sender].name = _name;
    }
    
    function updateDescription(string memory _description) public payable{
        require(bytes(_description).length < 300);
        
        users[msg.sender].description = _description;
    }
    
    function updateScore(int _score) public payable onlyOwner{
        users[msg.sender].score += _score;
    }
    
    function updateActivityAmount(uint _activityAmount) public payable onlyOwner{
        users[msg.sender].activityAmount += _activityAmount;
    }
    
    function showUser() public view returns(string memory,string memory,uint){
        return(users[msg.sender].name,users[msg.sender].description,users[msg.sender].lastActivityTime);
    }
    
}
