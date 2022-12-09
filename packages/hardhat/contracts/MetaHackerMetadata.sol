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

Gathers and encodes metadata.
*/

pragma solidity ^0.8.7;

import {IMetaHackerDNA} from "./interfaces/IMetaHackerDNA.sol";
import {IMetaHackerMotherBase} from "./interfaces/IMetaHackerMotherBase.sol";
import {IMetaHackerEngine} from "./interfaces/IMetaHackerEngine.sol";
import {HackerHelper} from "./HackerHelper.sol";

contract MetaHackerMetadata is IMetaHackerDNA {

IMetaHackerMotherBase internal metahackermotherbase;
IMetaHackerEngine internal metahackerengine;

// Array of generations's boosts
uint8[4] internal boosts;

constructor(IMetaHackerMotherBase _metahackermotherbase,
            IMetaHackerEngine _metahackerengine)
            {
    metahackermotherbase = _metahackermotherbase;
    metahackerengine = _metahackerengine;
    
    boosts[0] = 0;  // private
    boosts[1] = 5;  // captains
    boosts[2] = 10; // colonels
    boosts[3] = 20; // generals
  }

  function generateAttribute(Generation generation, uint256 tokenId) external view returns(string memory attribute) {
    string memory geneattribute = genesAttribute(generation, tokenId);
    string memory boostattribute = boostsAttribute(generation, tokenId);
    attribute = HackerHelper.concatString(geneattribute, boostattribute);
    
    string memory skillattribute = skillsAttribute(generation);
    attribute = HackerHelper.concatString(attribute, skillattribute);
    
    return attribute;
  }
    

  function genesAttribute(Generation generation, uint256 tokenId) internal view returns (string memory) {

      Genes memory nameOftrait = getTokenTraits(generation, tokenId);


      string memory backN = getTraitname(generation, 0, nameOftrait.backgColor);
      string memory bodyCN = getTraitname(generation, 1, nameOftrait.bodyColor);
      string memory backSN = getTraitname(generation, 2, nameOftrait.backgShape);
      string memory bodyN = getTraitname(generation, 3, nameOftrait.bodyShape);
      string memory eyesbN = getTraitname(generation, 4, nameOftrait.eyesbShape);
      string memory mouthN = getTraitname(generation, 5, nameOftrait.mouthShape);
      string memory hairN = getTraitname(generation, 6, nameOftrait.hairShape);
      string memory glassN = getTraitname(generation, 7, nameOftrait.glassShape);
      string memory clothN = getTraitname(generation, 8, nameOftrait.clothShape);

      return string(
          abi.encodePacked(
            '"attributes":', "[",

            '{"trait_type": "Rank",',
            '"value":"', backN, '"},',
            
            '{"trait_type": "Body Color",',
            '"value":"', bodyCN, '"},',

            '{"trait_type": "Back Shape",',
            '"value":"', backSN, '"},',

            '{"trait_type": "Body Shape",',
            '"value":"', bodyN, '"},',
    
            '{"trait_type": "EyesBrows",',
            '"value":"', eyesbN, '"},',

            '{"trait_type": "Mouth",',
            '"value":"', mouthN, '"},',

            '{"trait_type": "Hair",',
            '"value":"', hairN, '"},',

            '{"trait_type": "Glasses Shape",',
            '"value":"', glassN, '"},',
            
            '{"trait_type": "Clothes",',
            '"value":"', clothN, '"},'
          )
      );
  }

  function boostsAttribute(Generation generation, uint256 tokenId) internal view returns (string memory) {
    uint8 _ranking = getRanking(generation, tokenId);
    uint8 boostin = boosts[_ranking];

    return string(abi.encodePacked(
      '{"display_type": "boost_percentage",',
      '"trait_type": "boost",',
      '"value":"', HackerHelper.uint2str(boostin), '"},',

      '{"display_type": "number",',
      '"trait_type": "generation",',
      '"value":"', HackerHelper.uint2str(uint256(generation)), '"},'
      ));
  }

    function skillsAttribute(Generation generation) internal view returns(string memory) {

      Skills memory currentskill = getSkillz(generation);

      return string(
            abi.encodePacked(
              '{"display_type": "boost_number",',
              '"trait_type": "bravery",',
              '"value":"', HackerHelper.uint2str(currentskill.bravery), '"},',
              
              '{"display_type": "boost_number",',
              '"trait_type": "humor",',
              '"value":"', HackerHelper.uint2str(currentskill.humor), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "imagination",',
              '"value":"', HackerHelper.uint2str(currentskill.imagination), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "intelligence",',
              '"value":"', HackerHelper.uint2str(currentskill.intelligence), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "leadership",',
              '"value":"', HackerHelper.uint2str(currentskill.leadership), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "metaversal",',
              '"value":"', HackerHelper.uint2str(currentskill.metaversal), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "pressureResistance",',
              '"value":"', HackerHelper.uint2str(currentskill.pressureResistance), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "social",',
              '"value":"', HackerHelper.uint2str(currentskill.social), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "teamworking",',
              '"value":"', HackerHelper.uint2str(currentskill.teamworking), '"},',

              '{"display_type": "boost_number",',
              '"trait_type": "technological",',
              '"value":"', HackerHelper.uint2str(currentskill.technological), '"}],'
            ));
  }

  function getTokenTraits(Generation _generation, uint256 tokenId) internal view returns(Genes memory mhtraits){
    return metahackerengine.getTokenTraits(_generation, tokenId);
  }

  function getBoost(uint8 _ranking) external view returns(uint8 boost) {
    return boosts[_ranking];
  }

  function getTraitname(Generation _generation,uint256 _gene, uint256 _traitId) internal view returns(string memory) {
    return metahackermotherbase.getTraitname(_generation, _gene, _traitId);
  }
  
  function getRanking(Generation generation,uint256 tokenId) internal view returns(uint8 rank) {
    return metahackerengine.getRanking(generation, tokenId);
  }

  function getSkillz(Generation _generation) internal view returns(Skills memory) {
    return metahackermotherbase.getSkillz(_generation);
  }

}