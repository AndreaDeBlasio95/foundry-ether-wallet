# EtherWallet Project

Welcome to the EtherWallet Project! This guide provides comprehensive instructions on setting up, developing, testing, and deploying an Ether Wallet using the Foundry framework. Below you'll find details on installation, project structure, testing, and deployment instructions.

## Prerequisites

Before you begin, ensure Foundry is installed on your system. If you need to install Foundry, use the following commands:

### Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## Project Setup

To set up the project, initialize a new Foundry project and navigate into your project directory:

```bash
forge init ether-wallet
cd ether-wallet
```

## Project Structure

The project is organized into several directories, containing the smart contracts, tests, and deployment scripts. Here’s a quick overview of the top-level structure:

```
foundry-ether-wallet/
│
├── script/
│   └── DeployEtherWallet.s.sol       # Script for deploying the EtherWallet contract
│
├── src/
│   └── EtherWallet.sol               # Main smart contract for the EtherWallet
│
└── test/
    └── EtherWalletTest.t.sol         # Tests for the EtherWallet contract
```

## Smart Contract Implementation

The smart contract for the Ether Wallet is located in the `src` directory under the filename `EtherWallet.sol`. This contract includes functions for depositing and withdrawing Ether, changing the wallet owner, and handling Ether received through fallback methods.

## Test Suite

Testing is an essential part of development to ensure your contract functions as expected. All test files are located in the `test` directory. The `EtherWalletTest.t.sol` file contains comprehensive test cases covering deposit, withdrawal, and access control functionalities.

## Testing Procedures

### Compile the Contracts

To compile the smart contracts, run:

```bash
forge build
```

### Run Tests

Execute the tests using:

```bash
forge test
```

This will run all the test cases defined in `EtherWalletTest.t.sol` and provide a report on each test's success or failure.

## Deployment

To deploy the EtherWallet contract, follow these steps:

### Part 1: Environment Setup

#### Configure `.gitignore`

Add sensitive files and build artifacts to `.gitignore` to prevent them from being tracked by Git:

```
.env
out/
cache/
artifacts/
```

#### Create and Configure `.env`

Set up a `.env` file in the project root to store environment variables:

```
RPC_URL_ANVIL=http://127.0.0.1:8545
PRIVATE_KEY="YOUR_PRIVATE_KEY"
# Example private key from Anvil:
# 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

Load your `.env` file and verify the variables:

```bash
source .env
echo $PRIVATE_KEY
echo $RPC_URL_ANVIL
```

### Part 2: Deploying the Contract

#### Deployment Script

The deployment script `DeployEtherWallet.s.sol` in the `script` directory facilitates the broadcasting of the EtherWallet contract to the blockchain.

#### Execute Deployment

Run the deployment script with the environment variables:

```bash
forge script script/DeployEtherWallet.s.sol --private-key $PRIVATE_KEY --fork-url $RPC_URL_ANVIL
```

This command deploys the EtherWallet contract to the specified blockchain environment configured in your `.env` file.

## Conclusion

Following these instructions should help you effectively manage the development and deployment of the EtherWallet project. For more detailed interactions with the contract or modifications, refer to the files specified in the project structure. Happy coding!
