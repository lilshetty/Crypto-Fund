// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    struct Campaign {
        address payable creator;
        string description;
        uint goal;
        uint pledged;
        bool completed;
    }

    mapping(uint => Campaign) public campaigns;
    uint public campaignCount = 0;

    function createCampaign(string memory _description, uint _goal) public {
        require(_goal > 0, "Goal should be greater than 0");

        campaigns[campaignCount] = Campaign({
            creator: payable(msg.sender),
            description: _description,
            goal: _goal,
            pledged: 0,
            completed: false
        });

        campaignCount++;
    }

    function donate(uint _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.value > 0, "Donation should be greater than 0");
        require(!campaign.completed, "Campaign already completed");

        campaign.creator.transfer(msg.value);
        campaign.pledged += msg.value;

        if (campaign.pledged >= campaign.goal) {
            campaign.completed = true;
        }
    }

    function getCampaign(uint _campaignId) public view returns (
        address creator,
        string memory description,
        uint goal,
        uint pledged,
        bool completed
    ) {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.creator,
            campaign.description,
            campaign.goal,
            campaign.pledged,
            campaign.completed
        );
    }
}
