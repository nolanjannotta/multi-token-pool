pragma solidity 0.8.13;

import {UD60x18, unwrap, wrap, pow, ud, sub, add, div,UNIT} from "@prb/math/UD60x18.sol";

contract MultiTokenPool {
    struct Token {
        uint256 weight;
        uint256 balance;
        address tokenAddress;
    }

    mapping(uint256 => Token) public idToToken;

    mapping(uint256 => uint256) public idToBalance;

    uint256 numTokens;

    constructor() {
        idToToken[1] = Token(.15 ether, 20000 ether, address(0));
        idToToken[2] = Token(.2 ether, 20000 ether, address(0));
        // idToToken[3] = Token(.15 ether, 50 ether, address(0));
        // idToToken[4] = Token(.5 ether, 80 ether, address(0));
        numTokens = 4;
    }

    
    function getSpotPrice(uint256 _token1, uint256 _token2)
        public
        view
        returns (uint256)
    {
        // (tokenABalance / tokenAWeight) / (tokenBBalance / TokenBWeight)

        Token memory token1 = idToToken[_token1];
        Token memory token2 = idToToken[_token2];
        UD60x18 num = wrap(token1.balance).div(wrap(token1.weight));
        UD60x18 den = wrap(token2.balance).div(wrap(token2.weight));

        return unwrap(num.div(den));
    }

    function getEffectivePrice(uint256 _token1, uint _token2, uint amountToReceive)
        public
        view
        returns (uint256)
    {

        uint amountIn = getAmountIn(_token1,_token2,amountToReceive);

        UD60x18 price = div(wrap(amountIn), (wrap(amountToReceive)));

        return unwrap(price);
    }

    // invarient
    // (K) = (tokenABalance ^ tokenAWeight / 100) x (tokenBBalance ^ tokenBWeight / 100) x (tokenCBalance ^ tokenCWeight / 100)

    function getInvariant() public view returns (uint256) {
        // since were mulitplying it by itself, we need to start at 1
        UD60x18 invariant = UNIT;

        for (uint256 i = 1; i <= numTokens; i++) {
            Token memory token = idToToken[i];
            UD60x18 balance = ud(token.balance);
            UD60x18 weight = ud(token.weight);

            UD60x18 power = balance.pow(weight);
            invariant = invariant.mul(power);

        }

        return unwrap(invariant);
    }
    function getAmountOut(uint tokenAIndex, uint tokenBIndex, uint _amountIn) public view returns(uint) {
        // tokenA = the token a user is sending
        // tokenB = the token a user is receiving

        // tokenBOut = tokenBBalance (1- (tokenABalance / ( tokenABalance + tokenAIn )) ** (tokenAWeight/tokenB Weight)))
        Token memory tokenA = idToToken[tokenAIndex];
        Token memory tokenB = idToToken[tokenBIndex];

        UD60x18 tokenABalance = ud(tokenA.balance);
        UD60x18 tokenBBalance = ud(tokenB.balance);
        UD60x18 tokenAWeight = ud(tokenA.weight);
        UD60x18 tokenBWeight = ud(tokenB.weight);
        UD60x18 amountIn = ud(_amountIn);


        UD60x18 innerDenominator = add(tokenBBalance, amountIn);

        UD60x18 exponent = div(tokenBWeight,tokenAWeight);

        // we have to raise the numerator and demoninator the power individually then divide
        UD60x18 power = div(tokenBBalance.pow(exponent), innerDenominator.pow(exponent));

        UD60x18 amountOut = tokenABalance.mul(UNIT.sub(power));

        return unwrap(amountOut);


    }

    
    function getAmountIn(uint tokenAIndex, uint tokenBIndex, uint _amountOut) public view returns(uint) {
        // tokenA = the token a user is sending // tokenIn
        // tokenB = the token a user is receiving // tokenOut

        // tokenAIn = tokenABalance ((tokenBBalance / ( tokenBBalance - tokenBOut )) ** (tokenBWeight/tokenAWeight)) - 1)
        Token memory tokenA = idToToken[tokenAIndex];
        Token memory tokenB = idToToken[tokenBIndex];

        UD60x18 tokenABalance = ud(tokenA.balance);
        UD60x18 tokenBBalance = ud(tokenB.balance);
        UD60x18 tokenAWeight  = ud(tokenA.weight);
        UD60x18 tokenBWeight  = ud(tokenB.weight);
        UD60x18 amountOut     = ud(_amountOut);


        UD60x18 innerDenominator = sub(tokenBBalance, amountOut);

        UD60x18 exponent = div(tokenBWeight,tokenAWeight);

        // we have to raise the numerator and demoninator the power individually then divide
        UD60x18 powerResult = div(tokenBBalance.pow(exponent), innerDenominator.pow(exponent));

        UD60x18 amountIn = tokenABalance.mul(sub(powerResult, UNIT));

        return unwrap(amountIn);
    }
    function depositSingleAsset(uint tokenId, uint _amount) public returns(uint) {
        Token memory token = idToToken[tokenId];
        UD60x18 amount = ud(_amount);
        UD60x18 weight = token.weight;
        UD60x18 balance = token.balance;


        // poolShares = shareSupply ((1+ (depositAmount / balance))** weight     -1 )
        UD60x18 powerStuff = div(amount.pow(weight) / balance.pow()) ;
        
        UD60x18 innerFraction = add(UNIT, div(amount,balance));
        UD60x18 powerStuff = sub(innerFraction.pow(weight), UNIT);
        
        UD60x18 result = 




    }


}
