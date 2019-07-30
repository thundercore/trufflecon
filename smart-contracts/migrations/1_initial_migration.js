var Migrations = artifacts.require('./Migrations.sol')
var Double = artifacts.require('./DoubleOrNothing.sol')

module.exports = function(deployer) {
  deployer.deploy(Migrations)
  deployer.deploy(
    Double,
    1000, // decimals
    30, // referral bonus
    86400, // secondsUntilInactive
    true, // onlyRewardActiveReferrers
    [600, 200, 100], // levelRate
    [1, 500, 5, 750, 25, 1000], // refereeBonusRateMap
  )
}
