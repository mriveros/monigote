class PreciosController < ApplicationController

before_filter :require_usuario

  def index
  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_precios_id].present?

      cond << "id = ?"
      args << params[:form_buscar_precios_id]

    end

    if params[:form_buscar_precios_descripcion].present?

      cond << "descripcion ilike ?"
      args << "%#{params[:form_buscar_precios_descripcion]}%"

    end

    if params[:form_buscar_precios_monto].present?

      cond << "monto = ?"
      args << params[:form_buscar_precios_monto]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @precios =  VPrecio.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = Precio.where(cond).count

    else

      @precios = VPrecio.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = Precio.count

    end

    @total_registros = Precio.count

    respond_to do |f|

      f.js

    end

  end

  def agregar

    @precio = Precio.new

    respond_to do |f|

      f.js
      
    end

  end

  def guardar

    valido = true
    @msg = ""
    @precio_ok = false
    @precio = Precio.where('descripcion = ? and turno_id =?',params[:precio][:descripcion].upcase, params[:precio][:turno_id]).first

    if @precio.present?
      @msg = "Esta descripción y precio de turno ya existe."
      valido = false
    end

    if valido
    
      @precio = Precio.new()
      @precio.descripcion = params[:precio][:descripcion].upcase
      @precio.monto = params[:precio][:monto].to_s.gsub(/[$.]/,'').to_i
      @precio.turno_id = params[:precio][:turno_id]

      if @precio.save

        auditoria_nueva("registrar precio", "precios", @precio)
       
        @precio_ok = true
       

      end

    end 
  
      rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep.to_s
      
      end                
               
    respond_to do |f|

      f.js

    end

  end

  def eliminar

    valido = true
    @msg = ""

    @precio = Precio.find(params[:id])

    @precio_elim = @precio

    if valido

      if @precio.destroy

        auditoria_nueva("eliminar precio", "precios", @precio)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el precio."

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        @eliminado = false
        end
        
    respond_to do |f|

      f.js

    end

  end

  def editar

    @precio = Precio.find(params[:id])

    respond_to do |f|

      f.js

    end

  end

  def actualizar

    valido = true
    @msg = ""

    @precio = Precio.find(params[:precio][:id])
    auditoria_id = auditoria_antes("actualizar precio", "precios", @precio)

    if valido

      @precio.descripcion = params[:precio][:descripcion].upcase
      @precio.monto =  params[:precio][:monto].to_s.gsub(/[$.]/,'').to_i
      @precio.turno_id = params[:precio][:turno_id]

      if @precio.save

        auditoria_despues(@precio, auditoria_id)
        @precio_ok = true

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        end                
        
    respond_to do |f|

      f.js

    end

  end
  

  def buscar_precio

     @precios = Precio.where("descripcion ilike ?", "%#{params[:descripcion]}%")

    respond_to do |f|
      
      f.html
      f.json { render :json => @precios }
    
    end

  end

  def marcar_predeterminado

    @guardado_ok = false    
    @msg = ""

    Precio.update_all(predeterminado: false)

    @precio = Precio.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("Marcar precio predeterminado", "precios", @precio)
    @precio.predeterminado = true

    if @precio.save

        auditoria_despues(@precio, auditoria_id)
        @guardado_ok = true
        @msg = "Precio marcado como predeterminado exitosamente."

    end
    
    rescue Exception => exc  
      # dispone el mensaje de error 
      #puts "Aqui si muestra el error ".concat(exc.message)
      if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        @eliminado = false
      end
        
    respond_to do |f|

      f.js

    end

  end



end
