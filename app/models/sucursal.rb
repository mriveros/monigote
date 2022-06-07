class Sucursal < ActiveRecord::Base
  
  self.table_name="sucursales"
  
  
  scope :orden_01, -> { order("id")}
  scope :orden_descripcion, -> { order("descripcion asc")}
  
  
  attr_accessible :id, :descripcion, :departamento_id, :observacion, :jurisdiccion_id, :created_at, :updated_at
  
    
end