pragma solidity ^0.4.0;

import "./UserManager.sol";


contract ProductManager is UserManager {
    mapping(address => Action[]) userActions;

    struct Action {
        uint productId;
        address actionCreator;
        string actionMetadata;
    }

    struct Product {
        uint productId;
        uint productActionsLength;
        mapping(uint => Action) productActions;
    }

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

    function addProduct(string _actionMetadata)
        public
        onlyUser
    {
        products.push(Product(products.length, 0));
        userActions[msg.sender].push(Action(products.length, msg.sender, _actionMetadata));
        addProductAction(products.length, _actionMetadata);
    }

    function getProductActionCount(uint _productId)
        public
        constant
        returns(uint)
    {
        return 6;//products[_productId].productActions.length;
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
        productId = products[_productId].productActions[_actionIndex].productId;
        actionCreator = products[_productId].productActions[_actionIndex].actionCreator;
        actionMetadata = products[_productId].productActions[_actionIndex].actionMetadata;
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
}
