//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "./AlgMath.sol";


contract BasicMath is AlgMath {

	bytes public _value1;
	bytes public _value2;

	function demo() external {
		// check to see if we can get distribution of * over +
		Number memory a = newDeterminantNumber(2);
		Number memory b = newDeterminantNumber(5);
		Number memory c = newDeterminantNumber(3);
		Number memory d = multiply(c, add(a, b)); // 3 * (2 + 5)
		(bool ok, int256 val) = value(d);
		if (ok) {
			int256 expected1 = 3 * (2 + 5);
			require(val == expected1, "incorrect value 1");
		}
		_value1 = toBytes(d);
		bytes32 hashVal = keccak256(toBytes(d));

		Number memory a2 = newDeterminantNumber(2);
		Number memory b2 = newDeterminantNumber(5);
		Number memory c2 = newDeterminantNumber(3);
		Number memory d2 = multiply(c2, add(a2, b2)); // 3 * (2 + 5)

		_value2 = toBytes(d2);
		bytes32 hashVal2 = keccak256(toBytes(d2));
		require(hashVal == hashVal2, "unequal hashes");
		//_value = int256(-1);
	}
}
