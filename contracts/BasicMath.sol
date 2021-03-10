//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "./AlgMath.sol";


contract BasicMath is AlgMath {

	int256 public _value;

	function demo() external {
		Number memory a = newDeterminantNumber(1);
		Number memory b = newDeterminantNumber(2);
		Number memory c = add(a, b);
		(bool ok, int256 val) = value(c);
		if (ok) {
			_value = val;	
			return;
		}
		_value = int256(-1);
	}
}
