class VCuota < ActiveRecord::Base

  self.table_name="v_cuotas"
  self.primary_key="cuota_id"
  
  attr_accessible :cuota_id, :fecha_generacion, :mes_periodo_id, :mes_periodo, :periodo_escolar_id, :periodo_escolar, :nivel_id, :nivel, :sala_id, :sala, :sucursal_id, :sucursal, :total_cuotas, :created_at, :updated_at
  
  scope :orden_01, -> { order("cuota_id")}
  scope :orden_periodo, -> { order("mes_periodo asc, periodo_escolar_id DESC")}
  scope :fecha, -> { order("fecha_generacion desc")}

  
end