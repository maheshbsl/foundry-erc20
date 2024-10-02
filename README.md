# ManualToken Pseudocode

## Contract Overview

**State Variables:**
- `string name = "ManualToken"`
- `string symbol = "MTK"`
- `uint8 decimals = 18`
- `uint256 totalSupply`
- `mapping(address => uint256) balanceOf`
- `mapping(address => mapping(address => uint256)) allowance`

## Events:
- `Transfer(address indexed from, address indexed to, uint256 value)`
- `Approve(address indexed owner, address indexed spender, uint256 value)`
- `Burn(address indexed from, uint256 value)`

## Constructor:

```plaintext
constructor(string tokenName, string tokenSymbol, uint256 initialSupply):
    - Set totalSupply = initialSupply * 10^decimals
    - Assign totalSupply to balanceOf[msg.sender]
    - Set name and symbol based on input parameters

```
## Functions

```

_transfer(address from, address to, uint256 value):
    - REQUIRE: 'to' is not address(0)
    - REQUIRE: balanceOf[from] >= value (sufficient tokens)
    - REQUIRE: No overflow (balanceOf[to] + value >= balanceOf[to])
    - Track previous balance of 'from' and 'to'
    - Deduct 'value' from 'from' and add to 'to'
    - EMIT Transfer(from, to, value)
    - ASSERT: Balance consistency after transfer

transfer(address to, uint256 value) -> returns (bool):
    - CALL: _transfer(msg.sender, to, value)
    - RETURN: true


approve(address spender, uint256 value) -> returns (bool):
    - Set allowance[msg.sender][spender] = value
    - EMIT Approve(msg.sender, spender, value)
    - RETURN: true

transferFrom(address sender, address to, uint256 value) -> returns (bool):
    - REQUIRE: value <= allowance[sender][msg.sender]
    - Deduct value from allowance
    - CALL: _transfer(sender, to, value)
    - RETURN: true

burn(uint256 value) -> returns (bool):
    - REQUIRE: msg.sender has enough tokens to burn
    - Deduct 'value' from msg.sender’s balance
    - Reduce totalSupply by 'value'
    - EMIT Burn(msg.sender, value)
    - RETURN: true

burnFrom(address from, uint256 value) -> returns (bool):
    - REQUIRE: value <= allowance[from][msg.sender]
    - REQUIRE: balanceOf[from] >= value
    - Deduct value from 'from's balance and allowance
    - Reduce totalSupply by 'value'
    - EMIT Burn(from, value)
    - RETURN: true

increaseAllowance(address spender, uint256 value) -> returns (bool):
    - Increase allowance[msg.sender][spender] by value
    - EMIT Approve(msg.sender, spender, updated allowance)
    - RETURN: true

decreaseAllowance(address spender, uint256 valueToSubtract) -> returns (bool):
    - REQUIRE: allowance[msg.sender][spender] >= valueToSubtract
    - Decrease allowance[msg.sender][spender] by valueToSubtract
    - EMIT Approve(msg.sender, spender, updated allowance)
    - RETURN: true

```