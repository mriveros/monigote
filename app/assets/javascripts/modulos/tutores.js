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
        $("#direccion").val(data.direccion);
        $("#telefono").val(data.telefono);

          
      }else{

        $("#nombres").focus();
        $("#nombres").val('');
        $("#apellidos").val('');
        $("#direccion").val('');
        $("#telefono").val('');
        document.getElementById("nombres").readOnly = false;
        document.getElementById("apellidos").readOnly = false;
        document.getElementById("direccion").readOnly = false;
        document.getElementById("telefono").readOnly = false;
        
       
          
      }
    },
    typeData: 'json'     
  })
}

function buscar_tutor(documento, ruta){
  
  $("#msg-documento-persona").remove();
  $('#buscar_tutor').html('');
  $.ajax({
    type: 'GET',
    url: ruta,
    data: {documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#ci").next();
        
        $("#nombres").val(data.nombres); 
        $("#apellidos").val(data.apellidos);
        $("#tutor_id").val(data.id);
    
          
      }else{

        //$("#msg").val('El Tutor no existe');
        swal('El Tutor no existe');
            
      }
    },
    typeData: 'json'     
  })
}