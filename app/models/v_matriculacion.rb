class VMatriculacion < ActiveRecord::Base
  
  self.table_name= "matriculaciones"
  self.primary_key = "id"
  
  attr_accessible :matriculacion_id, :nivel_id, :nivel, :sala_id, :sala, :periodo_id, :periodo, :created_at, :updated_at
 
  scope :orden_01, -> { order("matriculacion_id")}
  scope :orden_niveles, -> { order("nivel")}

end