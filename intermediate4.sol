// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensisons/ERC20Burnable.sol";

contract MetaDegenToken is ERC20, Ownable, ERC20Burnable {
    // Constructor to initialize token name, symbol, and initial features
constructor() ERC20("MetaDegen", "MDGN") Ownable(msg.sender)
{
 initializeFeatures();
 }

 // Structure to hold feature information
 struct Feature {
 string title;
 uint256 cost;
}

 // Mappings to store features, user redemptions, and feature names for uniqueness
mapping(uint256 => Feature) private featureList;
mapping(address => mapping(uint256 => bool)) private userRedeemedFeatures;
mapping(string => bool) private uniqueFeatureNames;

 // Event to log token transfers
 event TokensTransferred(address indexed sender, address indexed recipient, uint256 amount);

// Event for feature redemption
event FeatureRedeemed(address indexed redeemer, uint256 featureId, string featureTitle);

 // Function to mint tokens, callable only by the owner
 function distributeTokens(address recipient, uint256 tokenAmount) external onlyOwner {
   _mint(recipient, tokenAmount);
  }
  // Function to burn tokens, callable by any user with sufficient balance
 function removeTokens(uint256 tokenAmount) external {
_burn(msg.sender, tokenAmount);
 }

     // Function to transfer tokens between users
 function transferTokens(address recipient, uint256 tokenAmount) external {
  require(balanceOf(msg.sender) >= tokenAmount, "Insufficient balance for transfer");
 _transfer(msg.sender, recipient, tokenAmount);
  emit TokensTransferred(msg.sender, recipient, tokenAmount);
  }
  // Function to check the balance of a specific address
  function getBalance(address user) external view returns (uint256) {
    return balanceOf(user);
   }                                                                                                                          // Add new feature (Only owner can add features)
     function introduceFeature(uint256 featureId, string memory title, uint256 cost) external onlyOwner {
    require(bytes(featureList[featureId].title).length == 0, "Feature already exists");
    require(!uniqueFeatureNames[title], "Feature name is not unique");

   featureList[featureId] = Feature(title, cost);
    uniqueFeatureNames[title] = true;
 }
    // Redeem a feature using tokens
  function useFeature(uint256 featureId) external {
    Feature memory feature = featureList[featureId];
   require(bytes(feature.title).length != 0, "Invalid feature");
    require(!userRedeemedFeatures[msg.sender][featureId], "Feature already redeemed");                                                                                                                                                                                             require(balanceOf(msg.sender) >= feature.cost, "Not enough tokens to redeem");

     _burn(msg.sender, feature.cost);
    userRedeemedFeatures[msg.sender][featureId] = true;
      emit FeatureRedeemed(msg.sender, featureId, feature.title);
   }                                                                                                                          // Check if a user has already redeemed a feature
    function hasUserRedeemedFeature(address user, uint256 featureId) external view returns (bool) {
 return userRedeemedFeatures[user][featureId];
 }                                                                                                                                                  // Internal function to initialize some default features during contract deployment
     function initializeFeatures() internal {
      introduceFeature(1, "Rocket Booster", 200);
 introduceFeature(2, "Invisibility Cloak", 300);
  introduceFeature(3, "Teleportation Device", 500); introduceFeature(4, "Laser Gun", 400);
 }
}
