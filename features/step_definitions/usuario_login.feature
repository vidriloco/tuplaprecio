# language: es

Característica: Usuario Login

Para que pueda hacer uso de la aplicación
Como un usuario cualquiera
Quiero ver las páginas que corresponden a cada tipo de usuario
    
Escenario: Administrador, vista administrador
    Dado un administrador
    Cuando lleno el formulario de login con datos de administrador
    Y hago click en el botón iniciar sesión
    Entonces soy enviado a la vista de administrador
    
Escenario: Encargado, vista encargado
    Dado un encargado
    Cuando lleno el formulario de login con datos de encargado
    Y hago click en el botón iniciar sesión    
    Entonces soy enviado a la vista de un encargado
    Y debe aparecer la plaza que tengo asignada
    
Escenario: Agente, vista agente
    Dado un agente
    Cuando lleno el formulario de login con datos de agente
    Y hago click en el botón iniciar sesión
    Entonces soy enviado a la vista de un agente