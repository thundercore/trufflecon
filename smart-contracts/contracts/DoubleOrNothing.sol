pragma solidity 0.5.0;

import '@thundercore/referral-solidity/contracts/Referral.sol';
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract DoubleOrNothing is Ownable, Referral {

    event BetSettled(address player, uint256 winnings);

    constructor(
        uint _decimals,
        uint _referralBonus,
        uint _secondsUntilInactive,
        bool _onlyRewardActiveReferrers,
        uint256[] memory _levelRate,
        uint256[] memory _refereeBonusRateMap
    ) Referral(
        _decimals,
        _referralBonus,
        _secondsUntilInactive,
        _onlyRewardActiveReferrers,
        _levelRate,
        _refereeBonusRateMap
    ) public {}

    function bet(address payable _referrer) payable external {
        if(!hasReferrer(msg.sender)) {
            addReferrer(_referrer);
        }
        bet();
    }

    // value transfer tx based bet.
    function bet() payable public {
        // msg.value is added to the balance to begin with so you need to double it
        require(msg.value * 2 <= address(this).balance, 'Balance too low!');
        uint256 winnings = 0;

        // DO NOT USE THIS IN PRODUCTION, IT IS INSECURE
        if(uint256(blockhash(block.number -1)) % 2 == 0) {
            // 3% is deducted to cover the referral bonus
            winnings = msg.value * 197/100;
            address(msg.sender).transfer(winnings);
        }

        payReferral(msg.value);
        emit BetSettled(msg.sender, winnings);
    }

    function withdraw(uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, 'Balance too low!');
        address payable owner = address(uint160(owner()));
        owner.transfer(_amount);
    }

    // This fallback function eats all funds and gas sent to it.
    // The owner can withdraw from the contract balance via `withdraw` above.
    function() external payable {}
}
