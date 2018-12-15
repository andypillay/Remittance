pragma solidity 0.4.24;

contract Remittance {
    
    uint constant oneyearblocks = 365 * 86400 / 15;

    struct Puzzle {
        uint256 balance;
        uint256 lastblock;
        bytes32 encyptedPw;
    }

    mapping (address=>Puzzle) public puzzle;

    event LogSendFund(
        address indexed sender,
        bytes32 indexed hashedpw,
        uint balance,
        uint lastBlock
    );

    function hashPasswords (address sender, bytes32 pw1, bytes32 pw2) public view returns (bytes32) { 
        return keccak256(abi.encodePacked(this, sender, pw1, pw2));
    }
    

    function sendFunds (address sender, bytes32 hashedpw, uint blockDuration) public payable returns (bool) {
        require(msg.value > 0, "msg.value should be greater than 0");
        require(puzzle[sender].balance == 0, "puzzle balance should be equals 0");
        require(blockDuration > 0, "block number should be more than 0");
        require(block.number < puzzle[sender].lastblock);
        require(blockDuration <= oneyearblocks, "block duration should be less than the 2,102,400");

        uint lastblock = block.number + blockDuration;
        puzzle[sender].balance = msg.value;
        puzzle[sender].lastblock = lastblock;
        puzzle[sender].encyptedPw = hashedpw;

        emit LogSendFund (msg.sender, hashedpw, msg.value, blockDuration);

        return true;
    }

}