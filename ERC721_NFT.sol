// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract SimpleNFT is ERC721, Ownable {

    uint256 public mintPrice = 0.05 ether;
    uint256 public totalSupply;
    // If it reach then no more tokens/NFT issues
    uint256 public maxSupply;
    // If enabled then people are allowed to mint
    bool public isMintEnabled;
    // to keep track mints each wallet done
    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721('Simple Mint', 'SIM') {
        maxSupply = 2;      
    }

    function toggleMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    // Check Statemnt

    function mint() external payable {
        require(isMintEnabled, 'minting not enabled');
        require(mintedWallets[msg.sender] < 1, 'exceeds max per wallet');
        require(msg.value == mintPrice, 'Wrong Value');
        require(maxSupply > totalSupply, 'sold out');

        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
    }
}
