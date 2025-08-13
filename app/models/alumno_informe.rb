class AlumnoInforme < ActiveRecord::Base
  self.table_name = 'alumnos_informes'

  belongs_to :alumno, foreign_key: 'numero_documento', primary_key: 'numero_documento'
  
  has_attached_file :data
  validates_attachment_content_type :data, content_type: /\A.*\z/

end