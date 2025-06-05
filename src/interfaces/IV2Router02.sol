// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IV2Router02 {

    // No hace falta importar todas las funciones, solamente la que vamos a utilizar
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
}