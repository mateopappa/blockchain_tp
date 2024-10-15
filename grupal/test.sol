// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity ^0.8.0;

contract DecentralizedVoting {
    address public owner;
    string public topic;
    uint public votingDeadline;
    mapping(address => bool) public hasVoted;
    mapping(string => uint) public votes;
    string[] public candidates;
    bool public votingClosed;

    event VoteCast(address indexed voter, string candidate);
    event VotingCompleted(string winner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp <= votingDeadline, "Voting period is over.");
        _;
    }

    constructor(string memory _topic, string[] memory _candidates, uint _votingDuration) {
        owner = msg.sender;
        topic = _topic;
        candidates = _candidates;
        votingDeadline = block.timestamp + _votingDuration;
        votingClosed = false;
    }

    function vote(string memory candidate) public beforeDeadline {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(!votingClosed, "Voting has ended.");
        
        bool isValidCandidate = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(candidate))) {
                isValidCandidate = true;
                break;
            }
        }
        require(isValidCandidate, "Invalid candidate.");

        votes[candidate]++;
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, candidate);
    }

    function endVoting() public onlyOwner {
        require(block.timestamp > votingDeadline, "Voting period still active.");
        require(!votingClosed, "Voting already ended.");

        string memory winner;
        uint highestVotes = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > highestVotes) {
                highestVotes = votes[candidates[i]];
                winner = candidates[i];
            }
        }
        
        votingClosed = true;
        emit VotingCompleted(winner);
    }
}
