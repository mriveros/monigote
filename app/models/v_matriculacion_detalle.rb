class VMatriculacionDetalle < ActiveRecord::Base
  
  self.table_name= "v_matriculaciones_detalles"
  self.primary_key = "id"
  
  attr_accessible :id, :matriculacion_id, :alumno_id, :nombre_alumno, :precio_id, :costo_matriculacion, :fecha_matriculacion, :estado_matriculacion_detalle_id, :estado_matriculacion_detalle, :created_at, :updated_at
 
  scope :orden_01, -> { order("id")}
  scope :orden_fecha, -> { order("fecha_matriculacion")}

end