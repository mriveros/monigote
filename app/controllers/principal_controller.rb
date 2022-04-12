# -*- encoding : utf-8 -*-
class PrincipalController < ApplicationController
   

  def index

    mes_actual = Time.now.month
    anho_actual = Time.now.year

    @citas_dia = Cita.where("fecha_cita = ?", Date.today)
    
  end

  def about

  end

  def legal

  end

  def contactos

  end

  def agregar_usuario


  end

  def guardar_usuario

    valido = true
    @msg = ""

    @usuario = Usuario.new

    persona = Persona.where("documento_persona = ? and tipo_documento_id = ? and nacionalidad_id = ?", params[:persona_documento], params[:persona][:tipo_documento_id], params[:persona][:nacionalidad_id])

    if persona.present?
      
      persona = persona.first

      edad = (DateTime.now - persona.fecha_nacimiento) / 365.25

      if edad.to_i < 18

        valido = false
        @msg += "Para acceder a una cuenta deber ser mayor edad.<br />"

      end

      if valido

        usuario_existente = Usuario.where("persona_id = ?", persona.id )

        unless usuario_existente.present?

          @usuario.persona_id = persona.id
          @usuario.login = "#{persona.documento_persona}-#{quita_acentos(persona.tipo_documento.descripcion.downcase[0..2])}-#{quita_acentos(persona.nacionalidad.descripcion.downcase[0..2])}"
          password = Usuario.generar_password
          @usuario.password = password 
          @usuario.password_confirmation = password
          @usuario.active = false
          @usuario.token = Digest::MD5.hexdigest(Time.now.to_s)
      
        else

          valido = false
          @msg += "Este usuario ya ha sido registrado.<br />"

        end

      end

    else

      valido = false
      @msg += "Persona no encontrada.<br />ENVIE SU NRO DE DOCUMENTO Y CORREO ELECTRONICO AL CORREO soporte@mec.gov.py para realizar verificaciones."

    end
        
    if !params[:usuario][:email].present?

      @msg += "El campo correo electronico no puede quedar vacio.<br />"
      valido = false

    else

      if params[:usuario][:email] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

        @usuario.email = params[:usuario][:email]

      else

        valido = false
        @msg += "Formato de correo electronico no valido.<br />"

      end

    end

    if params[:perfil] && params[:perfil][:rol_id].present?

      rol_id = params[:perfil][:rol_id]

    else

      @msg += "Seleccione un perfil.<br />"
      valido = false

    end

    #if !verify_recaptcha(:model => @usuario) 
    if !RecaptchaVerifier.verify(params["g-recaptcha-response"])
    
      @msg += "Código de verificación no valida.<br />Recargue el código verificador o presione F5."
      valido = false
    
    end

    if valido

      if @usuario.save

        perfil = Perfil.new
        perfil.usuario_id = @usuario.id
        perfil.rol_id = rol_id
        
        if perfil.save

          NotificarUsuario.email(@usuario, password).deliver
          @usuario_ok = true

        end 

      else

        @msg += "ERROR: No se ha podido registrar el usuario."

      end

    end

    respond_to do |f|

      f.js

    end

  end

  def activar_cuenta

    if params[:a].present?

      @usuario = Usuario.where('token = ?', params[:a]).first

      if @usuario.present?

        @usuario.active = true
        
        if @usuario.save

          @msg = "Cuenta activada exitosamente."
          @activado = true

        else

          @msg = "No se ha podido activar la cuenta."
          @activado = false

        end 

      else

        @msg = "No se ha encontrado la cuenta."
        @activado = false

      end

    else

      @msg = "El parámetro no existe."
      @activado = false

    end

    respond_to do |f|

      f.html

    end

  end

  def recuperar_password


  end

  def guardar_recuperar_password

    valido = true
    @msg = ""

    persona = Persona.joins("join usuarios u on personas.id = u.persona_id and active = true").where("documento_persona = ? and tipo_documento_id = ? and nacionalidad_id = ? and fecha_nacimiento = ?", params[:persona_documento], params[:persona][:tipo_documento_id], params[:persona][:nacionalidad_id], formatear_fecha(params[:fecha_nacimiento])).first

    if persona.present?
      
      @usuario = Usuario.where("persona_id = ?", persona.id ).first
      
      unless @usuario.present?

        valido = false
        @msg += "Usuario no encontrado o inactivo.<br />"

      end

      #if !verify_recaptcha(:model => @usuario)
      if !RecaptchaVerifier.verify(params["g-recaptcha-response"])
    
        @msg += "Código de verificación no valida.<br />Recargue el código verificador o presione F5."
        valido = false
    
      end

      if valido

        password = Usuario.generar_password
        @usuario.password = password 
        @usuario.password_confirmation = password
        @usuario.failed_login_count = 0

        if @usuario.save

          NotificarUsuario.email_recuperar_password(@usuario, password).deliver
          @usuario_ok = true

        end

      end

    else

      valido = false
      @msg += "Usuario no encontrado o inactivo."

    end

    respond_to do |f|

      f.js

    end

  end

  def buscar_usuario
    
    if params[:tipo_documento_id].present? && params[:nacionalidad_id] && params[:documento].present? && params[:fecha_nacimiento].present?

      @persona = Persona.joins("join usuarios u on personas.id = u.persona_id and u.active = true").where("tipo_documento_id = ? and nacionalidad_id = ? and documento_persona = ? and fecha_nacimiento = ?", params[:tipo_documento_id], params[:nacionalidad_id], params[:documento], formatear_fecha(params[:fecha_nacimiento])).first
 
    end

    respond_to do |f|
      f.json { render :json => @persona, :methods => :usuario_email}
    end

  end
  
  def buscar_institucion
    
    if params[:codigo_institucion].present?

      @institucion = VOfertaEducativa.where("v_ofertas_educativas.codigo_institucion = ?", params[:codigo_institucion]).first

    end
    
    respond_to do |f|
      
      f.json { render :json => @institucion }
    
    end
  
  end
  
  def buscar_persona
    
    if params[:documento].present? 

      @persona = Persona.where("documento_persona = ?",  params[:documento]).first
 
    end

    respond_to do |f|
      f.json { render :json => @persona}
    end

  end

end
