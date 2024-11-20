contract CheckSplit {
    struct Participant {
        uint contribution;
        bool hasPaid;
    }

    address public owner;
    uint public totalAmount;
    uint public totalContributed;
    mapping(address => Participant) public participants;
    address[] public participantList;
    bool public isCompleted;

    event ContributionMade(address indexed participant, uint amount);
    event SplitCompleted(address indexed owner, uint totalAmount);

    /// @param _totalAmount The total amount to be split
    /// @param _participants List of participant addresses
    constructor(uint _totalAmount, address[] memory _participants) public {
        require(_totalAmount > 0, "The total has to be greater than 0!");
        require(_participants.length > 0, "There has to be at least one participant!");

        owner = msg.sender;
        totalAmount = _totalAmount;
        participantList = _participants;

        for (uint i = 0; i < _participants.length; i++) {
            participants[_participants[i]] = Participant(0, false);
        }
    }

    function contribute() public payable {
        require(!isCompleted, "Bill splitting is complete!");
        require(participants[msg.sender].hasPaid == false, "participant already paid.");
        require(msg.value > 0, "The contribution has to be greater than 0!");
        require(msg.value <= (totalAmount - totalContributed), "The contribution is more than the remaining total!");

        uint remaining = totalAmount - totalContributed;
        uint contributionAmount = msg.value;
        uint excessAmount = 0;

        participants[msg.sender].contribution = msg.value;
        participants[msg.sender].hasPaid = true;
        totalContributed += msg.value;

        emit ContributionMade(msg.sender, msg.value);

        if (msg.value > remaining) {
            excessAmount = msg.value - remaining;// sets excess to the difference between the collected and whats remaining.
            totalContributed -= excessAmount;
        }

        participants[msg.sender].contribution = contributionAmount;  // Store actual contribution
        participants[msg.sender].hasPaid = true;
        totalContributed += contributionAmount;  // Add actual contribution

        emit ContributionMade(msg.sender, contributionAmount);  // Emit actual contribution

        if (excessAmount > 0) {
            payable(msg.sender).transfer(excessAmount); // refunds any excess amount
        }

        if (totalContributed >= totalAmount) {
            completeSplit();
        }       

    }

    function completeSplit() internal {
        require(totalContributed >= totalAmount, "Not enough funds collected!");// Makes sure that the amount split is either more then or equal to the amount of the bill.
        require(!isCompleted, "The Split has already been completed!");//Makes sure the split has not already been completed

        isCompleted = true;//Sets the bool to true that way the function dose not keep repeating.
        address payable ownerPayable = payable(owner);//Turns the address of the owner into one that can be paid by making it into an int thats 160 bits long
        ownerPayable.transfer(address(this).balance);//Sends the final amount after all the funds are collected to the adress

        emit SplitCompleted(owner, totalAmount);//logs the event split completed
    }

    function remainingAmount() public view returns (uint) {
        return totalAmount - totalContributed;// retuns the difference between the bill total and the amount contribued.
    }

    function() external payable {
        contribute();
    }
}


