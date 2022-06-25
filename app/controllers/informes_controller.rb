class InformesController < ApplicationController

	before_filter :require_usuario

  def indexa

  	cond = []
    args = []

  	@informe = "informes"
  	@msg = "" 
    
    if params[:v_alumno_id].present?

      cond << "alumno_id = ?"
      args << params[:v_alumno_id]

    end

    if params[:sucursal][:id].present?

      cond << "sucursal_id = ?"
      args << params[:sucursal][:id]

    end

    if params[:nivel][:id].present?

      cond << "nivel_id = ?"
      args << params[:nivel][:id]

    end

    if params[:periodo_escolar][:id].present?

      cond << "periodo_escolar_id = ?"
      args << params[:periodo_escolar][:id]

    end

    if params[:mes_periodo][:id].present?

      cond << "mes_periodo_id = ?"
      args << params[:mes_periodo][:id]

    end

    if params[:estado_pago_cuota_detalle][:id].present?

      cond << "estado_pago_cuota_detalle_id = ?"
      args << params[:estado_pago_cuota_detalle][:id]

    end

    if params[:fecha_desde].present? && params[:fecha_hasta].present? 

      cond << "fecha_cita >= '#{params[:fecha_desde]}' and fecha_cita <= '#{params[:fecha_hasta]}'" 

    elsif params[:fecha_desde].present?
      
      cond << "fecha_cita >= ?"
      args << params[:fecha_desde]

    elsif params[:fecha_hasta].present?
      
      cond << "fecha_cita <= ?"
      args << params[:fecha_hasta]

    end


    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0
     
      @cuota_detalle =  VCuotaDetalle.where(cond).orden_01.paginate(per_page: 10, page: params[:page])

    else

      @cuota_detalle = VCuotaDetalle.orden_01.paginate(per_page: 10, page: params[:page])

    end

    @parametros = { format: :pdf, pago_cuota_detalle_id: @cuota_detalle.map(&:cuota_detalle_id), alumno_id: params[:v_alumno_id], sucursal_id: params[:sucursal][:id], nivel_id: params[:nivel][:id], periodo_escolar_id: params[:periodo_escolar][:id], mes_periodo_id: params[:mes_periodo][:id], estado_pago_cuota_detalle_id: params[:estado_pago_cuota_detalle][:id], fecha_desde: params[:fecha_desde], fecha_hasta: params[:fecha_hasta] }

    respond_to do |f|

      f.js

    end

  end

  def generar_pdf
    
    
   @cita =  VCuotaDetalle.where("cita_id in (?)", params[:cita_id]).orden_01.paginate(per_page: 10, page: params[:page])
    

    respond_to do |f|
     
      f.pdf do

          render  :pdf => "planilla_resumen_cita_#{Time.now.strftime("%Y_%m_%d__%H_%M")}",
                  :template => 'informes/planilla_reporte_cita.pdf.erb',
                  :layout => 'pdf.html',
                  :header => {:html => { :template => "informes/cabecera_planilla_resumen_cita.pdf.erb" ,
                  :locals   => { :cita => @cita }}},
                  :margin => {:top => 65,                         # default 10 (mm)
                  :bottom => 11,
                  :left => 3,
                  :right => 3},
                  :orientation => 'Landscape',
                  :page_size => "A4",
                  :footer => { :html => {:template => 'layouts/footer.pdf' },
                  :spacing => 1,
                  :line => true }
      end
      
    end

  end

end


