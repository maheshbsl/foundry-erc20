# Implementing Your Own ERC20 Token

## ERC20 Architecture

### 1.smart contract storage
#### The smart contract includes mappings that track token balances and allowances.These data structures store the essential information about token ownership and how much one account is allowed to spend on behalf of another.

#### balances:-> This mapping stores the token balance for each address.
#### allownaces:-> This mapping stores the amount of tokens one  address is allowed to transfer from another address.
 