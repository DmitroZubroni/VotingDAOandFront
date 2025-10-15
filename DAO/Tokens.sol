// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20, ERC20Votes, EIP712, IVotes} from "./ERC20Bundle.sol";


contract ProfiCoin is ERC20Votes {

    constructor(address tom, address ben, address rick, address jack) ERC20("ProfiCoin", "Profi") EIP712("ProfiCoin", "1") {
        _mint(tom, 25000 * 10 ** 12);
        _mint(ben, 25000 * 10 ** 12);
        _mint(rick, 25000 * 10 ** 12);
        _mint(jack, 25000 * 10 ** 12);
    }

    function decimals() public pure override returns (uint8) {
        return 12;
    }

    function transferCustom(address from, address to, uint amount) public {
        _transfer(from,to,amount);
    }

    function delegate(address account) public virtual override {
        super.delegate(account);
    }
}

contract RTKCoin is ERC20Votes {

    constructor() ERC20("RTKCoin", "RTK") EIP712("RTKCoin", "1") {}

    uint constant maxSyply = 20_000_000 * 10 ** 12;

    function decimals() public pure override returns (uint8) {
        return 12;
    }

    function transferCustom(address from, address to, uint amount) public {
        _transfer(from,to,amount);
    }

    function delegate(address account) public virtual override {
        super.delegate(account);
    }

    function mint(address acount, uint amount) public {
        require(totalSupply() + amount <= maxSyply, "ERC20: mint amount exceeds maxSupply");
        _mint(acount, amount);
    }

    function price() public pure returns(uint) {
        return 1000000 wei;
    }
}