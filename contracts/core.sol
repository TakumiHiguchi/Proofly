//Crypto Proof Source code
//author: Takumi Higuchi ()

pragma solidity ^0.6.2;

contract control {

    address public owner;
    
    int public totalPoint;
    
    struct Permission{
        bool transferOfPointFromEtheuserToEtheuser;
        bool transferOfPointFromEtheuserToOuser;
        int PtoPFeeE;
        int PtoPFeeO;
    }
    Permission permission;
    
    constructor() public{
      owner = msg.sender;
      permission.transferOfPointFromEtheuserToEtheuser = true;
      permission.transferOfPointFromEtheuserToOuser = true;
      permission.PtoPFeeE = 0;
      permission.PtoPFeeO = 0;
      
      
    }
    
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

}


contract base is control{

    /*
    * User
    */
    //ユーザーには、①Ethereumアドレスを用いて作成するアカウント。②ownerが作成するアカウント。の2つの種類があります。
    //それぞれのユーザーの権限や構造体の中のメンバの詳細については、Crypto Proofのdeveloper referenceをご確認ください。
    
    struct User{
        string name;
        string description;
        int score;
        uint activityAmount;
        uint lastActivityTime;
    }
    
    
    struct UserCount{
        uint Euser;
        uint Ouser;
    }
    
    mapping (address=>User) public users;
    
    User[] public ousers;
    
    UserCount count;
    

    

    
    
    /*
    * Point
    */
    string private _pointName = "branchPoint";
    string private _pointSymbol = "BRP";

    mapping (address=>int256) public userPointBalance;
    mapping (uint256=>int256) public ouserPointBalance;
    

    /*
    * User
    */
    function createNewuserE(string memory _name,string memory _description) public payable{
        require(users[msg.sender].lastActivityTime == 0);
        require(bytes(_name).length < 50);
        require(bytes(_description).length < 300);
        
        users[msg.sender]=User(_name,_description,0,0,block.timestamp);
        userPointBalance[msg.sender] = 0;
        
        count.Euser++;
    }

    function updateNameE(string memory _name) public payable{
        require(bytes(_name).length < 50);
        
        users[msg.sender].name = _name;
    }

    function updateDescriptionE(string memory _description) public payable{
        require(bytes(_description).length < 300);
        
        users[msg.sender].description = _description;
    }

    function showUser() public view returns(string memory,string memory,uint){
        return(users[msg.sender].name,users[msg.sender].description,users[msg.sender].lastActivityTime);
    }
    
    function showOuser(uint _id) public view returns(string memory,string memory,uint){
        return(ousers[_id].name,ousers[_id].description,ousers[_id].lastActivityTime);
    }

    function showUserCount() public view returns(uint,uint){
        return(count.Euser,count.Ouser);
    }


    //--onlyOwner
    function createNewuserO(string memory _name,string memory _description) public payable onlyOwner{
        require(bytes(_name).length < 50);
        require(bytes(_description).length < 300);
        
        ousers.push( User(_name,_description,0,0,block.timestamp) );
        count.Ouser++;
        ouserPointBalance[count.Ouser-1] = 0;
    }
    
    function updateScoreE(address _for,int _score) public payable onlyOwner{
        users[_for].score += _score;
    }

    function updateActivityAmountE(address _for,uint _activityAmount) public payable onlyOwner{
        users[_for].activityAmount += _activityAmount;
    }
    function updateScoreO(uint _for,int _score) public payable onlyOwner{
        ousers[_for].score += _score;
    }

    function updateActivityAmountO(uint _for,uint _activityAmount) public payable onlyOwner{
        ousers[_for].activityAmount += _activityAmount;
    }

    function updateNameO(uint _for,string memory _name) public payable onlyOwner{
        require(bytes(_name).length < 50);
        
        ousers[_for].name = _name;
    }

    function updateDescriptionO(uint _for,string memory _description) public payable onlyOwner{
        require(bytes(_description).length < 300);
        
        ousers[_for].description = _description;
    }

    
    
    /*
    * Point
    */
    
    function showPointBalance(address _for) public view returns(int){
        return(userPointBalance[_for]);
    }
    
    function showOuserPointBalance(uint _id) public view onlyOwner returns(int){
        return(ouserPointBalance[_id]);
    }
    
    function transferOfPointFromEToE(address _for,int _amount) public payable{
        require(permission.transferOfPointFromEtheuserToEtheuser);
        require(users[_for].lastActivityTime > 0 && users[msg.sender].lastActivityTime > 0);
        require(_amount > 0 && userPointBalance[msg.sender] >= _amount);
        
        userPointBalance[msg.sender] -= _amount;
        userPointBalance[_for] += (_amount - permission.PtoPFeeE);
        userPointBalance[owner] += permission.PtoPFeeE;
        
        users[msg.sender].lastActivityTime = block.timestamp;
    }
    
    function transferOfPointFromEToO(uint _for,int _amount) public payable{
        require(permission.transferOfPointFromEtheuserToOuser);
        require(ousers[_for].lastActivityTime > 0 && users[msg.sender].lastActivityTime > 0);
        require(_amount > 0 && userPointBalance[msg.sender] >= _amount);
        
        userPointBalance[msg.sender] -= _amount;
        ouserPointBalance[_for] += (_amount - permission.PtoPFeeE);
        userPointBalance[owner] += permission.PtoPFeeE;
        
        users[msg.sender].lastActivityTime = block.timestamp;
    }
    
    
    
    //--onlyOwner
    
    function changePointE(address _for,int _amount) public payable onlyOwner{
        require(users[_for].lastActivityTime > 0);
        
        userPointBalance[_for] += _amount;
        totalPoint += _amount;
    }
    
    function changePointO(uint _for,int _amount) public payable onlyOwner{
        require(ousers[_for].lastActivityTime > 0);
        
        ouserPointBalance[_for] += _amount;
        totalPoint += _amount;
    }
    
    function transferOfPointFromOToO(uint _for,uint _from,int _amount) public payable onlyOwner{
        require(ousers[_for].lastActivityTime > 0 && ousers[_from].lastActivityTime > 0);
        require(_amount > 0 && ouserPointBalance[_from] >= _amount);
        
        ouserPointBalance[_from] -= _amount;
        ouserPointBalance[_for] += (_amount - permission.PtoPFeeO);
        userPointBalance[owner] += permission.PtoPFeeO;
        
        ousers[_from].lastActivityTime = block.timestamp;
    }
    
    function transferOfPointFromOToE(address _for,uint _from,int _amount) public payable onlyOwner{
        require(users[_for].lastActivityTime > 0 && ousers[_from].lastActivityTime > 0);
        require(_amount > 0 && ouserPointBalance[_from] >= _amount);
        
        ouserPointBalance[_from] -= _amount;
        userPointBalance[_for] += (_amount - permission.PtoPFeeO);
        userPointBalance[owner] += permission.PtoPFeeO;
        
        ousers[_from].lastActivityTime = block.timestamp;
    }
    
    
    
    
    
}
