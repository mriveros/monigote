class CuotasController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index

  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_cuotas_id].present?

      cond << "cuota_id = ?"
      args << params[:form_buscar_cuotas_id]

    end

    if params[:form_buscar_cuotas_fecha].present?

      cond << "fecha = ?"
      args << params[:form_buscar_cuotas_fecha]

    end

    if params[:form_buscar_cuotas][:mes_periodo_id].present?

      cond << "mes_periodo_id = ?"
      args << params[:form_buscar_cuotas][:mes_periodo_id]

    end

    if params[:form_buscar_cuotas][:periodo_escolar_id].present?

      cond << "periodo_escolar_id = ?"
      args << params[:form_buscar_cuotas][:periodo_escolar_id]

    end

    if params[:form_buscar_cuotas][:sucursal_id].present?

      cond << "sucursal_id = ?"
      args << params[:form_buscar_cuotas][:sucursal_id]

    end

    if params[:form_buscar_cuotas][:nivel_id].present?

      cond << "nivel_id = ?"
      args << params[:form_buscar_cuotas][:nivel_id]

    end

    if params[:form_buscar_cuotas][:sala_id].present?

      cond << "sala_id = ?"
      args << params[:form_buscar_cuotas][:sala_id]

    end


    if params[:form_buscar_cuotas_total_cuotas].present?

      cond << "total_cuotas = ?"
      args << params[:form_buscar_cuotas_total_cuotas]

    end

    if params[:form_buscar_cuotas_total_cobradas].present?

      cond << "total_cobradas = ?"
      args << params[:form_buscar_cuotas_total_cobradas]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @cuotas =  VCuota.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VCuota.where(cond).count
      
    else

      @cuotas = VCuota.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VCuota.count

    end

    @total_registros = VCuota.count

    respond_to do |f|
      
      f.js
      
    end

  end

  def agregar

    @cuota = Cuota.new

    respond_to do |f|
      
        f.js
      
    end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false
    @guardado_error = false
   
    @mes = Mes.where("id = ?", params[:mes_periodo][:id]).first
    @matriculaciones = Matriculacion.where('periodo_escolar_id = ?', params[:periodo_escolar][:id])
    
    CuotaDetalle.transaction do   

      @matriculaciones.each do |m|

          matriculacion_detalle = MatriculacionDetalle.where('matriculacion_id = ?', m.id)

          if matriculacion_detalle.count > 0
            
            @cuota = Cuota.where("mes_periodo_id = ? and periodo_escolar_id = ? and matriculacion_id = ?",params[:mes_periodo][:id], params[:periodo_escolar][:id], m.id).first
            
            unless @cuota.present?

              @cuota = Cuota.new
              @cuota.fecha_generacion = Date.today
              @cuota.mes_periodo_id = params[:mes_periodo][:id]
              @cuota.periodo_escolar_id = params[:periodo_escolar][:id]
              @cuota.matriculacion_id = m.id
              if @cuota.save
                
                matriculacion_detalle.each do |md|

                  cuota_detalle = CuotaDetalle.new
                  cuota_detalle.cuota_id = @cuota.id
                  cuota_detalle.alumno_id = md.alumno_id
                  precio = Precio.where('id = ?', md.precio_id).first
                  cuota_detalle.monto_cuota = precio.monto
                  cuota_detalle.estado_pago_cuota_detalle_id = PARAMETRO[:estado_pago_cuota_detalle_pendiente]
                  if cuota_detalle.save

                    @guardado_ok = true

                  else

                    @guardado_error = true

                  end
                  
                end #end each md

              end

            end

          end

      end

    end #end TRANSACTION
  
    respond_to do |f|
      
        f.js
      
    end

  end


  def eliminar

    valido = true
    @msg = ""

    @cuota = Cuota.find(params[:id])
    cuota_detalle = CuotaDetalle.where("cuota_id = ? and estado_pago_cuota_detalle_id in (?)", params[:id], [PARAMETRO[:estado_pago_cuota_detalle_pagado],PARAMETRO[:estado_pago_cuota_detalle_pago_parcial]])
    
    unless cuota_detalle.present?
      
      cuota_detalle.destroy_all
      @cuota_elim = @cuota

    end

    if valido

      if @cuota.destroy

        auditoria_nueva("eliminar cuota", "cuotas", @cuota_elim)
        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar la cuota. Ya cuenta con detalles pagados"

      end

    end

        
    respond_to do |f|

      f.js

    end

  end

  def cuota_detalle

    @pago_salario = Cuota.where("id = ?", params[:pago_salario_id] ).first
    @pago_salario_detalle = VCuotaDetalle.where("pago_salario_id = ?", params[:pago_salario_id]).paginate(per_page: 10, page: params[:page])


    respond_to do |f|

      f.js

    end

  end

end