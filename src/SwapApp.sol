// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


//Para poder utilizar las funciones de Uniswap necesitamos un contrato y una interfaz 
//El contrato lo definimos en el constructor. 
//La interfaz nos creamos una carpeta interfaces, añadimos la función que queremos y la importamos
import "./interfaces/IV2Router02.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract SwapApp {
    // Indicamos que queremos usar la librería SafeERC20 para la interfaz IERC20
    using SafeERC20 for IERC20; 

    address public V2Router02Address;
    event SwapTokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);   
    
    // Necesitamos la address de nuestro router del contrato de Uniswap
    constructor(address V2Router02Address_) {
        V2Router02Address = V2Router02Address_;
    } 

    // Función que nuestros usuarios puede n ejecutar para swapear tokens. 
    /**
     * uint amountIn - cantidad de tokens de input que vamos a mandar, es decir 5 usdt en nuestro ejemplo
     * uint amountOutMin - cantidad mínima de tokens que estamos dispuestos a recibir, sino la transacción debería de revertir
     * address[] calldata path - cantidad de hoops que se necesitan    
     * address to - qué cartera está recibiendo los tokens, a quién se va a mandar el resultado del swap- 
     * uint deadline - tiempo máximo que permitimos para que nuestra transacción se ejecute
     * uint[] memory amounts - cantidades tanto de inputs como de outputs 
     */  
    function swapTokens(uint256 amountIn_, uint256 amountOutMin_, address[] memory path_, uint256 deadline_) external {
        // 1. Transferimos tokens de nuestra cartera a este contrato
        // safeTransferFrom comprueba que no se mandan a la address(0), porque sino se quedarían ahí bloqueados para siempre
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);

        // 2. Tenemos que hacer un approve para que el safeTransferFrom de dentro de swatExactTokensForTokens se pueda ejecutar
        IERC20(path_[0]).approve(V2Router02Address, amountIn_);

        // 3. Swapea los tokens
        // Los parámetros tienen que ser calculados offchain y pasados a la función
        // swapExactTokensForTokens nos devuelve un array de cada una de las cantidades de los hoops. La última posición de este array sería la cantidad de tokens final. 
        uint256[] memory amountsOuts =  IV2Router02(V2Router02Address).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, msg.sender, deadline_);

        emit SwapTokens(path_[0], path_[path_.length - 1], amountIn_, amountsOuts[amountsOuts.length - 1]);
    }

}
