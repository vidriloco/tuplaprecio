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

  create_table "conceptos", :force => true do |t|
    t.boolean  "disponible"
    t.integer  "valor"
    t.float    "costo"
    t.text     "comentarios"
    t.integer  "servicio_id"
    t.integer  "metaconcepto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estados", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metaconceptos", :force => true do |t|
    t.string   "nombre"
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metaconceptos_metaservicios", :id => false, :force => true do |t|
    t.integer "metaservicio_id"
    t.integer "metaconcepto_id"
  end

  add_index "metaconceptos_metaservicios", ["metaconcepto_id"], :name => "index_metaconceptos_metaservicios_on_metaconcepto_id"
  add_index "metaconceptos_metaservicios", ["metaservicio_id"], :name => "index_metaconceptos_metaservicios_on_metaservicio_id"

  create_table "metaservicios", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metasubservicios", :force => true do |t|
    t.string   "nombre"
    t.integer  "metaservicio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paquetes", :force => true do |t|
    t.float    "costo_1_10"
    t.float    "costo_11_31"
    t.float    "costo_real"
    t.float    "ahorro"
    t.integer  "numero_de_servicios"
    t.string   "television"
    t.string   "telefonia"
    t.string   "internet"
    t.integer  "plaza_id"
    t.integer  "zona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "plaza_id"
    t.integer  "metasubservicio_id"
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

  create_table "zonas", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
