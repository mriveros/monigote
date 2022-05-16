class Matriculacion < ActiveRecord::Base
  
  self.table_name= "matriculaciones"
  self.primary_key = "id"
  
  attr_accessible :id, :nivel_id, :sala_id, :periodo_id, :created_at, :updated_at
 
  scope :orden_01, -> { order("id")}
  scope :orden_descripcion, -> { order("descripcion")}

end
