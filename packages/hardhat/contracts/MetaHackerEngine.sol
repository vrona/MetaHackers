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

Internal Engine for combinaison of traits (version of genes).
*/

pragma solidity ^0.8.7;

import {IMetaHackerDNA} from "./interfaces/IMetaHackerDNA.sol";
import {IMetaHackerMotherBase} from "./interfaces/IMetaHackerMotherBase.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MetaHackerEngine is IMetaHackerDNA, AccessControl {

  // roles
  bytes32 public constant FACTORY_ROLE = keccak256("FACTORY_ROLE");

  uint[4][5] internal limitbkgGen; // limit the number per rank (eg. 1 General)

  // probabilities of traits (version of genes)
  uint256[][11] internal rarities;
  // aliases (distribution of discrete traits) see Walker's Alias algorithm
  uint8[][11] internal aliases;

  /* Retrieve the tokenId of a given combinaison of traits in a given generation if existence
    otherwise retrieve 0
    uint256 tokenId = existingCombinations[enum Generation][uint256 traitHashing]
  */
  mapping(Generation => mapping(uint256 =>uint256)) internal existingCombinations;

  /* Store the hashed struct of traits of a given tokenId of a given generation
  uint256 traithash = traithashbank[enum Generation][uint256 tokenId]
  */
  mapping(Generation => mapping(uint256 =>uint256)) internal traithashbank;

  mapping(Generation => mapping(uint256 => uint256)) internal rankCount;

  mapping(Generation => mapping(uint256 => uint8)) internal storeRanking;

  // Mapping for .svg and .name of traits
  mapping(Generation => mapping(uint256 => Genes)) internal tokenTraits;

  IMetaHackerMotherBase internal metahackermotherbase;

  constructor(IMetaHackerMotherBase _metahackermotherbase) {
   
    // backgColor
    rarities[0] = [115, 221, 362, 413];             // [('Captains', 102), ('Colonels', 10), ('General', 1), ('Privates', 998)]
    aliases[0] = [3, 3, 3, 2];
    // bodyColor
    rarities[1] = [115, 221, 362, 413];             // [('A', 264), ('B', 269), ('C', 275), ('D', 302)]
    aliases[1] = [33, 27, 1, 44];
    // backgShape
    rarities[2] =  [1112];
    aliases[2] = [7];
    // bodyShape
    rarities[3] = [1112];
    aliases[3] = [4];
    // eyesbShape
    rarities[4] = [57, 92, 164, 218, 268, 312];      // [('A', 239), ('B', 263), ('C', 247), ('D', 265), ('E', 47), ('F', 50)]
    aliases[4] = [11, 41, 13, 50, 11, 41];
    // mouthShape
    rarities[5] = [43, 58, 107, 153, 231, 238, 281]; // [('A', 239), ('B', 264), ('C', 174), ('D', 160), ('E', 184), ('F', 47), ('G', 43)]
    aliases[5] = [32, 33, 54, 31, 32, 60, 31];
    // hairShape
    rarities[6] = [57, 92, 164, 218, 268, 312];     // [('B', 192), ('A', 364), ('F', 122), ('C', 323), ('E', 22), ('D', 88)]
    aliases[6] = [43, 13, 43, 13, 12, 43, 13];
    // glassShape
    rarities[7] = [57, 92, 164, 218, 268, 312];     // [('A', 279), ('B', 300), ('C', 97), ('D', 262), ('E', 97), ('F', 76)]
    aliases[7] = [10, 23, 51, 51, 10, 51];
    // clothShape
    rarities[8] = [70, 162, 221, 299, 359];         // [('A', 168), ('B', 227), ('C', 393), ('D', 185), ('E', 138)]
    aliases[8] = [62, 62, 61, 61, 62];

    
    limitbkgGen[0] = [1, 10, 100, 1000];
    limitbkgGen[1] = [1, 10, 100, 1000];
    limitbkgGen[2] = [1, 10, 100, 1000];
    limitbkgGen[3] = [1, 10, 100, 1000];
    limitbkgGen[4] = [1, 10, 100, 1000];
    
    metahackermotherbase = _metahackermotherbase;

    // set admin role for each role
    _setRoleAdmin(DEFAULT_ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
    _setRoleAdmin(FACTORY_ROLE, DEFAULT_ADMIN_ROLE);
    
    // set address to roles
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _setupRole(FACTORY_ROLE, msg.sender);

  }


  /**
   * generates traits for a specific _tokenId, checking to make sure it'mht unique
   * @param generation based on enum Generation type
   * @param _tokenId the id of the _token to generate traits for
   * @param seed a random 256 bits number to derive traits from
   * @return rmht - "Return MetaHackerTraits" a struct of traits for the given _tokenId ID
   */
    function mhEngineering(Generation generation, uint256 _tokenId, uint256 seed) public onlyRole(FACTORY_ROLE) returns (Genes memory rmht) {
        rmht = selectTraits(seed, generation);
        if (existingCombinations[generation][traitHashing(rmht)] == 0) {
        tokenTraits[generation][_tokenId] = rmht;
        existingCombinations[generation][traitHashing(rmht)] = _tokenId;
        traithashbank[generation][_tokenId] = traitHashing(rmht);
        storeRanking[generation][_tokenId] = rmht.backgColor;
        countRank(generation, rmht);
        return rmht;
        }
        return mhEngineering(generation, _tokenId, random(seed));
    }

  

  /**
   * based on A.J. Walker'mht Alias algorithm for O(1) rarity table.
   * probabilities & alias tables are generated off-chain beforehand (see.: constructor above + wRanks.py)
   * @param seed 16 bits portion of the 256 bits seed to retrieve trait correlation
   * @param traitType the gene type to select a trait from
   * @param generation based on enum Generation type
   * @return number of trait or alias
   */
  function selectTrait(uint16 seed, uint8 traitType, Generation generation) internal view returns (uint8) {
    uint8 trait = uint8(seed) % uint8(rarities[traitType].length);
    if (seed >> 16 < rarities[traitType][trait]) {
      if (traitType == 0 && rankCount[generation][trait] < limitbkgGen[uint8(generation)][trait]) {
        return trait;
      }
    }
    return aliases[traitType][trait];
  }

  /**
   * selects the species and all of its traits based on the seed value
   * @param seed a random 256 bits number to derive traits from
   * @param generation based on enum Generation type
   * @return rmht -  a struct of randomly selected traits
   */
  function selectTraits(uint256 seed, Generation generation) internal view returns (Genes memory rmht) {    

    seed >>= 16;
    rmht.backgColor = selectTrait(uint16(seed & 0xFFFF), 0, generation);
    seed >>= 16;
    rmht.bodyColor = selectTrait(uint16(seed & 0xFFFF), 1, generation);
    seed >>= 16;
    rmht.backgShape = selectTrait(uint16(seed & 0xFFFF), 2, generation);
    seed >>= 16;
    rmht.bodyShape = selectTrait(uint16(seed & 0xFFFF), 3, generation);
    seed >>= 16;
    rmht.eyesbShape = selectTrait(uint16(seed & 0xFFFF), 4, generation);
    seed >>= 16;
    rmht.mouthShape = selectTrait(uint16(seed & 0xFFFF), 5, generation);
    seed >>= 16;
    rmht.hairShape = selectTrait(uint16(seed & 0xFFFF), 6, generation);
    seed >>= 16;
    rmht.glassShape = selectTrait(uint16(seed & 0xFFFF), 7, generation);
    seed >>= 16;
    rmht.clothShape = selectTrait(uint16(seed & 0xFFFF), 8, generation);
  }
  
  /**
   * @notice converts a struct to a 256 bit hash to check for uniqueness
   * @param mht the struct of MetaHacker traits
   * @return traithash 256 bit hash of the struct (each, 8-bits, slot is a gene which can store a variation of value up to 255)
  */

  function traitHashing(Genes memory mht) internal pure returns(uint256) {
    uint256 traithash = hashOfGeneVar(0, mht.backgColor);
    traithash += hashOfGeneVar(1, mht.bodyColor);
    traithash += hashOfGeneVar(2, mht.backgShape);
    traithash += hashOfGeneVar(3, mht.bodyShape);
    traithash += hashOfGeneVar(4, mht.eyesbShape);
    traithash += hashOfGeneVar(5, mht.mouthShape);
    traithash += hashOfGeneVar(6, mht.hairShape);
    traithash += hashOfGeneVar(7, mht.glassShape);
    traithash += hashOfGeneVar(8, mht.clothShape);

    return traithash;
  }

  /**
   * @notice hashes into 256 bits a given gene's variation (trait) into a given slot
   * @param slot each slot (slot 0 for gene a, slot b for gene b,...) is 1 byte (8-bits) which can store a _variation
   * @param _variation of a gene (= trait) is of value from to 1 to 255
   * @return traithashed 256 bit
  */

  function hashOfGeneVar(uint8 slot, uint256 _variation) internal pure returns(uint256) {
        
    uint256 slotConst = 256;
    uint256 slotLocation;
    uint256 traithashed;

    slotLocation = uint256(slotConst ** slot);
    traithashed = _variation * slotLocation;

    return traithashed;
  }

  /**
   * @notice stacks and encodes svg layers of genes' variations
   * @param generation based on enum Generation type
   * @param tokenId the id of the token
   * @return encoded string of stacks of layer
  */

  function generateSVG(Generation generation, uint256 tokenId) external view returns (string memory) {
        Genes memory traitOfGene = tokenTraits[generation][tokenId];

        string memory backC = getTraitsvg(generation, 0, traitOfGene.backgColor);
        string memory bodyC = getTraitsvg(generation, 1, traitOfGene.bodyColor);
        string memory backgS = getTraitsvg(generation, 2, traitOfGene.backgShape);
        string memory bodyS = getTraitsvg(generation, 3, traitOfGene.bodyShape);
        string memory eyesbS = getTraitsvg(generation, 4, traitOfGene.eyesbShape);
        string memory mouthS = getTraitsvg(generation, 5, traitOfGene.mouthShape);
        string memory hairS = getTraitsvg(generation, 6, traitOfGene.hairShape);
        string memory glassS = getTraitsvg(generation, 7, traitOfGene.glassShape);
        string memory clothS = getTraitsvg(generation, 8, traitOfGene.clothShape);

        return string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='500' height='750'  viewBox='0 375 2000 2250'>",

                backC,
                bodyC,
                backgS,
                bodyS,
                eyesbS,
                mouthS,
                hairS,
                glassS,
                clothS,
                "</svg>"
            )
        );
    }

  function getTraitsvg(Generation _generation, uint256 _gene, uint256 _traitId) internal view returns(string memory) {
    return metahackermotherbase.getTraitsvg(_generation, _gene, _traitId);
  }

  function getTokenTraits(Generation _generation, uint256 tokenId) external view returns(Genes memory mhtraits) {
    return tokenTraits[_generation][tokenId];
  }

  function getTraithash(Generation generation, uint256 tokenId) external view returns(uint256 traithash) {
  return traithashbank[generation][tokenId];
  }
  
  function countRank(Generation generation, Genes memory mht) internal {
    rankCount[generation][mht.backgColor] += 1;
  }

  function random(uint256 seed) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(seed)));
  }

  function getRanking(Generation generation, uint256 tokenId) external view virtual returns(uint8 rank) {
        return storeRanking[generation][tokenId];
    }

}