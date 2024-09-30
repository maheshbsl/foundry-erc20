// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract ManualToken {

    mapping(address => uint256) s_balance;

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether; 
    }

    function decimal() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balance[_owner];
    }

    function transer(address _to, uint256 _amount) public  {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        require(s_balance[msg.sender] >= _amount, "Insufficient Balance");
        s_balance[msg.sender] -= _amount;
        s_balance[_to] += _amount;

        require(s_balance[msg.sender] + s_balance[_to] == previousBalances);
    }
}