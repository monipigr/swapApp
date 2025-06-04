// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "../lib/forge-std/src/Test.sol";
import "../src/SwapApp.sol";

contract SwapAppTest is Test {
    SwapApp app;
    address uniswapV2SwappRouterAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address user = 0xF977814e90dA44bFA03b6295A0616a897441aceC; // Address with USDT in Arbitrum mainnet
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT address in Arbitrum mainnet
    address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI address in Arbitrum mainnet

    function setUp() public {
        // Al estar imitando el estado de una red real, le pasamos la address del router de Uniswap para forkearla
        app = new SwapApp(uniswapV2SwappRouterAddress);
    }

    // Comprueba que se ha deployeado correctamente
    function testHasBeenDeployedCorrectly() public view {
        assert(app.V2Router02Address() == uniswapV2SwappRouterAddress);
    }

    function testSwapTokensCorrectly() public {
        vm.startPrank(user);
        // Como hacemos una llamada al safeTransferFrom tenemos que hacer un approve primero
        uint256 amountIn = 5 * 1e6; // 1e6 es número de decimales del token usdt en la red de arbitrum. 
        IERC20(USDT).approve(address(app), amountIn); // aprobamos a nuestro contrato app que transfiera dicha cantidad. 

        //Llamada a swapTokens propiamente
        uint256 amountOutMin = 4 * 1e18; // 1e18 es número de decimales del token dai en la red de arbitrum. 
        uint256 deadline = 1747815058 + 1000000000; //unixtimestamp + 100000000 para que no revierta
        address[] memory path = new address[](2);
        path[0] = USDT;
        path[1] = DAI;

        uint256 usdtBalanceBefore = IERC20(USDT).balanceOf(user);
        uint256 daiBalanceBefore = IERC20(DAI).balanceOf(user);
        app.swapTokens(amountIn, amountOutMin, path, deadline);
        uint256 usdtBalanceAfter = IERC20(USDT).balanceOf(user);
        uint256 daiBalanceAfter = IERC20(DAI).balanceOf(user);

        assert(usdtBalanceAfter == usdtBalanceBefore - amountIn);
        assert(daiBalanceAfter > daiBalanceBefore); // No sabemos qué cantidad nos va a devolver exactamente

        vm.stopPrank();
    }


}
