pragma solidity ^0.4.24;

import "./Ownable.sol";


contract Stoppable is Ownable {

    bool public running;

    event LogToggle(address sender, bool toggleSetting);

    modifier onlyIfRunning {
        require(running);
        _;
    }

    function Stoppable() public {
        running = true;
    }

    function flickToggler(bool onOff) public onlyOwner returns(bool success) {
        running = onOff;
        LogRunSwitch(msg.sender, onOff);
        return true;
    }

}