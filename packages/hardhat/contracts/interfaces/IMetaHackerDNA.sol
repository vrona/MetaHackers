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


interface IMetaHackerDNA {
    
    // enums' index 0
    enum Generation {
        HectorNazareth,
        Trinity,
        Morpheus,
        AgentSmith,
        Oracle
    }

    enum Ranking {
        Privates,
        Captains,
        Colonels,
        General
    }

    enum Gender {
        None,
        Male,
        Female
    }

    struct Genes {
        uint8 backgColor;
        uint8 bodyColor;
        uint8 backgShape;
        uint8 bodyShape;
        uint8 eyesbShape;
        uint8 mouthShape;
        uint8 hairShape;
        uint8 glassShape;
        uint8 clothShape;
    }
        
    struct Skills {
        uint256 bravery;
        uint256 humor;
        uint256 imagination;
        uint256 intelligence;
        uint256 leadership;
        uint256 metaversal;
        uint256 pressureResistance;
        uint256 social;
        uint256 teamworking;
        uint256 technological;
    }

    struct Traits{
        Generation generation;
        Gender gender;
        string gene;
        uint256 variation;
        string name;
        string svg;
    }

    struct MetaHacker{
        uint256 tokenId;
        uint256 traithash;
        uint8 generation;
        uint8 ranking;
        Gender gender;
        uint8 boosts;
        Skills skills;
        string dataURLhash;
    }
}