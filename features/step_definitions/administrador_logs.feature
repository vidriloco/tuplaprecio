# language: es

Característica: Administrador Logger

Estando en la pagina de administrador es posible ir a la pagina de logs

Escenario: Administrador, visita logs
    Dado un administrador
    Cuando lleno el formulario de login con datos de administrador
    Y hago click en el botón iniciar sesión
    Y estoy en la pagina de administrador doy click para ver los logs
    Entonces puedo ir a la pagina de logs
