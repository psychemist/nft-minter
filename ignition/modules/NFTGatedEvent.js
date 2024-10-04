const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const NFTGatedEvent = buildModule("NFTGatedEventModule", (m) => {

    const nftGatedEvent = m.contract("NFTGatedEvent");

    return { nftGatedEvent };
});

module.exports = NFTGatedEvent

