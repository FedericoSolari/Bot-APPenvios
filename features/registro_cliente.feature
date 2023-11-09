#language: es
@wip
Característica: Registro como cliente

    Regla: para registrarse un cliente debe ingresar una dirección y su código postal

    Escenario: Registro exitoso de cliente con comando '/registrar Juan, Av Las Heras 1232, CP: 1425'   
        Dado que no hay un usuario con el nombre Juan   
        Cuando envio el mensaje '/registrar Juan, Av Las Heras 1232, CP: 1425'
        Entonces deberia ver un mensaje "Bienvenid@ Juan"