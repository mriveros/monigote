class VCuota < ActiveRecord::Base

  self.table_name="v_cuotas"
  self.primary_key="id"
  
  attr_accessible :id, :fecha_generacion, :mes_periodo_id, :mes_periodo, :periodo_escolar_id, :anho_periodo, :nivel_id, :nivel, :sala_id, :sala, :sucursal_id, :sucursal, :total_cuotas, :created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  scope :periodo_, -> { order("mes_periodo, anho_periodo DESC")}

  
end