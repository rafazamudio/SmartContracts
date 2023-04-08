// Declarar la versión del compilador de Solidity
pragma solidity ^0.8.0;

// Declarar el contrato de transferencia de mercancías
contract TransferenciaMercancias {

    // Declarar una estructura para representar una mercancía
    struct Mercancia {
        uint256 id;
        string nombre;
        uint256 cantidad;
        string descripcion;
        address propietario;
        address recintoActual;
    }

    // Declarar una lista de mercancías
    Mercancia[] private _mercancias;

    // Función para agregar una nueva mercancía a la lista
    function agregarMercancia(uint256 id, string memory nombre, uint256 cantidad, string memory descripcion, address propietario, address recintoActual) public {
        _mercancias.push(Mercancia(id, nombre, cantidad, descripcion, propietario, recintoActual));
    }

    // Función para obtener el número total de mercancías en la lista
    function totalMercancias() public view returns (uint256) {
        return _mercancias.length;
    }

    // Función para obtener los detalles de una mercancía en particular
    function detallesMercancia(uint256 index) public view returns (uint256, string memory, uint256, string memory, address, address) {
        require(index < _mercancias.length, "El índice de la mercancía es inválido");
        Mercancia storage mercancia = _mercancias[index];
        return (mercancia.id, mercancia.nombre, mercancia.cantidad, mercancia.descripcion, mercancia.propietario, mercancia.recintoActual);
    }

    // Función para transferir una mercancía de un recinto a otro
    function transferirMercancia(uint256 index, address nuevoRecinto) public {
        require(index < _mercancias.length, "El índice de la mercancía es inválido");
        Mercancia storage mercancia = _mercancias[index];
        require(mercancia.recintoActual == msg.sender, "El remitente no es el recinto actual de la mercancía");
        mercancia.recintoActual = nuevoRecinto;
    }
}
