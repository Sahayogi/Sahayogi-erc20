const Web3 = require('web3');
const { Contract, BigNumber, constants } = require('ethers');

const contract_abi = require('./../buildWaffle/contracts/ALMMerkleDistributor.json');
const eth_rinkby =
  'https://rinkeby.infura.io/v3/e421fad5e7f047d59b687cf5827e00a1';

const web3 = new Web3(eth_rinkby);

let contract_address = '0x9e355A97cbCd22Facf5cc8C647cc85edd03A2E36';
let userPrivateKey =
  'bdc62f17203a054942bd8ee98d4fa1ab9d9a6a83b187b83e4e700e0969719837';
let user = web3.eth.accounts.privateKeyToAccount(userPrivateKey);

let amount = '100';
let index = '1';
let account = user.address.toString().toLowerCase();
let proofs = [
  '0x51f47245c15ebae45aa57c9fd4e9b1152fcf80336b0ce25883c9784537b01d7f',
  '0x9b9017a5322f51fe999e66922621178218f9965551cadca8967b43f9e6cfdee3',
];
let merkleRoot =
  '0x30518642b3af5aa0354df3bc9664f37849754655d46d1df26f470e90acb8cfa1';

let sendTx = async () => {
  const ALMMerkleDistributor = new web3.eth.Contract(
    contract_abi.abi,
    contract_address
  );
  let txMethod = ALMMerkleDistributor.methods.claim(
    index,
    account,
    amount,
    proofs,
    merkleRoot
  );

  const gas = await txMethod.estimateGas({ from: account });
  const gasPrice = await web3.eth.getGasPrice();
  const data = txMethod.encodeABI();
  const nonce = await web3.eth.getTransactionCount(account);

  const signedTx = await web3.eth.accounts.signTransaction(
    {
      to: contract_address,
      data: data,
      gas,
      gasPrice,
      nonce,
      chainId: 4,
    },
    userPrivateKey
  );

  const action = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
  action.then(console.log);
};

sendTx();
