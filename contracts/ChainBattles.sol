// SPDX-License-Identifier: MIT
//contract deployed to :  0x3f2A470a56582662e2c0E1B6A34b8d03359d4a8D

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//initializing the contract 
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    //declaring a new tokenids function to store our nftids 
    Counters.Counter private _tokenIds;
    
    //solving the alchemy challenge 
    struct PlayerData {
        uint256 level;
        uint256 speed; 
        uint256 strength;
        uint256 life; 
    }

    //mapping to store the level of an nft associated with its tokenid
    mapping(uint256 => PlayerData) public tokenIdToPlayerData;
    //the mapping links the nftid a uint256 to another uint256 the nft level 
    constructor() ERC721 ("Chain Battles", "CBTLS") {
    
}
/**implementing the following four functions
generateCharacter:generate & update the svg image of our nft
getLevels: get the current level of our nft 
getTokenURI: get the tokenURI of an nft
mint: to mint our nfts 
train: to train and raise the level of our nft 
*/

//generateCharacter function 
function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevel(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}

//function to retreive the nft levels 
function getLevel(uint256 tokenId) public view returns (string memory) {
    PlayerData memory data = tokenIdToPlayerData[tokenId];
    return data.level.toString();
}

 function getStrength(uint256 tokenId) public view returns (string memory) {
      PlayerData memory data = tokenIdToPlayerData[tokenId];
      return data.strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
      PlayerData memory data = tokenIdToPlayerData[tokenId];
      return data.life.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
      PlayerData memory data = tokenIdToPlayerData[tokenId];
      return data.speed.toString();
    }
//get tokenURI function to generate the tokenURI
function getTokenURI(uint256 tokenId) public returns (string memory) {
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(abi.encodePacked(
        "data:application/json;base64,",
        Base64.encode(dataURI)
    )
                 );
}

//function to create the nft with onchain  metadata
function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);

    
        PlayerData memory playerData = PlayerData(0, createRandom(2), createRandom(3), createRandom(4)); // level, speed, strength, life

        tokenIdToPlayerData[newItemId] = playerData;
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

//function to train your nft and raise the level by one 
function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");

     PlayerData memory currentPlayerData = tokenIdToPlayerData[tokenId];
      uint256 currentLevel = currentPlayerData.level;
      currentPlayerData.level = currentLevel + 1;
      tokenIdToPlayerData[tokenId] = currentPlayerData;
    _setTokenURI(tokenId, getTokenURI(tokenId));
}


    function createRandom(uint256 number) public view returns(uint256) {
      return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % number;
    }

}










