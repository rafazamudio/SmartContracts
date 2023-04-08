// Declarar la versión del compilador de Solidity
pragma solidity ^0.8.0;

// Declarar el contrato de almacenamiento de contratos jurídicos
contract AlmacenamientoContratos {

    // Declarar una estructura para representar un contrato jurídico
    struct Contrato {
        uint256 id;
        string titulo;
        string contenido;
    }

    // Declarar una lista de contratos jurídicos
    Contrato[] public contratos;

    // Declarar una variable para el administrador del contrato
    address public administrador;

    // Declarar un evento para notificar la creación de un contrato jurídico
    event ContratoCreado(uint256 id, string titulo, string contenido);

    // Constructor del contrato, se inicializa con el administrador
    constructor() {
        administrador = msg.sender;
    }

    // Función para crear un nuevo contrato jurídico
    function crearContrato(string memory titulo, string memory contenido) public {
        // Verificar que solo el administrador pueda crear contratos
        require(msg.sender == administrador, "Solo el administrador puede crear contratos");
        // Crear un nuevo contrato y agregarlo a la lista de contratos
        Contrato memory nuevoContrato = Contrato(contratos.length, titulo, contenido);
        contratos.push(nuevoContrato);
        // Emitir el evento de contrato creado
        emit ContratoCreado(nuevoContrato.id, nuevoContrato.titulo, nuevoContrato.contenido);
    }

    // Función para obtener la lista de contratos jurídicos
    function obtenerContratos() public view returns (Contrato[] memory) {
        return contratos;
    }

    // Función para obtener un contrato jurídico por su ID
    function obtenerContratoPorId(uint256 id) public view returns (Contrato memory) {
        require(id < contratos.length, "El contrato no existe");
        return contratos[id];
    }

    // Función para retirar los fondos del contrato (solo disponible para el administrador)
    function retirarFondos() public {
        require(msg.sender == administrador, "Solo el administrador puede retirar los fondos");
        uint256 balance = address(this).balance;
        require(balance > 0, "No hay fondos para retirar");
        payable(administrador).transfer(balance);
    }
}
