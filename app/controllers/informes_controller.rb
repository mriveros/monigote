class InformesController < ApplicationController

  #before_filter :require_usuario

  def index
  end

  def index_gastos
    @fecha_desde = parsear_fecha(params[:fecha_desde])
    @fecha_hasta = parsear_fecha(params[:fecha_hasta])

    unless @fecha_desde.present? && @fecha_hasta.present?
      render :index
      return
    end

    @registros_gastos = VRegistroGasto.where("fecha >= ? AND fecha <= ?", @fecha_desde, @fecha_hasta).orden_fecha_desc
    @total_monto = @registros_gastos.sum(:monto)

    respond_to do |f|
      f.html { render_reporte_gastos_pdf }
      f.pdf { render_reporte_gastos_pdf }
    end
  end

  def index_balance
    @fecha_desde = parsear_fecha(params[:fecha_desde])
    @fecha_hasta = parsear_fecha(params[:fecha_hasta])

    unless @fecha_desde.present? && @fecha_hasta.present?
      render :index
      return
    end

    @ingresos = VCuotaDetalle.where("estado_pago_cuota_detalle_id = ? AND fecha_pago >= ? AND fecha_pago <= ?",
                                    PARAMETRO[:estado_pago_cuota_detalle_pagado],
                                    @fecha_desde, @fecha_hasta).order("fecha_pago DESC")

    @egresos = VRegistroGasto.where("fecha >= ? AND fecha <= ?", @fecha_desde, @fecha_hasta).orden_fecha_desc

    @total_ingresos = @ingresos.sum(:pago_cuota)
    @total_egresos = @egresos.sum(:monto)
    @saldo = @total_ingresos - @total_egresos

    respond_to do |f|
      f.html { render_reporte_balance_pdf }
      f.pdf { render_reporte_balance_pdf }
    end
  end

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

      cond << "fecha_generacion >= '#{params[:fecha_desde]}' and fecha_generacion <= '#{params[:fecha_hasta]}'" 

    elsif params[:fecha_desde].present?
      
      cond << "fecha_generacion >= ?"
      args << params[:fecha_desde]

    elsif params[:fecha_hasta].present?
      
      cond << "fecha_generacion <= ?"
      args << params[:fecha_hasta]

    end


    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0
     
      @cuota_detalle =  VCuotaDetalle.where(cond).orden_01.paginate(per_page: 10, page: params[:page])

    else

      @cuota_detalle = VCuotaDetalle.orden_01.paginate(per_page: 10, page: params[:page])

    end

    @parametros = { format: :pdf, cuota_detalle_id: @cuota_detalle.map(&:cuota_detalle_id), alumno_id: params[:v_alumno_id], sucursal_id: params[:sucursal][:id], nivel_id: params[:nivel][:id], periodo_escolar_id: params[:periodo_escolar][:id], mes_periodo_id: params[:mes_periodo][:id], estado_pago_cuota_detalle_id: params[:estado_pago_cuota_detalle][:id], fecha_desde: params[:fecha_desde], fecha_hasta: params[:fecha_hasta] }

    respond_to do |f|

      f.js

    end

  end

  def generar_pdf
    
    
   @cuota_detalle =  VCuotaDetalle.where("cuota_detalle_id in (?)", params[:cuota_detalle_id]).orden_01.paginate(per_page: 10, page: params[:page])
    

    respond_to do |f|
     
      f.pdf do

          render  :pdf => "planilla_resumen_cuotas_#{Time.now.strftime("%Y_%m_%d__%H_%M")}",
                  :template => 'informes/planilla_reporte_cuotas.pdf.erb',
                  :layout => 'pdf.html',
                  :header => {:html => { :template => "informes/cabecera_planilla_resumen_cuotas.pdf.erb" ,
                  :locals   => { :cuota => @cuota_detalle }}},
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

  private

  def parsear_fecha(valor)
    return nil unless valor.present?

    begin
      Date.parse(valor)
    rescue
      nil
    end
  end

  def render_reporte_gastos_pdf
    render :pdf => "reporte_gastos_#{Time.now.strftime("%Y_%m_%d__%H_%M")}",
           :template => 'informes/planilla_reporte_gastos.pdf.erb',
           :layout => 'pdf.html',
           :header => {:html => { :template => 'informes/cabecera_planilla_resumen_gastos.pdf.erb' }},
           :margin => {:top => 50,
           :bottom => 11,
           :left => 8,
           :right => 8},
           :orientation => 'Portrait',
           :page_size => 'A4',
           :footer => { :html => {:template => 'layouts/footer.pdf' },
           :spacing => 1,
           :line => true }
  end

  def render_reporte_balance_pdf
    render :pdf => "reporte_balance_#{Time.now.strftime("%Y_%m_%d__%H_%M")}",
           :template => 'informes/planilla_reporte_balance.pdf.erb',
           :layout => 'pdf.html',
           :header => {:html => { :template => 'informes/cabecera_planilla_resumen_balance.pdf.erb' }},
           :margin => {:top => 55,
           :bottom => 11,
           :left => 8,
           :right => 8},
           :orientation => 'Portrait',
           :page_size => 'A4',
           :footer => { :html => {:template => 'layouts/footer.pdf' },
           :spacing => 1,
           :line => true }
  end

end
