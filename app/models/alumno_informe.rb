class AlumnoInforme < ActiveRecord::Base
  self.table_name = 'alumnos_informes'

  belongs_to :alumno, foreign_key: 'numero_documento', primary_key: 'numero_documento'

  # Configuración de Paperclip para S3
  has_attached_file :data,
    storage: :s3,
    s3_region: 'sa-east-1',
    s3_credentials: {
      bucket: 'adjuntos-fono-monigote',
      access_key_id: Rails.application.secrets.aws_access_key_id, #'REMOVED_ACCESS_KEY',
      secret_access_key: Rails.application.secrets.aws_secret_access_key #'REMOVED_SECRET_KEY'
    },
    path: "/:class/:id/:basename.:extension",
    url: ":s3_domain_url",
    acl: :public_read 
    
  validates_attachment_content_type :data, content_type: /\A.*\z/
end
