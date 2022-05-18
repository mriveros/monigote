class MatriculacionDetalle < ActiveRecord::Base
  
  self.table_name= "matriculaciones_detalles"
  self.primary_key = "id"
  
  attr_accessible :id, :matriculacion_id, :alumno_id, :precio_id, :fecha_matriculacion, :estado_matriculacion_detalle_id, :created_at, :updated_at
 
  scope :orden_01, -> { order("id")}
  scope :orden_fecha, -> { order("fecha_matriculacion")}

end