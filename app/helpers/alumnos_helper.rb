module PilotosHelper

	def link_to_editar_piloto(piloto_id)
		
	    render partial: 'link_to_editar_piloto', locals: { piloto_id: piloto_id }
	    
	end

	def piloto_avatar(piloto, options = {})
    if piloto.photo.nil?
      image_tag piloto.avatar_url, options
    else
      image_tag piloto.photo.thumb('150x150#').url, options
    end
  end
  
end