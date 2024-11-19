/// Check Splitting Contract
/// This splits a bill among participants using Ether.
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

    /// _totalAmount The total amount to be split
    /// _participants List of participant addresses
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

        participants[msg.sender].contribution = msg.value;
        participants[msg.sender].hasPaid = true;
        totalContributed += msg.value;

        emit ContributionMade(msg.sender, msg.value);

        if (totalContributed >= totalAmount) {
            completeSplit();
        }
    }

    function completeSplit() internal {
        require(totalContributed >= totalAmount, "Not enough funds collected!");
        require(!isCompleted, "The Split has already been completed!");

        isCompleted = true;
        address payable ownerPayable = address(uint160(owner));
        ownerPayable.transfer(address(this).balance);

        emit SplitCompleted(owner, totalAmount);
    }

    function remainingAmount() public view returns (uint) {
        return totalAmount - totalContributed;
    }

    function() external payable {
        contribute();
    }
}