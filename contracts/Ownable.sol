pragma solidity ^0.4.24;


contract Ownable {

    address public owner;

    event LogNewOwner(address sender, address oldOwner, address newOwner);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) public onlyOwner
    returns(bool success)
    {
        LogNewOwner(msg.sender, owner, newOwner);
        owner = newOwner;
        return true;
    }

    function getOwner() public view returns(address) {
        return _owner;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }

}