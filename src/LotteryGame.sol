// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

contract LotteryGame {
    uint256 public constant TICKET_PRICE = 1e16;// 0.01eth

    address[] public tickets;
    address public winner;
    uint256 public ticketingCloses;

    constructor(uint256 duration){
        ticketingCloses = block.timestamp + duration; 
    }

    function buy () public payable {
        require(msg.value == TICKET_PRICE);
        require(block.timestamp < ticketingCloses);
        tickets.push(msg.sender);
    }

    function drawWinner() public {
        require(block.timestamp > ticketingCloses + 5 minutes);
        require(winner == address(0));

        bytes32 hashnum = blockhash(block.number -1);
        bytes32 rand_seed = keccak256(abi.encode(hashnum));
        bytes32 randomNum = rand_seed;

        winner = tickets[uint256(randomNum) % tickets.length];
    }

    function withdraw () public {
        require(msg.sender == winner);
        payable(msg.sender).transfer(address(this).balance);
    }

    receive () external payable {
        buy();
    }
}
