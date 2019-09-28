var validation;

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
function form_submit(formID) {
  var x, form_assign = '';
	if (!validation) {
		alert("Please complete all required fields!");
	}else {
	form_assign = document.getElementById(formID);
	x = submit_form_data(form_assign);

	if (x === 'error') {
		alert("something went wrong");
	}else {
		console.log(x);
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

    console.log(this);

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
 function validationCheck(InputID,vType) {
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
 	console.log('validate function');
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
