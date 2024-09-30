# ETHintermediate4
# MetaDegenToken (MDGN) Smart Contract

MetaDegenToken (MDGN) is an ERC20-compliant token designed for the MetaDegen ecosystem. It incorporates advanced features such as token burning, feature redemption, and ownership controls to provide a robust and flexible platform for decentralized applications.

## Table of Contents

- [Features](#features)
- [Token Details](#token-details)
- [Smart Contract Overview](#smart-contract-overview)
  - [Constructor](#constructor)
  - [Structures](#structures)
  - [Mappings](#mappings)
  - [Events](#events)
  - [Functions](#functions)
    - [Token Management](#token-management)
    - [Feature Management](#feature-management)
    - [Redemption](#redemption)
    - [Utility](#utility)
- [Security Considerations](#security-considerations)
- [Installation & Deployment](#installation--deployment)
- [Usage](#usage)
- [License](#license)

## Features

- **ERC20 Standard:** Fully compliant with the ERC20 token standard.
- **Ownable:** Ownership control to restrict certain functions to the contract owner.
- **Burnable:** Allows token holders to burn their tokens, reducing the total supply.
- **Feature Redemption:** Users can redeem unique features using MDGN tokens.
- **Event Logging:** Emits events for token transfers and feature redemptions for transparency.

## Token Details

- **Name:** MetaDegen
- **Symbol:** MDGN
- **Decimals:** 18
- **Total Supply:** Dynamic (mintable by the owner)

## Smart Contract Overview

The `MetaDegenToken` smart contract extends OpenZeppelin's ERC20, Ownable, and ERC20Burnable contracts to provide additional functionalities tailored to the MetaDegen ecosystem.

### Constructor

Initializes the token with a name, symbol, and sets the deployer as the owner. It also initializes default features available for redemption.

```solidity
constructor() ERC20("MetaDegen", "MDGN") Ownable(msg.sender) {
    initializeFeatures();
}
```

### Structures

#### Feature

Represents a redeemable feature within the ecosystem.

```solidity
struct Feature {
    string title;
    uint256 cost;
}
```

### Mappings

- `featureList`: Maps a feature ID to its corresponding `Feature` struct.
- `userRedeemedFeatures`: Tracks whether a user has redeemed a specific feature.
- `uniqueFeatureNames`: Ensures that each feature title is unique.

### Events

- **TokensTransferred**
  - **Description:** Emitted when tokens are transferred between users.
  - **Parameters:**
    - `sender` (address): The address sending the tokens.
    - `recipient` (address): The address receiving the tokens.
    - `amount` (uint256): The amount of tokens transferred.

- **FeatureRedeemed**
  - **Description:** Emitted when a user redeems a feature using MDGN tokens.
  - **Parameters:**
    - `redeemer` (address): The address redeeming the feature.
    - `featureId` (uint256): The ID of the redeemed feature.
    - `featureTitle` (string): The title of the redeemed feature.

### Functions

#### Token Management

- **distributeTokens**
  - **Description:** Mints new MDGN tokens to a specified address. Only callable by the contract owner.
  - **Parameters:**
    - `recipient` (address): The address to receive the tokens.
    - `tokenAmount` (uint256): The amount of tokens to mint.

- **removeTokens**
  - **Description:** Burns a specified amount of MDGN tokens from the caller's balance.
  - **Parameters:**
    - `tokenAmount` (uint256): The amount of tokens to burn.

- **transferTokens**
  - **Description:** Transfers MDGN tokens from the caller to another address.
  - **Parameters:**
    - `recipient` (address): The address to receive the tokens.
    - `tokenAmount` (uint256): The amount of tokens to transfer.

- **getBalance**
  - **Description:** Retrieves the MDGN token balance of a specified address.
  - **Parameters:**
    - `user` (address): The address to query.
  - **Returns:** `uint256` representing the user's balance.

#### Feature Management

- **introduceFeature**
  - **Description:** Adds a new redeemable feature to the contract. Only callable by the contract owner.
  - **Parameters:**
    - `featureId` (uint256): The unique ID for the feature.
    - `title` (string): The title of the feature.
    - `cost` (uint256): The cost in MDGN tokens to redeem the feature.

- **initializeFeatures**
  - **Description:** Initializes a set of default features during contract deployment. This is an internal function and is called within the constructor.

#### Redemption

- **useFeature**
  - **Description:** Allows a user to redeem a feature by burning the required amount of MDGN tokens.
  - **Parameters:**
    - `featureId` (uint256): The ID of the feature to redeem.

- **hasUserRedeemedFeature**
  - **Description:** Checks if a user has already redeemed a specific feature.
  - **Parameters:**
    - `user` (address): The address to check.
    - `featureId` (uint256): The ID of the feature.
  - **Returns:** `bool` indicating redemption status.

#### Utility

- **hasUserRedeemedFeature**
  - **Description:** Checks if a user has already redeemed a specific feature.
  - **Parameters:**
    - `user` (address): The address to check.
    - `featureId` (uint256): The ID of the feature.
  - **Returns:** `bool` indicating whether the user has redeemed the feature.

## Security Considerations

- **Access Control:** Functions that modify the state, such as `distributeTokens` and `introduceFeature`, are restricted to the contract owner using the `onlyOwner` modifier.
- **Reentrancy:** The contract leverages OpenZeppelin's tested libraries, reducing the risk of reentrancy attacks.
- **Input Validation:** Functions include `require` statements to validate inputs and state before execution, ensuring the contract behaves as expected.
- **Burn Mechanism:** Users can burn their tokens, which permanently removes them from circulation, potentially impacting the tokenomics.

## Installation & Deployment

### Prerequisites

- **Node.js** and **npm** installed.
- **Hardhat** or **Truffle** for smart contract development and deployment.
- **MetaMask** or another Ethereum wallet for interacting with the deployed contract.

### Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-repo/MetaDegenToken.git
   cd MetaDegenToken
   ```

2. **Install Dependencies**

   ```bash
   npm install
   ```

3. **Configure Environment**

   Create a `.env` file and add your Ethereum node provider and private key.

   ```env
   INFURA_PROJECT_ID=your_infura_project_id
   PRIVATE_KEY=your_private_key
   ```

4. **Compile the Contract**

   ```bash
   npx hardhat compile
   ```

5. **Deploy the Contract**

   Ensure you have configured the deployment script with the correct network settings.

   ```bash
   npx hardhat run scripts/deploy.js --network your_network
   ```

## Usage

Once deployed, the `MetaDegenToken` contract can be interacted with using Web3 libraries like Ethers.js or directly through Ethereum wallets that support contract interactions.

### Common Operations

- **Minting Tokens:**
  Only the contract owner can mint new tokens to a specified address.

  ```javascript
  await metaDegenToken.distributeTokens(recipientAddress, tokenAmount);
  ```

- **Burning Tokens:**
  Any user can burn tokens from their balance.

  ```javascript
  await metaDegenToken.removeTokens(tokenAmount);
  ```

- **Transferring Tokens:**
  Users can transfer tokens to others.

  ```javascript
  await metaDegenToken.transferTokens(recipientAddress, tokenAmount);
  ```

- **Redeeming Features:**
  Users can redeem available features by burning the required amount of tokens.

  ```javascript
  await metaDegenToken.useFeature(featureId);
  ```

- **Checking Redemption Status:**
  Verify if a user has already redeemed a specific feature.

  ```javascript
  const hasRedeemed = await metaDegenToken.hasUserRedeemedFeature(userAddress, featureId);
  ```

### Listening to Events

Developers can listen to emitted events for real-time updates.

- **TokensTransferred Event**

  ```javascript
  metaDegenToken.on("TokensTransferred", (sender, recipient, amount) => {
      console.log(`${sender} transferred ${amount} MDGN to ${recipient}`);
  });
  ```

- **FeatureRedeemed Event**

  ```javascript
  metaDegenToken.on("FeatureRedeemed", (redeemer, featureId, featureTitle) => {
      console.log(`${redeemer} redeemed feature ${featureTitle} (ID: ${featureId})`);
  });
  ```

## License

This project is licensed under the [MIT License](./LICENSE).

---

**Disclaimer:** This smart contract is provided for educational purposes and should be thoroughly tested and audited before deployment in a production environment.
