class Alumno < ActiveRecord::Base

  self.table_name="pilotos"
  self.primary_key="id"
  extend Dragonfly::Model
  include Avatarable

  dragonfly_accessor :photo

  attr_accessible :id, :nombres, :apellidos, :ci, :grupo_sanguineo_id, :direccion, :telefono, :fecha_nacimiento
  
  scope :orden_01, -> { order("id")}
  scope :orden_descripcion, -> { order("nombres, apellidos")}
  def full_name
    [nombres, apellidos].join(' ')
  end

  # required for avatarable
  def avatar_text
    nombres.chr
  end
  
end