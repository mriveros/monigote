class PeriodoEscolar < ActiveRecord::Base
  
  self.table_name= "periodos_escolares"
  self.primary_key = "id"
  
  attr_accessible :id, :anho_periodo, :created_at, :updated_at
 
  scope :orden_01, -> { order("id")}
  scope :orden_periodo, -> { order("anho_periodo asc")}
  scope :periodo_actual, -> { where("anho_periodo = ?", Date.today.year.to_s)}

end