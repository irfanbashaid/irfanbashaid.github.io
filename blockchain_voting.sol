pragma solidity ^0.5.0;

contract Blockchain_voting {

    constructor() public{
        _candReg("TRUMP");
        _candReg("BIDEN");
    }

    mapping(string=>bool) public registeredCandidatesMap;
    mapping(address=>bool) public isVoted;
    mapping(string=>uint) public no_of_votes;
    function _candReg(string memory _candName) internal {
        registeredCandidatesMap[_candName] = true;
    }

    function voting(string memory candName) public {
        require(registeredCandidatesMap[candName],"Invalid Candidate!");
        require(votingStartTime>0,"Voting not started!");
        require(votingStartTime+votingDuration>getBlockchainTime(),"Voting already ends!");
        require(!isVoted[msg.sender],"Already voted!");
        no_of_votes[candName]++;
        isVoted[msg.sender] = true;
    }

    uint votingStartTime;
    uint votingDuration = 5 minutes;
    function startVoting() public {
        votingStartTime = getBlockchainTime();
    }

    function getBlockchainTime() public view returns(uint){
        return block.timestamp;
    }
        
    function result() public view returns(string memory) {
        if(votingStartTime>0){
            if(votingStartTime+votingDuration<getBlockchainTime()){
                if(no_of_votes["TRUMP"] > no_of_votes["BIDEN"]) {
                    return "Trump won the election";
                }
                else if(no_of_votes["TRUMP"] < no_of_votes["BIDEN"]) {
                    return "Biden won the election";
                }
                else {
                    return "Tie! no result";
                }
            }
            else {
                return "Voting not ends!";
            }
        }
        else {
            return "Voting not started!";
        }
    }
}
