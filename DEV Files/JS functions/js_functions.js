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

	form_assign = document.getElementById(formID);
	x = submit_form_data(form_assign);

	if (x === 'error') {
		alert("something went wrong");
	}else {
		console.log(x);
		window.location.href = "../disney-guest-db.php";
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
	}
/*
//------------------------------
//Room type selection functions
//------------------------------
			function createOption(ddl, text, value) {
			 var opt = document.createElement('option');
			 opt.value = value;
			 opt.text = text;
			 ddl.options.add(opt);
	    }

	    function createOptions(optionsArray, ddl) {
	   		 for (i = 0; i < optionsArray.length; i++) {
	   				 createOption(ddl, optionsArray[i], optionsArray[i]);
	   		 }
	    }

			function resortSelect(ddl1, ddl2){
				//var resorts = <?php echo json_encode($_SESSION['resorts']); ?>;
				var ddl1Clean = ddl1.value.replace("’", "'");

        //loop through resorts
				for (i = 0; i < resorts.length; i++) {

					//find the selected option in the resort array
					if (ddl1Clean == Object.keys(resorts[i])[0]) {

            //assign room values to ddl2keys
						var ddl2keys = Object.values(resorts[i])[0];

						//remove existing options
						ddl2.options.length = 0;

						//pass the rooms and room selection ID to populate options
						createOptions(ddl2keys.sort(), ddl2);
						return;
					}else {
							//document.getElementById("test").innerHTML = 'Sorry, there was no match!';
							createOption(ddl2,'~Least Expensive','Least Expensive');
					}
				}
		  }*/

//------------------------------
