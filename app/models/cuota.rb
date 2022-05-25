class Cuota < ActiveRecord::Base

  self.table_name="cuotas"
  self.primary_key="id"
  
  attr_accessible :id, :fecha_generacion, :mes_periodo_id, :periodo_escolar_id, :nivel_id, :sala_id, :sucursal_id, :total_cuotas,:created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  
end