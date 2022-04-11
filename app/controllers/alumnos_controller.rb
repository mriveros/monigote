class PilotosController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index
   

  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_pilotos_id].present?

      cond << "piloto_id = ?"
      args << params[:form_buscar_pilotos_id]

    end

    if params[:form_buscar_pilotos_nombre].present?

      cond << "nombres ilike ?"
      args << "%#{params[:form_buscar_pilotos_nombre]}%"

    end

    if params[:form_buscar_pilotos_apellido].present?

      cond << "apellidos ilike ?"
      args << "%#{params[:form_buscar_pilotos_apellido]}%"

    end

    if params[:form_buscar_pilotos_ci].present?

      cond << "ci = ?"
      args << params[:form_buscar_pilotos_ci]

    end

    if params[:form_buscar_pilotos_fecha_nacimiento].present?

      cond << "fecha_nacimiento = ?"
      args << params[:form_buscar_pilotos_fecha_nacimiento]

    end

    if params[:form_buscar_pilotos][:grupo_sanguineo_id].present?

      cond << "grupo_sanguineo_id = ?"
      args << params[:form_buscar_pilotos][:grupo_sanguineo_id]

    end

    if params[:form_buscar_pilotos_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_pilotos_direccion]}%"

    end

    if params[:form_buscar_pilotos_telefono].present?

      cond << "telefono ilike ?"
      args << "%#{params[:form_buscar_pilotos_telefono]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @pilotos =  VPiloto.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VPiloto.where(cond).count
      
    else

      @pilotos = VPiloto.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VPiloto.count

    end

    @total_registros = VPiloto.count

  	respond_to do |f|
	    
	   f.js
	    
	  end

  end

  def agregar

    @piloto = Piloto.new

    respond_to do |f|
	    
	      f.js
	    
	  end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false
    

    if @valido
      
      @piloto = Piloto.new()
      @piloto.nombres = params[:nombres].upcase
      @piloto.apellidos = params[:apellidos].upcase
      @piloto.ci = params[:ci]
      @piloto.grupo_sanguineo_id = params[:piloto][:grupo_sanguineo_id]
      @piloto.fecha_nacimiento = params[:piloto][:fecha_nacimiento]
      @piloto.direccion = params[:direccion].upcase
      @piloto.telefono = params[:telefono]
      

        if @piloto.save

          auditoria_nueva("registrar piloto", "pilotos", @piloto)
          @guardado_ok = true
          @persona = Persona.where('documento_persona = ?', params[:ci]).first
          
          unless @persona.present?

            @persona = Persona.new
            @persona.nombre_persona = params[:nombres].upcase
            @persona.apellido_persona = params[:apellidos].upcase
            @persona.documento_persona = params[:ci]
            @persona.tipo_documento_id = params[:persona][:tipo_documento_id]
            @persona.nacionalidad_id = params[:persona][:nacionalidad_id]
            @persona.fecha_nacimiento = params[:piloto][:fecha_nacimiento]
            @persona.direccion = params[:direccion].upcase
            @persona.telefono = params[:telefono]
            @persona.celular = params[:telefono]
            @persona.grupo_sanguineo_id = params[:piloto][:grupo_sanguineo_id]
            #sexo por defecto no especificado
            @persona.genero_id = 3 
            if @persona.save
              @guardado_ok = true
               auditoria_nueva("registrar persona", "personas", @persona)
            end

          end
         
        end 
 
    end
  
    rescue Exception => exc  
    # dispone el mensaje de error 
    #puts "Aqui si muestra el error ".concat(exc.message)
      if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4].to_s)
      
      end                
              
  	respond_to do |f|
	    
	      f.js
	    
	   end

  end

  def editar

    @piloto = Piloto.find(params[:piloto_id])

  	respond_to do |f|
	    
	      f.js
	    
	end

  end

  def actualizar

    valido = true
    @msg = ""

    @piloto = Piloto.find(params[:piloto_id])

    auditoria_id = auditoria_antes("actualizar piloto", "pilotos", @piloto)

    if valido

      @piloto.nombres = params[:piloto][:nombres].upcase
      @piloto.apellidos = params[:piloto][:apellidos].upcase
      @piloto.ci = params[:piloto][:ci]
      @piloto.grupo_sanguineo_id = params[:piloto][:grupo_sanguineo_id]
      @piloto.fecha_nacimiento = params[:piloto][:fecha_nacimiento]
      @piloto.direccion = params[:piloto][:direccion].upcase
      @piloto.telefono = params[:piloto][:telefono]

      if @piloto.save

        auditoria_despues(@piloto, auditoria_id)
        @piloto_ok = true

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        end                

  	respond_to do |f|
	    
	      f.js
	    
	  end

  end

  def buscar_piloto
    
    @pilotos = Piloto.where("nombre ilike ?", "%#{params[:piloto]}%")

    respond_to do |f|
      
      f.html
      f.json { render :json => @personas }
    
    end
    
  end

  def buscar_persona
    
    if params[:tipo_documento_id].present? && params[:nacionalidad_id] && params[:documento].present?

      @persona = Persona.where("tipo_documento_id = ? and nacionalidad_id = ? and documento_persona = ?", params[:tipo_documento_id], params[:nacionalidad_id], params[:documento])  

    end

    respond_to do |f|
      f.json { render :json => @persona.first}
    end

  end

  def eliminar

    valido = true
    @msg = ""

    @piloto = Piloto.find(params[:piloto_id])

    @piloto_elim = @piloto  

    if valido

      if @piloto.destroy

        auditoria_nueva("eliminar piloto", "pilotos", @piloto_elim)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el piloto."

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @eliminado = false
        end
        
    respond_to do |f|

      f.js

    end

  end

  def buscar_piloto_documento
    
    if params[:documento].present?

      @piloto = Piloto.where("ci = ?", params[:documento])  

    end

    respond_to do |f|
      f.json { render :json => @piloto.first}
    end

  end

end