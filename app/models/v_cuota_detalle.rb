class VCuotaDetalle < ActiveRecord::Base

  self.table_name="v_cuotas_detalles"
  self.primary_key="id"
  
  attr_accessible :id, :cuota_id, :alumno_id, :nombre_alumno, :monto_cuota, :pago_parcial, :pago_pendiente, :estado_pago_cuota_detalle_id, :estado_pago_cuota_detalle, :fecha_pago, :created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  
end