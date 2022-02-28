const SahayogiToken = artifacts.require("SahayogiToken");
const Exchange = artifacts.require("Exchange");
const FundRaising = artifacts.require("FundRaising");
const SahayogiAgency = artifacts.require("SahayogiAgency");

module.exports = async function (deployer) {
  //deploy token 
  await deployer.deploy(SahayogiToken,"0x656e513c655b3f1e7cc5b2117c0eff17342ad7e1");
  const erc20 = await SahayogiToken.deployed();
  //deployFundRaising
  await deployer.deploy(
    FundRaising,
    erc20.address,
    "0x656e513c655b3f1e7cc5b2117c0eff17342ad7e1");
  const fundRaising = await FundRaising.deployed();

  await deployer.deploy(
    SahayogiAgency,
    erc20.address,
    fundRaising.address,
    "0x656e513c655b3f1e7cc5b2117c0eff17342ad7e1");
  await SahayogiAgency.deployed();
 
   //deploy Exchange
  // await deployer.deploy(Exchange, erc20.address);
  // const exchange = await Exchange.deployed()
  // console.log('exchange:',exchange)




};