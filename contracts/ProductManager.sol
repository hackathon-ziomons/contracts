pragma solidity ^0.4.0;


contract ProductManager {

    struct Action {
        uint productId;
        address actionCreator;
        string actionMetadata;
    }

    struct Product {
        uint productId;
        Action[] productActions;
    }

    Product[] products;

    function addProduct(string _actionMetadata)
        public
        onlyUser
    {
        require(_actionMetadata != "");

        Action action = Action(products.length, msg.sender, _actionMetadata);
        products.push(Product(products.length), action);
    }

    function addProductAction(uint _productId, string _actionMetadata)
        public
        onlyUser
    {
        require(
            _productId < products.length &&
            _actionMetadata != ""
        );

        Action action = Action(_productId, msg.sender, _actionMetadata);
        products[_productId].productActions.push(action);
    }

    function getProductActions(uint _productId)
        public
        constant
        returns(Action[])
    {
        return products[_productId].productActions;
    }
}
