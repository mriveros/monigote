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
  
end