pragma solidity 0.8.4;


// SPDX-License-Identifier: MIT;


contract CaseManager {
    
    mapping(address => bool )public firstResponder;
    mapping(address => bool ) public investigator;
    mapping(address=> bool) public prosecutor;
    mapping(uint256 => Evidence[])  _getEvidence; // case_id returns array of evidence struct
    mapping (uint256 => Case) _getCase;
    struct Evidence{
        address personnel;
        string evidenceHash;
        uint256 timestamp;
        uint256 evidenceId;
    }
    
    struct Case{
        uint256 caseId;
        address initializer;
        uint256 [] evidenceIds;
        Stage stage;
    }
    
    enum Stage{
         opened, closed
    }
    
    uint256 public caseId = 0;
    
    event Initialized(address initializer, Stage stage);
    event NewEvidence(address person, string evidence_hash, uint256 case_id);
    event CaseCompleted( address person, uint256 case_id);
    
    modifier OnlyFirstResponder(){
        require(firstResponder[msg.sender]);
        _;
    }
    
     modifier OnlyInvestigator(){
        require(investigator[msg.sender]);
        _;
    }
    
    modifier OnlyProsecutor(){
        require(prosecutor[msg.sender]);
        _;
    }
    
    constructor(){}
    
    function getEvidence(uint256 _caseId) external view returns(Evidence[] memory){
        return _getEvidence[_caseId];
    }
    
    
    function getCase(uint256 _caseId) external view returns(Case memory){
        return _getCase[_caseId];
    }
    
    
    function initializeCase( string calldata evidence_hash) external OnlyFirstResponder{
        Evidence memory evidence;
        caseId = caseId+1;
        evidence.evidenceHash = evidence_hash;
        evidence.personnel =msg.sender;
        evidence.timestamp = block.timestamp;
        evidence.evidenceId = 1;
        
    }
    
    function updateCase( uint256 _caseId, string calldata evidenceHash) external {
        
         Evidence memory evidence;
        evidence.evidenceHash = evidenceHash;
        evidence.personnel =msg.sender;
        evidence.timestamp = block.timestamp;
        evidence.evidenceId = 1;
        
        _getEvidence[_caseId].push(evidence);
        
    }
    
    function completeCase(uint256 _caseId) external OnlyProsecutor{
        Case storage _case = _getCase[_caseId];
        _case.stage = Stage.closed;
        
    }
    
}