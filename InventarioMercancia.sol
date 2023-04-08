// Declarar la versión del compilador de Solidity
pragma solidity ^0.8.0;

// Declarar el contrato de control de inventario
contract Inventario {

    // Estructura de los productos del inventario
    struct Producto {
        string nombre;
        uint cantidad;
    }

    // Mapeo de los productos del inventario
    mapping(uint => Producto) public productos;

    // Función para agregar un producto al inventario
    function agregarProducto(uint id, string memory nombre, uint cantidad) public {
        productos[id] = Producto(nombre, cantidad);
    }

    // Función para actualizar la cantidad de un producto en el inventario
    function actualizarCantidad(uint id, uint cantidad) public {
        require(productos[id].cantidad >= cantidad, "No hay suficiente cantidad en el inventario");
        productos[id].cantidad -= cantidad;
    }

    // Función para obtener la cantidad de un producto en el inventario
    function obtenerCantidad(uint id) public view returns (uint) {
        return productos[id].cantidad;
    }
}
