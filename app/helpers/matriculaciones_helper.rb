module MatriculacionesHelper

  def link_to_editar_matriculacion(matriculacion)

      render partial: 'link_to_editar_matriculacion', locals: { matriculacion: matriculacion }
      
  end

  
end