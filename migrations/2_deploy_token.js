const SahayogiToken = artifacts.require("SahayogiToken");
const Exchange = artifacts.require("Exchange");

module.exports = function (deployer) {
  //deploy token 
  await deployer.deploy(SahayogiToken);
  const sahayogitoken = await SahayogiToken.deployed()
  
  //deploy Exchange
  await deployer.deploy(Exchange);
  const exchange= await Exchange.deployed()
  

};
