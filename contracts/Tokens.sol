// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20, ERC20Votes, EIP712, IVotes} from "./ERC20Bundle.sol";

contract ProfiCoin is ERC20Votes  {
    constructor(address Tom, address Ben, address Rick, address Jack) ERC20("ProfiCoin", "Profi") EIP712("ProfiCoin", "1"){
        _mint(Tom, 25_000 * 10 ** 12);
        _mint(Ben, 25_000 * 10 ** 12);
        _mint(Rick, 25_000 * 10 ** 12);
        _mint(Jack, 25_000 * 10 ** 12);
    }

    function mint(address account, uint amount) public {
        _mint(account, amount);
    }

    function transfer(address from, address to, uint amount) public {
        _transfer(from, to, amount);
    }

    function delegate(address delegatee) public virtual override {
        super.delegate(delegatee);
    }
}

contract RTKCoin is ERC20Votes  {
    constructor(address Tom, address Ben, address Rick, address Jack) ERC20("RTKCoin", "rtk") EIP712("RTKCoin", "1") {
    }

    function price() public pure returns(uint) {
        return 1000000 wei;
    }

    function mint(address account, uint amount) public {
        _mint(account, amount);
    }

    function transfer(address from, address to, uint amount) public {
        _transfer(from, to, amount);
    }

    function delegate(address delegatee) public virtual override {
        super.delegate(delegatee);
    }
}