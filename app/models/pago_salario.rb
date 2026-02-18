class PagoSalario < ActiveRecord::Base

  self.table_name="pagos_salarios"
  self.primary_key="id"
  
  attr_accessible :id, :fecha, :mes_periodo, :anho_periodo, :sucursal_id,
   :total_salario, :total_adelantos, :total_descuentos, :total_remunericiones_extras, :monto_total_pagado,
   :created_at, :updated_at, :total_ips
  
  scope :orden_01, -> { order("id")}
  scope :periodo_mes_anho, -> { order("mes_periodo, anho_periodo DESC")}

  
end