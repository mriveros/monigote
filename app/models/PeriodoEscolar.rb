class PeriodoEscolar < ActiveRecord::Base
  
  self.table_name= "periodos_escolares"
  self.primary_key = "id"
  
  attr_accessible :id, :anho_periodo, :sueldo, :created_at, :updated_at
 
  scope :orden_01, -> { order("id")}
  scope :orden_descripcion, -> { order("descripcion")}

end