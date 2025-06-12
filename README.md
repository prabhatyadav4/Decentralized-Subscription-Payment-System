# Decentralized Subscription Payment System

## Project Description

The Decentralized Subscription Payment System is a blockchain-based smart contract solution that revolutionizes how subscription-based services handle recurring payments. Built on Ethereum using Solidity, this system eliminates the need for traditional payment processors and provides a transparent, automated, and trustless way to manage subscription payments between service providers and subscribers.

The system enables service providers to register their services with specified monthly rates, while subscribers can create subscriptions by paying upfront for their desired duration. The smart contract automatically handles payment processing, subscription management, and fund distribution, ensuring both parties have full transparency and control over their transactions.

## Project Vision

Our vision is to create a decentralized ecosystem where subscription-based businesses can operate without relying on centralized payment processors, reducing fees, increasing transparency, and providing users with complete control over their subscription data. We aim to democratize access to subscription services globally, especially in regions where traditional payment methods are limited or expensive.

By leveraging blockchain technology, we envision a future where:
- Subscription payments are processed instantly without intermediaries
- Users have complete ownership and control of their subscription data
- Service providers can reach global audiences without payment processing barriers
- Transaction costs are minimized through direct peer-to-peer payments
- Subscription terms are enforced transparently through smart contracts

## Key Features

### Core Functionality
- **Service Provider Registration**: Businesses can register their services with custom monthly rates
- **Subscription Creation**: Users can subscribe to services by paying upfront for their desired duration
- **Automated Payment Processing**: Smart contract handles monthly payment processing and fund distribution
- **Subscription Management**: Users can view, manage, and cancel their active subscriptions

### Advanced Features
- **Multi-Duration Support**: Flexible subscription periods (1 month to unlimited duration)
- **Automatic Refunds**: Excess payments are automatically refunded to users
- **Balance Management**: Service providers can withdraw their accumulated earnings
- **Payment Due Tracking**: Real-time tracking of payment due dates and subscription status
- **Subscription Expiry Management**: Automatic handling of expired subscriptions

### Security & Transparency
- **Access Control**: Role-based permissions for subscribers and service providers
- **Event Logging**: Comprehensive event emission for all major operations
- **Input Validation**: Robust validation of all user inputs and state changes
- **Reentrancy Protection**: Secure handling of Ether transfers

### User Experience
- **Subscription Dashboard**: Easy viewing of all user subscriptions
- **Payment Status Tracking**: Real-time monitoring of payment due dates
- **Provider Statistics**: Service providers can track subscriber counts and earnings
- **Flexible Cancellation**: Users can cancel subscriptions at any time

## Future Scope

### Phase 1: Enhanced Features
- **Partial Refunds**: Implement pro-rated refunds for cancelled subscriptions
- **Discount Coupons**: Add support for promotional codes and discounts
- **Subscription Tiers**: Multiple subscription levels for the same service
- **Grace Period**: Allow delayed payments with penalty mechanisms

### Phase 2: Advanced Integrations
- **Oracle Integration**: Connect with external price feeds for stable coin pricing
- **Multi-Token Support**: Accept various ERC-20 tokens as payment methods
- **Recurring Automation**: Implement automatic recurring payments from user wallets
- **Dispute Resolution**: Decentralized arbitration system for subscription disputes

### Phase 3: Ecosystem Expansion
- **Mobile Application**: User-friendly mobile app for subscription management
- **Analytics Dashboard**: Comprehensive analytics for service providers
- **API Integration**: RESTful APIs for easy integration with existing platforms
- **Marketplace**: Decentralized marketplace for discovering subscription services

### Phase 4: Cross-Chain Compatibility
- **Multi-Chain Deployment**: Deploy on multiple blockchain networks
- **Cross-Chain Payments**: Enable payments across different blockchain networks
- **Layer 2 Integration**: Implement on scaling solutions for reduced gas costs
- **Interoperability Protocols**: Connect with other DeFi protocols and services

### Long-term Vision
- **DAO Governance**: Community-driven governance for protocol upgrades
- **NFT Subscriptions**: Unique subscription NFTs with transferable benefits
- **Subscription Insurance**: Protect subscribers against service provider defaults
- **Enterprise Solutions**: Tailored solutions for large-scale enterprise adoption

---

## Getting Started

### Prerequisites
- Node.js and npm installed
- Hardhat or Truffle development environment
- MetaMask or similar Web3 wallet
- Ethereum testnet ETH for deployment and testing

### Installation
1. Clone the repository
2. Install dependencies: `npm install`
3. Compile contracts: `npx hardhat compile`
4. Run tests: `npx hardhat test`
5. Deploy to testnet: `npx hardhat run scripts/deploy.js --network goerli`

### Usage
1. **For Service Providers**: Call `registerServiceProvider()` with your service details
2. **For Subscribers**: Use `createSubscription()` to subscribe to registered services
3. **Payment Processing**: Use `processMonthlyPayment()` for recurring payments
4. **Management**: Use view functions to track subscriptions and balances

## Contributing
We welcome contributions to improve the Decentralized Subscription Payment System. Please feel free to submit issues, feature requests, or pull requests.

## Deployment Details

- **status**:	          `0x1 Transaction mined and execution succeed`
- **transaction hash**:	`0xb2f860261c07602deaf1fcfbe5b60ea319aa037aaf33e77fba5fedb92a3af78d`
- **block hash**:	      `0x75aceb7cd966b8bdaf87ba059ac98984343b8cce00a753432ff786a189ce6b15`
- **block number**:	    `5518491`
- **contract address**:	`0xe892cb9c6f5a05541982055c3c2f57dd1ef530d6`
- **from**:	            `0xEBfB8DEcd9AD740993AD4e35ad3B4E50cb21634D`
- **to**:	              `Project.(constructor)`
- **gas**:	            `2602149 gas`
- **transaction cost**:	`2580502 gas` 

## Screenshot
![image](https://github.com/user-attachments/assets/0dd9ccc5-5c84-423d-93e8-90c7612281a1)
