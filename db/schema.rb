# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090510162912) do

  create_table "administraciones", :force => true do |t|
    t.string   "nivel_alto"
    t.string   "nivel_medio"
    t.string   "nivel_bajo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorias", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorias_conceptos", :id => false, :force => true do |t|
    t.integer "concepto_id"
    t.integer "categoria_id"
  end

  add_index "categorias_conceptos", ["categoria_id"], :name => "index_categorias_conceptos_on_categoria_id"
  add_index "categorias_conceptos", ["concepto_id"], :name => "index_categorias_conceptos_on_concepto_id"

  create_table "conceptos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "especializados", :force => true do |t|
    t.float    "costo"
    t.boolean  "activo"
    t.integer  "servicio_id"
    t.integer  "plaza_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estados", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incorporados", :force => true do |t|
    t.float    "costo"
    t.integer  "servicio_id"
    t.integer  "paquete_id"
    t.date     "vigente_desde"
    t.date     "vigente_hasta"
    t.string   "detalles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paquetes", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paquetes_plazas", :id => false, :force => true do |t|
    t.integer "plaza_id"
    t.integer "paquete_id"
  end

  add_index "paquetes_plazas", ["paquete_id"], :name => "index_paquetes_plazas_on_paquete_id"
  add_index "paquetes_plazas", ["plaza_id"], :name => "index_paquetes_plazas_on_plaza_id"

  create_table "plazas", :force => true do |t|
    t.string   "nombre"
    t.integer  "estado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicios", :force => true do |t|
    t.text     "detalles"
    t.integer  "concepto_id"
    t.integer  "categoria_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.integer  "responsabilidad_id"
    t.string   "responsabilidad_type"
    t.string   "nombre",                    :limit => 100, :default => ""
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "rol_id"
  end

  add_index "usuarios", ["login"], :name => "index_usuarios_on_login", :unique => true

end
