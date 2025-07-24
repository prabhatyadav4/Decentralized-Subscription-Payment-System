// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Decentralized Subscription Payment System
 * @dev A smart contract that manages subscription-based payments in a decentralized manner
 * @author Your Name
 */
contract Project {
    
    // Events
    event SubscriptionCreated(uint256 indexed subscriptionId, address indexed subscriber, address indexed serviceProvider, uint256 amount, uint256 duration);
    event PaymentProcessed(uint256 indexed subscriptionId, address indexed subscriber, uint256 amount, uint256 timestamp);
    event SubscriptionCancelled(uint256 indexed subscriptionId, address indexed subscriber);
    event ServiceProviderRegistered(address indexed provider, string serviceName);
    
    // Structures
    struct Subscription {
        uint256 id;
        address subscriber;
        address serviceProvider;
        uint256 monthlyAmount;
        uint256 startTime;
        uint256 duration; // in months
        uint256 lastPaymentTime;
        bool isActive;
        string serviceName;
    }
    
    struct ServiceProvider {
        string serviceName;
        uint256 monthlyRate;
        bool isRegistered;
        uint256 totalSubscribers;
    }
    
    // State variables
    mapping(uint256 => Subscription) public subscriptions;
    mapping(address => ServiceProvider) public serviceProviders;
    mapping(address => uint256[]) public userSubscriptions;
    mapping(address => uint256) public providerBalances;
    
    uint256 public nextSubscriptionId;
    uint256 public constant MONTH_IN_SECONDS = 30 days;
    
    // Modifiers
    modifier onlyServiceProvider() {
        require(serviceProviders[msg.sender].isRegistered, "Not a registered service provider");
        _;
    }
    
    modifier onlyActiveSubscription(uint256 _subscriptionId) {
        require(subscriptions[_subscriptionId].isActive, "Subscription is not active");
        _;
    }
    
    modifier onlySubscriber(uint256 _subscriptionId) {
        require(subscriptions[_subscriptionId].subscriber == msg.sender, "Not the subscriber");
        _;
    }
    
    /**
     * @dev Register as a service provider
     * @param _serviceName Name of the service
     * @param _monthlyRate Monthly subscription rate in wei
     */
    function registerServiceProvider(string memory _serviceName, uint256 _monthlyRate) external {
        require(!serviceProviders[msg.sender].isRegistered, "Already registered as service provider");
        require(_monthlyRate > 0, "Monthly rate must be greater than 0");
        require(bytes(_serviceName).length > 0, "Service name cannot be empty");
        
        serviceProviders[msg.sender] = ServiceProvider({
            serviceName: _serviceName,
            monthlyRate: _monthlyRate,
            isRegistered: true,
            totalSubscribers: 0
        });
        
        emit ServiceProviderRegistered(msg.sender, _serviceName);
    }
    
    /**
     * @dev Create a new subscription
     * @param _serviceProvider Address of the service provider
     * @param _duration Duration of subscription in months
     */
    function createSubscription(address _serviceProvider, uint256 _duration) external payable {
        require(serviceProviders[_serviceProvider].isRegistered, "Service provider not registered");
        require(_duration > 0, "Duration must be greater than 0");
        
        uint256 monthlyAmount = serviceProviders[_serviceProvider].monthlyRate;
        uint256 totalAmount = monthlyAmount * _duration;
        
        require(msg.value >= totalAmount, "Insufficient payment for subscription");
        
        uint256 subscriptionId = nextSubscriptionId++;
        
        subscriptions[subscriptionId] = Subscription({
            id: subscriptionId,
            subscriber: msg.sender,
            serviceProvider: _serviceProvider,
            monthlyAmount: monthlyAmount,
            startTime: block.timestamp,
            duration: _duration,
            lastPaymentTime: block.timestamp,
            isActive: true,
            serviceName: serviceProviders[_serviceProvider].serviceName
        });
        
        userSubscriptions[msg.sender].push(subscriptionId);
        serviceProviders[_serviceProvider].totalSubscribers++;
        
        // Transfer first month's payment to service provider
        providerBalances[_serviceProvider] += monthlyAmount;
        
        // Refund excess payment if any
        if (msg.value > totalAmount) {
            payable(msg.sender).transfer(msg.value - totalAmount);
        }
        
        emit SubscriptionCreated(subscriptionId, msg.sender, _serviceProvider, monthlyAmount, _duration);
        emit PaymentProcessed(subscriptionId, msg.sender, monthlyAmount, block.timestamp);
    }
    
    /**
     * @dev Process monthly payment for active subscription
     * @param _subscriptionId ID of the subscription
     */
    function processMonthlyPayment(uint256 _subscriptionId) external payable onlyActiveSubscription(_subscriptionId) {
        Subscription storage subscription = subscriptions[_subscriptionId];
        
        require(block.timestamp >= subscription.lastPaymentTime + MONTH_IN_SECONDS, "Payment not due yet");
        require(block.timestamp <= subscription.startTime + (subscription.duration * MONTH_IN_SECONDS), "Subscription expired");
        
        uint256 monthlyAmount = subscription.monthlyAmount;
        require(msg.value >= monthlyAmount, "Insufficient payment amount");
        
        subscription.lastPaymentTime = block.timestamp;
        providerBalances[subscription.serviceProvider] += monthlyAmount;
        
        // Refund excess payment if any
        if (msg.value > monthlyAmount) {
            payable(msg.sender).transfer(msg.value - monthlyAmount);
        }
        
        emit PaymentProcessed(_subscriptionId, msg.sender, monthlyAmount, block.timestamp);
    }

    /**
     * @dev Renew an expired or active subscription by extending its duration
     * @param _subscriptionId ID of the subscription to renew
     * @param _additionalMonths Number of months to extend
     */
    function renewSubscription(uint256 _subscriptionId, uint256 _additionalMonths) external payable onlySubscriber(_subscriptionId) {
        Subscription storage subscription = subscriptions[_subscriptionId];
        require(_additionalMonths > 0, "Must renew for at least 1 month");

        uint256 totalAmount = subscription.monthlyAmount * _additionalMonths;
        require(msg.value >= totalAmount, "Insufficient payment for renewal");

        // If subscription is expired, reset timing
        if (block.timestamp > subscription.startTime + (subscription.duration * MONTH_IN_SECONDS)) {
            subscription.startTime = block.timestamp;
            subscription.lastPaymentTime = block.timestamp;
            subscription.duration = _additionalMonths;
        } else {
            // Still active, just extend duration
            subscription.duration += _additionalMonths;
        }

        providerBalances[subscription.serviceProvider] += subscription.monthlyAmount;

        if (msg.value > totalAmount) {
            payable(msg.sender).transfer(msg.value - totalAmount);
        }

        if (!subscription.isActive) {
            subscription.isActive = true;
            serviceProviders[subscription.serviceProvider].totalSubscribers++;
        }

        emit PaymentProcessed(_subscriptionId, msg.sender, subscription.monthlyAmount, block.timestamp);
    }
    
    /**
     * @dev Cancel an active subscription
     * @param _subscriptionId ID of the subscription to cancel
     */
    function cancelSubscription(uint256 _subscriptionId) external onlySubscriber(_subscriptionId) onlyActiveSubscription(_subscriptionId) {
        Subscription storage subscription = subscriptions[_subscriptionId];
        
        subscription.isActive = false;
        serviceProviders[subscription.serviceProvider].totalSubscribers--;
        
        emit SubscriptionCancelled(_subscriptionId, msg.sender);
    }
    
    // View functions
    function getSubscription(uint256 _subscriptionId) external view returns (Subscription memory) {
        return subscriptions[_subscriptionId];
    }
    
    function getUserSubscriptions(address _user) external view returns (uint256[] memory) {
        return userSubscriptions[_user];
    }
    
    function getServiceProvider(address _provider) external view returns (ServiceProvider memory) {
        return serviceProviders[_provider];
    }
    
    function isPaymentDue(uint256 _subscriptionId) external view returns (bool) {
        Subscription memory subscription = subscriptions[_subscriptionId];
        if (!subscription.isActive) return false;
        
        return block.timestamp >= subscription.lastPaymentTime + MONTH_IN_SECONDS;
    }
    
    function isSubscriptionExpired(uint256 _subscriptionId) external view returns (bool) {
        Subscription memory subscription = subscriptions[_subscriptionId];
        return block.timestamp > subscription.startTime + (subscription.duration * MONTH_IN_SECONDS);
    }
    
    // Service provider functions
    function withdrawBalance() external onlyServiceProvider {
        uint256 balance = providerBalances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        
        providerBalances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
    
    function getProviderBalance() external view returns (uint256) {
        return providerBalances[msg.sender];
    }
}
