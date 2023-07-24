

# IAlgebraFactory


The interface for the Algebra Factory



*Developer note: Credit to Uniswap Labs under GPL-2.0-or-later license:
https://github.com/Uniswap/v3-core/tree/main/contracts/interfaces*


## Events
### RenounceOwnershipStart


`event RenounceOwnershipStart(uint256 timestamp, uint256 finishTimestamp)`  

Emitted when a process of ownership renounce is started



| Name | Type | Description |
| ---- | ---- | ----------- |
| timestamp | uint256 | The timestamp of event |
| finishTimestamp | uint256 | The timestamp when ownership renounce will be possible to finish |


### RenounceOwnershipStop


`event RenounceOwnershipStop(uint256 timestamp)`  

Emitted when a process of ownership renounce cancelled



| Name | Type | Description |
| ---- | ---- | ----------- |
| timestamp | uint256 | The timestamp of event |


### RenounceOwnershipFinish


`event RenounceOwnershipFinish(uint256 timestamp)`  

Emitted when a process of ownership renounce finished



| Name | Type | Description |
| ---- | ---- | ----------- |
| timestamp | uint256 | The timestamp of ownership renouncement |


### Pool


`event Pool(address token0, address token1, address pool)`  

Emitted when a pool is created



| Name | Type | Description |
| ---- | ---- | ----------- |
| token0 | address | The first token of the pool by address sort order |
| token1 | address | The second token of the pool by address sort order |
| pool | address | The address of the created pool |


### DefaultCommunityFee


`event DefaultCommunityFee(uint16 newDefaultCommunityFee)`  

Emitted when the default community fee is changed



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultCommunityFee | uint16 | The new default community fee value |


### DefaultTickspacing


`event DefaultTickspacing(int24 newDefaultTickspacing)`  

Emitted when the default tickspacing is changed



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultTickspacing | int24 | The new default tickspacing value |


### DefaultFee


`event DefaultFee(uint16 newDefaultFee)`  

Emitted when the default fee is changed



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultFee | uint16 | The new default fee value |


### DefaultPluginFactory


`event DefaultPluginFactory(address defaultPluginFactoryAddress)`  

Emitted when the defaultPluginFactory address is changed



| Name | Type | Description |
| ---- | ---- | ----------- |
| defaultPluginFactoryAddress | address | The new defaultPluginFactory address |



## Functions
### POOLS_ADMINISTRATOR_ROLE


`function POOLS_ADMINISTRATOR_ROLE() external view returns (bytes32)` view external

role that can change communityFee and tickspacing in pools




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes32 | The hash corresponding to this role |

### hasRoleOrOwner


`function hasRoleOrOwner(bytes32 role, address account) external view returns (bool)` view external

Returns &#x60;true&#x60; if &#x60;account&#x60; has been granted &#x60;role&#x60; or &#x60;account&#x60; is owner.



| Name | Type | Description |
| ---- | ---- | ----------- |
| role | bytes32 | The hash corresponding to the role |
| account | address | The address for which the role is checked |

**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool Whether the address has this role or the owner role or not |

### owner


`function owner() external view returns (address)` view external

Returns the current owner of the factory

*Developer note: Can be changed by the current owner via transferOwnership(address newOwner)*




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The address of the factory owner |

### poolDeployer


`function poolDeployer() external view returns (address)` view external

Returns the current poolDeployerAddress




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The address of the poolDeployer |

### communityVault


`function communityVault() external view returns (address)` view external

Returns the current communityVaultAddress




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The address to which community fees are transferred |

### defaultCommunityFee


`function defaultCommunityFee() external view returns (uint16)` view external

Returns the default community fee




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint16 | Fee which will be set at the creation of the pool |

### defaultFee


`function defaultFee() external view returns (uint16)` view external

Returns the default fee




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint16 | Fee which will be set at the creation of the pool |

### defaultTickspacing


`function defaultTickspacing() external view returns (int24)` view external

Returns the default tickspacing




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int24 | Tickspacing which will be set at the creation of the pool |

### defaultPluginFactory


`function defaultPluginFactory() external view returns (contract IAlgebraPluginFactory)` view external

Return the current pluginFactory address




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | contract IAlgebraPluginFactory | Algebra plugin factory |

### defaultConfigurationForPool


`function defaultConfigurationForPool() external view returns (uint16 communityFee, int24 tickSpacing, uint16 fee)` view external

Returns the default communityFee and tickspacing




**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| communityFee | uint16 | which will be set at the creation of the pool |
| tickSpacing | int24 | which will be set at the creation of the pool |
| fee | uint16 | which will be set at the creation of the pool |

### computePoolAddress


`function computePoolAddress(address token0, address token1) external view returns (address pool)` view external

Deterministically computes the pool address given the token0 and token1

*Developer note: The method does not check if such a pool has been created*



| Name | Type | Description |
| ---- | ---- | ----------- |
| token0 | address | first token |
| token1 | address | second token |

**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The contract address of the Algebra pool |

### poolByPair


`function poolByPair(address tokenA, address tokenB) external view returns (address pool)` view external

Returns the pool address for a given pair of tokens, or address 0 if it does not exist

*Developer note: tokenA and tokenB may be passed in either token0/token1 or token1/token0 order*



| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenA | address | The contract address of either token0 or token1 |
| tokenB | address | The contract address of the other token |

**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The pool address |

### renounceOwnershipStartTimestamp


`function renounceOwnershipStartTimestamp() external view returns (uint256 timestamp)` view external






**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| timestamp | uint256 | The timestamp of the beginning of the renounceOwnership process |

### createPool


`function createPool(address tokenA, address tokenB) external returns (address pool)`  external

Creates a pool for the given two tokens

*Developer note: tokenA and tokenB may be passed in either order: token0/token1 or token1/token0.
The call will revert if the pool already exists or the token arguments are invalid.*



| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenA | address | One of the two tokens in the desired pool |
| tokenB | address | The other of the two tokens in the desired pool |

**Returns:**

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The address of the newly created pool |

### setDefaultCommunityFee


`function setDefaultCommunityFee(uint16 newDefaultCommunityFee) external`  external



*Developer note: updates default community fee for new pools*



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultCommunityFee | uint16 | The new community fee, _must_ be &lt;&#x3D; MAX_COMMUNITY_FEE |


### setDefaultFee


`function setDefaultFee(uint16 newDefaultFee) external`  external



*Developer note: updates default fee for new pools*



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultFee | uint16 | The new  fee, _must_ be &lt;&#x3D; MAX_DEFAULT_FEE |


### setDefaultTickspacing


`function setDefaultTickspacing(int24 newDefaultTickspacing) external`  external



*Developer note: updates default tickspacing for new pools*



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultTickspacing | int24 | The new tickspacing, _must_ be &lt;&#x3D; MAX_TICK_SPACING and &gt;&#x3D; MIN_TICK_SPACING |


### setDefaultPluginFactory


`function setDefaultPluginFactory(address newDefaultPluginFactory) external`  external



*Developer note: updates pluginFactory address*



| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultPluginFactory | address | address of new plugin factory |


### startRenounceOwnership


`function startRenounceOwnership() external`  external

Starts process of renounceOwnership. After that, a certain period
of time must pass before the ownership renounce can be completed.





### stopRenounceOwnership


`function stopRenounceOwnership() external`  external

Stops process of renounceOwnership and removes timer.




