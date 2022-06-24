class InformesController < ApplicationController

	before_filter :require_usuario

  def indexa

  	cond = []
    args = []

  	@informe = "informes"
  	@msg = "" 
    
    if params[:alumno_id].present?

      cond << "alumno_id = ?"
      args << params[:alumno_id]

    end

    if params[:sucursal_id].present?

      cond << "sucursal_id = ?"
      args << params[:sucursal_id]

    end

    if params[:periodo_escolar][:id].present?

      cond << "periodo_escolar_id = ?"
      args << params[:periodo_escolar][:id]

    end

    if params[:mes_periodo][:id].present?

      cond << "mes_periodo_id = ?"
      args << params[:mes_periodo][:id]

    end

    if params[:estado_cobro][:id].present?

      cond << "estado_cobro_id = ?"
      args << params[:estado_cobro][:id]

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
     
      @cita =  VCita.where(cond).orden_01.paginate(per_page: 10, page: params[:page])

    else

      @cita = VCita.orden_01.paginate(per_page: 10, page: params[:page])

    end

    @parametros = { format: :pdf, cita_id: @cita.map(&:cita_id), paciente_id: params[:paciente_id], profesional_id: params[:profesional_id], tipo_consulta_id: params[:tipo_consulta][:id], estado_cita_id: params[:estado_cita][:id], estado_cobro_id: params[:estado_cobro][:id], fecha_desde: params[:fecha_desde], fecha_hasta: params[:fecha_hasta] }

    respond_to do |f|

      f.js

    end

  end

  def generar_pdf
    
    
   @cita =  VCita.where("cita_id in (?)", params[:cita_id]).orden_01.paginate(per_page: 10, page: params[:page])
    

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


