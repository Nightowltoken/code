{\rtf1\ansi\deff0\nouicompat{\fonttbl{\f0\fnil\fcharset0 Calibri;}}
{\*\generator Riched20 10.0.19041}\viewkind4\uc1 
\pard\sa200\sl276\slmult1\f0\fs22\lang9 pragma solidity 0.5.16;\par
\par
interface IBEP20 \{\par
  function totalSupply() external view returns (uint256);\par
  function decimals() external view returns (uint8);\par
  function symbol() external view returns (string memory);\par
  function name() external view returns (string memory);\par
  function getOwner() external view returns (address);\par
  function balanceOf(address account) external view returns (uint256);\par
  function transfer(address recipient, uint256 amount) external returns (bool);\par
  function allowance(address _owner, address spender) external view returns (uint256);\par
  function approve(address spender, uint256 amount) external returns (bool);\par
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\par
  event Transfer(address indexed from, address indexed to, uint256 value);\par
  event Approval(address indexed owner, address indexed spender, uint256 value);\par
\}\par
\par
contract Context \{\par
\par
  constructor () internal \{ \}\par
\par
  function _msgSender() internal view returns (address payable) \{\par
    return msg.sender;\par
  \}\par
\par
  function _msgData() internal view returns (bytes memory) \{\par
    this;\par
    return msg.data;\par
  \}\par
\}\par
\par
library SafeMath \{\par
\par
  function add(uint256 a, uint256 b) internal pure returns (uint256) \{\par
    uint256 c = a + b;\par
    require(c >= a, "SafeMath: addition overflow");\par
\par
    return c;\par
  \}\par
\par
  function sub(uint256 a, uint256 b) internal pure returns (uint256) \{\par
    return sub(a, b, "SafeMath: subtraction overflow");\par
  \}\par
\par
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) \{\par
    require(b <= a, errorMessage);\par
    uint256 c = a - b;\par
\par
    return c;\par
  \}\par
\par
  function mul(uint256 a, uint256 b) internal pure returns (uint256) \{\par
\par
    if (a == 0) \{\par
      return 0;\par
    \}\par
\par
    uint256 c = a * b;\par
    require(c / a == b, "SafeMath: multiplication overflow");\par
\par
    return c;\par
  \}\par
\par
  function div(uint256 a, uint256 b) internal pure returns (uint256) \{\par
    return div(a, b, "SafeMath: division by zero");\par
  \}\par
\par
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) \{\par
\par
    require(b > 0, errorMessage);\par
    uint256 c = a / b;\par
\par
    return c;\par
  \}\par
\par
  function mod(uint256 a, uint256 b) internal pure returns (uint256) \{\par
    return mod(a, b, "SafeMath: modulo by zero");\par
  \}\par
\par
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) \{\par
    require(b != 0, errorMessage);\par
    return a % b;\par
  \}\par
\}\par
\par
contract Ownable is Context \{\par
  address private _owner;\par
\par
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\par
\par
  constructor () internal \{\par
    address msgSender = _msgSender();\par
    _owner = msgSender;\par
    emit OwnershipTransferred(address(0), msgSender);\par
  \}\par
\par
  function owner() public view returns (address) \{\par
    return _owner;\par
  \}\par
\par
  modifier onlyOwner() \{\par
    require(_owner == _msgSender(), "Ownable: caller is not the owner");\par
    _;\par
  \}\par
\par
  function renounceOwnership() public onlyOwner \{\par
    emit OwnershipTransferred(_owner, address(0));\par
    _owner = address(0);\par
  \}\par
\par
  function transferOwnership(address newOwner) public onlyOwner \{\par
    _transferOwnership(newOwner);\par
  \}\par
\par
  function _transferOwnership(address newOwner) internal \{\par
    require(newOwner != address(0), "Ownable: new owner is the zero address");\par
    emit OwnershipTransferred(_owner, newOwner);\par
    _owner = newOwner;\par
  \}\par
\}\par
\par
contract BEP20Token is Context, IBEP20, Ownable \{\par
  using SafeMath for uint256;\par
\par
  mapping (address => uint256) private _balances;\par
\par
  mapping (address => mapping (address => uint256)) private _allowances;\par
\par
  uint256 private _totalSupply;\par
  uint8 private _decimals;\par
  string private _symbol;\par
  string private _name;\par
\par
  constructor() public \{\par
    _name = "NightOwlToken"; \par
    _symbol = "OWL"; \par
    _decimals = 12;\par
    _totalSupply = 130000000000000000000000; //130,000,000,000 Tokens\par
    _balances[msg.sender] = _totalSupply;\par
\par
    emit Transfer(address(0), msg.sender, _totalSupply);\par
  \}\par
\par
  function getOwner() external view returns (address) \{\par
    return owner();\par
  \}\par
\par
  function decimals() external view returns (uint8) \{\par
    return _decimals;\par
  \}\par
\par
  function symbol() external view returns (string memory) \{\par
    return _symbol;\par
  \}\par
\par
  function name() external view returns (string memory) \{\par
    return _name;\par
  \}\par
\par
  function totalSupply() external view returns (uint256) \{\par
    return _totalSupply;\par
  \}\par
\par
  function balanceOf(address account) external view returns (uint256) \{\par
    return _balances[account];\par
  \}\par
\par
  function transfer(address recipient, uint256 amount) external returns (bool) \{\par
    _transfer(_msgSender(), recipient, amount);\par
    return true;\par
  \}\par
\par
  function allowance(address owner, address spender) external view returns (uint256) \{\par
    return _allowances[owner][spender];\par
  \}\par
\par
  function approve(address spender, uint256 amount) external returns (bool) \{\par
    _approve(_msgSender(), spender, amount);\par
    return true;\par
  \}\par
\par
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) \{\par
    _transfer(sender, recipient, amount);\par
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));\par
    return true;\par
  \}\par
\par
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) \{\par
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\par
    return true;\par
  \}\par
\par
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) \{\par
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));\par
    return true;\par
  \}\par
\par
  function mint(uint256 amount) public onlyOwner returns (bool) \{\par
    _mint(_msgSender(), amount);\par
    return true;\par
  \}\par
\par
  function _transfer(address sender, address recipient, uint256 amount) internal \{\par
    require(sender != address(0), "BEP20: transfer from the zero address");\par
    require(recipient != address(0), "BEP20: transfer to the zero address");\par
\par
    _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");\par
    _balances[recipient] = _balances[recipient].add(amount);\par
    emit Transfer(sender, recipient, amount);\par
  \}\par
\par
  function _mint(address account, uint256 amount) internal \{\par
    require(account != address(0), "BEP20: mint to the zero address");\par
\par
    _totalSupply = _totalSupply.add(amount);\par
    _balances[account] = _balances[account].add(amount);\par
    emit Transfer(address(0), account, amount);\par
  \}\par
\par
  function _burn(address account, uint256 amount) internal \{\par
    require(account != address(0), "BEP20: burn from the zero address");\par
\par
    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");\par
    _totalSupply = _totalSupply.sub(amount);\par
    emit Transfer(account, address(0), amount);\par
  \}\par
\par
  function _approve(address owner, address spender, uint256 amount) internal \{\par
    require(owner != address(0), "BEP20: approve from the zero address");\par
    require(spender != address(0), "BEP20: approve to the zero address");\par
\par
    _allowances[owner][spender] = amount;\par
    emit Approval(owner, spender, amount);\par
  \}\par
\par
  function _burnFrom(address account, uint256 amount) internal \{\par
    _burn(account, amount);\par
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));\par
  \}\par
\}\par
\par
}
 