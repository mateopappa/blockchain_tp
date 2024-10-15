// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {
    uint256 private _tokenIdCounter;

    constructor() ERC721("NftDelospibes", "WACHO") {
        _tokenIdCounter = 0;
    }

    function safeMint(address to) public {
        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter; 
        _safeMint(to, tokenId); 
    }
}

