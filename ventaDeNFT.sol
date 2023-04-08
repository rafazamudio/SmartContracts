// Declarar la versión del compilador de Solidity
pragma solidity ^0.8.0;

// Declarar el contrato de venta de NFTs
contract VentaNFT {

    // Declarar una estructura para representar un NFT
    struct NFT {
        uint256 tokenId;
        address propietario;
        string uri;
    }

    // Declarar una lista de NFTs disponibles para la venta
    NFT[] public nftsEnVenta;

    // Declarar un mapping para llevar el registro de los NFTs que han sido vendidos
    mapping(uint256 => bool) public nftsVendidos;

    // Declarar una variable para el dueño del contrato
    address payable public propietarioContrato;

    // Declarar un evento para notificar la venta de un NFT
    event NFTVendido(address comprador, uint256 tokenId, uint256 precio);

    // Constructor del contrato, se inicializa con el dueño del contrato
    constructor() {
        propietarioContrato = payable(msg.sender);
    }

    // Función para agregar un NFT a la lista de venta
    function agregarNFT(uint256 tokenId, string memory uri, uint256 precio) public {
        require(msg.sender == propietarioContrato, "Solo el dueño del contrato puede agregar NFTs a la venta");
        nftsEnVenta.push(NFT(tokenId, address(this), uri));
        emit NFTVendido(address(0), tokenId, precio);
    }

    // Función para obtener la lista de NFTs en venta
    function obtenerNFTsEnVenta() public view returns (NFT[] memory) {
        return nftsEnVenta;
    }

    // Función para comprar un NFT de la lista de venta
    function comprarNFT(uint256 tokenId) public payable {
        // Verificar que el NFT esté disponible para la venta y que el pago sea suficiente
        require(!nftsVendidos[tokenId], "El NFT ya ha sido vendido");
        uint256 precio = msg.value;
        require(precio > 0, "Se requiere un pago mayor a cero");
        for (uint i = 0; i < nftsEnVenta.length; i++) {
            if (nftsEnVenta[i].tokenId == tokenId) {
                require(precio >= precioNFT(i), "Pago insuficiente");
                // Transferir el pago al propietario del contrato
                propietarioContrato.transfer(precio);
                // Transferir la propiedad del NFT al comprador
                nftsEnVenta[i].propietario = msg.sender;
                // Registrar que el NFT ha sido vendido
                nftsVendidos[tokenId] = true;
                // Emitir el evento de venta
                emit NFTVendido(msg.sender, tokenId, precio);
                break;
            }
        }
    }

    // Función para obtener el precio de un NFT en la lista de venta
    function precioNFT(uint256 index) public view returns (uint256) {
        return address(this).balance / nftsEnVenta.length;
    }

    // Función para retirar los fondos del contrato (solo disponible para el propietario)
    function retirarFondos() public {
        require(msg.sender == propietarioContrato, "Solo el dueño del contrato puede retirar los fondos");
        prop
