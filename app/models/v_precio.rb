class VPrecio < ActiveRecord::Base
  
  self.table_name= "v_precios"
  self.primary_key = "id"
  
  attr_accessible :id, :descripcion, :monto, :nivel_id, :nivel, :predeterminado
 
  scope :predeterminado, -> { order("predeterminado = 't' desc")}
  scope :orden_01, -> { order("id")}
  
end
