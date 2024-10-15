// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Ballot {
    
    // struct that resembles person who will be voting (voters)
    struct Voter {
        bool hasVoted;
        address delegate;
        uint256 weight;
        uint256 voteFor;
    }

    // struct that resembles person who will be voted upon (candidates)
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    // the person who manages this ballot
    address public chairperson;

    // map wallet address to Voter object
    mapping(address => Voter) public voters;

    // array to store candidates information
    Proposal[] public proposals;

    constructor(string[] memory newProposals) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // create new Proposal object based on the supplied data when the contract is deployed
        for (uint i = 0; i < newProposals.length; i++) {
            proposals.push(Proposal({
                name: newProposals[i],
                voteCount: 0
            }));
        }
    }

    function giveVotingRight(address voter) external {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[voter].hasVoted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.hasVoted, "Already voted.");
        
        sender.hasVoted = true;
        sender.voteFor = proposal;

        // If `proposal` is out of the range of the array, this will throw automatically and revert all changes.
        proposals[proposal].voteCount += sender.weight;
    }

    function getProposals() external view returns (string[] memory, uint[] memory) {
        uint proposalCount = proposals.length;
        string[] memory proposalNames = new string[](proposalCount);
        uint[] memory proposalVoteCounts = new uint[](proposalCount);

        for (uint i = 0; i < proposalCount; i++) {
            proposalNames[i] = proposals[i].name;
            proposalVoteCounts[i] = proposals[i].voteCount;
        }

        return (proposalNames, proposalVoteCounts);
    }

}