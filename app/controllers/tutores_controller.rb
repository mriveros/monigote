class TutoresController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index
   
  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_tutores_id].present?

      cond << "tutor_id = ?"
      args << params[:form_buscar_tutores_id]

    end

    if params[:form_buscar_tutores_nombre].present?

      cond << "nombres ilike ?"
      args << "%#{params[:form_buscar_tutores_nombre]}%"

    end

    if params[:form_buscar_tutores_apellido].present?

      cond << "apellidos ilike ?"
      args << "%#{params[:form_buscar_tutores_apellido]}%"

    end

    if params[:form_buscar_tutores_ci].present?

      cond << "ci = ?"
      args << params[:form_buscar_tutores_ci]

    end

    if params[:form_buscar_tutores_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_tutores_direccion]}%"

    end

    if params[:form_buscar_tutores_telefono].present?

      cond << "telefono ilike ?"
      args << "%#{params[:form_buscar_tutores_telefono]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @tutores =  VTutor.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VTutor.where(cond).count
      
    else

      @tutores = VTutor.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VTutor.count

    end

    @total_registros = VTutor.count

    respond_to do |f|
      
     f.js
      
    end

  end

  def agregar

    @tutor = Tutor.new

    respond_to do |f|
      
        f.js
      
    end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false
    

    if @valido
      
      @tutor = Tutor.new()
      @tutor.nombres = params[:nombres].upcase
      @tutor.apellidos = params[:apellidos].upcase
      @tutor.ci = params[:ci]
      @tutor.direccion = params[:direccion].upcase
      @tutor.telefono = params[:telefono]
      

        if @tutor.save

          auditoria_nueva("registrar tutor", "tutores", @tutor)
          @guardado_ok = true
          @persona = Persona.where('documento_persona = ?', params[:ci]).first
          
          unless @persona.present?

            @persona = Persona.new
            @persona.nombre_persona = params[:nombres].upcase
            @persona.apellido_persona = params[:apellidos].upcase
            @persona.documento_persona = params[:ci]
            @persona.tipo_documento_id = params[:persona][:tipo_documento_id]
            @persona.nacionalidad_id = params[:persona][:nacionalidad_id]
            @persona.fecha_nacimiento = params[:tutor][:fecha_nacimiento]
            @persona.direccion = params[:direccion].upcase
            @persona.telefono = params[:telefono]
            @persona.celular = params[:telefono]
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
        @msg = @excep.to_s
      end                
              
    respond_to do |f|
      
        f.js
      
     end

  end

  def editar

    @tutor = Tutor.find(params[:tutor_id])

    respond_to do |f|
      
        f.js
      
  end

  end

  def actualizar

    valido = true
    @msg = ""

    @tutor = Tutor.find(params[:tutor_id])

    auditoria_id = auditoria_antes("actualizar tutor", "tutores", @tutor)

    if valido

      @tutor.nombres = params[:tutor][:nombres].upcase
      @tutor.apellidos = params[:tutor][:apellidos].upcase
      @tutor.ci = params[:tutor][:ci]
      @tutor.fecha_nacimiento = params[:tutor][:fecha_nacimiento]
      @tutor.direccion = params[:tutor][:direccion].upcase
      @tutor.telefono = params[:tutor][:telefono]

      if @tutor.save

        auditoria_despues(@tutor, auditoria_id)
        @tutor_ok = true

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3]
        end                

    respond_to do |f|
      
        f.js
      
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


  def buscar_tutor
    
    @tutores = Tutor.where("nombre ilike ?", "%#{params[:tutor]}%")

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

    @tutor = Tutor.find(params[:tutor_id])

    @tutor_elim = @tutor  

    if valido

      if @tutor.destroy

        auditoria_nueva("eliminar tutor", "tutores", @tutor_elim)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el tutor."

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

  def buscar_tutor_documento
    
    if params[:documento].present?

      @tutor = tutor.where("ci = ?", params[:documento])  

    end

    respond_to do |f|
      f.json { render :json => @tutor.first}
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


  def tutor_detalle
    
    @tutor_detalle = VTutorDetalle.where("tutor_id = ?", params[:tutor_id])


     respond_to do |f|

      f.js

    end
  
  end


  def agregar_tutor_detalle
    
    @tutor_detalle = TutorDetalle.new

   respond_to do |f|

      f.js

    end
  
  end


   def guardar_tutor_detalle
    
    @valido = true
    @msg = ""
    @guardado_ok = false

    unless params[:persona_documento].present?

      @valido = false
      @msg += " Debe Completar el campo Documento. \n"

    end

    unless params[:persona_nombre].present?

      @valido = false
      @msg += " El nombre del Paciente no puede estar vacío. \n"

    end

    unless params[:parentezco][:id].present?

      @valido = false
      @msg += " El apellido del Paciente no puede estar vacío. \n"

    end

    if @valido
      
      @tutor_Detalle = TutorDetalle.new()
      @tutor_Detalle.tutor_id = params[:tutor_id]
      @tutor_Detalle.paciente_id = params[:paciente_id]
      @tutor_Detalle.parentezco_id = params[:parentezco][:id]

        if @tutor_Detalle.save

          auditoria_nueva("registrar paciente asignado a tutor", "tutores_detalles", @tutor_Detalle)
          @guardado_ok = true
         
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

  def eliminar_tutor_detalle

    @valido = true
    @msg = ""

    @tutor_detalle = TutorDetalle.find(params[:tutor_detalle_id])

    if @valido

      if @tutor_detalle.destroy

        auditoria_nueva("eliminar tutor detalle", "tutores_detalles", @tutor_detalle)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el detalle del Tutor. Intente más tarde."

      end

    end

        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
          
          @excep = exc.message.split(':')    
          @msg = @excep
          @eliminado = false
        
        end
        
    respond_to do |f|

      f.js

    end
  
  end



end