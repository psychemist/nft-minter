require("@nomicfoundation/hardhat-toolbox");

const { vars } = require("hardhat/config");
const ALCHEMY_API_KEY = vars.get("ALCHEMY_API_KEY");
const ETHERSCAN_API_KEY = vars.get("ETHERSCAN_API_KEY");
const METAMASK_PRIVATE_KEY = vars.get("METAMASK_PRIVATE_KEY");

module.exports = {
    solidity: {
        compilers: [
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
        sepolia: {
            url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
            accounts: [METAMASK_PRIVATE_KEY],
        },
    },
    etherscan: {
        apiKey: {
            sepolia: ETHERSCAN_API_KEY,
        },
    },
};
