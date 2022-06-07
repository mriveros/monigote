module CuotasHelper

	def link_to_cuota_detalle(cuota_id)

      render partial: 'link_to_cuota_detalle', locals: { cuota_id: cuota_id }
      
  	end

end