import { Contract, BigNumber, constants } from 'ethers';
import { BigNumber as BN } from 'bignumber.js';
import BalanceTree from '../src/balance-tree';
import path from 'path';
import fs, { PathLike } from 'fs';
import csv from 'csv-parser';
import { isAsteriskToken } from 'typescript';

async function generateMerkleProofs() {
  let filePath: PathLike = path.join(__dirname, 'details.json');
  let writeFilePath: PathLike = path.join(__dirname, 'proofs.json');

  var allUsers: Array<{ account: string; amount: BigNumber }> = [];
  var proofs: Array<{
    account: string;
    proofs: Array<String>;
    amount: string;
    index: string;
  }> = [];

  BN.config({
    EXPONENTIAL_AT: 1e9,
    ROUNDING_MODE: BN.ROUND_DOWN,
  });

  let data = fs.readFileSync(filePath);
  let jsonData = JSON.parse(data.toString());
  jsonData.forEach((parameter: { account: string; amount: BigNumber; }) => {
    allUsers.push({
      account: parameter.account,
      amount: BigNumber.from(parameter.amount),
    });
  });
  let tree: BalanceTree = new BalanceTree(allUsers);
  let root = tree.getHexRoot();
  allUsers.forEach((item, index) => {
    proofs.push({
      account: item.account,
      proofs: tree.getProof(index, item.account, item.amount),
      amount: item.amount.toString(),
      index: index.toString(),
    });
  });
  // let proofs = tree.getProof(736, allUsers[736].account, allUsers[736].amount);
  let allData = await JSON.stringify(proofs);
  fs.writeFileSync(writeFilePath, allData);
  console.log(root);
}

generateMerkleProofs();
