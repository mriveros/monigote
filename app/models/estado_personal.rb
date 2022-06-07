class EstadoPersonal < ActiveRecord::Base
  
  self.table_name="estados_personales"
  self.primary_key = 'id'

  attr_accessible :id, :descripcion 
  scope :orden_01, -> { order("id")}
  scope :orden_descripcion, -> { order("descripcion asc")}

end
