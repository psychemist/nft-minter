// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;
    uint256 public totalSupply;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        address _initialOwner
    ) ERC721(_name, _symbol) Ownable(_initialOwner) {
        totalSupply = _totalSupply;
    }

    function mintNFT(
        address _recipient,
        string memory _tokenURI
    ) public onlyOwner returns (uint256) {
        _tokenIds++;

        uint256 newItemId = _tokenIds;

        if (newItemId <= totalSupply) {
            _safeMint(_recipient, newItemId);
            _setTokenURI(newItemId, _tokenURI);
        }

        return newItemId;
    }
}
