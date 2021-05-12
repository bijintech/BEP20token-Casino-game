pragma solidity >=0.5.16;
import './StableXPair.sol';
import './StableXFactory.sol';
import './libraries/IWETH.sol';

interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint256 value) internal pure {
        // (bool success, ) = to.call{value: value}(new bytes(0));
        // require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
        // to.transfer(value);
        to.call.value(value);
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
  // Empty internal constructor, to prevent people from mistakenly deploying
  // an instance of this contract, which should be used via inheritance.
  constructor () internal { }

  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

library StableXLibrary {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'StableXLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'StableXLibrary: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'a8c17cde5b5b0559d7dd9df85ccf3bb3941535d4a67923802ee89fce19be7bec' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address pairAddress, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = StableXPair(pairAddress).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'StableXLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'StableXLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'StableXLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'StableXLibrary: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(9994);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'StableXLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'StableXLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(10000);
        uint denominator = reserveOut.sub(amountOut).mul(9994);
        amountIn = (numerator / denominator).add(1);
    }
    
    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(uint amountIn, address pairAddress, address tokenA, address tokenB) internal view returns (uint amounts) {
        (uint reserveIn, uint reserveOut) = getReserves(pairAddress, tokenA, tokenB);
        amounts = getAmountOut(amountIn, reserveIn, reserveOut);
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(uint amountOut, address pairAddress, address tokenA, address tokenB) internal view returns (uint amounts) {
        (uint reserveIn, uint reserveOut) = getReserves(pairAddress, tokenA, tokenB);
        amounts = getAmountIn(amountOut, reserveIn, reserveOut);
    }
}

contract DICEToken is Context, IBEP20, Ownable {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  uint256 private maxSupply;
  address private developerAddress;
  uint256 private mintedAmount;
  address public factory;
  address payable public WETH;
  address public pairAddress;
  uint256 public betnum;
  uint256 public startTime;
  uint256 public lastmintTime;
  uint256 public lastrewardTime;

  struct User {
    uint256 playcount;
    bool play;
    bool liquidity;
    uint256 reward;
  }
  
  mapping (address => User) internal users;
  
  address payable[] public LiqudityAdresses;
  address payable[] public BetAdresses;

  constructor(address _factory, address payable _WETH, address _developer) public {
    _name = 'DICE';
    _symbol = 'DICE';
    _decimals = 8;
    _totalSupply = 50000000 * 10**8;
    maxSupply = 1000000000 * 10**8;
    developerAddress = _developer;
    mintedAmount = 0;
    betnum = 0;
    factory = _factory;
    WETH = _WETH;
    startTime = block.timestamp;
    lastmintTime = block.timestamp;
    lastrewardTime = block.timestamp;
    
    pairAddress = StableXFactory(factory).createPair(WETH, address(this));
    
    // _balances[msg.sender] = _totalSupply;
    _balances[address(this)] = _totalSupply.div(10);
    _balances[developerAddress] = _totalSupply.div(10).mul(9);

    emit Transfer(address(0), address(this), _totalSupply.div(10));
    emit Transfer(address(0), developerAddress, _totalSupply.div(10).mul(9));
  }

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address) {
    return owner();
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }
  
  function getPairAddress() external view returns (address) {
      return pairAddress;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function setBet(address payable sender, uint256 amount) external returns (bool) {
    betnum = betnum + 1;
    User storage user = users[sender];
    user.playcount = user.playcount + 1;
    if(!user.play) {
        user.play = true;
        BetAdresses.push(sender);
    }
    _transfer(sender, address(this), amount);
    updateAll();
    return true;
  }

  function getBet(address recipient, uint256 amount) external returns (bool) {
    _transfer(address(this), recipient, amount);
    updateAll();
    return true;
  }
  
  function rewardDaily() internal returns (bool) {
      uint256 mintAmount = mintedAmount;
      uint256 developerToken = mintedAmount.div(10);
      User storage user = users[developerAddress];
      user.reward = user.reward + developerToken;
      // _transfer(address(this), developerAddress, developerToken);

      uint256 betToken = mintedAmount.div(10).mul(3);
      playerReward(betToken);
      uint256 liqudityToken = mintedAmount.div(10).mul(4);
      farmingReward(liqudityToken);
      mintedAmount = mintedAmount - mintAmount;
      return true;
  }

  function playerReward(uint256 amount) internal returns (bool) {
    for(uint256 i = 0; i < BetAdresses.length; i++) {
      User storage user = users[BetAdresses[i]];
      user.play = false;
      user.reward = user.reward + amount.div(betnum).mul(user.playcount);
      user.playcount = 0;
      // _transfer(address(this), BetAdresses[i], betToken.div(betnum).mul(users[BetAdresses[i]].playcount));      
    }
    betnum = 0;
    delete BetAdresses;
  }

  function farmingReward(uint256 amount) internal returns (bool) {
    for(uint256 i = 0; i < LiqudityAdresses.length; i++) {
      if(StableXPair(pairAddress).totalSupply() != 0) {
          User storage user = users[LiqudityAdresses[i]];
          uint256 token = amount.div(StableXPair(pairAddress).totalSupply()).mul(StableXPair(pairAddress).balanceOf(LiqudityAdresses[i]));
          user.reward = user.reward + token;
          // _transfer(address(this), LiqudityAdresses[i], token);
      }
    }
  }

  function checkReward() external view returns (bool) {
    if (users[msg.sender].reward > 0) {
      return true;
    } else {
      return false;
    }
  }

  function getReward() external returns (bool) {
    _transfer(address(this), msg.sender, users[msg.sender].reward);
    users[msg.sender].reward = 0;
    return true;
  }

  function updateAll() public returns (bool){
    if (block.timestamp > lastmintTime) {
        uint256 mintPerSecond = getMintAmount(block.timestamp);
        uint256 multiplier = getMultiplier(lastmintTime, block.timestamp);
        uint256 mint = multiplier.mul(mintPerSecond);
        _mint(_msgSender(), mint);
        lastmintTime = block.timestamp;
    }
    if (block.timestamp - lastrewardTime >= 60*60*24) {
      rewardDaily();
      lastrewardTime = block.timestamp;
    }
    return true;
  }

  function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
      _from = _from > startTime ? _from : startTime;
      if (_to < startTime) {
          return 0;
      }
      return _to - _from;
  }

  function getMintAmount(uint256 time) public view returns (uint256) {
    if (time < startTime) {
      return 0;
    }
    if (time-startTime < 15*60*60*24) {
      return 20;
    }
    if (time-startTime < 30*60*60*24) {
      return 10;
    }
    return 1;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue));
    return true;
  }

  /**
   * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
   * the total supply.
   *
   * Requirements
   *
   * - `msg.sender` must be the token owner
   */
  function mint(uint256 amount) public onlyOwner returns (bool) {
    _mint(_msgSender(), amount);
    return true;
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Transfer} event with `from` set to the zero address.
   *
   * Requirements
   *
   * - `to` cannot be the zero address.
   */
  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: mint to the zero address");
    require(_totalSupply.add(amount)<=maxSupply, "BEP20: mint override max totalsupply");

    _totalSupply = _totalSupply.add(amount);
    _balances[address(this)] = _balances[address(this)].add(amount);
    mintedAmount = mintedAmount.add(amount);
    emit Transfer(address(0), address(this), amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount);
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
   * from the caller's allowance.
   *
   * See {_burn} and {_approve}.
   */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount));
  }

  // **** ADD LIQUIDITY ****
    function _addLiquidity(
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin
    ) internal returns (uint amountA, uint amountB) {
        // create the pair if it doesn't exist yet
        if (StableXFactory(factory).getPair(WETH, address(this)) == address(0)) {
            StableXFactory(factory).createPair(WETH, address(this));
        }
        (uint reserveA, uint reserveB) = StableXLibrary.getReserves(pairAddress, address(this), WETH);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = StableXLibrary.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, 'StableXRouter: INSUFFICIENT_B_AMOUNT');
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint amountAOptimal = StableXLibrary.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, 'StableXRouter: INSUFFICIENT_A_AMOUNT');
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }
    function addLiquidityETH(
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity) {
        updateAll();
        User storage user = users[msg.sender];
        if(!user.liquidity) {
            LiqudityAdresses.push(msg.sender);
        }
        (amountToken, amountETH) = _addLiquidity(
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin
        );
        address pair = pairAddress;
        // TransferHelper.safeTransferFrom(address(this), msg.sender, pair, amountToken);
        _transfer(msg.sender, pair, amountToken);
        // IWETH(WETH).deposit{value: amountETH}();
        IWETH(WETH).deposit.value(amountETH)();
        assert(IWETH(WETH).transfer(pair, amountETH));
        liquidity = StableXPair(pair).mint(to);
        // // refund dust eth, if any
        // if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
        if (msg.value > amountETH) {
            (bool success, ) = msg.sender.call.value(msg.value - amountETH)('');
            require(success, 'DICE: CALL ERROR');
        }
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to
    ) public returns (uint amountA, uint amountB) {
        address pair = pairAddress;
        StableXPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        (uint amount0, uint amount1) = StableXPair(pair).burn(to);
        (address token0,) = StableXLibrary.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, 'StableXRouter: INSUFFICIENT_A_AMOUNT');
        require(amountB >= amountBMin, 'StableXRouter: INSUFFICIENT_B_AMOUNT');
    }
    function removeLiquidityETH(
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address payable to
    ) public returns (uint amountToken, uint amountETH) {
        (amountToken, amountETH) = removeLiquidity(
            address(this),
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this)
        );
        TransferHelper.safeTransfer(address(this), to, amountToken);
        IWETH(WETH).withdraw(amountETH, developerAddress, to);
        // TransferHelper.safeTransferETH(to, amountETH);
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    function _swap(uint amounts, address addressA, address addressB, address _to) internal {
        updateAll();
        (address input, address output) = (addressA, addressB);
        (address token0,) = StableXLibrary.sortTokens(input, output);
        uint amountOut = amounts;
        (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
        // address to = i < path.length - 2 ? StableXLibrary.pairFor(factory, output, path[i + 2]) : _to;
        // StableXPair(pairAddress).sync();
        StableXPair(pairAddress).swap(
            amount0Out, amount1Out, _to, new bytes(0)
        );
    }
    function swapExactETHForTokens(address to)
        external
        payable
        returns (uint amounts)
    {
        // require(path[0] == WETH, 'StableXRouter: INVALID_PATH');
        amounts = StableXLibrary.getAmountsOut(msg.value, pairAddress, WETH, address(this));
        // require(amounts >= amountOutMin, 'StableXRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        // IWETH(WETH).deposit{value: amounts[0]}();
        IWETH(WETH).deposit.value(msg.value)();
        assert(IWETH(WETH).transfer(pairAddress, msg.value));
        _swap(amounts, WETH, address(this), to);
    }
    function swapTokensForExactETH(uint amountOut, address payable to)
        external
        returns (uint amounts)
    {
        // require(path[path.length - 1] == WETH, 'StableXRouter: INVALID_PATH');
        amounts = StableXLibrary.getAmountsIn(amountOut, pairAddress, address(this), WETH);
        // require(amounts <= amountInMax, 'StableXRouter: EXCESSIVE_INPUT_AMOUNT');
        // TransferHelper.safeTransferFrom(
        //     address(this), msg.sender, pairAddress, amounts
        // );
        _transfer(msg.sender, pairAddress, amounts);
        _swap(amountOut, address(this), WETH, developerAddress);
        IWETH(WETH).withdraw(amountOut, developerAddress, to);
        // TransferHelper.safeTransferETH(to, amountOut);
    }
    function swapExactTokensForETH(uint amountIn, address payable to)
        external
        returns (uint amounts)
    {
        // require(path[path.length - 1] == WETH, 'StableXRouter: INVALID_PATH');
        amounts = StableXLibrary.getAmountsOut(amountIn, pairAddress, address(this), WETH);
        // require(amounts >= amountOutMin, 'StableXRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        // TransferHelper.safeTransferFrom(
        //     address(this), msg.sender, pairAddress, amountIn
        // );
        _transfer(msg.sender, pairAddress, amountIn);
        _swap(amounts, address(this), WETH, developerAddress);
        IWETH(WETH).withdraw(amounts,developerAddress, to);
        // TransferHelper.safeTransferETH(to, amounts);
    }
    function swapETHForExactTokens(uint amountOut, address to)
        external
        payable
        returns (uint amounts)
    {
        // require(path[0] == WETH, 'StableXRouter: INVALID_PATH');
        amounts = StableXLibrary.getAmountsIn(amountOut, pairAddress, WETH, address(this));
        // require(amounts <= msg.value, 'StableXRouter: EXCESSIVE_INPUT_AMOUNT');
        // IWETH(WETH).deposit{value: amounts[0]}();
        IWETH(WETH).deposit.value(amounts)();
        assert(IWETH(WETH).transfer(pairAddress, amounts));
        _swap(amountOut, WETH, address(this), to);
        // refund dust eth, if any
        // if (msg.value > amounts) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts);
        if (msg.value > amounts) {
            (bool success, ) = msg.sender.call.value(msg.value - amounts)('');
            require(success, 'DICE: CALL ERROR');
        }
    }

    // **** LIBRARY FUNCTIONS ****
    function quote(uint amountA, uint reserveA, uint reserveB) public pure returns (uint amountB) {
        return StableXLibrary.quote(amountA, reserveA, reserveB);
    }

    function getReserves() public view returns (uint amountA, uint amountB) {
      (amountA, amountB) = StableXLibrary.getReserves(pairAddress, WETH, address(this));
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
        public
        pure
        returns (uint amountOut)
    {
        return StableXLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
    }

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
        public
        pure
        returns (uint amountIn)
    {
        return StableXLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
    }

    function getAmountsOutFromETH(uint amountIn)
        public
        view
        returns (uint amounts)
    {
        return StableXLibrary.getAmountsOut(amountIn, pairAddress, WETH, address(this));
    }

    function getAmountsOutFromToken(uint amountIn)
        public
        view
        returns (uint amounts)
    {
        return StableXLibrary.getAmountsOut(amountIn, pairAddress, address(this), WETH);
    }

    function getAmountsInFromETH(uint amountOut)
        public
        view
        returns (uint amounts)
    {
        return StableXLibrary.getAmountsIn(amountOut, pairAddress, WETH, address(this));
    }

    function getAmountsInFromToken(uint amountOut)
        public
        view
        returns (uint amounts)
    {
        return StableXLibrary.getAmountsIn(amountOut, pairAddress, address(this), WETH);
    }

    function getLiquidity(address liquidityAddress) public view returns (uint liquidity)
    {
      return StableXPair(pairAddress).balanceOf(liquidityAddress);
    }
    
    function getTotalLiquidity() public view returns (uint liquidity)
    {
      return StableXPair(pairAddress).totalSupply();
    }
}
