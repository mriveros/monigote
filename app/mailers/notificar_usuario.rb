class NotificarUsuario < ActionMailer::Base
  
  default from: "info.monigote@gmail.com"

  def test_email(user_id, adjuntos)

    @datos_adjuntos = adjuntos

    @user = Usuario.find_by_id user_id

    if (@user)

      to = @user.email
      mail(:to => to, :subject => "Aviso Monigote", :from => "info.monigote@gmail.com") 

    end

  end

  def email(usuario, password)
    
    @usuario = usuario
    @password = password

    mail(to: @usuario.email, subject: "Monigote: Nuevo Usuario")

  end

  def email_usuario(usuario, password)
    
    @usuario = usuario
    @password = password

    mail(to: @usuario.email, subject: "Monigote: Nuevo Usuario")

  end

  def email_recuperar_password(usuario, password)
    
    @usuario = usuario
    @password = password

    mail(to: @usuario.email, subject: "Monigote: Recuperar Contraseña")

  end

  def enviar_notificacion(destinatario, subject ,texto, otro_texto)

    
    
    @subject = subject
    @destinatario = destinatario
    @texto_principal = texto
    @otro_texto = otro_texto

    if (@email)
      #from =>"info.monigote@gmail.com" 
      mail(:to => @destinatario, :subject => @subject, :from => "smarthub.py@gmail.com") 
    
    end

  end

  

end
