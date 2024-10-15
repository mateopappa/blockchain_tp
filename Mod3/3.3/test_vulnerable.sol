// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VulnerableBank {
   mapping(address => uint256) public balances;


   // Depósito
   function deposit() public payable {
       balances[msg.sender] += msg.value;
   }


   // Función vulnerable al ataque de reentrancy
   function withdraw(uint256 amount) public {
       require(balances[msg.sender] >= amount, "Insufficient balance");


       // Llamada externa antes de actualizar el balance
       (bool success, ) = msg.sender.call{value: amount}("");
       require(success, "Transfer failed");


       balances[msg.sender] -= amount;
   }
}