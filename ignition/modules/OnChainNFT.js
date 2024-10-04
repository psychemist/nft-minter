const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const OnChainNFT = buildModule("OnChainNFTModule", (m) => {

    const onChainNFT = m.contract("OnChainNFT");

    return { onChainNFT };
});

module.exports = OnChainNFT

// Deployed OnChainNFT: 
