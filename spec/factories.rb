

Factory.define :categoria do |c|
  c.nombre "Alguna Categoria"
end

Factory.define :administracion do |a|
  a.nivel_alto "Administrador" 
  a.nivel_medio "Encargado"
  a.nivel_bajo "Agente"
end



