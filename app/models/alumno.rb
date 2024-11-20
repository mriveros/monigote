class Alumno < ActiveRecord::Base

  self.table_name="alumnos"
  self.primary_key="id"
  extend Dragonfly::Model
  include Avatarable
  validates_property :format, of: :photo, in: ['jpeg', 'jpg', 'png', 'gif'], message: "solo se permiten imágenes (JPEG, PNG o GIF)"
  
  dragonfly_accessor :photo

  attr_accessible :id, :nombres, :apellidos, :ci, :direccion, :telefono, :fecha_nacimiento
  
  scope :orden_01, -> { order("id")}
  scope :orden_nombres, -> { order("nombres, apellidos")}
  def full_name
    [nombres, apellidos].join(' ')
  end

  # required for avatarable
  def avatar_text
    nombres.chr
  end
  
end