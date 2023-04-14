pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VantageLpDistributor is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public lpToken;
    address public vantageDaoTreasury;

    uint256 public constant ONE_LP_TOKEN = 1e18; // 1 LP token (assuming 18 decimals)

    event Distribution(address indexed sender, uint256 totalRecipients, uint256 totalLpDistributed);

    constructor(address _lpToken, address _vantageDaoTreasury) {
        lpToken = IERC20(_lpToken);
        vantageDaoTreasury = _vantageDaoTreasury;
    }

    function distributeLpTokens(address[] calldata recipients) external onlyOwner {
        uint256 totalLpDistributed = recipients.length * ONE_LP_TOKEN;
        require(lpToken.balanceOf(vantageDaoTreasury) >= totalLpDistributed, "Not enough LP tokens in DAO treasury");

        for (uint256 i = 0; i < recipients.length; i++) {
            lpToken.safeTransferFrom(vantageDaoTreasury, recipients[i], ONE_LP_TOKEN);
        }

        emit Distribution(msg.sender, recipients.length, totalLpDistributed);
    }
}
