# language: es

Característica: Usuario Login

Para que pueda hacer uso de la aplicación
Como un usuario cualquiera
Quiero ver las páginas que corresponden a cada tipo de usuario
    
Escenario: Desde la página de login, enviarme a página de administrador cuando sea administrador
    Dado un administrador
    Cuando lleno el formulario de login con datos de administrador
    Entonces soy enviado a la vista de administrador
    
Escenario: Desde la página de login, enviarme a página de encargado cuando sea encargado
    Dado un encargado
    Cuando lleno el formulario de login con datos de encargado
    Entonces soy enviado a la vista de un encargado
    Y debe aparecer la plaza que tengo asignada
    
Escenario: Desde la página de login, enviarme a página de agente cuando sea agente
    Dado un agente
    Cuando lleno el formulario de login con datos de agente
    Entonces soy enviado a la vista de un agente