pragma solidity 0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract DoubleOrNothing is Ownable {

    constructor() public {}

    // This fallback function eats all funds and gas sent to it.
    // The owner can withdraw from the contract balance via `withdraw` above.
    function() external payable {}
}