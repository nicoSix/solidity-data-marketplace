const Factory = artifacts.require("Factory");

module.exports = function (deployer) {
  deployer.deploy(Factory, "ipfs://Qme6Kkjrs2LQfQj7BMHGtM62P5inHhDhBiMwPK3TLFyAHh");
};
