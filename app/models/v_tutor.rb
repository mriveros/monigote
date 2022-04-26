class VTutor < ActiveRecord::Base

  self.table_name="v_tutores"
  self.primary_key="tutor_id"
  
  extend Dragonfly::Model
  include Avatarable

  dragonfly_accessor :photo

  attr_accessible :id, :nombres, :apellidos, :ci, :direccion, :telefono, :fecha_nacimiento
  
  scope :orden_01, -> { order("tutor_id")}
  scope :orden_nombres, -> { order("nombres, apellidos")}
  def full_name
    [nombres, apellidos].join(' ')
  end

  # required for avatarable
  def avatar_text
    nombres.chr
  end
  
end