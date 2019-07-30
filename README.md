# TruffleCon 2019

[DoubleOrNothing](https://jiang-yifan.github.io) is a coin flip game built on Thunder.

## Development

### Setup
* `node` LTS Carbon (`8.x.x`) or Dubnium (`10.x.x`)
* Install packages: `cd` into `smart-contracts` and `frontend` and run `yarn install` (or `npm install` if you don't have `yarn`)

### Smart Contracts

This project uses [Truffle](https://www.trufflesuite.com) to handle all of the smart contract related work.

In the `/smart-contracts/contracts` folder, you will find `DoubleOrNothing.sol` which contains the game logic. After you make any updates to it, you will have to redeploy the contract:
`yarn migrate --network thunder --reset` or `npm run migrate -- --network thunder --reset`

The example above uses the `thunder` network; also available is `development` (which points to localhost, useful for interacting with [Ganache](https://www.trufflesuite.com/ganache)) and `thunderTestnet` which points to our testnet.

To deploy on `thunder` or `thunderTestnet`, you _must_ add a mnemonic to `/smart-contracts/truffle-config.js` for the network config you want to use.

### Frontend

The frontend was built using [create-react-app](https://github.com/facebook/create-react-app) with [Typescript](https://www.typescriptlang.org/).
To interact with the chain, we use [Ethers.js](https://docs.ethers.io/ethers.js/html/).

To start the frontend, `cd` into `frontend` and run `yarn start`.

### Helpful Content

* [Thunder's _trusted_ random number generation code](https://github.com/thundercore/RandomLibrary)
 ```  
  library LibThunderRNG {
      function rand() internal returns (uint256) {
          uint256[1] memory m;
          assembly {
              if iszero(call(not(0), 0x8cC9C2e145d3AA946502964B1B69CE3cD066A9C7, 0, 0, 0x0, m, 0x20)) {
                  revert(0, 0)
              }
          }
          return m[0];
      }
  }
  ```
* Stablecoin ERC677 smart contracts
  * TT-USDT Testnet: `0x42532085e51e5618575005f626589ff57d280d68`
  * TT-DAI Testnet: `0xd60db41a718a73da844a4c454c8bd6e07173d722`
  * TT-USDT Mainnet: `0x2b31e3b88847f03c1335E99A0d1274A2c72059DE`
  * TT-DAI Mainnet: `0x4f3C8E20942461e2c3Bdd8311AC57B0c222f2b82`
* `Referral` contract demo parameters [(find the library here)](https://github.com/thundercore/referral-solidity)
```
    1000, // decimals
    30, // referralBonus
    86400, // secondsUntilInactive
    true, // onlyRewardActiveReferrers
    [600, 200, 100], // levelRate
    [1, 500, 5, 750, 25, 1000] // referreeBonusRateMap
```
* Helpful interfaces (for plugging into [Remix](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.5.1+commit.c8a2cb62.js&appVersion=0.7.7))
  * ERC677
  ```
      // We import our ERC20 interface from OpenZeppelin
      contract ERC677 is ERC20 {
          event Transfer(address indexed from, address indexed to, uint value, bytes data);
          function transferAndCall(address, uint, bytes calldata) external returns (bool);
      }
      
      contract IBurnableMintableERC677Token is ERC677 {
          function mint(address, uint256) public returns (bool);
          function burn(uint256 _value) public;
          function claimTokens(address _token, address _to) public;
      }
      
      contract ERC677Receiver {
          function onTokenTransfer(address _from, uint _value, bytes calldata _data) external returns(bool);
      }
  ```
  * DoubleOrNothing
  ``` 
      contract DoubleOrNothing {
      
          struct TokenData {
              IBurnableMintableERC677Token instance;
              uint256 lastBalance; // Don't trust this; see onTokenTransfer
          }
      
          event BetSettled(address player, uint256 winnings);
      
          function addToken(address _tokenAddress) external;
      
          function deleteToken(address _tokenAddress) external;
      
          function bet(address payable _referrer) payable external;
      
          function bet() payable public;
      
          function betTokens(IBurnableMintableERC677Token _token, uint256 _amount) internal;
      
          // With no data sent, the contract token balance is simply updated.
          // Any data provided indicates that a user wants to make a bet.
          function onTokenTransfer(address /*_from*/, uint _value, bytes calldata _data) external returns(bool);
      
          function withdraw(uint256 _amount) external;
      
          function withdrawTokens(address _tokenAddress, uint256 _amount) external;
      }
  ```
### Deploying to Github Pages
  
  1. Fork this repo
  2. Rename the forked repo as {{Your-github-username}}.github.io
  3. ssh `git clone git@github.com:{{Your-github-username}}/{{Your-github-username}}.github.io.git`
   \
   or 
   \
  https `git clone https://github.com/{{Your-github-username}}/{{Your-github-username}}.github.io.git`
  4. `cd {{Your-github-username}}.git.hub.io.git`
  5. `git commit --allow-empty -m "bump"`
  6. `git push`
  *Note: If you see the error “push declined due to email privacy restrictions”, you will need to allow command line pushes that expose your email address. This under “Settings”, “Emails”
  7. It will take ~10 mins for Github to create your page. It can be accessed at 
  \
  `https://{{Your-github-username}}.github.io`
  8. While you wait, make sure to have [Metamask](https://metamask.io/) installed
  9. Set it up to a new Custom RPC url: https://mainnet-rpc.thundercore.com
  10. When your page is built, you should be able to play the game
