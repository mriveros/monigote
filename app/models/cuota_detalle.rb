class CuotaDetalle < ActiveRecord::Base

  self.table_name="cuotas_detalles"
  self.primary_key="id"
  
  attr_accessible :id, :cuota_id, :alumno_id, :monto_cuota, :pago_cuota, :pago_pendiente, :estado_pago_cuota_detalle_id, :fecha_pago, :created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  
end