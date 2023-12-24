// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract VotingContract {
   address public owner;
  
   enum State { NotStarted, InProgress, Ended }
   State public currentState;
  
   uint256 public startTime;
   uint256 public endTime;


   // Candidate structure
   struct Candidate {
       uint256 id;
       string name;
       uint256 voteCount;
   }


   mapping(uint256 => Candidate) public candidates;
   uint256 public candidatesCount;


   // Voter structure
   struct Voter {
       bool hasVoted;
   }


   mapping(address => Voter) public voters;


   // Events
   event VoteCasted(address indexed voter, uint256 candidateId);
   event ElectionEnded(uint256 winningCandidateId);


   modifier onlyOwner() {
       require(msg.sender == owner, "Only the owner can execute this");
       _;
   }


   modifier onlyDuringVotingPeriod() {
       require(
           currentState == State.InProgress && block.timestamp >= startTime && block.timestamp <= endTime,
           "Voting is not currently allowed"
       );
       _;
   }


   modifier onlyAfterVotingPeriod() {
       require(currentState == State.Ended && block.timestamp > endTime, "Voting period has not ended");
       _;
   }


   modifier hasNotVoted() {
       require(!voters[msg.sender].hasVoted, "You have already voted");
       _;
   }


  constructor() {
   owner = msg.sender;
   startTime = block.timestamp; // Set the start time to the current block timestamp
   endTime = startTime + 5 minutes; // Set the end time to 30 minutes after the start time
   currentState = State.NotStarted;
}




   function startVoting() external onlyOwner {
       require(currentState == State.NotStarted, "Voting has already started or ended");
       currentState = State.InProgress;
   }


   function endVoting() external onlyOwner onlyDuringVotingPeriod {
       currentState = State.Ended;
       uint256 winningCandidateId = getWinningCandidate();
       emit ElectionEnded(winningCandidateId);
   }


   function addCandidate(string memory _name) external onlyOwner onlyDuringVotingPeriod {
       candidatesCount++;
       candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
   }


   function vote(uint256 _candidateId) external onlyDuringVotingPeriod hasNotVoted {
       require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
       voters[msg.sender].hasVoted = true;
       candidates[_candidateId].voteCount++;
       emit VoteCasted(msg.sender, _candidateId);
   }


   function getWinner() external view onlyAfterVotingPeriod returns (string memory winnerName, uint256 winnerVotes) {
       uint256 winningCandidateId = getWinningCandidate();
       winnerName = candidates[winningCandidateId].name;
       winnerVotes = candidates[winningCandidateId].voteCount;
   }


   function getWinningCandidate() internal view returns (uint256) {
       uint256 winningVoteCount = 0;
       uint256 winningCandidateId;


       for (uint256 i = 1; i <= candidatesCount; i++) {
           if (candidates[i].voteCount > winningVoteCount) {
               winningVoteCount = candidates[i].voteCount;
               winningCandidateId = i;
           }
       }


       return winningCandidateId;
   }
}
