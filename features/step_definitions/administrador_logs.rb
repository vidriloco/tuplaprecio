Y /^estoy en la pagina de administrador doy click para ver los logs$/ do
  click_link('Sección de Logs de la aplicación')
end

Entonces /^puedo ir a la pagina de logs$/ do
  response.should render_template("logs/index.html.erb")
end
