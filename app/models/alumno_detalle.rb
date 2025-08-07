class AlumnoDetalle < ActiveRecord::Base

  self.table_name="alumnos_detalles"
  self.primary_key="id"
  
  attr_accessible :id, :alumno_id, :antecedentes_personales, :antecedentes_familiares, :antecedentes_otros, :antecedentes_habitos, :sindrome,
  :sindrome_especificar, :transtornos, :transtorno_especificar, :enfermedad, :enfermedad_especificar, 
  :medicamentos, :observacion
  
  scope :orden_01, -> { order("id")}
  
end