module CuotasHelper

	def link_to_cuota_detalle(cuota_id)

      render partial: 'link_to_cuota_detalle', locals: { cuota_id: cuota_id }
      
  	end

  	def link_to_pago_cuota_detalle(cuota_detalle_id)

      render partial: 'link_to_pago_cuota_detalle', locals: { cuota_detalle_id: cuota_detalle_id }
      
  	end

    def link_to_notificar_cuota_detalle_pendiente(cuota_detalle_id)

      render partial: 'link_to_notificar_cuota_detalle_pendiente', locals: { cuota_detalle_id: cuota_detalle_id }
      
    end

end