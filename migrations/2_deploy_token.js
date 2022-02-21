const SahayogiToken = artifacts.require("SahayogiToken");
const Exchange = artifacts.require("Exchange");

module.exports = async function (deployer) {
  //deploy token 
  await deployer.deploy(SahayogiToken);
  const sahayogiToken = await SahayogiToken.deployed()

  //deploy Exchange
  await deployer.deploy(Exchange, sahayogiToken.address);
  const exchange = await Exchange.deployed()
  console.log('exchange:',exchange)


};