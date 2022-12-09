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
*/

pragma solidity ^0.8.0;

import {IMetaHackerDNA} from "./IMetaHackerDNA.sol";

interface IMetaHackerEngine is IMetaHackerDNA {

  function getTraithash(Generation generation, uint256 tokenId) external view returns(uint256 traithash);

  function generateSVG(Generation generation, uint256 tokenId) external view returns (string memory);

  function mhEngineering(Generation generation, uint256 _tokenId, uint256 seed) external returns (Genes memory rmht);

  function random(uint256 seed) external pure returns (uint256);

  function getTokenTraits(Generation _generation, uint256 tokenId) external view returns(Genes memory mhtraits);

  function getRanking(Generation generation, uint256 tokenId) external view returns(uint8 rank);
  
}