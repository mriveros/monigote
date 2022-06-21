class PagoAdelanto < ActiveRecord::Base

  self.table_name="pagos_adelantos"
  self.primary_key="id"
  
  attr_accessible :id, :fecha, :personal_id, :monto, :mes_periodo, :periodo_escolar_id, :observacion, :created_at, :updated_at
  scope :orden_01, -> { order("id")}
  
end