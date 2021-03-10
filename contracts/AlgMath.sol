//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";


contract AlgMath {

	enum State { indeterminant, determinant, resolved }
	enum Operation { none, negation, addition, subtraction, multiplication, division, exponentiation, root, sin, cos, tan, imaginary }
	
	struct Number {
		State state;
		// if determinant
		int256 resolvedValue;
		// if unresolved
		bool negated;
		bool imaginary;
		Operation operation;
		Number[] operands;
	}

	function toBytes(Number memory number) internal pure returns(bytes memory) {
		bytes[] memory operandBytes = new bytes[](number.operands.length);
		uint256 operandBytesLen;
		for (uint256 i = 0; i < number.operands.length; i++) {
			bytes memory converted = toBytes(number.operands[i]);	
			operandBytesLen += converted.length;
			operandBytes[i] = converted;
		}
		uint256 retLen = 8 + 256 + 8 + 8 + 8 + operandBytesLen;
		bytes memory ret = new bytes(retLen);
		uint256 idx;
		for (uint256 i = 0; i < number.operands.length; i++) {
			for (uint256 j = 0; j < operandBytes[i].length; j++) {
				ret[idx] = operandBytes[i][j];
				idx++;	
			}	
		}
		return ret;
	}

	function value(Number memory number) internal pure returns(bool ok, int256 val) {
		Number memory resNumber = resolve(number);
		if (resNumber.state != State.resolved) {
			return (ok, val);
		}
		ok = true;
		val = resNumber.resolvedValue;
	}

	function newIndeterminantNumber() internal pure returns (Number memory) {
		Number[] memory emptyOperands;
		return Number(
			State.indeterminant,
			0,
			false,
			false,
			Operation.none,
			emptyOperands);
	}

	function newDeterminantNumber(int256 base) internal pure returns (Number memory) {
		Number[] memory emptyOperands;
		return Number(State.determinant, base, false, false, Operation.none, emptyOperands);
	}

	function negate(Number memory number) internal pure returns (Number memory) {
		number.negated = !number.negated;
		return number; 
	}

	function binaryOp(Number[] memory operands, Operation operation) internal pure returns (Number memory) {
		Number memory ret = Number( 
			State.determinant, 
			0, 
			false, 
			false, 
			operation, 
			operands);
		return ret;
	}

	function operand(Number memory a) internal pure returns (Number[] memory) {
		Number[] memory o = new Number[](1);
		o[0] = a;
		return o;
	}

	function operands(Number memory a, Number memory b) internal pure returns (Number[] memory) {
		Number[] memory o = new Number[](2);
		o[0] = a;
		o[1] = b;
		return o;
	}

	function add(Number memory a, Number memory b) internal pure returns (Number memory) {
		return binaryOp(operands(a, b), Operation.addition);
	}

	function subtract(Number memory a, Number memory b) internal pure returns (Number memory) {
		return binaryOp(operands(a, b), Operation.subtraction);
	}

	function multiply(Number memory a, Number memory b) internal pure returns (Number memory) {
		return binaryOp(operands(a, b), Operation.multiplication);
	}

	function divide(Number memory a, Number memory b) internal pure returns (Number memory) {
		return binaryOp(operands(a, b), Operation.division);
	}

	function pow(Number memory a, Number memory b) internal pure returns (Number memory) {
		return binaryOp(operands(a, b), Operation.exponentiation);
	}

	function root(Number memory a, Number memory b) internal pure returns (Number memory) {
		return binaryOp(operands(a, b), Operation.root);
	}

	function sin(Number memory number) internal pure returns (Number memory) {
		return binaryOp(operand(number), Operation.sin);
	}

	function cos(Number memory number) internal pure returns (Number memory) {
		return binaryOp(operand(number), Operation.cos);
	}

	function tan(Number memory number) internal pure returns (Number memory) {
		return binaryOp(operand(number), Operation.tan);
	}
	
	function imaginary(Number memory number) internal pure returns (Number memory) {
		return binaryOp(operand(number), Operation.imaginary);
	}

	function resolve(Number memory number) internal pure returns (Number memory) {
		if (number.state == State.resolved || number.state == State.indeterminant) {
			return number;
		}
		Number memory ret;
		if (number.operation == Operation.none) {
			ret.state = State.resolved;
			ret.resolvedValue = number.resolvedValue;
			return ret;
		}
		if (number.operation == Operation.negation) {
			Number memory a = resolve(number.operands[0]);
			if (a.state != State.resolved) { // TODO write isResolved()
				number.operands = operand(a);
				return number;
			}	
			ret.state = State.resolved;
			ret.resolvedValue = - a.resolvedValue;
			return ret;
		}
		if (number.operation == Operation.addition) {
			Number memory a = resolve(number.operands[0]);
			Number memory b = resolve(number.operands[1]);
			if (a.state != State.resolved || b.state != State.resolved) { // TODO write isResolved()
				number.operands = operands(a, b);
				return number;
			}	
			ret.state = State.resolved;
			ret.resolvedValue = a.resolvedValue + b.resolvedValue; // TODO SAFEMATH
			return ret;
		}
		if (number.operation == Operation.subtraction) {
			Number memory a = resolve(number.operands[0]);
			Number memory b = resolve(number.operands[1]);
			if (a.state != State.resolved || b.state != State.resolved) { // TODO write isResolved()
				number.operands = operands(a, b);
				return number;
			}	
			ret.state = State.resolved;
			ret.resolvedValue = a.resolvedValue - b.resolvedValue; // TODO SAFEMATH
			return ret;
		}
		if (number.operation == Operation.multiplication) {
			Number memory a = resolve(number.operands[0]);
			Number memory b = resolve(number.operands[1]);
			if (a.state != State.resolved || b.state != State.resolved) { // TODO write isResolved()
				number.operands = operands(a, b);
				return number;
			}	
			ret.state = State.resolved;
			ret.resolvedValue = a.resolvedValue * b.resolvedValue; // TODO SAFEMATH
			return ret;
		}
		if (number.operation == Operation.division) {
			Number memory a = resolve(number.operands[0]);
			Number memory b = resolve(number.operands[1]);
			if (a.state != State.resolved || b.state != State.resolved) { // TODO write isResolved()
				number.operands = operands(a, b);
				return number;
			}	
			ret.state = State.resolved;
			ret.resolvedValue = a.resolvedValue / b.resolvedValue; // TODO SAFEMATH
			return ret;
		}
		if (number.operation == Operation.exponentiation) {
			Number memory a = resolve(number.operands[0]);
			Number memory b = resolve(number.operands[1]);
			if (a.state != State.resolved || b.state != State.resolved) { // TODO write isResolved()
				number.operands = operands(a, b);
				return number;
			}	
			ret.state = State.resolved;
			// TODO ret.resolvedValue = pow(a.resolvedValue, b.resolvedValue); // TODO SAFEMATH
			return ret;
		}
		if (number.operation == Operation.root) {
			Number memory a = resolve(number.operands[0]);
			Number memory b = resolve(number.operands[1]);
			if (a.state != State.resolved || b.state != State.resolved) { // TODO write isResolved()
				number.operands = operands(a, b);
				return number;
			}	
			ret.state = State.resolved;
			// TODO ret.resolvedValue = root(a.resolvedValue, b.resolvedValue); // TODO SAFEMATH
			return ret;
		}
		// ETC .........
		// TODO
		// this will recursively resolve the number;
		// will set `resolvedValue` iff all operands can be resolved.
		return ret; // DUMMY
	}
}
