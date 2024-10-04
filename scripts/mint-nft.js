require('dotenv').config();
const contract = require("../artifacts/contracts/MyNFT.sol/MyNFT.json");
const ethers = require('ethers');

// Get Alchemy API Key
const API_KEY = process.env.API_KEY;

// Define an Alchemy Provider
const provider = new ethers.AlchemyProvider('sepolia', API_KEY)