// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract SecureBank is ReentrancyGuard {
   mapping(address => uint256) public balances;


   // Depósito
   function deposit() public payable {
       balances[msg.sender] += msg.value;
   }


   // Función segura con prevención de reentrada
   function withdraw(uint256 amount) public nonReentrant {
       require(balances[msg.sender] >= amount, "Insufficient balance");


       // Primero actualizamos el balance
       balances[msg.sender] -= amount;


       // Luego realizamos la llamada externa
       (bool success, ) = msg.sender.call{value: amount}("");
       require(success, "Transfer failed");
   }


   // Obtener el balance de un usuario
   function getBalance() public view returns (uint256) {
       return balances[msg.sender];
   }
}
