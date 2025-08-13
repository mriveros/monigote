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

    if params[:form_buscar_alumnos_telefono_contacto].present?

      cond << "telefono_contacto ilike ?"
      args << "%#{params[:form_buscar_alumnos_telefono_contacto]}%"

    end

    if params[:form_buscar_alumnos_email_contacto].present?

      cond << "email_contacto ilike ?"
      args << "%#{params[:form_buscar_alumnos_email_contacto]}%"

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
      @alumno.nacionalidad_id = params[:alumno][:nacionalidad_id]
      @alumno.tipo_documento_id = params[:alumno][:tipo_documento_id]
      @alumno.nombres = params[:nombres].upcase
      @alumno.apellidos = params[:apellidos].upcase
      @alumno.ci = params[:ci]
      @alumno.fecha_nacimiento = params[:alumno][:fecha_nacimiento]
      @alumno.direccion = params[:direccion].upcase
      @alumno.telefono = params[:telefono]
      @alumno.email = params[:email]
      if params[:alumno][:photo].present?
        @alumno.photo = params[:alumno][:photo]
      end

        if @alumno.save

          auditoria_nueva("registrar alumno", "alumnos", @alumno)
          @guardado_ok = true

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
      @alumno.nacionalidad_id = params[:alumno][:nacionalidad_id]
      @alumno.tipo_documento_id = params[:alumno][:tipo_documento_id]
      @alumno.nombres = params[:alumno][:nombres].upcase
      @alumno.apellidos = params[:alumno][:apellidos].upcase
      @alumno.ci = params[:alumno][:ci]
      @alumno.fecha_nacimiento = params[:alumno][:fecha_nacimiento]
      @alumno.direccion = params[:alumno][:direccion].upcase
      @alumno.telefono = params[:alumno][:telefono]
      @alumno.email = params[:alumno][:email]
      if params[:alumno][:photo].present?
        @alumno.photo = params[:alumno][:photo]
      end


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
    
    @alumnos = Alumno.where("nombres ilike ?", "%#{params[:alumno]}%")

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


  def alumno_detalle

    @alumno_detalle = AlumnoDetalle.where('alumno_id = ?', params[:alumno_id]).first

    unless @alumno_detalle.present?
    
      @alumno_detalle = AlumnoDetalle.new()
    
    end

    respond_to do |f|

      f.js

    end

  end

  def guardar_alumno_detalle

    @guardado_ok =  false

    @alumno_detalle = AlumnoDetalle.where('alumno_id = ?', params[:alumno_id]).first
    
    unless @alumno_detalle.present?
    
      @alumno_detalle = AlumnoDetalle.new()
      
    end
    
    @alumno_detalle.alumno_id = params[:alumno_id]
    @alumno_detalle.antecedentes_personales = params[:alumno_detalle][:antecedentes_personales]
    @alumno_detalle.antecedentes_familiares = params[:alumno_detalle][:antecedentes_familiares]
    @alumno_detalle.antecedentes_otros = params[:alumno_detalle][:antecedentes_otros]
    @alumno_detalle.transtornos = params[:alumno_detalle][:transtornos]
    
    if params[:alumno_detalle][:transtornos].to_i == 1
      @alumno_detalle.transtorno_especificar = params[:alumno_detalle][:transtorno_especificar]
    else
      @alumno_detalle.transtorno_especificar = ''
    end

    @alumno_detalle.enfermedad = params[:alumno_detalle][:enfermedad]
    if params[:alumno_detalle][:enfermedad].to_i == 1
      @alumno_detalle.enfermedad_especificar = params[:alumno_detalle][:enfermedad_especificar]
    else
      @alumno_detalle.enfermedad_especificar = ''
    end
    @alumno_detalle.medicamento = params[:alumno_detalle][:medicamento]
    @alumno_detalle.medicamento_especificar = params[:alumno_detalle][:medicamento_especificar]
    @alumno_detalle.observacion = params[:alumno_detalle][:observacion]
    if @alumno_detalle.save
      
      @guardado_ok =  true

    end

    respond_to do |f|

      f.js

    end

  end

  def alumno_informe

    alumno = Alumno.where('id = ?', params["alumno_id"]).first
    if alumno.present?
    
      @alumno_informe = AlumnoInforme.where('numero_documento = ?', alumno.ci).paginate(per_page: 10, page: params[:page])
    
    end
    respond_to do |f|

      f.js

    end

  end

end