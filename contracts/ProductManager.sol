pragma solidity ^0.4.0;

import "./UserManager.sol";


contract ProductManager is UserManager {

    event AddedProduct(uint indexed _productId);

    struct Action {
        uint productId;
        address actionCreator;
        string actionMetadata;
        mapping(address => uint8) actionVotes;
    }

    struct Product {
        uint productId;
        uint productActionsLength;
        mapping(uint => Action) productActions;
    }

    mapping(address => Action[]) userActions;
    Product[] products;

    function addProductAction(uint _productId, string _actionMetadata)
        public
        onlyUser
    {
        require(_productId < products.length);
        uint actionIndex = products[_productId].productActionsLength;
        products[_productId].productActions[actionIndex] = Action(_productId, msg.sender, _actionMetadata);
        products[_productId].productActionsLength++;
        userActions[msg.sender].push(Action(_productId, msg.sender, _actionMetadata));
    }

    function getProductCount()
        public
        constant
        returns(uint)
    {
        return products.length;
    }

    function getProductActionCount(uint _productId)
        public
        constant
        returns(uint)
    {
        require(_productId < getProductCount());
        return products[_productId].productActionsLength;
    }

    function getProductAction(uint _productId, uint _actionIndex)
        public
        constant
        returns(
            uint productId,
            address actionCreator,
            string actionMetadata
        )
    {
        require(_productId < getProductCount());
        productId = products[_productId].productActions[_actionIndex].productId;
        actionCreator = products[_productId].productActions[_actionIndex].actionCreator;
        actionMetadata = products[_productId].productActions[_actionIndex].actionMetadata;
    }

    function addProduct(string _actionMetadata)
        public
        onlyUser
    {
        products.push(Product(products.length, 0));
        userActions[msg.sender].push(Action(products.length, msg.sender, _actionMetadata));
        addProductAction(products.length - 1, _actionMetadata);

        emit AddedProduct(getProductCount() - 1);
    }

    function getUserActionCount(address _userAddress)
        public
        constant
        returns(uint)
    {
        return userActions[_userAddress].length;
    }

    function getUserAction(address _userAddress, uint _actionIndex)
        public
        constant
        returns(
            uint productId,
            address actionCreator,
            string actionMetadata
        )
    {
        productId = userActions[_userAddress][_actionIndex].productId;
        actionCreator = userActions[_userAddress][_actionIndex].actionCreator;
        actionMetadata = userActions[_userAddress][_actionIndex].actionMetadata;
    }

    function vote(uint _productId, uint _actionId, uint8 _value)
        public
        onlyUser
    {
        require(_value < 5);
        products[_productId].productActions[_actionId].actionVotes[msg.sender] = _value;
    }

    function getActionVote(uint _productId, uint _actionId, address _userAddress)
        public
        constant
        returns(uint8)
    {
        return products[_productId].productActions[_actionId].actionVotes[_userAddress];
    }
}
