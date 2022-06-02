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

    @cuota = Cuota.new

    respond_to do |f|
      
        f.js
      
    end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false
   
    @mes = Mes.where("id = ?", params[:mes_periodo][:id]).first
    @sucursal = Sucursal.where("id = ?", 1).first

    @cuota = Cuota.where("mes_periodo_id = ? and periodo_escolar_id = ? and sucursal_id = ? and nivel_id = ? and sala_id = ?", params[:mes_periodo][:id], params[:anho_periodo], 1, params[:cuota][:nivel_id],params[:cuota][:sala_id]).first
    
    if @cuota.present?

      @valido = false
      @msg += "La cuota ya fue generado."

    end
    
    #verificar cantidad alumnos matriculados
    unless total_hacienda.present?
      
      @valido = false
      @msg += "No existen alumnos en la matriculación seleccionada."

    end
    
    if @valido

     
      CuotaDetalle.transaction do    

        
          

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