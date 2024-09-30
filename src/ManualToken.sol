// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract ManualToken {
    /*State Variables*/
    string public name = "ManualToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    //mappings
    mapping(address account => uint256) balanceOf;
    // address A -->  (address B ---> value)
    // address A allows address B to spend value
    mapping(address account => mapping(address spender => uint256)) allowance;
    //Bob    allows             DEX  to spend  up to 10 ether

    /**
     * @dev Emitted when `tokens` are transferred from one addres to another including zero-value transfers.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the owner of tokens approves a spender to withdraw
     *  a specific amount of tokens from their account.
     */
    event Approve(address indexed owner, address indexed spender, uint256 value);

    /**
     *  Notify the clients about the amouont burn
     */
    event Burn(address indexed from, uint256 value);

    /**
     *  Constructor -> set the values for {name}, {symbol} and {totalSupply}
     */
    constructor(string memory tokenName, string memory tokenSymbol, uint256 initailSupply) {
        totalSupply = initailSupply * 10 ** uint256(decimals); // eg   (33 * 10**18 )
        balanceOf[msg.sender] = totalSupply;  // initially give all tokens to the creater. 
        name = tokenName;
        symbol = tokenSymbol;
    }
    /**
     * @param from addres of sender
     * @param to address of recipient
     * @param value the amount of tokens
     * preventing sending tokens to the zero address
     * ensure that the sender has enough balance
     */

    function _transfer(address from, address to , uint256 value) internal {
        require(to != address(0)); //not sending to address zero
        require(balanceOf[from] >= value);  // ensure that sender has enough balance
        require(balanceOf[to] + value >= balanceOf[to]); //check for overflow
        uint256 previoiusBalance = balanceOf[to] + balanceOf[from]; // for later assertion
        balanceOf[from] -= value; //subtract value from sender
        balanceOf[to] += value; // add value to recipient
        emit Transfer(from, to, value);
        assert(balanceOf[from] + balanceOf[to] == previoiusBalance);

    }
    /**
     * transfer funciton
     * Transfer tokens from the caller's address to recipient
     * @param to -> the address of the recipient
     * @param value -> the amount of tokens
     * Returns a boolean value indicating whether the operation succeed or not
     * call a internal function _transfer
     */
    function transfer(address to, uint256  value) public  returns (bool success) {
       _transfer(msg.sender, to, value);
       return true;
    }
    /**
     * 
     * @param spender The person who is authorized to spend token
     * @param value The amount of token
     */
    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value; // caller approves spender to spend up to value
        emit Approve(msg.sender, spender, value);
        return true;
    }

    /**
     * 
     * @param sender The person who has approved caller to  spend tokens
     * @param to The recipient address 
     * @param value the token ammount
     * ensure to deduct the value from allowance
     */
    function transferFrom(address sender, address to, uint256 value) public returns (bool success) {
        require(value <= allowance[sender][msg.sender]);  //previously sender has appreoved caller the spend token
        allowance[sender][msg.sender] -= value; // deduct the value from allowance
        _transfer(sender, to , value);
        return true;
    }
    /**
     * @param value The total amount of token to burn
     * ensure that the caller has enough balance
     * emit the event
     */
    function burn(uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value); // ensure that the caller has enough balance
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value); // emit that specific amount of token is burned and deducted from total supply
        return true;
    }
    /**
     * 
     * @param from The addres that give the caller the authority to spend tokens
     * @param value The amount of tokens the caller can spend
     */

    function burnFrom(address from, uint256 value) public returns (bool success) {
        require(value <= allowance[from][msg.sender]);  // ensure that the allowance is greater than value
        require(balanceOf[from] >= value); // ensure that user has enough balance
        balanceOf[from] -= value; //deduct the amount from target balance
        allowance[from][msg.sender] -= value; // deduct the amount of allowance
        totalSupply -= value; // deduct the value from total supply
        emit Burn(from, value); // emit the event
        return true;
    }

    
}
