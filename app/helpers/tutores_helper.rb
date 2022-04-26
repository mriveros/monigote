module TutoresHelper

	def link_to_editar_tutor(tutor_id)
		
	    render partial: 'link_to_editar_tutor', locals: { tutor_id: tutor_id }
	    
	end

	def tutor_avatar(tutor, options = {})
    if tutor.photo.nil?
      image_tag tutor.avatar_url, options
    else
      image_tag tutor.photo.thumb('150x150#').url, options
    end
  end
  
end