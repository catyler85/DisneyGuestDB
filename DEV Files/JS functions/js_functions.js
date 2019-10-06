var validation = false;



//------------------------------
//submit on "Enter"
//------------------------------
document.addEventListener("keyup", function(event) {
	event.preventDefault();
	if (event.keyCode === 13) {
		document.getElementById("submit").click();
	}
});

//------------------------------
//submit the form
//------------------------------
function form_submit(formID,ValidationARR) {
  var x, form_assign = '';
	validationCheck(ValidationARR,-1);
	if (!validation) {
		alert("Please complete all required fields!");
	}else {
	  form_assign = document.getElementById(formID);
	  x = submit_form_data(form_assign);

	  if (x === 'error') {
	  	alert("something went wrong");
	  }else {
	  	//console.log(x);
		//console.log($( formID ).serialize(););
		window.location.href = "../disney-guest-db.php";
	}
}
};



//------------------------------
//set selection values
//------------------------------
  $("select[value]").each(function() {

    $(this).val(this.getAttribute("value"));

	});

	$("checkbox[value]").each(function() {

    //console.log(this);

	});


	function row_select(x, dest_url) {
	//var table = document.getElementById('recent_leads_table');
	var table_id = $(x).parents('table').attr('id');
	var table = document.getElementById(table_id);
	var sel_row_id = table.rows[x.rowIndex].cells[0].innerHTML;
	var sel_id_type = table.rows[x.rowIndex].cells[1].innerHTML;
	  //'<?php $_SESSION["lead_id"] = "' + sel_lead_id + '";?>';
	  //sessionStorage.setItem('lead_id', 'sel_lead_id');
	  //alert("lead_id is: " + table.rows[x.rowIndex].cells[4].innerHTML);
	  window.location.assign(dest_url+'?lookup_value='+sel_row_id+'&lookup_key='+sel_id_type);
	};

	function form_clear(x) {
   document.getElementById(x).reset();
	 form_submit(x);
 };


 function copy_function() {
	 /* Get the table field */
	 var copyText = document.getElementById('one_note_table');
	 var body = document.body, range, sel;
		 if (document.createRange && window.getSelection) {
				 range = document.createRange();
				 sel = window.getSelection();
				 sel.removeAllRanges();
				 try {
						 range.selectNodeContents(copyText);
						 sel.addRange(range);
				 } catch (e) {
						 range.selectNode(copyText);
						 sel.addRange(range);
				 }
		 } else if (body.createTextRange) {
				 range = body.createTextRange();
				 range.moveToElementText(copyText);
				 range.select();
		 }

	 /* Copy the text inside the text field */
	 document.execCommand("copy");

 };
 function findObjectByKey(array, key) {
     if (!array[key]) {
             return null;
         }else {
         	   return array[key];
         }

 }
 //------------------------------
 //form validations
 //------------------------------
 	function validationField(InputID, vType) {
	var inpObj = document.getElementById(InputID);
 	var validationLocation = 'v' + InputID;
 	var validationMessage = '';
	var dict = {
		email: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
		notnull: /^(?!\s*$).+/,
		phone: /^(\s*|\(?[\d]{3}\)?[\s-]?[\d]{3}[\s-]?[\d]{4})$/
	};

 	var patt = dict[vType];
   validation = patt.test(inpObj.value);

   //inpObj.checkValidity()
 	//console.log('validate function');
  if (!validation) {

	 switch (vType) {
	 	case 'email':
	 		validationMessage = 'Please provide a valid email address.';
	 		break;
		case 'notnull':
		  validationMessage = 'This is a required field.';
			break;
		case 'phone':
			 validationMessage = 'Invalid format. 123-456-5555';
			 break;
	 	default:

	 }
		 document.getElementById(validationLocation).innerHTML = validationMessage;
		 document.getElementById(InputID).classList.add('w3-border-red');
	 }else {
		 document.getElementById(validationLocation).innerHTML = '';
		 document.getElementById(InputID).classList.remove('w3-border-red');
	 }
 };

 function validationCheck(ValidationARR,vInputID) {
  var type;
	if (vInputID === -1) {
		for (var key in ValidationARR) {
      validationField(key, ValidationARR[key]);
    }
  }else {
  	type = findObjectByKey(ValidationARR, vInputID);
		console.log("type: " + type + " ID: " + vInputID);
		validationField(vInputID, type);
  }
}

function sameAs(inputID,divID) {
  if (!document.getElementById(inputID).checked) {
  	document.getElementById(divID).style.display = "block";
  }else if (document.getElementById(inputID).checked) {
  	document.getElementById(divID).style.display = "none";
  }

}

 //add guest functions
 $('#add-guest').on("click", function(){
 	var long;
 	var i=0;
 	var rows = document.getElementById('guests').getElementsByTagName("tr").length;
 	i = rows + 1
 	long = '<tr id="g'+(rows+2)+'" ><td><hr>' +
 '<h3 id="h'+(rows+2)+'" class="w3-col m2">Guest '+(rows+2)+'</h3> ' +
 '<div class="w3-bar w3-col-row w3-row-padding">' +
 '<div class="w3-col m2">' +
 '<label>Room:</label>' +
 '<input name="Adults['+i+'][room]" class="w3-input w3-round w3 w3-margin-bottom w3-row-padding" type="text" placeholder="Room" >' +
 '</div>' +
 '<div class="w3-col m2">' +
 '<label>Child Flag</label>' +
 '<input id="cfcheck'+i+'" name="Adults['+i+'][child_flag]" onchange=childCheckbox("cfcheck'+i+'","aatvalueID'+i+'","g'+(rows+2)+'") class="w3-check w3-round w3-row-padding" type="checkbox" >' +
 '</div>' +
 '<div class="w3-col m2" id="aatvalueID'+i+'" style="display:none">' +
 '<label>Age at Travel</label>' +
 '<input name="Adults['+i+'][age_at_travel]" class="w3-input w3-round w3-row-padding" type="text" placeholder="age at travel" >' +
 '</div>' +
 '</div>' +
 '<div class="w3-row-padding w3-margin-bottom">' +
 '<div class="w3-col m2">' +
 '<input name="Adults['+i+'][name_prefix]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Prefix" >' +
 '</div>' +
 '<div class="w3-col m3">' +
 '<input id="FName'+i+'" name="Adults['+i+'][first_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="First Name" >' +
 '<p id="vFName'+i+'" class="w3-tiny w3-text-red"></p>' +
 '</div>' +
 '<div class="w3-col m3">' +
 '<input name="Adults['+i+'][middle_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Middle Name" >' +
 '</div>' +
 '<div class="w3-col m3">' +
 '<input id="LName'+i+'" name="Adults['+i+'][last_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Last Name" >' +
 '<p id="vLName'+i+'" class="w3-tiny w3-text-red"></p>' +
 '</div>' +
 '<div class="w3-col m1">' +
 '<input name="Adults['+i+'][name_suffix]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Suffix" >' +
 '</div>' +
 '</div>' +
 '<div class="w3-row-padding w3-margin-bottom">' +
 '<div class="w3-col m3">' +
 '<label class="w3-small">Email</label>' +
 '<input name="Adults['+i+'][email]" class="w3-input w3-round w3-row-padding" type="text" placeholder="abc@xyz.com" >' +
 '</div>' +
 '<div class="w3-col m2">' +
 '<label class="w3-small">Phone</label>' +
 '<input name="Adults['+i+'][phone]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" >' +
 '</div>' +
 '<div class="w3-col m2">' +
 '<label class="w3-small">Cell</label>' +
 '<input name="Adults['+i+'][cell]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" >' +
 '</div>' +
 '<div class="w3-col m2">' +
 '<label class="w3-small">Fax</label>' +
 '<input name="Adults['+i+'][fax]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" >' +
 '</div>' +
 '<div class="w3-col m3">' +
 '<label class="w3-small">Preferred Contact Method</label>' +
 '<select class="w3-select w3-round w3-row-padding w3-white" name="Adults['+i+'][contact_preference]" >' +
 '<option value="No Preference">No Preference</option>' +
 '<option value="Phone">Phone</option>' +
 '<option value="Email">Email</option>' +
 '</select>' +
 '</div>' +
 '<div class="w3-row">' +
 '<h5>Address</h5>' +
 '<label>Same as Lead</label>' +
 '<input id="sameAs'+i+'"  type="checkbox" name="same_as" onchange=sameAs("sameAs'+i+'","sameAsDiv' +i+'") value="Same as Lead" class="w3-check w3-round w3-row-padding" checked/>' +
 '<div id="sameAsDiv' +i+'" class="w3-border" style="display: none;">' +
 '<div class="w3-cell-row w3-row-padding w3-margin-bottom w3-margin-top">' +
 '<div class="w3-col m4">' +
 '<input name="Adults['+i+'][address1]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 1" >' +
 '</div>' +
 '<div class="w3-col m4">' +
 '<input name="Adults['+i+'][address2]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 2" >' +
 '</div>' +
 '<div class="w3-col m4">' +
 '<input name="Adults['+i+'][address3]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 3" >' +
 '</div>' +
 '</div>' +
 '<div class="w3-cell-row w3-row-padding w3-margin-bottom">' +
 '<div class="w3-col m4">' +
 '<input name="Adults['+i+'][city]" class="w3-input w3-round w3-row-padding" type="text" placeholder="City" >' +
 '</div>' +
 '<div class="w3-col m3">' +
 '<input name="Adults['+i+'][state]" class="w3-input w3-round w3-row-padding" type="text" placeholder="State" >' +
 '</div>' +
 '<div class="w3-col m2">' +
 '<input name="Adults['+i+'][zip]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Zip" >' +
 '</div>' +
 '<div class="w3-col m3">' +
 '<input name="Adults['+i+'][country]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Country" >' +
 '</div>' +
 '</div>' +
 '</div>' +
 '</div><div><button type="button" class="w3-btn w3-round w3-row-padding w3-pink w3-margin-bottom guest_remove" name="remove" id="g'+(rows+2)+'">Remove</button></div></td></tr>';
 	i++;		$('#guests').append(long);
 });

 $(document).on('click', '.guest_remove', function(){

 	var button_id = this.getAttribute("id");
 	$('#'+button_id+'').remove();

 	var rows = document.getElementById('guests').getElementsByTagName("tr");
 	var gnum=1;
 	for (i = 0; i < rows.length;i++) {

 		gnum = gnum + 1;
 		var vrow = 	document.getElementById('h'+(gnum+1));
 		if (vrow) {
 			vrow.innerHTML= "Guest " + gnum;
 		}
 	}
 });
