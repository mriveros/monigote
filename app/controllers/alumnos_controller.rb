class AlumnosController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index
   
  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_alumnos_id].present?

      cond << "alumno_id = ?"
      args << params[:form_buscar_alumnos_id]

    end

    if params[:form_buscar_alumnos_nombre].present?

      cond << "nombres ilike ?"
      args << "%#{params[:form_buscar_alumnos_nombre]}%"

    end

    if params[:form_buscar_alumnos_apellido].present?

      cond << "apellidos ilike ?"
      args << "%#{params[:form_buscar_alumnos_apellido]}%"

    end

    if params[:form_buscar_alumnos_ci].present?

      cond << "ci = ?"
      args << params[:form_buscar_alumnos_ci]

    end

    if params[:form_buscar_alumnos_fecha_nacimiento].present?

      cond << "fecha_nacimiento = ?"
      args << params[:form_buscar_alumnos_fecha_nacimiento]

    end

    if params[:form_buscar_alumnos_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_alumnos_direccion]}%"

    end

    if params[:form_buscar_alumnos_telefono].present?

      cond << "telefono ilike ?"
      args << "%#{params[:form_buscar_alumnos_telefono]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @alumnos =  VAlumno.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VAlumno.where(cond).count
      
    else

      @alumnos = VAlumno.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VAlumno.count

    end

    @total_registros = VAlumno.count

  	respond_to do |f|
	    
	   f.js
	    
	  end

  end

  def agregar

    @alumno = Alumno.new

    respond_to do |f|
	    
	      f.js
	    
	  end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false
    

    if @valido
      
      @alumno = Alumno.new()
      @alumno.nombres = params[:nombres].upcase
      @alumno.apellidos = params[:apellidos].upcase
      @alumno.ci = params[:ci]
      @alumno.fecha_nacimiento = params[:alumno][:fecha_nacimiento]
      @alumno.direccion = params[:direccion].upcase
      @alumno.telefono = params[:telefono]
      

        if @alumno.save

          auditoria_nueva("registrar alumno", "alumnos", @alumno)
          @guardado_ok = true
          @persona = Persona.where('documento_persona = ?', params[:ci]).first
          
          unless @persona.present?

            @persona = Persona.new
            @persona.nombre_persona = params[:nombres].upcase
            @persona.apellido_persona = params[:apellidos].upcase
            @persona.documento_persona = params[:ci]
            @persona.tipo_documento_id = params[:persona][:tipo_documento_id]
            @persona.nacionalidad_id = params[:persona][:nacionalidad_id]
            @persona.fecha_nacimiento = params[:alumno][:fecha_nacimiento]
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

    @alumno = Alumno.find(params[:alumno_id])

  	respond_to do |f|
	    
	      f.js
	    
	end

  end

  def actualizar

    valido = true
    @msg = ""

    @alumno = Alumno.find(params[:alumno_id])

    auditoria_id = auditoria_antes("actualizar alumno", "alumnos", @alumno)

    if valido

      @alumno.nombres = params[:alumno][:nombres].upcase
      @alumno.apellidos = params[:alumno][:apellidos].upcase
      @alumno.ci = params[:alumno][:ci]
      @alumno.fecha_nacimiento = params[:alumno][:fecha_nacimiento]
      @alumno.direccion = params[:alumno][:direccion].upcase
      @alumno.telefono = params[:alumno][:telefono]

      if @alumno.save

        auditoria_despues(@alumno, auditoria_id)
        @alumno_ok = true

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

  def buscar_alumno
    
    @alumnos = Alumno.where("nombre ilike ?", "%#{params[:alumno]}%")

    respond_to do |f|
      
      f.html
      f.json { render :json => @alumnos }
    
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

    @alumno = Alumno.find(params[:alumno_id])

    @alumno_elim = @alumno  

    if valido

      if @alumno.destroy

        auditoria_nueva("eliminar alumno", "alumnos", @alumno_elim)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el alumno."

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

  def buscar_alumno_documento
    
    if params[:documento].present?

      @alumno = Alumno.where("ci = ?", params[:documento])  

    end

    respond_to do |f|
      f.json { render :json => @alumno.first}
    end

  end

end