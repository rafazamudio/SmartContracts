// Declarar la versión del compilador de Solidity
pragma solidity ^0.8.0;

// Declarar el contrato de control de votos electorales
contract ControlVotos {

    // Declarar una estructura para representar un candidato
    struct Candidato {
        uint256 id;
        string nombre;
        uint256 votos;
    }

    // Declarar una lista de candidatos
    Candidato[] public candidatos;

    // Declarar un mapping para llevar el registro de los votos emitidos
    mapping(address => bool) public votantes;

    // Declarar una variable para el administrador del contrato
    address public administrador;

    // Declarar un evento para notificar la emisión de un voto
    event VotoEmitido(address votante, uint256 candidatoId);

    // Constructor del contrato, se inicializa con los candidatos y el administrador
    constructor(string[] memory nombresCandidatos) {
        administrador = msg.sender;
        for (uint i = 0; i < nombresCandidatos.length; i++) {
            candidatos.push(Candidato(i, nombresCandidatos[i], 0));
        }
    }

    // Función para obtener la lista de candidatos
    function obtenerCandidatos() public view returns (Candidato[] memory) {
        return candidatos;
    }

    // Función para emitir un voto por un candidato
    function emitirVoto(uint256 candidatoId) public {
        // Verificar que el votante no haya votado antes y que el candidato exista
        require(!votantes[msg.sender], "Ya has emitido tu voto");
        require(candidatoId < candidatos.length, "El candidato no existe");
        // Registrar el voto del votante
        votantes[msg.sender] = true;
        // Incrementar el número de votos del candidato
        candidatos[candidatoId].votos++;
        // Emitir el evento de voto emitido
        emit VotoEmitido(msg.sender, candidatoId);
    }

    // Función para obtener el número de votos emitidos por un candidato
    function obtenerVotosCandidato(uint256 candidatoId) public view returns (uint256) {
        require(candidatoId < candidatos.length, "El candidato no existe");
        return candidatos[candidatoId].votos;
    }

    // Función para obtener el resultado de la elección
    function obtenerResultado() public view returns (Candidato[] memory) {
        Candidato[] memory resultado = new Candidato[](candidatos.length);
        for (uint i = 0; i < candidatos.length; i++) {
            resultado[i] = candidatos[i];
        }
        return resultado;
    }

    // Función para retirar los fondos del contrato (solo disponible para el administrador)
    function retirarFondos() public {
        require(msg.sender == administrador, "Solo el administrador puede retirar los fondos");
        uint256 balance = address(this).balance;
        require(balance > 0, "No hay fondos para retirar");
        payable(administrador).transfer(balance);
    }
}
