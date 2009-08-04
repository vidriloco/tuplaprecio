Dado /^un administrador$/ do
  @administrador = Factory.create(:usuario_completo_admin)
end

Cuando /^lleno el formulario de login con datos de administrador$/ do
  visit '/login'
  fill_in "login", :with => @administrador.login
  fill_in "password", :with => @administrador.password
end

Y /^hago click en el botón iniciar sesión$/ do
  click_button "Iniciar Sesión"
end

Entonces /^soy enviado a la vista de administrador$/ do
  response.should render_template("administraciones/index.html.erb")
end


Dado /^un encargado$/ do
  @encargado = Factory.create(:usuario_completo_encargado)
end

Cuando /^lleno el formulario de login con datos de encargado$/ do
  visit '/login'
  fill_in "login", :with => @encargado.login
  fill_in "password", :with => @encargado.password
end

Entonces /^soy enviado a la vista de un encargado$/ do
  response.should render_template("tableros/index_nivel_dos.html.erb")
end

Y /^debe aparecer la plaza que tengo asignada$/ do
  response.should contain(@encargado.plaza.nombre)
end

Dado /^un agente$/ do
  @agente = Factory.create(:usuario_completo_agente)
end

Cuando /^lleno el formulario de login con datos de agente$/ do
  visit '/login'
  fill_in "login", :with => @agente.login
  fill_in "password", :with => @agente.password
end

Entonces /^soy enviado a la vista de un agente$/ do
  response.should render_template("tableros/index_nivel_tres.html.erb")
end

