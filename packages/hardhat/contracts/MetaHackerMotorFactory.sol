//SPDX-License-Identifier: MIT
/*
      ___           ___                         ___           ___           ___           ___           ___           ___           ___     
     /\  \         /\__\                       /\  \         /\  \         /\  \         /\__\         /|  |         /\__\         /\  \    
    |::\  \       /:/ _/_         ___         /::\  \        \:\  \       /::\  \       /:/  /        |:|  |        /:/ _/_       /::\  \   
    |:|:\  \     /:/ /\__\       /\__\       /:/\:\  \        \:\  \     /:/\:\  \     /:/  /         |:|  |       /:/ /\__\     /:/\:\__\  
  __|:|\:\  \   /:/ /:/ _/_     /:/  /      /:/ /::\  \   ___ /::\  \   /:/ /::\  \   /:/  /  ___   __|:|  |      /:/ /:/ _/_   /:/ /:/  /  
 /::::|_\:\__\ /:/_/:/ /\__\   /:/__/      /:/_/:/\:\__\ /\  /:/\:\__\ /:/_/:/\:\__\ /:/__/  /\__\ /\ |:|__|____ /:/_/:/ /\__\ /:/_/:/__/___
 \:\~~\  \/__/ \:\/:/ /:/  /  /::\  \      \:\/:/  \/__/ \:\/:/  \/__/ \:\/:/  \/__/ \:\  \ /:/  / \:\/:::::/__/ \:\/:/ /:/  / \:\/:::::/  /
  \:\  \        \::/_/:/  /  /:/\:\  \      \::/__/       \::/__/       \::/__/       \:\  /:/  /   \::/~~/~      \::/_/:/  /   \::/~~/~~~~ 
   \:\  \        \:\/:/  /   \/__\:\  \      \:\  \        \:\  \        \:\  \        \:\/:/  /     \:\~~\        \:\/:/  /     \:\~~\     
    \:\__\        \::/  /         \:\__\      \:\__\        \:\__\        \:\__\        \::/  /       \:\__\        \::/  /       \:\__\    
     \/__/         \/__/           \/__/       \/__/         \/__/         \/__/         \/__/         \/__/         \/__/         \/__/    

Gathers and encodes svg encoding + metadata.
*/

pragma solidity ^0.8.7;
import {IMetaHackerDNA} from "./interfaces/IMetaHackerDNA.sol";
import {MetaHackerMotherBase} from "./MetaHackerMotherBase.sol";
import {IMetaHackerEngineDown} from "./interfaces/IMetaHackerEngineDown.sol";
import {IMetaHackerMetadata} from "./interfaces/IMetaHackerMetadata.sol";
import "base64-sol/base64.sol";

contract MetaHackerMotorFactory {
    
    IMetaHackerMetadata internal metahackermetadata;
    IMetaHackerEngineDown internal metahackerengine;
    MetaHackerMotherBase internal metahackermotherbase;

    constructor(address _metaHackerEngine,
                address _metahackermotherbase,
                address _metahackermetadata
            ) {
        metahackerengine = IMetaHackerEngineDown(_metaHackerEngine);
        metahackermetadata = IMetaHackerMetadata(_metahackermetadata);
        metahackermotherbase = MetaHackerMotherBase(_metahackermotherbase);
    }
    
    function metahackerz(IMetaHackerDNA.Generation generation, uint256 tokenId, string memory _txOfDataURL) external view returns(IMetaHackerDNA.MetaHacker memory metahackers) {
        
        metahackers.tokenId = tokenId;
        metahackers.traithash = getTraithash(generation, tokenId);
        metahackers.generation = uint8(generation);
        metahackers.ranking = getRanking(generation, tokenId);
        metahackers.gender = getTraitgender(generation, 3, 0);          // return Gender based on bodyShape gene
        metahackers.boosts = getBoost(getRanking(generation, tokenId));
        metahackers.skills = getSkillz(generation);
        metahackers.dataURLhash = _txOfDataURL;
    }

    function toTokenURI(string memory imageURI, string memory attributeURI) external pure returns (string memory) {
        
        string memory metadatas = string(abi.encodePacked(
            '{"description": "Unique soldier called MetaHacker which pairs up as teams to win hacker game. Images and Metadata are 100% on-chain",',
            '"external_url": "MetaHacker....",',
            '"name":"",',
            attributeURI,
            '"image_data":"', imageURI, '"}'));
            
        return string(abi.encodePacked(
          "data:application/json;base64,",
          Base64.encode(
              bytes(abi.encodePacked(metadatas)
              )
          )
      )
      );
    }

    function svgToImageURI(string memory svg) external pure returns (string memory prefixcode) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL,svgBase64Encoded));
    }

    function getTraithash(IMetaHackerDNA.Generation generation, uint256 tokenId) internal view returns(uint256 traithash) {
        return metahackerengine.getTraithash(generation, tokenId);
    }

    function getRanking(IMetaHackerDNA.Generation generation, uint256 tokenId) internal view returns(uint8 rank) {
        return metahackerengine.getRanking(generation, tokenId);
    }

    function getTraitgender(IMetaHackerDNA.Generation _generation,uint256 _gene, uint256 _traitId) internal view returns(IMetaHackerDNA.Gender) {
        return metahackermotherbase.getTraitgender(_generation, _gene, _traitId);
    }

    function getBoost(uint8 _ranking) internal view returns(uint8 boost) {
        return metahackermetadata.getBoost(_ranking);
    }

    function getSkillz(IMetaHackerDNA.Generation _generation) internal view returns(IMetaHackerDNA.Skills memory) {
        return metahackermotherbase.getSkillz(_generation);
    }
}