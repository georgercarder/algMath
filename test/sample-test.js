const { expect } = require("chai");

describe("AlgMath", function() {
  it("runs the demo", async function() {

    const BasicMath = await ethers.getContractFactory("BasicMath");
    const bMath = await BasicMath.deploy();

    await bMath.deployed();
    
    bMath.demo();
    let v1 = await bMath._value1();
    let v2 = await bMath._value2();
    console.log(v1);
    console.log(v2);
	  /*const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    
    await greeter.deployed();
    expect(await greeter.greet()).to.equal("Hello, world!");

    await greeter.setGreeting("Hola, mundo!");
    expect(await greeter.greet()).to.equal("Hola, mundo!");*/
  });
});
