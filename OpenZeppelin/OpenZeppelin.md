### **1. SafeERC20**

#### **Before Optimization (Unoptimized)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnoptimizedERC20 {
    mapping(address => uint256) public balances;

    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount; // Unsafe subtraction
        balances[to] += amount; // Unsafe addition
    }
}
```

#### **After Optimization (Using SafeERC20)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract OptimizedERC20 {
    using SafeERC20 for IERC20;

    mapping(address => uint256) public balances;

    function transfer(IERC20 token, address to, uint256 amount) public {
        token.safeTransfer(to, amount); // Safe ERC20 transfer
    }

    function transferFrom(IERC20 token, address from, address to, uint256 amount) public {
        token.safeTransferFrom(from, to, amount); // Safe transfer from another address
    }
}
```

### **When to Use SafeERC20:**
Use SafeERC20 when you want to handle ERC20 token transfers securely, preventing any transfer issues that could lead to unexpected contract behavior.
- **safeTransfer:** "I'm sending my tokens to you."
- **safeTransferFrom:** "I'm sending someone else's tokens (with permission) to another person."

---

### **2. SafeMath**

#### **Before Optimization (Unoptimized)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnoptimizedMath {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b; // Unsafe addition
    }

    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        require(b <= a, "Subtraction overflow");
        return a - b; // Unsafe subtraction
    }

    function mul(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b; // Unsafe multiplication
    }

    function div(uint256 a, uint256 b) public pure returns (uint256) {
        require(b > 0, "Division by zero");
        return a / b; // Unsafe division
    }
}
```

#### **After Optimization (Using SafeMath)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract OptimizedMath {
    using SafeMath for uint256;

    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a.add(b); // Safe addition
    }

    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        return a.sub(b); // Safe subtraction
    }

    function mul(uint256 a, uint256 b) public pure returns (uint256) {
        return a.mul(b); // Safe multiplication
    }

    function div(uint256 a, uint256 b) public pure returns (uint256) {
        return a.div(b); // Safe division
    }
}
```

### **When to Use SafeMath:**
Use SafeMath for all arithmetic operations to avoid overflow and underflow issues in your contract.

---

### **3. ReentrancyGuard**

#### **Before Optimization (Unoptimized)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnoptimizedReentrancy {
    mapping(address => uint256) public balances;

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        payable(msg.sender).transfer(amount); // Unsafe external call
        balances[msg.sender] -= amount; // Unsafe subtraction
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value; // Unsafe addition
    }

    function callExternalContract(address externalContract, bytes memory data) public {
        (bool success, ) = externalContract.call(data); // Unsafe external call
        require(success, "External call failed");
    }

    function sendCrossChainData(address recipient, bytes memory data) public {
        // Example: Using Chainlink's CCIP to send data
        CCIP.send(recipient, data); // Unsafe call to CCIP
    }
}
```

#### **After Optimization (Using ReentrancyGuard)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract OptimizedReentrancy is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender].sub(amount); // Safe subtraction
        payable(msg.sender).transfer(amount); // Reentrancy protected
    }

    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value); // Safe addition
    }

    // Example of external contract call without reentrancy protection
    function callExternalContract(address externalContract, bytes memory data) public {
        (bool success, ) = externalContract.call(data); // Unsafe external call
        require(success, "External call failed");
    }

    // Example of external contract call with CCIP without reentrancy protection
    function sendCrossChainData(address recipient, bytes memory data) public {
        // Example: Using Chainlink's CCIP to send data
        CCIP.send(recipient, data); // Unsafe call to CCIP
    }
}
```

### **When to Use ReentrancyGuard:**
Use ReentrancyGuard to protect functions that send Ether or call external contracts to prevent reentrancy attacks. Additionally, it should be used for any function interacting with external contracts.

---

### **4. Pausable**

#### **Before Optimization (Unoptimized)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnoptimizedPausable {
    bool public paused;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function pause() public {
        require(msg.sender == admin, "Not an admin");
        paused = true; // Manual pause
    }

    function unpause() public {
        require(msg.sender == admin, "Not an admin");
        paused = false; // Manual unpause
    }

    function withdraw(uint256 amount) public {
        require(!paused, "Contract is paused");
        // Withdrawal logic
    }
}
```

#### **After Optimization (Using Pausable)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract OptimizedPausable is Pausable, AccessControlEnumerable {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    constructor() {
        _setupRole(ADMIN_ROLE, msg.sender); // Deployer is admin
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause(); // Pausable
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause(); // Unpause
    }

    function withdraw(uint256 amount) public whenNotPaused {
        // Withdrawal logic
    }
}
```

### **When to Use Pausable:**
Use Pausable to enable emergency pauses on your contract, preventing critical functions from being executed during maintenance or in response to vulnerabilities.

---

### **5. Combined Optimized Contract with CCIP**

Here’s the final combined code integrating all the optimizations, including the CCIP functionality:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/CCIP.sol"; // Import Chainlink CCIP

contract CombinedOptimizedContract is ReentrancyGuard, Pausable, AccessControlEnumerable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    mapping(address => uint256) public balances;

    constructor() {
        _setupRole(ADMIN_ROLE, msg.sender); // Deployer is admin
    }

    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value); // Safe addition
    }

    function withdraw(uint256 amount) public nonReentrant whenNotPaused {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender].sub(amount); // Safe subtraction
        payable(msg.sender).transfer(amount); // Reentrancy protected
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause(); // Pause the contract
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause(); // Unpause the contract
    }

    function transferTokens(IERC20 token, address to, uint256 amount) public {
        token.safeTransfer(to, amount); // Safe ERC20 transfer
    }

    function callExternalContract(address externalContract, bytes memory data) public {
        (bool success, ) = externalContract.call(data); // Unsafe external call
        require(success, "External call failed");
    }

    function sendCrossChainData(address recipient, bytes memory data

) public onlyRole(ADMIN_ROLE) nonReentrant whenNotPaused {
        CCIP.send(recipient, data); // Call to CCIP
    }
}
```

### **Conclusion**
This README structure provides a comprehensive overview of the design patterns used in Solidity, particularly with OpenZeppelin libraries, including SafeERC20, SafeMath, ReentrancyGuard, and Pausable, alongside implementing Chainlink's CCIP for external contract interactions. 

### **When to Use This Combined Contract:**
Use this combined contract structure for secure and maintainable ERC20 token contracts that require cross-chain interactions, manage balances, and implement effective access controls.
