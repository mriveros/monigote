Rails.application.routes.draw do

  
  namespace 'api' do
    namespace 'v1' do
  
      resources :personas
      resources :usuarios
  
    end
  end  

# Avatar routes
get "avatar/:size/:background/:text" => Dragonfly.app.endpoint { |params, app|
  app.generate(:initial_avatar, URI.unescape(params[:text]), { size: params[:size], background_color: params[:background] })
}, as: :avatar

#-------------------------------------MONIGOTE----------------------------------------------------

#GENERACION DE CUOTAS
  get 'cuotas/index'
  post 'cuotas/lista'
  get 'cuotas/lista'
  get 'cuotas/agregar'
  post 'cuotas/guardar'
  get 'cuotas/eliminar'
  get 'cuotas/cuota_detalle'
  post 'cuotas/lista_cuota_detalle'
  get 'cuotas/lista_cuota_detalle'
  get 'cuotas/pagar_cuota_detalle'
  post 'cuotas/guardar_pago_cuota_detalle'


#PERSONALES
  post 'personales/lista'
  get 'personales/lista'
  get 'personales/agregar'
  post 'personales/guardar'
  get 'personales/eliminar'
  get 'personales/editar'
  post 'personales/actualizar'
  get 'personales/index'
  get 'personales/buscar_personal'
  
#MATRICULACIONES
  get "matriculaciones/index"
  post "matriculaciones/lista"
  get "matriculaciones/lista"
  get "matriculaciones/agregar"
  post "matriculaciones/guardar"
  get "matriculaciones/editar"
  post "matriculaciones/actualizar"
  get "matriculaciones/eliminar"
  get "matriculaciones/matriculacion_detalle"
  get "matriculaciones/agregar_matriculacion_detalle"
  post "matriculaciones/guardar_matriculacion_detalle"
  get "matriculaciones/eliminar_matriculacion_detalle"
 

#ALUMNOS
  post "alumnos/lista"
  get "alumnos/lista"
  get "alumnos/agregar"
  post "alumnos/guardar"
  get "alumnos/eliminar"
  get "alumnos/editar"
  post "alumnos/actualizar"
  get "alumnos/index"
  get "alumnos/buscar_alumno"
  get "alumnos/buscar_persona" 
  get "alumnos/buscar_alumno_documento"

#TUTORES
  post "tutores/lista"
  get "tutores/lista"
  get "tutores/agregar"
  post "tutores/guardar"
  get "tutores/eliminar"
  get "tutores/editar"
  post "tutores/actualizar"
  get "tutores/index"
  get "tutores/buscar_tutor"
  get "tutores/buscar_persona" 
  get "tutores/tutor_detalle"
  get "tutores/agregar_tutor_detalle"
  post "tutores/guardar_tutor_detalle"
  get "tutores/eliminar_tutor_detalle"
  
  #CARGOS
  post 'cargos/lista'
  get 'cargos/lista'
  get 'cargos/agregar'
  post 'cargos/guardar'
  get 'cargos/eliminar'
  get 'cargos/editar'
  post 'cargos/actualizar'
  get 'cargos/index'

  #REMUNERACIONES EXTRAS
  post 'pagos_remuneraciones_extras/lista'
  get 'pagos_remuneraciones_extras/lista'
  get 'pagos_remuneraciones_extras/agregar'
  post 'pagos_remuneraciones_extras/guardar'
  get 'pagos_remuneraciones_extras/eliminar'
  get 'pagos_remuneraciones_extras/editar'
  post 'pagos_remuneraciones_extras/actualizar'
  get 'pagos_remuneraciones_extras/index'

#DESCUENTOS
  post 'pagos_descuentos/lista'
  get 'pagos_descuentos/lista'
  get 'pagos_descuentos/agregar'
  post 'pagos_descuentos/guardar'
  get 'pagos_descuentos/eliminar'
  get 'pagos_descuentos/editar'
  post 'pagos_descuentos/actualizar'
  get 'pagos_descuentos/index'

#ADELANTOS
  post 'pagos_adelantos/lista'
  get 'pagos_adelantos/lista'
  get 'pagos_adelantos/agregar'
  post 'pagos_adelantos/guardar'
  get 'pagos_adelantos/eliminar'
  get 'pagos_adelantos/editar'
  post 'pagos_adelantos/actualizar'
  get 'pagos_adelantos/index'

#PAGOS DE SALARIOS
  get 'pagos_salarios/index'
  post 'pagos_salarios/lista'
  get 'pagos_salarios/lista'
  get 'pagos_salarios/agregar'
  post 'pagos_salarios/guardar'
  get 'pagos_salarios/eliminar'
  get 'pagos_salarios/salario_detalle'
#---------------------------------------FONOWARE------------------------------------------------------------------------    
  #CRONTAB
  get "crontab_ultron/index"

  #JURISDICCIONES
  get "jurisdicciones/index"
  get "jurisdicciones/buscar_juridisccion_oferta" 

  #JURISDICCIONES
  get "informes/index"
  get "informes/indexa"
  get "informes/generar_pdf"

  #DETALLES DEBITOS
  post "detalles_debitos/lista"
  get "detalles_debitos/lista"
  get "detalles_debitos/agregar"
  post "detalles_debitos/guardar"
  get "detalles_debitos/eliminar"
  get "detalles_debitos/editar"
  post "detalles_debitos/actualizar"
  get "detalles_debitos/index"
 
  #DETALLES CREDITOS
  post "detalles_creditos/lista"
  get "detalles_creditos/lista"
  get "detalles_creditos/agregar"
  post "detalles_creditos/guardar"
  get "detalles_creditos/eliminar"
  get "detalles_creditos/editar"
  post "detalles_creditos/actualizar"
  get "detalles_creditos/index"

  #PRODUCCION
  get "produccion/index"
  get "produccion/lista"
  post "produccion/lista"
  get "produccion/agregar"
  post "produccion/guardar"
  get "produccion/eliminar"
  get "produccion/editar"
  post "produccion/actualizar"
  get "produccion/produccion_detalle_credito"
  get "produccion/produccion_detalle_debito"
  get "produccion/agregar_detalle_credito"
  get "produccion/agregar_detalle_debito"
  post "produccion/guardar_detalle_credito"
  post "produccion/guardar_detalle_debito"
  get "produccion/eliminar_produccion_detalle_credito"
  get "produccion/eliminar_produccion_detalle_debito"
  get "produccion/cambiar_estado_solicitado_a_en_progreso"
  get "produccion/cambiar_estado_en_progreso_a_finalizado"
  get "produccion/cambiar_estado_cobro"
  get "produccion/cambiar_estado_cobro_desconfirmar"
  get "produccion/planilla_resumen_produccion"
  get "produccion/planilla_resumen_produccion_pdf"
  get "produccion/planilla_resumen_produccion_cliente"
  get "produccion/planilla_resumen_produccion_cliente_pdf"
  
  #PACIENTES
  post "pacientes/lista"
  get "pacientes/lista"
  get "pacientes/agregar"
  post "pacientes/guardar"
  get "pacientes/eliminar"
  get "pacientes/editar"
  post "pacientes/actualizar"
  get "pacientes/index"
  get "pacientes/buscar_paciente"
  get "pacientes/buscar_persona"
  get "pacientes/buscar_paciente_cita"

  #PACIENTES DETALLES FONO
  get "pacientes_detalles_fono/paciente_detalle_fono"
  post "pacientes_detalles_fono/guardar_detalle_fono"

  #HISTORIALES PACIENTES
  post "historiales_pacientes/lista_pacientes"
  get "historiales_pacientes/lista_pacientes"
  get "historiales_pacientes/index"
  get "historiales_pacientes/historial_paciente_detalle_fono"
  get "historiales_pacientes/lista_citas"
  post "historiales_pacientes/lista_citas"
  get "historiales_pacientes/historial_cita_detalle_fono_terminado"
  


  #PROFESIONALES
  post "profesionales/lista"
  get "profesionales/lista"
  get "profesionales/agregar"
  post "profesionales/guardar"
  get "profesionales/eliminar"
  get "profesionales/editar"
  post "profesionales/actualizar"
  get "profesionales/index"
  get "profesionales/buscar_profesional"
  get "profesionales/buscar_persona"
  
  

  #PRECIOS
  post "precios/lista"
  get "precios/lista"
  get "precios/agregar"
  post "precios/guardar"
  get "precios/eliminar"
  get "precios/editar"
  post "precios/actualizar"
  get "precios/index"
  get "precios/obtener_datos"
  get "precios/buscar_precio"
  get "precios/marcar_predeterminado"

  #CITAS
  get "citas/index"
  post "citas/lista"
  get "citas/lista"
  get "citas/agregar"
  post "citas/guardar"
  get "citas/editar"
  post "citas/actualizar"
  get "citas/eliminar"
  get "citas/cambiar_estado_cita_en_espera_a_en_consultorio"
  get "citas/cambiar_estado_cita_en_consultorio_a_terminado"
  get "citas/cambiar_estado_cobro_a_cobrado"
  get "citas/cambiar_estado_cobro_a_no_cobrado"
  get "citas/cambiar_estado_cita_terminado_a_en_consultorio"
  get "citas/postergar_cita"
  post "citas/guardar_postergar_cita"
  get "citas/imprimir_informe"
  get "citas/generar_informe_pdf"
  get "citas/cambiar_estado_cita_en_consultorio_a_en_espera"
  

  #CITAS DETALLES FONO
  get "citas_detalles_fono/cita_detalle_fono"
  post "citas_detalles_fono/guardar_cita_detalle_fono"
  get "citas_detalles_fono/emitir_resolucion"
  post "citas_detalles_fono/guardar_resolucion"
  get "citas_detalles_fono/adjuntar_resolucion"
  post "citas_detalles_fono/guardar_resolucion_adjunta"
  get "citas_detalles_fono/habilitar_descarga_archivo"
  get "citas_detalles_fono/deshabilitar_descarga_archivo"
  get "citas_detalles_fono/cita_detalle_fono_terminado"

#--------------------------------------------SISTEMA------------------------------------------------------------  
  #PERSONAS
  post "personas/lista"
  get "personas/lista"
  get "personas/agregar"
  get "personas/agregar_persona_senatics"
  post "personas/guardar"
  post "personas/guardar_persona_senatics"
  get "personas/eliminar"
  get "personas/editar"
  post "personas/actualizar"
  get "personas/index"
  get "personas/mostrar_formulario"
  post "personas/unificar_persona"
  get "personas/obtener_datos"
  get "personas/buscar_persona_senatics"
  get "personas/buscar_chofer"
  

  #ROLES
  post "roles/lista"
  get "roles/lista"
  get "roles/agregar"
  post "roles/guardar"
  get "roles/eliminar"
  get "roles/editar"
  post "roles/actualizar"
  get "roles/accesos"
  get "roles/agregar_acceso"
  get "roles/guardar_acceso"
  get "roles/eliminar_acceso"
  get "roles/index"

  
  #CONTROLADORES
  post "controladores/lista"
  get "controladores/lista"
  get "controladores/agregar"
  post "controladores/guardar"
  get "controladores/eliminar"
  get "controladores/editar"
  post "controladores/actualizar"
  get "controladores/acciones"
  get "controladores/agregar_accion"
  post "controladores/guardar_accion"
  get "controladores/eliminar_accion"
  get "controladores/index"

  
  #USUARIOS
  get "usuarios/cambiar_perfil_actual"
  get "usuarios/mi_cuenta"
  post "usuarios/actualizar_mi_cuenta"
  post "usuarios/actualizar_mi_password"
  get "usuarios/perfiles"
  get "usuarios/agregar_perfil"
  get "usuarios/guardar_perfil"
  get "usuarios/eliminar_perfil"
  post "usuarios/actualizar_password"
  get "usuarios/reset_password"
  get "usuarios/perfiles"
  get 'usuarios/index'
  get 'usuarios/lista'
  post 'usuarios/lista'
  get "usuarios/agregar"
  post "usuarios/guardar"
  get "usuarios/eliminar"
  get "usuarios/editar"
  post "usuarios/actualizar"
  get 'usuarios/buscar_persona'
  post 'usuarios/cambiar_estado_usuario'

  #LOGIN
  get 'login' => "usuarios_sessions#new",      :as => :login
  get 'logout' => "usuarios_sessions#destroy", :as => :logout
  post "usuarios_sessions/create"
  get "usuarios_sessions/acceso_denegado"
  get "usuarios_sessions/new"  
  get "usuarios_sessions/mantenimiento"  

  get "principal/buscar_institucion"
  get "principal/buscar_persona"
  get "principal/buscar_usuario"
  post "principal/guardar_recuperar_password"
  get "principal/recuperar_password"
  post "principal/guardar_usuario"
  get "principal/activar_cuenta"
  get "principal/agregar_usuario"
  get "contactos" => "principal#contactos", :as => :contactos
  get "index" => "principal#index", :as => :index
  get "about" => "principal#about", :as => :about
  get "legal" => "principal#legal", :as => :legal
  get "index" => "principal#index", :as => :indexv
	
	

  root 'principal#index'
  
  get "application/autocompletar" => 'application#autocompletar', :as => :autocompletar

  #INFORMACIONES
  get "informaciones/index"
  get "informaciones/lista"
  post "informaciones/lista"
	get "informaciones/perfiles"
	get "informaciones/enlaces"
  get "informaciones/agregar"
  post "informaciones/guardar"
	get "informaciones/agregar_enlace"
	get "informaciones/guardar_enlace"
	post "informaciones/guardar_enlace"
	get "informaciones/agregar_perfil"
  get "informaciones/guardar_perfil"
  get "informaciones/eliminar"
  get "informaciones/editar"
  post "informaciones/actualizar"
	get "informaciones/editar_enlace"
	post "informaciones/actualizar_enlace"
  get "informaciones/eliminar_enlace"
  get "informaciones/eliminar_rol"

end
