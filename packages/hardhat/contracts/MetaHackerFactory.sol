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

Convergence occurs here.
*/

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {MetaHackerEngineDown} from "./MetaHackerEngineDown.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

import {IMetaHackerDNA} from "./interfaces/IMetaHackerDNA.sol";
import {IMetaHackerMotorFactory} from "./interfaces/IMetaHackerMotorFactory.sol";
import {IMetaHackerEngineDown} from "./interfaces/IMetaHackerEngineDown.sol";
import {IMetaHackerMetadata} from "./interfaces/IMetaHackerMetadata.sol";


contract MetaHackerFactory is ERC721URIStorage, Ownable, VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;
    IMetaHackerEngineDown ENGINE;
    IMetaHackerMetadata METADATA;
    IMetaHackerMotorFactory MOTOR;

    // Generation Status
    IMetaHackerDNA.Generation internal stateofgen;

    bool private paused;
    uint64 public subId;
    bytes32 keyHash;
    
    uint32 callbackGasLimit = 300000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    uint256 public nftPrice = 0.0018 ether;
    address payable winsiders;

    // All MetaHacker across all Ranking and Generation
    IMetaHackerDNA.MetaHacker[] metahacker;

    // Mapping dedicated to ChainLink
    mapping(uint256 => address) internal requestIdToSender;
    mapping(uint256 => uint256) internal requestIdToRandomNumber;
    mapping(uint256 => uint256) internal requestIdToTokenId;

    // store tokenId of metahackers per generation
    mapping(uint8 => uint256[]) internal metahackerPerGen;
    
    // store ante-uri
    mapping(uint256 => string) anteuri;

    IMetaHackerMetadata internal metahackermetadata;
    IMetaHackerMotorFactory internal metahackermotorfactory;
    
    event createUri(string indexed _tokenUri, string tokenUri);
    //event createRandomUri(uint256 indexed tokenId, string tokenUri);
   //event createRandomNum(uint256 indexed tokenId, uint256[] randomNumber);
    event requestedTokenId(uint256 indexed s_requestId, uint256 indexed tokenId); 
    
    constructor(IMetaHackerEngineDown _metaHackerEngine,
                uint64 _subId,
                bytes32 _keyHash,
                IMetaHackerMotorFactory _metahackermotorfactory,
                IMetaHackerMetadata _metahackermetadata,
                address _VRFCoordinator,
                address payable _winsiders
            )
            VRFConsumerBaseV2(_VRFCoordinator)
            ERC721 ("MetaHacker", "MHW") {
        COORDINATOR = VRFCoordinatorV2Interface(_VRFCoordinator);
        ENGINE = _metaHackerEngine;
        METADATA = _metahackermetadata;
        MOTOR = _metahackermotorfactory;
        subId = _subId;
        keyHash = _keyHash;
        winsiders = _winsiders;
        paused = false;
        stateofgen = IMetaHackerDNA.Generation.HectorNazareth;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    
    function createToken() public payable returns(uint256 s_requestId) {
        require(!paused, "paused");
        //require (generation < 5, "gene out of range");
        uint8 generation = uint8(stateofgen);
        uint256 volumeOfmh =  metahackerPerGen[generation].length;
        require (volumeOfmh < 1100, "gene full");
        uint256 tokenId = metahacker.length;

        require(msg.value == nftPrice, "needs funds");
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        
        requestIdToTokenId[s_requestId] = tokenId;
        requestIdToSender[s_requestId] = msg.sender;
        
        emit requestedTokenId(s_requestId, tokenId);
    }
    
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        requestIdToRandomNumber[requestId] = randomWords[0];

        uint256 tokenId = requestIdToTokenId[requestId];
        address metahackerOwner = requestIdToSender[requestId];
       
        _safeMint(metahackerOwner, tokenId);
        
        //emit createRandomNum(requestId, randomWords);
    }

    function getRand(uint256 _requestId) public view onlyOwner returns(uint256) {
        return  requestIdToRandomNumber[_requestId];
    }

    function metaHackerWIP(uint256 _requestId) external {
        uint256 tokenId = requestIdToTokenId[_requestId];
        require(bytes(tokenURI(tokenId)).length <= 0, "URI already");
        
        require(requestIdToRandomNumber[_requestId] > 0, "no randnum");
        uint256 randomNumber = requestIdToRandomNumber[_requestId];

        IMetaHackerDNA.Generation generation = stateofgen;

        ENGINE.mhEngineering(generation, tokenId, randomNumber);

        string memory imageSVG = ENGINE.generateSVG(generation, tokenId);
        string memory attribute = METADATA.generateAttribute(generation, tokenId);
        string memory imageURI = MOTOR.svgToImageURI(imageSVG);
        string memory _tokenURI = MOTOR.toTokenURI(imageURI, attribute);

        metahackerPerGen[uint8(generation)].push(tokenId);
        emit createUri(_tokenURI, _tokenURI);
    }

    function metaBytes(bytes calldata _arrayuri) external {}

    function mapMetaBytes(string memory txHash, uint256 _tokenId) external {
        anteuri[_tokenId] = txHash;
    }

    function getMetaBytes(uint256 _tokenId) internal view returns(string memory) {
        return anteuri[_tokenId];
    }

    function tokenURIng(uint256 tokenId, string memory _tokenURI) public {
        IMetaHackerDNA.Generation generation = stateofgen;
        string memory _txOfDataURL = getMetaBytes(tokenId);
        _setTokenURI(tokenId, _tokenURI);
        addMHdata(generation, tokenId, _txOfDataURL);
       
    }
    
    function addMHdata(IMetaHackerDNA.Generation generation, uint256 tokenId, string memory _txOfDataURL) internal {     
        metahacker.push(MOTOR.metahackerz(generation, tokenId, _txOfDataURL));
    }

    function getMetaHacker(uint256 tokenId) public view returns(IMetaHackerDNA.MetaHacker memory) {
        return metahacker[tokenId];
    }

    function setGeneration(IMetaHackerDNA.Generation _generation) public onlyOwner {
        stateofgen = _generation;
    }

    function setPrice(uint256 _newprice) public onlyOwner {
        nftPrice = _newprice;
    }

    function setWinsiders(address payable _newadress) public onlyOwner {
        winsiders = _newadress;
    }

    function setSubId(uint64 _newsubId) public onlyOwner {
        subId = _newsubId;
    }

    function withdraw() public payable onlyOwner {
        winsiders.transfer(address(this).balance);
    }

    function burn(uint256 tokenId) public onlyOwner{
        _burn(tokenId);
    }

     function pause(bool _state) public onlyOwner {
        paused = _state;
    }

}