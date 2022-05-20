class MatriculacionesController < ApplicationController

	before_filter :require_usuario

	  def index

	  end

	  def lista

	    cond = []
	    args = []

	    if params[:form_buscar_matriculaciones_id].present?

	      cond << "matriculacion_id = ?"
	      args << params[:form_buscar_matriculaciones_id]

	    end

	    if params[:form_buscar_matriculaciones][:nivel_id].present?

	      cond << "nivel_id = ?"
	      args << params[:form_buscar_matriculaciones][:nivel_id]

	    end

	    if params[:form_buscar_matriculaciones][:sala_id].present?

	      cond << "sala_id = ?"
	      args << params[:form_buscar_matriculaciones][:sala_id]

	    end

	    if params[:form_buscar_matriculaciones][:periodo_id].present?

	      cond << "periodo_id = ?"
	      args << params[:form_buscar_matriculaciones][:periodo_id]

	    end

	    if params[:form_buscar_matriculaciones][:estado_matriculacion_id].present?

	      cond << "estado_matriculacion_id = ?"
	      args << params[:form_buscar_matriculaciones][:estado_matriculacion_id]

	    end



	    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

	    if cond.size > 0

	      @matriculaciones =  VMatriculacion.orden_niveles.where(cond).paginate(per_page: 10, page: params[:page])
	      @total_encontrados = VMatriculacion.where(cond).count

	    else

	      @matriculaciones = VMatriculacion.orden_niveles.paginate(per_page: 10, page: params[:page])
	      @total_encontrados = VMatriculacion.count

	    end

	    @total_registros = VMatriculacion.count

	    respond_to do |f|

	      f.js

	    end

	  end


	  def agregar

	    @matriculacion = Matriculacion.new

	    respond_to do |f|

	      f.js

	    end

	  end


	  def guardar

	    valido = true
	    @msg = ""

	    @matriculacion = Matriculacion.new()

	    @matriculacion.periodo_id = params[:matriculacion][:periodo_id]
	    @matriculacion.nivel_id = params[:matriculacion][:nivel_id]
	    @matriculacion.sala_id = params[:matriculacion][:sala_id]
	    @matriculacion.estado_matriculacion_id = params[:matriculacion][:estado_matriculacion_id]
	    
	      if @matriculacion.save

	        auditoria_nueva("registrar matriculacion", "matriculaciones", @matriculacion)
	       
	        @matriculacion_ok = true
	       

	      end              
	               
	    respond_to do |f|

	      f.js

	    end

	  end


	  def eliminar

	    valido = true
	    @msg = ""

	    @matriculacion = Matriculacion.find(params[:id])
		@matriculacion_elim = @matriculacion

	    if valido

	      	if @matriculacion.destroy

		        auditoria_nueva("eliminar matriculacion", "matriculaciones", @matriculacion)
		        @eliminado = true

	    	end
		end

	    respond_to do |f|

	      f.js

	    end

	  end

	  def editar

	    @matriculacion = Matriculacion.find(params[:id])

	    respond_to do |f|

	      f.js

	    end

	  end

	  def actualizar

	    valido = true
	    @msg = ""

	    @matriculacion = Matriculacion.find(params[:matriculacion][:id])
	    auditoria_id = auditoria_antes("actualizar matriculacion", "matriculaciones", @matriculacion)

	    if valido

	      
	    	@matriculacion.descripcion = params[:matriculacion][:descripcion].upcase
	    	@matriculacion.sueldo = params[:matriculacion][:sueldo].to_s.gsub(/[$.]/,'').to_i
	      	
	      	if @matriculacion.save

	      		auditoria_despues(@matriculacion, auditoria_id)
	        	@matriculacion_ok = true

	      end

	    end           
	        
	    respond_to do |f|

	      f.js

	    end

	  end

	  def matriculacion_detalle

	  	@matriculacion_detalle = VMatriculacionDetalle.orden_fecha.where('matriculacion_id = ?', params[:matriculacion_id]).paginate(per_page: 10, page: params[:page])

	  	respond_to do |f|

	      f.js

	    end

	  end

	  def agregar_matriculacion_detalle

	    @matriculacion_detalle = MatriculacionDetalle.new

	    respond_to do |f|

	      f.js

	    end

	  end

	  def guardar_matriculacion_detalle

	    valido = true
	    @msg = ""
	    @matriculacion_detalle = MatriculacionDetalle.where('matriculacion_id = ? and alumno_id = ? ', params[:matriculacion_id],params[:alumno_id]).first
	    if @matriculacion_detalle.present?
	    	valido = false
	    	@msg = 'El alumno ya se encuentra matriculado.'
	    end

	    if valido

		    @matriculacion_detalle = MatriculacionDetalle.new()
		    @matriculacion_detalle.matriculacion_id = params[:matriculacion_id]
		    @matriculacion_detalle.alumno_id = params[:alumno_id]
		    @matriculacion_detalle.precio_id = params[:matriculacion_detalle][:precio_id]
		    @matriculacion_detalle.fecha_matriculacion = params[:fecha_matriculacion]
		    @matriculacion_detalle.estado_matriculacion_detalle_id = PARAMETRO[:estado_matriculacion_detalle_activo]
		    
		      if @matriculacion_detalle.save

		        auditoria_nueva("registrar matriculacion detalle", "matriculaciones_detalles", @matriculacion_detalle)
		       
		        @matriculacion_ok = true
		       

		      end              
	    end

	    respond_to do |f|

	      f.js

	    end

	  end

	def eliminar_matriculacion_detalle

    @valido = true
    @msg = ""

    @matriculacion_detalle = MatriculacionDetalle.find(params[:matriculacion_detalle_id])
    @matriculacion_detalle_elim = @matriculacion_detalle

    if @valido

      if @matriculacion_detalle.destroy

        auditoria_nueva("eliminar matriculacion detalle", "matriculaciones_detalles", @matriculacion_detalle)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar esta matriculación"

      end

    end

        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
           
          @msg = 'Esta matriculación ya cuenta con detalles'
          @eliminado = false
        
        end
        
    respond_to do |f|

      f.js

    end
  
end
	    

end