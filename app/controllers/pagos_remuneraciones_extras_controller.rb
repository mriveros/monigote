class PagosRemuneracionesExtrasController < ApplicationController

	before_filter :require_usuario

	  def index


	  end 

	  def lista

	    cond = []
	    args = []

	    if params[:form_buscar_pagos_remuneraciones_extras_id].present?

	      cond << "pago_remuneracion_extra_id = ?"
	      args << params[:form_buscar_pagos_remuneraciones_extras_id]

	    end

	    if params[:form_buscar_pagos_remuneraciones_extras_fecha].present?

	      cond << "fecha = ?"
	      args << params[:form_buscar_pagos_remuneraciones_extras_fecha]

	    end

	    if params[:form_buscar_pagos_remuneraciones_extras_nombre_personal].present?

	      cond << "personal_nombre ilike ?"
	      args << "%#{params[:form_buscar_pagos_remuneraciones_extras_nombre_personal]}%"

	    end

	    if params[:form_buscar_pagos_remuneraciones_extras_apellido_personal].present?

	      cond << "personal_apellido ilike ?"
	      args << "%#{params[:form_buscar_pagos_remuneraciones_extras_apellido_personal]}%"
 
	    end

	    if params[:form_buscar_pagos_remuneraciones_extras][:mes_periodo_id].present?

      		cond << "mes_periodo_id = ?"
      		args << params[:form_buscar_pagos_remuneraciones_extras][:mes_periodo_id]

    	end

    	if params[:form_buscar_pagos_remuneraciones_extras_periodo_escolar_id].present?

	      cond << "periodo_escolar_id = ?"
	      args << params[:form_buscar_pagos_remuneraciones_extras_periodo_escolar_id]

	    end
	    
	    if params[:form_buscar_pagos_remuneraciones_extras_monto].present?

	      cond << "monto = ?"
	      args << params[:form_buscar_pagos_remuneraciones_extras_monto]

	    end

	    if params[:form_buscar_pagos_remuneraciones_extras_observacion].present?

	      cond << "observacion ilike ?"
	      args << "%#{params[:form_buscar_pagos_remuneraciones_extras_observacion]}%"

	    end
	    

	    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

	    if cond.size > 0

	      @pagos_remuneraciones_extras =  VPagoRemuneracionExtra.orden_fecha_desc.where(cond).paginate(per_page: 10, page: params[:page])
	      @total_encontrados = VPagoRemuneracionExtra.where(cond).count

	    else

	      @pagos_remuneraciones_extras = VPagoRemuneracionExtra.orden_fecha_desc.paginate(per_page: 10, page: params[:page])
	      @total_encontrados = PagoRemuneracionExtra.count

	    end

	    @total_registros = RegistroGasto.count

	    respond_to do |f|

	      f.js

	    end

	  end

	  def agregar

	    @pago_remuneracion_extra = PagoRemuneracionExtra.new

	    respond_to do |f|
	      f.js
	    end

	  end

	  def guardar

	    @valido = true
	    @msg = ""
	    
	    if @valido

		    @pago_remuneracion_extra = PagoRemuneracionExtra.new()
		    @pago_remuneracion_extra.fecha = params[:fecha]
		    @pago_remuneracion_extra.personal_id = params[:personal][:id]
		    @pago_remuneracion_extra.mes_periodo_id = params[:mes_periodo][:id]
		    @pago_remuneracion_extra.periodo_escolar_id = params[:periodo_escolar][:id]
		    @pago_remuneracion_extra.monto = params[:monto].to_s.gsub(/[$.]/,'').to_i
		    @pago_remuneracion_extra.observacion = params[:observacion]
 
		    if @pago_remuneracion_extra.save

		    	auditoria_nueva("Registrar nuevo RemuneracionExtra", "pagos_remuneraciones_extras", @pago_remuneracion_extra)
		        @guardado_ok = true
		       	@pago_salario = PagoSalario.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:mes_periodo][:id],params[:periodo_escolar_id]).first
		        
		        if @pago_salario.present?

		        	@total_adelantos = PagoAdelanto.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:mes_periodo][:id], params[:periodo_escolar_id]).sum(:monto)
				    @total_descuentos = PagoDescuento.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:mes_periodo][:id], params[:periodo_escolar_id]).sum(:monto)
				    @total_remuneraciones_extras = PagoRemuneracionExtra.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:mes_periodo][:id], params[:periodo_escolar_id]).sum(:monto)
					
					@pago_salario_detalle = PagoSalarioDetalle.where("pago_salario_id = ?", @pago_salario.id)
					@pago_salario_detalle.each do |psd|

						@personal_salario = VPersonal.where("personal_id = ?", psd.personal_id).first
			            @personal_total_adelantos = PagoAdelanto.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?",psd.personal_id, params[:mes_periodo][:id],params[:periodo_escolar_id]).sum(:monto).to_i
			            @personal_total_descuentos = PagoDescuento.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?", psd.personal_id, params[:mes_periodo][:id],params[:periodo_escolar_id]).sum(:monto).to_i
			            @personal_total_remuneracion_extra = PagoRemuneracionExtra.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?", psd.personal_id, params[:mes_periodo][:id],params[:periodo_escolar_id]).sum(:monto).to_i
			            @personal_sueldo_percibido = (@personal_salario.sueldo.to_i + @personal_total_remuneracion_extra) - (@personal_total_adelantos + @personal_total_descuentos)
			            @acumulacion_sueldo_percibido = @acumulacion_sueldo_percibido.to_i + @personal_sueldo_percibido.to_i

			            psd.adelantos = @personal_total_adelantos
              			psd.descuentos = @personal_total_descuentos
              			psd.otras_remuneraciones = @personal_total_remuneracion_extra
              			psd.salario_percibido = @personal_sueldo_percibido

              			if psd.save

              			end

					end

					@pago_salario.monto_total_pagado = @acumulacion_sueldo_percibido
					
					if @pago_salario.save

			           @guardado_ok = true

			        end

		        end

		    end 

		 end
	         
	    respond_to do |f|

	      f.js

	    end

	  end

	  def eliminar

	    @valido = true
	    @msg = ""
	    @eliminado =false

	    @pago_remuneracion_extra = PagoRemuneracionExtra.find(params[:id])
	    @pago_remuneracion_extra_elim = @pago_remuneracion_extra

	    if @valido

	      if @pago_remuneracion_extra.destroy

	        auditoria_nueva("Eliminar registro de RemuneracionExtra", "pagos_remuneraciones_extras", @pago_remuneracion_extra_elim)
	        @eliminado = true
	        @pago_salario = PagoSalario.where("mes_periodo_id = ? and periodo_escolar_id = ?", @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).first
		        
		    if @pago_salario.present?

		        @total_adelantos = PagoAdelanto.where("mes_periodo_id = ? and periodo_escolar_id = ?", @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).sum(:monto)
				@total_descuentos = PagoDescuento.where("mes_periodo_id = ? and periodo_escolar_id = ?", @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).sum(:monto)
				@total_remuneraciones_extras = PagoRemuneracionExtra.where("mes_periodo_id = ? and periodo_escolar_id = ?", @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).sum(:monto)
					
				@pago_salario_detalle = PagoSalarioDetalle.where("pago_salario_id = ?", @pago_salario.id)
				@pago_salario_detalle.each do |psd|

					@personal_salario = VPersonal.where("personal_id = ?", psd.personal_id).first
			        @personal_total_adelantos = PagoAdelanto.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?",psd.personal_id, @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).sum(:monto).to_i
			        @personal_total_descuentos = PagoDescuento.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?", psd.personal_id, @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).sum(:monto).to_i
			        @personal_total_remuneracion_extra = PagoRemuneracionExtra.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?", psd.personal_id, @pago_remuneracion_extra_elim.mes_periodo_id, @pago_remuneracion_extra_elim.periodo_escolar_id).sum(:monto).to_i
			        @personal_sueldo_percibido = (@personal_salario.sueldo.to_i + @personal_total_remuneracion_extra) - (@personal_total_adelantos + @personal_total_descuentos)
			        @acumulacion_sueldo_percibido = @acumulacion_sueldo_percibido.to_i + @personal_sueldo_percibido.to_i

			        psd.adelantos = @personal_total_adelantos
              		psd.descuentos = @personal_total_descuentos
              		psd.otras_remuneraciones = @personal_total_remuneracion_extra
              		psd.salario_percibido = @personal_sueldo_percibido

              		if psd.save

              		end

				end

				@pago_salario.monto_total_pagado = @acumulacion_sueldo_percibido
					
				if @pago_salario.save

			        @guardado_ok = true

			    end

		    end
		    
	      end

	    end
	        
	    respond_to do |f|

	      f.js

	    end

	  end

	  def editar

	    @pago_remuneracion_extra = PagoRemuneracionExtra.find(params[:id])

	    respond_to do |f|

	      f.js

	    end

	  end

	  def actualizar

	    valido = true
	    @msg = ""

	    @pago_remuneracion_extra = PagoRemuneracionExtra.find(params[:pago_remuneracion_extra_id])
	    auditoria_id = auditoria_antes("actualizar pago_remuneracion_extra", "pagos_remuneraciones_extras", @pago_remuneracion_extra)

	    if valido

	    	
		    @pago_remuneracion_extra.fecha = params[:pago_remuneracion_extra][:fecha]
		    @pago_remuneracion_extra.personal_id = params[:pago_remuneracion_extra][:personal_id]
		    @pago_remuneracion_extra.mes_periodo_id = params[:pago_remuneracion_extra][:mes_periodo_id]
		    @pago_remuneracion_extra.periodo_escolar_id = params[:pago_remuneracion_extra][:periodo_escolar_id]
		    @pago_remuneracion_extra.monto = params[:pago_remuneracion_extra][:monto].to_s.gsub(/[$.]/,'').to_i
		    @pago_remuneracion_extra.observacion = params[:pago_remuneracion_extra][:observacion]

		    if @pago_remuneracion_extra.save

		    	auditoria_nueva("Registrar nuevo Remuneracion Extra", "pagos_remuneraciones_extras", @pago_remuneracion_extra)
		        @actualizado_ok = true
		       	@pago_salario = PagoSalario.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).first
		        
		        if @pago_salario.present?

		        	@total_adelantos = PagoAdelanto.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).sum(:monto)
				    @total_descuentos = PagoDescuento.where("mes_periodo_id = ? and periodo_escolar_id = ?", params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).sum(:monto)
				    @total_remuneraciones_extras = PagoRemuneracionExtra.where("mes_periodo_id = ? and periodo_escolar_id = ?",params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).sum(:monto)
					
					@pago_salario_detalle = PagoSalarioDetalle.where("pago_salario_id = ?", @pago_salario.id)
					@pago_salario_detalle.each do |psd|

						@personal_salario = VPersonal.where("personal_id = ?", psd.personal_id).first
			            @personal_total_adelantos = PagoAdelanto.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?",psd.personal_id, params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).sum(:monto).to_i
			            @personal_total_descuentos = PagoDescuento.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?", psd.personal_id, params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).sum(:monto).to_i
			            @personal_total_remuneracion_extra = PagoRemuneracionExtra.where("personal_id = ? and mes_periodo_id = ? and periodo_escolar_id = ?", psd.personal_id, params[:pago_remuneracion_extra][:mes_periodo_id], params[:pago_remuneracion_extra][:periodo_escolar_id]).sum(:monto).to_i
			            @personal_sueldo_percibido = (@personal_salario.sueldo.to_i + @personal_total_remuneracion_extra) - (@personal_total_adelantos + @personal_total_descuentos)
			            @acumulacion_sueldo_percibido = @acumulacion_sueldo_percibido.to_i + @personal_sueldo_percibido.to_i

			            psd.adelantos = @personal_total_adelantos
              			psd.descuentos = @personal_total_descuentos
              			psd.otras_remuneraciones = @personal_total_remuneracion_extra
              			psd.salario_percibido = @personal_sueldo_percibido

              			if psd.save

              			end

					end

					@pago_salario.monto_total_pagado = @acumulacion_sueldo_percibido
					
					if @pago_salario.save

			           @guardado_ok = true

			        end

		        end
		        
		    end 

		 end
	         
	    respond_to do |f|

	      f.js

	    end

	  end
	    

end