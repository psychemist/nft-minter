const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const name = "GeekNFT";
const symbol = "GXFT";
const totalSupply = 1000;

const CustomNFT = buildModule("CustomNFTModule", (m) => {

    const customNFT = m.contract("CustomNFT", [name, symbol, totalSupply]);

    return { customNFT };
});

module.exports = CustomNFT


// const { ethers } = require("hardhat");

// async function main() {
//     // Grab the contract factory     
//     const MyNFT = await ethers.getContractFactory("CustomNFT");

//     // Start deployment, returning a promise that resolves to a contract object
//     const myNFT = await MyNFT.deploy("GeekNFT", "GXFT", 1000); // Pass the deployer's address as the initial owner

//     // Await deployment
//     await myNFT.deployed();

//     console.log("Contract deployed to address:", myNFT.address);
// }

// main()
//     .then(() => process.exit(0))
//     .catch(error => {
//         console.error(error);    
//         process.exit(1);
//     });


// Deployed CustomNFT: 
