// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.17;
pragma abicoder v1;

import '@cryptoalgebra/core/contracts/libraries/TickManagement.sol';
import '@cryptoalgebra/core/contracts/libraries/Constants.sol';
import '@cryptoalgebra/core/contracts/libraries/Plugins.sol';
import '@cryptoalgebra/core/contracts/libraries/TickMath.sol';

import '@cryptoalgebra/core/contracts/interfaces/pool/IAlgebraPoolActions.sol';
import '@cryptoalgebra/core/contracts/interfaces/pool/IAlgebraPoolState.sol';
import '@cryptoalgebra/core/contracts/interfaces/pool/IAlgebraPoolPermissionedActions.sol';
import '@cryptoalgebra/core/contracts/interfaces/IAlgebraPoolErrors.sol';
import '@cryptoalgebra/core/contracts/interfaces/plugin/IAlgebraPlugin.sol';

/// @title Mock of Algebra concentrated liquidity pool for plugins testing
contract MockPool is IAlgebraPoolActions, IAlgebraPoolPermissionedActions, IAlgebraPoolState {
  struct GlobalState {
    uint160 price; // The square root of the current price in Q64.96 format
    int24 tick; // The current tick
    int24 prevInitializedTick; // The previous initialized tick in linked list
    uint16 fee; // The current fee in hundredths of a bip, i.e. 1e-6
    uint8 pluginConfig;
    uint16 communityFee; // The community fee represented as a percent of all collected fee in thousandths (1e-3)
    bool unlocked; // True if the contract is unlocked, otherwise - false
  }

  /// @inheritdoc IAlgebraPoolState
  uint256 public override totalFeeGrowth0Token;
  /// @inheritdoc IAlgebraPoolState
  uint256 public override totalFeeGrowth1Token;
  /// @inheritdoc IAlgebraPoolState
  GlobalState public override globalState;

  /// @inheritdoc IAlgebraPoolState
  uint128 public override liquidity;
  /// @inheritdoc IAlgebraPoolState
  int24 public override tickSpacing;
  /// @inheritdoc IAlgebraPoolState
  uint32 public override communityFeeLastTimestamp;

  /// @inheritdoc IAlgebraPoolState
  address public override plugin;

  /// @inheritdoc IAlgebraPoolState
  mapping(int24 => TickManagement.Tick) public override ticks;

  /// @inheritdoc IAlgebraPoolState
  mapping(int16 => uint256) public override tickTable;

  struct Position {
    uint256 liquidity; // The amount of liquidity concentrated in the range
    uint256 innerFeeGrowth0Token; // The last updated fee growth per unit of liquidity
    uint256 innerFeeGrowth1Token;
    uint128 fees0; // The amount of token0 owed to a LP
    uint128 fees1; // The amount of token1 owed to a LP
  }

  /// @inheritdoc IAlgebraPoolState
  mapping(bytes32 => Position) public override positions;

  /// @inheritdoc IAlgebraPoolState
  function getCommunityFeePending() external pure override returns (uint128, uint128) {
    revert('not implemented');
  }

  /// @inheritdoc IAlgebraPoolState
  function fee() external pure returns (uint16) {
    revert('not implemented');
  }

  constructor() {
    globalState.fee = Constants.BASE_FEE;
    globalState.prevInitializedTick = TickMath.MIN_TICK;
  }

  /// @inheritdoc IAlgebraPoolState
  function getReserves() external pure override returns (uint128, uint128) {
    revert('not implemented');
  }

  /// @inheritdoc IAlgebraPoolActions
  function initialize(uint160 initialPrice) external override {
    int24 tick = TickMath.getTickAtSqrtRatio(initialPrice); // getTickAtSqrtRatio checks validity of initialPrice inside

    if (plugin != address(0)) {
      IAlgebraPlugin(plugin).beforeInitialize(msg.sender, initialPrice);
    }

    tickSpacing = 60;

    uint8 pluginConfig = globalState.pluginConfig;

    globalState.price = initialPrice;
    globalState.unlocked = true;
    globalState.tick = tick;

    if (pluginConfig & Plugins.AFTER_INIT_FLAG != 0) {
      IAlgebraPlugin(plugin).afterInitialize(msg.sender, initialPrice, tick);
    }
  }

  /// @inheritdoc IAlgebraPoolActions
  function mint(
    address,
    address,
    int24 bottomTick,
    int24 topTick,
    uint128 liquidityDesired,
    bytes calldata
  ) external override returns (uint256, uint256, uint128) {
    if (globalState.pluginConfig & Plugins.BEFORE_POSITION_MODIFY_FLAG != 0) {
      IAlgebraPlugin(plugin).beforeModifyPosition(msg.sender, bottomTick, topTick, int128(liquidityDesired)); // TODO REENTRANCY
    }

    if (globalState.pluginConfig & Plugins.AFTER_POSITION_MODIFY_FLAG != 0) {
      IAlgebraPlugin(plugin).afterModifyPosition(msg.sender, bottomTick, topTick, int128(liquidityDesired), 0, 0);
    }
    return (0, 0, 0);
  }

  /// @inheritdoc IAlgebraPoolActions
  function burn(int24 bottomTick, int24 topTick, uint128 liquidityDesired) external override returns (uint256, uint256) {
    if (globalState.pluginConfig & Plugins.BEFORE_POSITION_MODIFY_FLAG != 0) {
      IAlgebraPlugin(plugin).beforeModifyPosition(msg.sender, bottomTick, topTick, -int128(liquidityDesired));
    }

    if (globalState.pluginConfig & Plugins.AFTER_POSITION_MODIFY_FLAG != 0) {
      IAlgebraPlugin(plugin).afterModifyPosition(msg.sender, bottomTick, topTick, -int128(liquidityDesired), 0, 0);
    }
    return (0, 0);
  }

  /// @inheritdoc IAlgebraPoolActions
  function collect(address, int24, int24, uint128, uint128) external pure override returns (uint128, uint128) {
    revert('Not implemented');
  }

  /// @inheritdoc IAlgebraPoolActions
  function swap(address, bool, int256, uint160, bytes calldata) external pure override returns (int256, int256) {
    revert('Not implemented');
  }

  function swapToTick(int24 targetTick) external {
    if (globalState.pluginConfig & Plugins.BEFORE_SWAP_FLAG != 0) {
      // TODO optimize
      IAlgebraPlugin(plugin).beforeSwap(msg.sender, true, 0, 0);
    }

    globalState.price = TickMath.getSqrtRatioAtTick(targetTick);
    globalState.tick = targetTick;

    if (globalState.pluginConfig & Plugins.AFTER_SWAP_FLAG != 0) {
      // TODO optimize
      IAlgebraPlugin(plugin).afterSwap(msg.sender, true, 0, 0, 0, 0);
    }
  }

  /// @inheritdoc IAlgebraPoolActions
  function swapSupportingFeeOnInputTokens(address, address, bool, int256, uint160, bytes calldata) external pure override returns (int256, int256) {
    revert('Not implemented');
  }

  /// @inheritdoc IAlgebraPoolActions
  function flash(address, uint256 amount0, uint256 amount1, bytes calldata) external override {
    uint8 pluginConfig = globalState.pluginConfig;
    if (pluginConfig & Plugins.BEFORE_FLASH_FLAG != 0) {
      IAlgebraPlugin(plugin).beforeFlash(msg.sender, amount0, amount1);
    }

    if (pluginConfig & Plugins.AFTER_FLASH_FLAG != 0) {
      IAlgebraPlugin(plugin).afterFlash(msg.sender, amount0, amount1, 0, 0);
    }
  }

  /// @inheritdoc IAlgebraPoolPermissionedActions
  function setCommunityFee(uint16 newCommunityFee) external override {
    if (newCommunityFee > Constants.MAX_COMMUNITY_FEE || newCommunityFee == globalState.communityFee)
      revert IAlgebraPoolErrors.invalidNewCommunityFee();
    globalState.communityFee = newCommunityFee;
  }

  /// @inheritdoc IAlgebraPoolPermissionedActions
  function setTickSpacing(int24 newTickSpacing) external override {
    if (newTickSpacing <= 0 || newTickSpacing > Constants.MAX_TICK_SPACING || tickSpacing == newTickSpacing)
      revert IAlgebraPoolErrors.invalidNewTickSpacing();
    tickSpacing = newTickSpacing;
  }

  /// @inheritdoc IAlgebraPoolPermissionedActions
  function setPlugin(address newPluginAddress) external override {
    plugin = newPluginAddress;
  }

  /// @inheritdoc IAlgebraPoolPermissionedActions
  function setPluginConfig(uint8 newConfig) external override {
    globalState.pluginConfig = newConfig;
  }

  /// @inheritdoc IAlgebraPoolPermissionedActions
  function setFee(uint16 newFee) external override {
    globalState.fee = newFee;
  }
}