// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenToNFTExchange is Ownable {
    IERC20 public token; // Token ERC20 que se utilizará para el intercambio
    IERC721 public nft; // Contrato del NFT

    // Estructura para almacenar la información de la oferta
    struct Offer {
        uint256 nftId; // ID del NFT
        uint256 price; // Precio en tokens
    }

    // Mapeo de ofertas
    mapping(uint256 => Offer) public offers;

    // Evento para registrar el intercambio
    event Exchange(address indexed buyer, uint256 indexed nftId, uint256 price);

    constructor(IERC20 _token, IERC721 _nft) Ownable(msg.sender) {
        token = _token;
        nft = _nft;
    }


    // Función para crear una oferta
    function createOffer(uint256 nftId, uint256 price) external onlyOwner {
        require(nft.ownerOf(nftId) == msg.sender, "No eres el propietario del NFT");
        offers[nftId] = Offer(nftId, price);
    }

    // Función para intercambiar tokens por un NFT
    function buyNFT(uint256 nftId) external {
        Offer memory offer = offers[nftId];
        require(offer.price > 0, "No hay oferta disponible");
        
        // Transferir el precio en tokens del comprador al vendedor
        token.transferFrom(msg.sender, owner(), offer.price);
        
        // Transferir el NFT al comprador
        nft.safeTransferFrom(owner(), msg.sender, nftId);
        
        emit Exchange(msg.sender, nftId, offer.price);
        
        // Eliminar la oferta después de la compra
        delete offers[nftId];
    }

    // Función para cancelar una oferta (solo el propietario)
    function cancelOffer(uint256 nftId) external onlyOwner {
        delete offers[nftId];
    }
}
