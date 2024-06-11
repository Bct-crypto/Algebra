// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import 'hardhat/console.sol';

/// @title Provides functions for deriving a pool address from the poolDeployer and tokens
/// @dev Credit to Uniswap Labs under GPL-2.0-or-later license:
/// https://github.com/Uniswap/v3-periphery
library PoolAddress {
    bytes32 internal constant POOL_INIT_CODE_HASH = 0x4b9e4a8044ce5695e06fce9421a63b6f5c3db8a561eebb30ea4c775469e36eaf;

    /// @notice The identifying key of the pool
    struct PoolKey {
        address token0;
        address token1;
        address deployer;
    }

    /// @notice Returns PoolKey: the ordered tokens
    /// @param tokenA The first token of a pool, unsorted
    /// @param tokenB The second token of a pool, unsorted
    /// @return Poolkey The pool details with ordered token0 and token1 assignments
    function getPoolKey(address tokenA, address tokenB, address deployer) internal pure returns (PoolKey memory) {
        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
        return PoolKey({token0: tokenA, token1: tokenB, deployer: deployer});
    }

    /// @notice Deterministically computes the pool address given the poolDeployer and PoolKey
    /// @param poolDeployer The Algebra poolDeployer contract address
    /// @param key The PoolKey
    /// @return pool The contract address of the Algebra pool
    function computeAddress(address poolDeployer, PoolKey memory key) internal pure returns (address pool) {
        require(key.token0 < key.token1, 'Invalid order of tokens');
        if (key.deployer == address(0)) {
            pool = address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                hex'ff',
                                poolDeployer,
                                keccak256(abi.encode(key.token0, key.token1)),
                                POOL_INIT_CODE_HASH
                            )
                        )
                    )
                )
            );
        } else {
            console.log('token0: ', key.token0);
            console.log('token1: ', key.token1);
            console.log('deployer: ', key.deployer);
            pool = address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                hex'ff',
                                poolDeployer,
                                keccak256(abi.encode(key.deployer, key.token0, key.token1)),
                                POOL_INIT_CODE_HASH
                            )
                        )
                    )
                )
            );
        }
    }
}
