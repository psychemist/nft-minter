require("@nomicfoundation/hardhat-toolbox");

const { vars } = require("hardhat/config");
const ACCOUNT_PRIVATE_KEY = vars.get("ACCOUNT_PRIVATE_KEY");
const ALCHEMY_API_KEY = vars.get("ALCHEMY_API_KEY");
const ETHERSCAN_API_KEY = vars.get("ETHERSCAN_API_KEY");
const LISK_RPC_URL = vars.get("LISK_RPC_URL");

module.exports = {
    solidity: {
        compilers: [
            {
                version: "0.8.27",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
            {
                version: "0.8.24",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
            {
                version: "0.8.20",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },
    networks: {
        "sepolia": {
            url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
            accounts: [ACCOUNT_PRIVATE_KEY],
        },
        "lisk-sepolia": {
            url: LISK_RPC_URL,
            accounts: [ACCOUNT_PRIVATE_KEY],
            gasPrice: 1000000000,
        },
    },
    etherscan: {
        apiKey: {
            "sepolia": ETHERSCAN_API_KEY,
            "lisk-sepolia": "123",
        },
        customChains: [
            {
                network: "lisk-sepolia",
                chainId: 4202,
                urls: {
                    apiURL: "https://sepolia-blockscout.lisk.com/api",
                    browserURL: "https://sepolia-blockscout.lisk.com/",
                },
            },
        ],
    },
};
