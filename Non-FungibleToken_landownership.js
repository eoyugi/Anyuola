pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract LandNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => string) public landParcelIDs;

    constructor() ERC721("Land NFT", "LNFT") {}

    function safeMint(string memory landParcelID) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        landParcelIDs[tokenId] = landParcelID;
    }

    function transferLand(uint256 tokenId, address newOwner) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "You are not the owner or approved");
        _transfer(_ownerOf(tokenId), newOwner, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        // Add additional validation logic here
    }
}
