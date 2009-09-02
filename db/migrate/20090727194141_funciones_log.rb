class FuncionesLog < ActiveRecord::Migration
  def self.up
    execute "SET TIME ZONE DEFAULT;"
    #execute "CREATE LANGUAGE plpgsql;"
    execute "CREATE FUNCTION clona_recurso(varchar, integer, integer) RETURNS INTEGER AS $$
      DECLARE
        id_salida integer;
        tupla_de_ids RECORD;
    	BEGIN
    		IF $1 = 'servicios' THEN 
    			INSERT INTO servicio_clones (plaza_nombre, estado_nombre, metasubservicio_nombre, metaservicio_nombre) 
    			SELECT plazas.nombre, estados.nombre, metasubservicios.nombre, metaservicios.nombre  
    			FROM servicios, plazas, estados, metasubservicios, metaservicios WHERE 
    			servicios.id = $2 AND 
    			servicios.plaza_id = plazas.id AND 
    			plazas.estado_id = estados.id AND 
    			servicios.metasubservicio_id = metasubservicios.id AND 
    			metasubservicios.metaservicio_id = metaservicios.id 
    			RETURNING servicio_clones.id INTO id_salida;
    			
    			FOR tupla_de_ids IN SELECT conceptos.id AS concepto_id FROM servicios, conceptos WHERE servicios.id = $2 AND conceptos.servicio_id = servicios.id  LOOP
    			  PERFORM clona_recurso('conceptos', tupla_de_ids.concepto_id, id_salida);
    			END LOOP;
    		ELSIF $1 = 'conceptos' THEN
    		  INSERT INTO concepto_clones (disponible, valor, costo, comentarios, servicio_clon_id, metaconcepto_nombre, metaconcepto_tipo) 
    		  SELECT conceptos.disponible, conceptos.valor, conceptos.costo, conceptos.comentarios, $3, metaconceptos.nombre, metaconceptos.tipo 
          FROM servicios, conceptos, metaconceptos WHERE
          conceptos.id = $2 AND
          conceptos.servicio_id = servicios.id AND
          conceptos.metaconcepto_id = metaconceptos.id;
        ELSIF $1 = 'paquetes' THEN
          INSERT INTO paquete_clones (costo_1_10, costo_11_31, costo_real, ahorro, numero_de_servicios, television, telefonia, internet, plaza_nombre, estado_nombre, zona_nombre) 
          SELECT paquetes.costo_1_10, paquetes.costo_11_31, paquetes.costo_real, paquetes.ahorro, paquetes.numero_de_servicios, paquetes.television, paquetes.telefonia, paquetes.internet, plazas.nombre, estados.nombre, zonas.nombre  
          FROM paquetes, plazas, estados, zonas WHERE
          paquetes.id = $2 AND
          paquetes.plaza_id = plazas.id AND
          plazas.estado_id = estados.id AND
          paquetes.zona_id = zonas.id
          RETURNING paquete_clones.id INTO id_salida;
    		END IF;
    		RETURN id_salida;
    	END;
    $$ LANGUAGE plpgsql;"
    
  end

  def self.down
    execute "DROP FUNCTION clona_recurso(varchar, integer, integer);"
    #begin
    #  execute "DROP LANGUAGE plpgsql;"
    #rescue
    #  execute "DROP LANGUAGE plpgsql CASCADE;"
    #end
  end
end
