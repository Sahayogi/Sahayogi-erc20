const { merge } = require('sol-merger');

// Get the merged code as a string
const mergedCode = await merge("./contracts/SahayogiToken.sol");
// Print it out or write it to a file etc.
console.log(mergedCode);
