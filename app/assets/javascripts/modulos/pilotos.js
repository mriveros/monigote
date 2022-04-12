//--------------------------------------------------------------//
function buscar_persona_v2(tipo_documento_id, nacionalidad_id, documento, ruta){

  $("#msg-documento-persona").remove();
  $('#buscar_perso').html('');
  $.ajax({
    type: 'GET',
    url: ruta,
    data: {tipo_documento_id: tipo_documento_id, nacionalidad_id: nacionalidad_id, documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#ci").next();
        
        $("#nombres").val(data.nombre_persona); 
        $("#apellidos").val(data.apellido_persona);
        $("#piloto_fecha_nacimiento").val(data.fecha_nacimiento);
        $("#direccion").val(data.direccion);
        $("#telefono").val(data.telefono);

          
      }else{

        $("#nombres").focus();
        $("#nombres").val('');
        $("#apellidos").val('');
        $("#piloto_grupo_sanguineo_id").val('');
        $("#piloto_fecha_nacimiento").val('');
        $("#direccion").val('');
        $("#telefono").val('');
        document.getElementById("nombres").readOnly = false;
        document.getElementById("apellidos").readOnly = false;
        document.getElementById("piloto_fecha_nacimiento").readOnly = false;
        document.getElementById("direccion").readOnly = false;
        document.getElementById("telefono").readOnly = false;
        
       
          
      }
    },
    typeData: 'json'     
  })
}

function buscar_piloto(documento, ruta){
  
  $("#msg-documento-persona").remove();
  $('#buscar_piloto').html('');
  $.ajax({
    type: 'GET',
    url: ruta,
    data: {documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#ci").next();
        
        $("#nombres").val(data.nombres); 
        $("#apellidos").val(data.apellidos);
        $("#piloto_id").val(data.id);
    
          
      }else{

        //$("#msg").val('El Piloto no existe');
        swal('El Piloto no existe');
            
      }
    },
    typeData: 'json'     
  })
}