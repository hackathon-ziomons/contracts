pragma solidity ^0.4.24;

import "./Ownable.sol";


contract UserManager is Ownable, ProductManager {

    struct User {
        address userAddress;
        string userMetadata;
        uint userBalance;
        Action[] userActions;
    }

    address[] public usersLUT;
    mapping(address => uint) public userAddressLUTPosition;
    mapping(address => User) public userMapping;

    function userExists(address _user)
        public
        constant
        returns(bool)
    {
        if (userAddressLUTPosition[_user] == 0)
            return false;
        else
            return true;
    }

    function userCount()
        public
        constant
        returns(uint)
    {
        return usersLUT.length;
    }

    function getUsers()
        public
        constant
        returns(address[])
    {
        return usersLUT;
    }

    function getUserMetadata(address _userAddress)
        public
        constant
        returns(string)
    {
        return userMapping[_userAddress].userMetadata;
    }

    function getUserBalance(address _userAddress)
        public
        constant
        returns(uint)
    {
        return userMapping[_userAddress].userBalance;
    }

    function getUserActions(address _userAddress)
        public
        constant
        returns(Action)
    {
        return userMapping[_userAddress].userActions;
    }

    function addUser(address _userAddress, string _userMetadata)
        public
        onlyOwner
    {
        require(
            _userAddress != 0x0 &
            !userExists(_userAddress)
        );

        Action[] tmp;
        userMapping[_userAddress] = User(_userAddress, _userMetadata, 0, tmp);
        userAddressLUTPosition[_userAddress] = usersLUT.push(_userAddress);
    }

    function removeUser(address _userAddress)
        public
        onlyOwner
    {
        require(
            userExists(_userAddress)
        );
        usersLUT[userAddressLUTPosition[_userAddress] - 1] = usersLUT[userCount() - 1];
        userAddressLUTPosition[usersLUT[userCount() - 1]] = userAddressLUTPosition[_userAddress];
        userAddressLUTPosition[_userAddress] = 0;
        usersLUT.length--;
        Action[] tmp;
        userMapping[_userAddress] = User(0x0, "", 0, tmp);
    }

    modifier onlyUser() {
        require(userExists(msg.sender));
        _;
    }
}
