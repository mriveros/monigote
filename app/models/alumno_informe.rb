class AlumnoInforme < ActiveRecord::Base
  self.table_name = 'alumnos_informes'

  belongs_to :alumno,
    foreign_key: 'ci',
    primary_key: 'ci'

  has_attached_file :data,
    storage: :s3,
    s3_region: 'sa-east-1',
    s3_credentials: {
      bucket: 'adjuntos-fono-monigote',
      access_key_id: Rails.application.secrets.aws_access_key_id,
      secret_access_key: Rails.application.secrets.aws_secret_access_key
    },
    path: "/alumnos_informe/:numero_documento/:basename.:extension",
    url: ":s3_domain_url",
    acl: :public_read

  validates_attachment_content_type :data,
    content_type: ['application/pdf', 'image/jpeg', 'image/png']

  before_create :setear_url_archivo

  private

  def setear_url_archivo
    self.url_archivo = data.url if data.present?
  end
end
