class Nivel < ActiveRecord::Base
  
  self.table_name= "niveles"
  self.primary_key = "id"
  
  attr_accessible :id, :descripcion, :sueldo, :created_at, :updated_at
 
  scope :orden_01, -> { order("id")}
  scope :orden_descripcion, -> { order("descripcion")}

end