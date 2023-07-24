

# IAlgebraPoolPermissionedActions


Permissioned pool actions

Contains pool methods that may only be called by permissioned addresses

*Developer note: Credit to Uniswap Labs under GPL-2.0-or-later license:
https://github.com/Uniswap/v3-core/tree/main/contracts/interfaces*


## Functions
### setCommunityFee


`function setCommunityFee(uint16 newCommunityFee) external`  external

Set the community&#x27;s % share of the fees. Only factory owner or POOLS_ADMINISTRATOR_ROLE role



| Name | Type | Description |
| ---- | ---- | ----------- |
| newCommunityFee | uint16 | The new community fee percent in thousandths (1e-3) |


### setTickSpacing


`function setTickSpacing(int24 newTickSpacing) external`  external

Set the new tick spacing values. Only factory owner or POOLS_ADMINISTRATOR_ROLE role



| Name | Type | Description |
| ---- | ---- | ----------- |
| newTickSpacing | int24 | The new tick spacing value |


### setPlugin


`function setPlugin(address newPluginAddress) external`  external

Set the new plugin address. Only factory owner or POOLS_ADMINISTRATOR_ROLE role



| Name | Type | Description |
| ---- | ---- | ----------- |
| newPluginAddress | address | The new plugin address |


### setPluginConfig


`function setPluginConfig(uint8 newConfig) external`  external

Set new plugin config



| Name | Type | Description |
| ---- | ---- | ----------- |
| newConfig | uint8 | In the new configuration of the plugin,


### setFee


`function setFee(uint16 newFee) external`  external

Set new pool fee. Can be called by owner if dynamic fee is disabled.
Called by the plugin if dynamic fee is enabled



| Name | Type | Description |
| ---- | ---- | ----------- |
| newFee | uint16 | The new fee value |

