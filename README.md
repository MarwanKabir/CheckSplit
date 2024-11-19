# CheckSplit Smart Contract

## Purpose
This is a smart contract that formulates a safe and decentralized way for a group to split a bill. The process is very simple as each person can pay their share while the contract automatically tracks contributions and once the total amount is fully paid the process is done.

Main features:
- Ether contributions from participants
- Automatic tracking of every participants contribution
- No duplicate payments
- Transfer funds to owner when owed balance reaches 0
- Transparent record of all of the transactions

## Team Members
1. Marwan Kabir - marwan.kabir06@myhunter.cuny.edu
2. Karim Elshabassy - karim.elshabassy53@myhunter.cuny.edu
3. Edison Freire - edisonfreire49@myhunter.cuny.edu
4. Abdullah Al Razee - abdullah.razee05@myhunter.cuny.edu
5. Blank - Blank

## Contract Interface

### Events
- `ContributionMade(address indexed participant, uint amount)`: This is run when a participant contributes eth
- `SplitCompleted(address indexed owner, uint totalAmount)`: This is run when the split is done

### Functions
- `constructor(uint _totalAmount, address[] memory _participants)`: Initializes the contract
- `contribute()`: Lets all participants to contribute their share of the bill
- `remainingAmount()`: Returns the remaining total amount left to complete the bill split

## Usage
1. The contract owner will deploy this contract with these params:
   - Total bill amount that will be split
   - Pariticipant addresses
2. The Participants will send their money using the contribute() function
3. The Contract will auto complete when the total amount is met
4. The Funds are transferred to the owner once everyone has paid and the balance remaining is 0