pragma solidity 0.4.24;

contract Ownable {

    address public owner;

    event LogNewOwner(address sender, address oldOwner, address newOwner);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor () public {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) public onlyOwner
    returns(bool success)
    {
        emit LogNewOwner(msg.sender, owner, newOwner);
        owner = newOwner;
        return true;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == owner;
    }

}