// SPDX-License-Identifier: MIT
// ATSUSHI MANDAI CRDIT Contracts

pragma solidity ^0.8.0;

import "./access/Ownable.sol";
import "./INEL.sol";

/// @title NEL
/// @author Atsushi Mandai
/// @notice Basic functions of the ERC20 Token NEL.
contract NELGetter is Ownable {

    /**
     * @dev Emits this event when faucet mints
     */
    event MintToken(address to, uint256 amount);

    /**
     * @dev Amount of NEL a user could mint with Faucet.
     */ 
    uint256 public faucetAmount = 2 * (10**uint256(18));

    /**
     * @dev Address of NEL Token.
     */ 
    address public AddressNEL;

    /**
     * @dev User must wait until the cooldownTime to use nelFaucet function.
     */ 
    mapping(address => uint256) public cooldownTime;

    /**
     * @dev Changes the faucetAmount.
     */ 
    function changeFaucetAmount(uint256 _amount) public onlyOwner {
        faucetAmount = _amount;
    }

    /**
    * @dev Changes AddressNEL.
    */ 
    function changeAddressNEL(address _address) public onlyOwner {
        AddressNEL = _address;
    }

    /**
     * @dev Lets a user mint new NEL.
     */
    function nelFaucet() public returns(bool) {
        require(block.timestamp > cooldownTime[_msgSender()], "Still in the cooldown time.");
        cooldownTime[_msgSender()] = block.timestamp + 1 days;
        INEL token = INEL(AddressNEL);
        bool value = token.issuerMint(_msgSender(), faucetAmount);
        if (value == true) {
            emit MintToken(_msgSender(), faucetAmount);
        } else {
            emit MintToken(_msgSender(), 0);
        }
        return value;
    }

}