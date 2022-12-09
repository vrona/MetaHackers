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

Uploads traits 'n' skills.
*/

pragma solidity ^0.8.7;

import {IMetaHackerDNA} from "./interfaces/IMetaHackerDNA.sol";
import {IMetaHackerMotherBase} from "./interfaces/IMetaHackerMotherBase.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MetaHackerMotherBase is IMetaHackerDNA, IMetaHackerMotherBase, AccessControl {

    // Generation Status
    Generation internal stateofgen;

    // roles
    bytes32 public constant STUDIO_ROLE = keccak256("STUDIO_ROLE");
       
    //All skills across all Generation
    Skills internal skills; 

    /* storage of data's traits: name, genes, gender, variation, svg
    struct IMetaHackerDNA Traits = traitData[enum IMetaHackerDNA generation][uint256 gene][uint traitIDs]
    */
    mapping(Generation => mapping (uint256 => mapping(uint256 => Traits))) internal traitData;

    /* storage of generation's skills
    struct Skills = skillsdata[enum Generation]
    */
    mapping(Generation => Skills) internal skillsdata;

    constructor() {
         // set admin role for each role
        _setRoleAdmin(DEFAULT_ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(STUDIO_ROLE, DEFAULT_ADMIN_ROLE);
        
        // set address to roles
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(STUDIO_ROLE, msg.sender);
    }

    /**
    * @notice upload from json to onchain, attributes of traits from a given gene and generation
    * @param _generation respecting Generation type
    * @param gene given
    * @param traitvarId are the variation id of each  gene
    * @param _traits with "struct" attributes: eg. generation, names, svg, ...
    */
    
    function uploadTraits(Generation _generation, uint256 gene, uint256[] calldata traitvarId, Traits[] calldata _traits) external override onlyRole(STUDIO_ROLE) {
        require(traitvarId.length == _traits.length, "Mismat inputs");
        stateofgen = _generation;
        
        for (uint i = 0; i < _traits.length; i++) {
        traitData[_generation][gene][traitvarId[i]] = Traits(
            _traits[i].generation,
            _traits[i].gender,
            _traits[i].gene,
            _traits[i].variation,
            _traits[i].name,
            _traits[i].svg
        );
        }
    }
    
    function uploadSkills(Generation _generation, uint256[] calldata eachSkill) external override onlyRole(STUDIO_ROLE){
      
        skillsdata[_generation] = Skills(
        skills.bravery = eachSkill[0],
        skills.humor = eachSkill[1],
        skills.imagination = eachSkill[2],
        skills.intelligence = eachSkill[3],
        skills.leadership = eachSkill[4],
        skills.metaversal = eachSkill[5],
        skills.pressureResistance = eachSkill[6],
        skills.social = eachSkill[7],
        skills.teamworking = eachSkill[8],
        skills.technological = eachSkill[9]
        );
    }

    function getTraitsvg(Generation _generation,uint256 _gene, uint256 _traitId) external view virtual override returns(string memory) {
        return traitData[_generation][_gene][_traitId].svg;
    }

    function getTraitname(Generation _generation,uint256 _gene, uint256 _traitId) external view virtual override returns(string memory) {
        return traitData[_generation][_gene][_traitId].name;
    }

    function getTraitgender(Generation _generation,uint256 _gene, uint256 _traitId) external view virtual override returns(Gender) {
        return traitData[_generation][_gene][_traitId].gender;
    }

    function getSkillz(Generation _generation) external view virtual override returns(Skills memory) {
        return skillsdata[_generation];
    }

    function checkStatusOfGen() external view override returns(Generation) {
        return stateofgen;
    }

}