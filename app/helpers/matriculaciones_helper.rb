module MatriculacionesHelper

  def link_to_editar_matriculacion(matriculacion)

      render partial: 'link_to_editar_matriculacion', locals: { matriculacion: matriculacion }
      
  end

  def link_to_matriculacion_detalle(matriculacion)

      render partial: 'link_to_matriculacion_detalle', locals: { matriculacion: matriculacion }
      
  end

  

  
end