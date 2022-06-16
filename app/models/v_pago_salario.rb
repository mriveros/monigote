class VPagoSalario < ActiveRecord::Base

  self.table_name="v_pagos_salarios"
  self.primary_key="pago_salario_id"
  
  
  
  scope :orden_01, -> { order("pago_salario_id")}
  scope :periodo_mes_anho, -> { order("mes_periodo, anho_periodo DESC")}

  
end