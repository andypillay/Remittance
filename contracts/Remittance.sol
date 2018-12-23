pragma solidity 0.4.24;

import "./Stoppable.sol";

contract Remittance is Stoppable {
    
    uint public balance;
    uint constant oneyearblocks = 365 * 86400 / 15;

    struct Puzzle {
        uint balance;
        uint lastblock;
        bytes32 encyptedPw;
    }

    mapping (address=>Puzzle) public puzzles;

    event LogSendFund(
        address indexed sender,
        bytes32 indexed hashedpw,
        uint balance,
        uint lastblock
    );

    event LogWithdraw(
        address indexed sender,
        uint balance
    );

    event LogRefund(
        address indexed sender,
        address remitter,
        uint amount
    );

    function hashPasswords (address sender, bytes32 pw1, bytes32 pw2) public view returns (bytes32) { 
        return keccak256(abi.encodePacked(this, sender, pw1, pw2));
    }
    

    function sendFunds (address sender, bytes32 hashedpw, uint blockDuration) public payable onlyOwner onlyIfRunning returns (bool) {
        require(msg.value > 0, "msg.value should be greater than 0");
        require(puzzles[sender].balance == 0, "puzzles balance should be equals 0");
        require(blockDuration > 0, "block number should be more than 0");
        require(blockDuration <= oneyearblocks, "block duration should be less than the 2,102,400");

        uint lastblock = block.number + blockDuration;
        puzzles[sender].balance = msg.value;
        puzzles[sender].lastblock = lastblock;
        puzzles[sender].encyptedPw = hashedpw;

        emit LogSendFund(msg.sender, hashedpw, msg.value, blockDuration);

        return true;
    }

    function withdraw (bytes32 pw1, bytes32 pw2) public returns onlyIfRunning (bool) {
        require(pw1.length > 0 || pw2.length > 0 , "password must not be empty");
        require(puzzles[msg.sender].encyptedPw == hashPasswords(msg.sender,pw1,pw2), "Incorrect pw");

        uint balance = puzzles[msg.sender].balance;
        uint lastBlock = puzzles[msg.sender].lastblock;

        require(balance > 0, "Balance must be greater than 0");
        require(block.number <= lastBlock, "Withdraw deadline");

        delete puzzles[msg.sender];

        emit LogWithdraw(msg.sender, balance);
        msg.sender.transfer(balance);

        return true;
    }

    function refund (address remitter) public onlyOwner onlyIfRunning returns (bool success) {
        require(puzzles[remitter].balance > 0 );
        require(puzzles[remitter].lastblock <= block.number);
        uint256 refundAmount;
        refundAmount = puzzles[remitter].balance;
        puzzles[remitter].balance = 0;
        balance -= refundAmount;
        owner.transfer(refundAmount);

        emit LogRefund(msg.sender, remitter, refundAmount);
        return true;
    }

}