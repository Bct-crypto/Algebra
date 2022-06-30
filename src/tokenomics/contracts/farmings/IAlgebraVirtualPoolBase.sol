// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import 'algebra/contracts/interfaces/IAlgebraVirtualPool.sol';

/// @title Base interface for virtual pools
interface IAlgebraVirtualPoolBase is IAlgebraVirtualPool {
    // returns how much time the price was out of any farmd liquidity
    function timeOutside() external returns (uint32);

    // returns data associated with a tick
    function ticks(int24 tickId)
        external
        returns (
            uint128 liquidityTotal,
            int128 liquidityDelta,
            uint256 outerFeeGrowth0Token,
            uint256 outerFeeGrowth1Token,
            int56 outerTickCumulative,
            uint160 outerSecondsPerLiquidity,
            uint32 outerSecondsSpent,
            bool initialized
        );

    // returns the liquidity after previous swap (like the last timepoint in a default pool)
    function prevLiquidity() external returns (uint128);

    // returns the current liquidity in virtual pool
    function currentLiquidity() external returns (uint128);

    // returns the current tick in virtual pool
    function globalTick() external returns (int24);

    // returns total seconds per farmd liquidity from the moment of initialization of the virtual pool
    function globalSecondsPerLiquidityCumulative() external returns (uint160);

    // returns the timestamp after previous swap (like the last timepoint in a default pool)
    function prevTimestamp() external returns (uint32);

    /**
     * @dev This function is called when anyone farms their liquidity. The position in a virtual pool
     * should be changed accordingly
     * @param bottomTick The bottom tick of a position
     * @param topTick The top tick of a position
     * @param liquidityDelta The amount of liquidity in a position
     * @param tick The current tick in the main pool
     */
    function applyLiquidityDeltaToPosition(
        uint32 currentTimestamp,
        int24 bottomTick,
        int24 topTick,
        int128 liquidityDelta,
        int24 tick
    ) external;
}
