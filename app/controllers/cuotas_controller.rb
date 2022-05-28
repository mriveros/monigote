class CuotasController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index

  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_cuotas_id].present?

      cond << "pago_salario_id = ?"
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

    if params[:form_buscar_cuotas_anho_periodo].present?

      cond << "anho_periodo ilike ?"
      args << "%#{params[:form_buscar_cuotas_anho_periodo]}%"

    end

    if params[:form_buscar_cuotas][:hacienda_id].present?

      cond << "hacienda_id = ?"
      args << params[:form_buscar_cuotas][:hacienda_id]

    end

    if params[:form_buscar_cuotas_total_salario].present?

      cond << "total_salario = ?"
      args << params[:form_buscar_cuotas_total_salario]

    end

    if params[:form_buscar_cuotas_total_adelantos].present?

      cond << "total_adelantos = ?"
      args << params[:form_buscar_cuotas_total_adelantos]

    end

    if params[:form_buscar_cuotas_total_descuentos].present?

      cond << "total_descuentos = ?"
      args << params[:form_buscar_cuotas_total_descuentos]

    end

    if params[:form_buscar_cuotas_total_remuneraciones_extras].present?

      cond << "total_remuneraciones_extras = ?"
      args << params[:form_buscar_cuotas_total_remuneraciones_extras]

    end


    if params[:form_buscar_cuotas_monto_total_pagado].present?

      cond << "monto_total_pagado = ?"
      args << params[:form_buscar_cuotas_monto_total_pagado]

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

    @pago_salario = Cuota.new

    respond_to do |f|
      
        f.js
      
    end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false
    @acumulacion_sueldo_percibido = 0
    @mes = Mes.where("id = ?", params[:mes_periodo][:id]).first
    @hacienda = Hacienda.where("id = ?", params[:hacienda][:id]).first

    @pago_salario = PagoSalario.where("mes_periodo_id = ? and anho_periodo = ? and hacienda_id = ? ", params[:mes_periodo][:id], params[:anho_periodo], params[:hacienda][:id]).first
    
    if @pago_salario.present?

      @valido = false
      @msg += "El Pago de Salarios del Periodo seleccionado ya fue generado."

    end
    total_hacienda = VPersonal.where("hacienda_id = ?", params[:hacienda][:id])
    
    unless total_hacienda.present?

      @valido = false
      @msg += "No existen Personales asignados en la Hacienda seleccionada."

    end
    
    if @valido

      @total_salario = VPersonal.where("hacienda_id = ?", params[:hacienda][:id]).sum(:sueldo)
      @total_adelantos = PagoAdelanto.where("mes_periodo_id = ? and anho_periodo = ?", params[:mes_periodo][:id], params[:anho_periodo]).sum(:monto)
      @total_descuentos = PagoDescuento.where("mes_periodo_id = ? and anho_periodo = ?", params[:mes_periodo][:id], params[:anho_periodo]).sum(:monto)
      @total_remuneraciones_extras = PagoRemuneracionExtra.where("mes_periodo_id = ? and anho_periodo = ?", params[:mes_periodo][:id], params[:anho_periodo]).sum(:monto)
      
      CuotaDetalle.transaction do    

        @pago_salario = Cuota.new()
        @pago_salario.fecha = params[:fecha]
        @pago_salario.mes_periodo_id = params[:mes_periodo][:id]
        @pago_salario.anho_periodo = params[:anho_periodo]
        @pago_salario.hacienda_id = params[:hacienda][:id]
        @pago_salario.mes_periodo_id = params[:mes_periodo][:id]
        @pago_salario.total_salario = @total_salario
        @pago_salario.total_adelantos = @total_adelantos
        @pago_salario.total_descuentos = @total_descuentos
        @pago_salario.total_remuneraciones_extras = @total_remuneraciones_extras

          if @pago_salario.save

            auditoria_nueva("registrar pagos de salarios", "cuotas", @pago_salario)

            #generar pagos de salarios detalles
            @personales_hacienda = Personal.where("hacienda_id = ? and estado_personal_id = ?", params[:hacienda][:id], PARAMETRO[:estado_personal_activo])
            @personales_hacienda.each do |ph|

              @personal_salario = VPersonal.where("personal_id = ? and hacienda_id = ?", ph.id, params[:hacienda][:id]).first
              @personal_total_adelantos = PagoAdelanto.where("personal_id = ? and mes_periodo_id = ? and anho_periodo = ?", ph.id, params[:mes_periodo][:id],params[:anho_periodo]).sum(:monto).to_i
              @personal_total_descuentos = PagoDescuento.where("personal_id = ? and mes_periodo_id = ? and anho_periodo = ?", ph.id, params[:mes_periodo][:id],params[:anho_periodo]).sum(:monto).to_i
              @personal_total_remuneracion_extra = PagoRemuneracionExtra.where("personal_id = ? and mes_periodo_id = ? and anho_periodo = ?", ph.id, params[:mes_periodo][:id],params[:anho_periodo]).sum(:monto).to_i
              @personal_sueldo_percibido = (@personal_salario.sueldo.to_i + @personal_total_remuneracion_extra) - (@personal_total_adelantos + @personal_total_descuentos)
              @acumulacion_sueldo_percibido = @acumulacion_sueldo_percibido + @personal_sueldo_percibido

              @pago_salario_detalle = PagoSalarioDetalle.new
              @pago_salario_detalle.pago_salario_id = @pago_salario.id
              @pago_salario_detalle.personal_id = ph.id
              @pago_salario_detalle.cargo_id = ph.cargo_id
              @pago_salario_detalle.salario_base = @personal_salario.sueldo.to_i
              @pago_salario_detalle.adelantos = @personal_total_adelantos
              @pago_salario_detalle.descuentos = @personal_total_descuentos
              @pago_salario_detalle.otras_remuneraciones = @personal_total_remuneracion_extra
              @pago_salario_detalle.salario_percibido = @personal_sueldo_percibido

              if @pago_salario_detalle.save

                auditoria_nueva("registrar pagos de salarios de personales - detalles", "cuotas_detalles", @pago_salario_detalle)

              end

            end
           
          end 
          
          #actualizar monto total pago salario
          @pago_salario.monto_total_pagado = @acumulacion_sueldo_percibido
          
          if @pago_salario.save

            @guardado_ok = true

            @registro_gastos = RegistroGasto.new
            @registro_gastos.fecha = params[:fecha]
            @registro_gastos.gasto_id = PARAMETRO[:registro_gasto_pago_salario]
            @registro_gastos.monto = @pago_salario.monto_total_pagado
            @registro_gastos.observacion = "PAGO DE SALARIOS #{@hacienda.descripcion}: #{@mes.descripcion}/#{params[:anho_periodo]}"
            @registro_gastos.pago_salario_id = @pago_salario.id
            @registro_gastos.save

          end

      end#end transaction

    end
  
    respond_to do |f|
      
        f.js
      
    end

  end


  def eliminar

    valido = true
    @msg = ""

    @pago_salario = Cuota.find(params[:id])
    pago_salario_detalle = CuotaDetalle.where("pago_salario_id = ?", params[:id])
    pago_salario_detalle.destroy_all
    @pago_salario_elim = @pago_salario  

    @registro_gasto = RegistroGasto.where("pago_salario_id = ?", @pago_salario.id).first
    @registro_gasto.destroy

    if valido

      if @pago_salario.destroy

        auditoria_nueva("eliminar pago de salario", "cuotas", @pago_salario_elim)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el Pago de Salarios."

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