import { Contract, BigNumber, constants } from 'ethers';
import { BigNumber as BN } from 'bignumber.js';
import BalanceTree from '../src/balance-tree';
import path from 'path';
import fs, { PathLike } from 'fs';
import csv from 'csv-parser';
import { isAsteriskToken } from 'typescript';

let filePath: PathLike = path.join(__dirname, 'holders.csv');
let writeFilePath: PathLike = path.join(__dirname, 'details.json');

var allUsers: Array<{ account: string; amount: string }> = [];

BN.config({
  EXPONENTIAL_AT: 1e9,
  ROUNDING_MODE: BN.ROUND_DOWN,
});

fs.createReadStream(filePath)
  .pipe(csv())
  .on('data', async function (row) {
    let balance: BN = new BN(row.Balance);
    let user_amount: String = balance
      .times(10 ** 9)
      .integerValue()
      .toString();
    let big_nmber = BigNumber.from(user_amount).mul(10 ** 9);
    console.log(big_nmber.toString());

    allUsers.push({
      account: row.HolderAddress,
      amount: big_nmber.toString(),
    });
  })
  .on('end', async () => {
    let jsonAllUser = await JSON.stringify(allUsers);
    await fs.writeFile(writeFilePath, jsonAllUser, (err) => {
      if (err) {
        console.log('Error writing file', err);
      } else {
        console.log('Successfully wrote file');
      }
    });
    // console.log(allUsers[12]);
    // let tree: BalanceTree = new BalanceTree(allUsers);
    // let proofs = tree.getProof(
    //   12,
    //   '0x0094615159736bea347ac2d3b94b5df4af20b35e',
    //   BigNumber.from('0')
    // );
    // let root = tree.getHexRoot();
    // let bufferedProofs: Array<Buffer> = [];
    // let bufferedRoot = Buffer.from(root);
    // proofs.map((item) => {
    //   bufferedProofs.push(Buffer.from(item));
    // });
    // let verifyProofs = BalanceTree.verifyProof(
    //   1,
    //   '0x00000000005ee5c591b0f0e37143e306e16bbbc8'.toLowerCase(),
    //   BigNumber.from(1),
    //   bufferedProofs,
    //   bufferedRoot
    // );
    // console.log(proofs);
    // console.log(root);
    // console.log(verifyProofs);
  });
