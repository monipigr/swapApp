## 🔄 SwapApp

## 📝 Overview

**SwapApp** is a lightweight and secure smart contract that enables token swaps via Uniswap V2 using custom parameters for input amount, slippage tolerance, swap path, and deadline. Designed for composability and ease of integration, it provides a safe interface for users to interact with the `swapExactTokensForTokens` method from Uniswap's router. Developed and tested using Foundry.

## ✨ Features

- 🔁 **Token Swapping:** Executes swaps between any ERC-20 tokens using Uniswap V2.
- 🧾 **Custom Parameters**: Accepts user-defined path, amountIn, slippage (`amountOutMin`), and deadline
- 🛡️ **Safe Transfers**: Utilizes `SafeERC20` for secure token operations
- 🔄 **Approvals & Transfers**: Handles ERC-20 approvals and input transfers internally
- 📢 **Event Emission**: Emits `SwapTokens` event with swap metadata

## 🧩 Smart Contract Architecture and Patterns

- **Design**: Stateless contract that interacts with the external `IV2Router02` interface from Uniswap
- **Events**:
  - `SwapTokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut)`
- **Libraries**:
  - Uses `SafeERC20` from OpenZeppelin to prevent unsafe token transfers
- **Patterns**:
  - CEI (Checks-Effects-Interactions)
  - No storage modification other than the router address
- **Security Practices**:
  - Safe token handling via `safeTransferFrom` and `approve`
  - Avoids approvals of unlimited amounts to minimize risk

## 🛠 Technologies Used

- **Solidity**: `^0.8.24`
- **Smart Contract Tools**: [Foundry](https://book.getfoundry.sh/)
- **Libraries**:
  - OpenZeppelin `SafeERC20`
  - Custom interface `IV2Router02` for Uniswap interaction

## 🧪 Testing

The contract is tested using Foundry on a forked Arbitrum mainnet environment. Addresses for real tokens (USDT and DAI) and the Uniswap router are used to simulate actual swaps.

| Test Function                  | Purpose                                              |
| ------------------------------ | ---------------------------------------------------- |
| `testHasBeenDeployedCorrectly` | Asserts correct initialization of router address     |
| `testSwapTokensCorrectly`      | Validates end-to-end token swap between USDT and DAI |

### What is covered:

- ✔️ Deployment with correct router
- ✔️ ERC-20 `approve` and `safeTransferFrom` integration
- ✔️ Token balances checked pre and post swap
- ✔️ Correct configuration of swap path and parameters
- ✔️ Successful event emission

## 💻 How to Run the Project Locally

### Prerequisites

- Install [Foundry](https://book.getfoundry.sh/)

### Setup

```bash
git clone https://github.com/your-username/swap-app.git
cd swap-app
forge install
```

### Testing

```bash
forge test
forge test --match-test testSwapTokensCorrectly -vvvv
```

## 📜 License

This project is licensed under the MIT License.
