<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta tietoja</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="5" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>			
				<th></th>	
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="submit" id="tallenna" value="Tallenna muutokset"></td>
			</tr>
		</tbody>
	</table>
		<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){
	$("#takaisin").click(function(){	//kunteelee takaisin-painiketta 
		document.location="listaaasiakkaat.jsp";
	});
	
	var asiakas_id = requestURLParam("asiakas_id");
	$.ajax({url:"asiakkaat/haeyksi/"+asiakas_id, type:"GET", dataType:"json", success:function(result) {
		$("#asiakas_id").val(result.asiakas_id);
		$("#etunimi").val(result.etunimi);
		$("#sukunimi").val(result.sukunimi);
		$("#puhelin").val(result.puhelin);
		$("#sposti").val(result.sposti);
	}
		});
	
	$("#tiedot").validate({			//tiedot-lomakkeen validointi			
		rules: {
			etunimi:  {
				required: true,
				minlength: 2,
				maxlength:50
			},	
			sukunimi:  {
				required: true,
				minlength: 2,
				maxlength:50
			},
			puhelin:  {
				required: true,
				digits: true,
				minlength: 7,
				maxlength:20
			},	
			sposti:  {
				required: true,
				email:true,
				minlength: 5,
				maxlength: 50
			}	
		},
		messages: {					//viestit, jos validointiehdot ei täyty
			etunimi: {     
				required: "Puuttuu",
				minlength: "Liian lyhyt",
				maxlength: "Liian pitkä"
			},
			sukunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt",
				maxlength: "Liian pitkä"
			},
			puhelin: {
				required: "Puuttuu",
				digits: "Vain numerot sallittu",
				minlength: "Liian lyhyt",
				maxlength: "Liian pitkä"
			},
			sposti: {
				required: "Puuttuu",
				email: "Virheellinen sähköpostiosoite",
				minlength: "Liian lyhyt",
				maxlength: "Liian pitkä"
			}
		},			
		submitHandler: function(form) {	//kun validointi menee läpi, kutsutaan lisaaTiedot-funktiota
			paivitaTiedot();
		}		
	});
	$("#etunimi").focus(); // siirtää kursorin etunimi-kenttään sivun latautuessa
});

function paivitaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //serialize muuttaa lomakkeen tiedot muuttuja/arvo-pareiksi rekno:arvo&merkki:arvo&..., mutta REST tarvii JSON stringin>formDataJsonStr-funktio muuttaa sen (sijainti main.js)
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) { //kutsuu autot servletin doPut-funktiota, result on joko {"response:1"} tai {"response:0"}       
		if(result.response==0){
      	$("#ilmo").html("Asiakkaan tietojen muuttaminen epäonnistui.");
      }else if(result.response==1){			
      	$("#ilmo").html("Asiakkaan muuttaminen onnistui.");
      	$("#etunimi", "#sukunimi", "#puhelin", "#sposti").val("");
		}
  }});	
}
</script>
</html>