const SahayogiToken = artifacts.require("SahayogiToken");
const Exchange = artifacts.require("Exchange");
const FundRaising = artifacts.require("FundRaising");
const SahayogiAgency = artifacts.require("SahayogiAgency");

module.exports = async function (deployer) {
  //deploy token 
  await deployer.deploy(SahayogiToken,"0xC30004803F5dc1f6Ad15193A197fd1Fbd0D471D1");
  const erc20 = await SahayogiToken.deployed();
  //deployFundRaising
  await deployer.deploy(
    FundRaising,
    erc20.address,
    "0xC30004803F5dc1f6Ad15193A197fd1Fbd0D471D1");
  const fundRaising = await FundRaising.deployed();

  await deployer.deploy(
    SahayogiAgency,
    erc20.address,
    fundRaising.address,
    "0xC30004803F5dc1f6Ad15193A197fd1Fbd0D471D1");
  await SahayogiAgency.deployed();
 
   //deploy Exchange
  // await deployer.deploy(Exchange, erc20.address);
  // const exchange = await Exchange.deployed()
  // console.log('exchange:',exchange)




};