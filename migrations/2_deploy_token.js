const SahayogiToken = artifacts.require("SahayogiToken");
const Exchange = artifacts.require("Exchange");
const FundRaising = artifacts.require("FundRaising");


module.exports = async function (deployer) {
  //deploy token 
  await deployer.deploy(SahayogiToken,admin.address);
  const erc20 = await SahayogiToken.deployed()

  //deploy Exchange
  await deployer.deploy(Exchange, erc20.address,admin.address);
  const exchange = await Exchange.deployed()
  console.log('exchange:',exchange)

  //deployFundRaising
  await deployer.deploy(FundRaising, erc20.address);
  const fundRaising = await FundRaising.deployed()



};