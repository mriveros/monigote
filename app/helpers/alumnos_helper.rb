module AlumnosHelper

	def link_to_editar_alumno(alumno_id)
		
	    render partial: 'link_to_editar_alumno', locals: { alumno_id: alumno_id }
	    
	end

	def alumno_avatar(alumno, options = {})
    if alumno.photo.nil?
      image_tag alumno.avatar_url, options
    else
      image_tag alumno.photo.thumb('150x150#').url, options
    end
  end

  def link_to_alumno_detalle(alumno_id)

    render partial: 'link_to_alumno_detalle', locals: { alumno_id: alumno_id}

  end

  def link_to_alumno_informe(alumno_id)

    render partial: 'link_to_alumno_informe', locals: { alumno_id: alumno_id}

  end

  def link_descargar_data(alumno_informe_id)
    alumno_informe = AlumnoInforme.find_by(id: alumno_informe_id)

    if alumno_informe.present?
      link_to "Descargar archivo", alumno_informe.data.url, target: "_blank", rel: "noopener"
    else
      content_tag(:span, "Sin archivo", class: "text-muted")
    end
  end
  
end