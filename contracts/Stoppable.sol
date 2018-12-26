pragma solidity 0.4.24;

import "./Ownable.sol";


contract Stoppable is Ownable {

    bool public running;

    event LogPause(address sender);
    event LogResume(address sender);

    modifier onlyIfRunning {
        require(running);
        _;
    }

    constructor () public {
        running = true;
    }

    function pause() public onlyOwner returns(bool success){
        require(running);
        emit LogPause(msg.sender);
        running = false;
        return true;
    }

    function resume() public onlyOwner returns(bool success){
        require(!running);
        emit LogResume(msg.sender);
        running = true;
        return true;
    }

}