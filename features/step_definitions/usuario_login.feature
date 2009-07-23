# language: es

Característica: Usuario Login

Para que pueda hacer uso de la aplicación
Como un usuario cualquiera
Quiero ver las páginas que corresponden a cada tipo de usuario
    
Escenario: Desde la página de login, enviarme a página de administrador cuando sea administrador
    Dado un administrador
    Cuando lleno el formulario de login
    Entonces soy enviado a la vista de administrador