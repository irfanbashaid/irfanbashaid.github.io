pragma solidity ^0.5.0;
contract VotingContract {
    //cand reg
    mapping(string=>bool) isCandRegistered;
    function candidateRegisteration() private {
        isCandRegistered["TRUMP"] = true;
        isCandRegistered["BIDEN"] = true;
    }
    constructor() public {
        candidateRegisteration();
    }
    
    mapping(string => uint) voteCount;
    mapping(address => bool) isAlreadyVoted;
    function voting(string memory _candName) public{
        //_candName isRegistered?
        //is voting started?
        //is voting inProgress?
        //is already voted?
        require(isCandRegistered[_candName],"Invalid candidate");
        require(votingStartTime!=0, "please wait! voting yet to start");
        require(votingStartTime+votingDuration > getBlockchainTime(), "Voting Ends");
        require(!isAlreadyVoted[msg.sender], "Already voted");
        voteCount[_candName]++;
        isAlreadyVoted[msg.sender] = true;
    }

    function getBlockchainTime() public view returns (uint){
        return block.timestamp;
    }
   
    uint votingStartTime = 0;
    uint votingDuration = 5 minutes;
    function startVoting() public {
        votingStartTime = getBlockchainTime();
    }

    function noOfVotes(string memory candName) public view returns(uint) {
        return voteCount[candName];
    }

    function result_state() public view returns(string memory) {
        if(votingStartTime!=0) {
            if(votingStartTime+votingDuration<getBlockchainTime()) {
                if(voteCount["TRUMP"] > voteCount["BIDEN"]) {
                    return "Trump won the election";
                } else if(voteCount["BIDEN"] > voteCount["TRUMP"]){
                    return "Biden won the election";
                } else {
                    return "Tie! no result";
                }
            } else {
                return "please wait! voting is inProgress";
            }
        } else {
            return "Voting not started!";
        }
    }

}
