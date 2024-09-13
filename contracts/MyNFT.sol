// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage {
    uint256 private _tokenIds;
    uint256 public totalSupply;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) ERC721(_name, _symbol) {
        totalSupply = _totalSupply;
    }

    function mintNFT(string memory _tokenURI) public returns (uint256) {
        _tokenIds++;

        uint256 newItemId = _tokenIds;

        if (newItemId <= totalSupply) {
            _safeMint(msg.sender, newItemId);
            _setTokenURI(newItemId, _tokenURI);
        }

        return newItemId;
    }
}
