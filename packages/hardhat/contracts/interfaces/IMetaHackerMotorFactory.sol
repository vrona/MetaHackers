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
import {IMetaHackerEngine} from "./IMetaHackerEngine.sol";

interface IMetaHackerMotorFactory is IMetaHackerDNA, IMetaHackerEngine {

  function metahackerz(Generation generation, uint256 tokenId, string memory _txOfDataURL) external view returns(MetaHacker memory metahackers);

  function toTokenURI(string memory imageURI, string memory attributeURI) external pure returns (string memory);

  function svgToImageURI(string memory svg) external pure returns (string memory prefixcode);

  //function checkStatusOfGen() external view returns(Generation);
}