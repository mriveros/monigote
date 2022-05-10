class VTutorDetalle < ActiveRecord::Base

  self.table_name="v_tutores_detalles"
  self.primary_key="tutor_detalle_id"
  
  attr_accessible :tutor_detalle_id, :tutor_id, :alumno_id, :parentezco_id, :nombre_alumno, :apellido_alumno
  
  scope :orden_01, -> { order("tutor_detalle_id")}
  
end