const { expect } = require("chai");

describe("AlgMath", function() {
  it("runs the demo", async function() {

    const BasicMath = await ethers.getContractFactory("BasicMath");
    const bMath = await BasicMath.deploy();

    await bMath.deployed();
    
    bMath.demo();
    let val = await bMath._value();
    console.log(val);
	  /*const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    
    await greeter.deployed();
    expect(await greeter.greet()).to.equal("Hello, world!");

    await greeter.setGreeting("Hola, mundo!");
    expect(await greeter.greet()).to.equal("Hola, mundo!");*/
  });
});
