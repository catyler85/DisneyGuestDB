<?php
session_start();
?>
<!DOCTYPE html>
<html>
<title>Disney Guest DB - Verify Lead Data</title>
	<head>
    <?php
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
			 $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/db_files/form_values_ld.php";
       include_once($path);
			 include("../db_files/edit_lead_parse.php");
    ?>
    <script src="../js_functions/submit_form_data.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

  </head>

  <body style="background-color:LavenderBlush;">

    <h1 class="w3-panel w3-center w3-content">Verify Lead Data</h1>
    <hr>
		<div class="w3-container w3-center">
			<button class="w3-btn w3-round-large w3-pink" onclick="document.getElementById('one_note_modal').style.display='block'">View for One Note</button>
			<button class="w3-btn w3-round-large w3-pink" onclick="document.getElementById('launch_email').style.display='block'">Send Email</button>
			<button class="w3-btn w3-round-large w3-pink" id="submit" onclick="form_submit('edit_lead_form')">Submit</button>

		</div>
		<br>
		<!-- ../disney-guest-db.php -->
		<?php include_once("../forms/_lead_form.php"); ?>

			<!--One Note modal     -->
			<div id="one_note_modal" class="w3-modal">
			    <div class="w3-modal-content w3-card-4">
			      <header class="w3-container w3-purple">
			        <span onclick="document.getElementById('one_note_modal').style.display='none'" class="w3-button w3-display-topright">&times;</span>
			        <h2>One Note View</h2>
							<button class="w3-btn w3-pink w3-margin-bottom w3-round-large" onclick="copy_function()">Copy</button>
			      </header>
			      <div class="w3-container w3-padding">
						  <table id="one_note_table" class="w3-table w3-border w3-bordered">
								<tr>
									<td class="w3-border">Email Address</td>
									<td class="w3-border"><?php echo $email ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Ref/Guar?</td>
									<td class="w3-border"><?php if ($guaranteed_quote === 'Yes') {
									                       	echo 'Guaranteed';
									                       }else {
									                       	echo 'Reference';
									                       }  ?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Reservation #</b></td>
									<td class="w3-border"><?=$reservation_num?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Cast Member Name</b></td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Date</b></td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Time</b></td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Courtesy hold good till</b></td>
									<td class="w3-border"><?=$courtesy_hld_exp_date?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Final payment due</b></td>
									<td class="w3-border"><?=$final_payment_due_date?></td>
							  </tr>
								<tr>
									<td class="w3-border">Salutation</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border">House/Mouse/Self</td>
									<td class="w3-border"><?=$source?></td>
							  </tr>
								<tr>
									<td class="w3-border">Celebration/1st Visit?</td>
									<td class="w3-border"><?php if (strpos($previous_disney_experience, 'first') > 0 & empty($special_occasion)) {
									                       	echo 'First Visit ';
																				}else {
																					echo '';
																				}
																				if (empty($special_occasion)) {
																					echo '';
																				}else {
																					echo " - " .$special_occasion;
																				} ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Budget</td>
									<td class="w3-border"><?=$budget?></td>
							  </tr>
								<tr>
									<td class="w3-border">Check in Date</td>
									<td class="w3-border"><?=strval($check_in)?></td>
							  </tr>
								<tr>
									<td class="w3-border">Check Out Date</td>
									<td class="w3-border"><?php echo strval($check_out) ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Room - people</td>
									<td class="w3-border"><?php echo "Adults: ".$adult_num." - Children: ".$child_num."<br>".nl2br($rooms_str) ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Resort</td>
									<td class="w3-border"><?=$resort ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Room Type Preference</td>
									<td class="w3-border"><?=$resort_accomodations ?></td>
							  </tr>
								<tr>
									<td class="w3-border">     View/Bedding</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border">Tickets # and type</td>
									<td class="w3-border"><?php echo $num_of_passes.' '.$ticket_type; ?></td>
							  </tr>
								<tr>
									<td class="w3-border">     Ticket Valid</td>
									<td class="w3-border"><?=$ticket_valid_thru?></td>
							  </tr>
								<tr>
									<td class="w3-border">Dining?</td>
									<td class="w3-border"><?=$resort_package?></td>
							  </tr>
								<tr>
									<td class="w3-border">Memory maker</td>
									<td class="w3-border"><?=$memory_maker ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Travel protection</td>
									<td class="w3-border"><?=$travel_insurance ?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Refurb</b></td>
									<td class="w3-border"><?=$refurb?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Total Price</td>
									<td class="w3-border"><?=$total_cost?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Cost Savings?</td>
									<td class="w3-border"><?=$cost_savings?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Discount?</td>
									<td class="w3-border"><?=$discount_applied?></td>
							  </tr>
							</table>
			      </div>
			      <footer class="w3-container w3-purple">
			        <p class="w3-btn w3-round-large" onclick="document.getElementById('one_note_modal').style.display='none'">Close</p>
			      </footer>
			    </div>
			  </div>
  </body>
	<footer>
		<script type="text/javascript">
		var i=0;

		//add guest functions
		$('#add-guest').click(function(){
		  var long;
		  var rows = document.getElementById('guests').getElementsByTagName("tr").length;
		  i = rows + 2
		  long = '<tr id="g'+i+'" ><td><hr>' +
		'<h3 id="h'+i+'" class="w3-col m2">Guest '+(rows+2)+'</h3> ' +
		'<div class="w3-bar w3-col-row w3-row-padding">' +
		'<div class="w3-col m2">' +
		'<label>Room:</label>' +
		'<input name="Adults['+i+'][room]" class="w3-input w3-round w3 w3-margin-bottom w3-row-padding" type="text" placeholder="Room" >' +
		'</div>' +
		'<div class="w3-col m2">' +
		'<label>Child Flag</label>' +
		'<input id="cfcheck'+i+'" name="Adults['+i+'][child_flag]" onchange=childCheckbox("cfcheck'+i+'","aatvalueID'+i+'") class="w3-check w3-round w3-row-padding" type="checkbox" >' +
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
		'<input name="Adults['+i+'][first_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="First Name" >' +
		'</div>' +
		'<div class="w3-col m3">' +
		'<input name="Adults['+i+'][middle_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Middle Name" >' +
		'</div>' +
		'<div class="w3-col m3">' +
		'<input name="Adults['+i+'][last_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Last Name" >' +
		'</div>' +
		'<div class="w3-col m1">' +
		'<input name="Adults['+i+'][name_suffix]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Suffix" >' +
		'</div>' +
		'</div>' +
		'<div class="w3-cell-row w3-row-padding w3-margin-bottom">' +
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
		'<div class="w3-row-padding w3-margin-bottom">' +
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
		'<label class="w3-small">Email</label>' +
		'<input name="Adults['+i+'][email]" class="w3-input w3-round w3-row-padding" type="text" placeholder="abc@xyz.com" >' +
		'</div>' +
		'<div class="w3-col m3">' +
		'<label class="w3-small">Preferred Contact Method</label>' +
		'<select class="w3-select w3-round w3-row-padding w3-white" name="Adults['+i+'][contact_preference]" >' +
		'<option value="No Preference">No Preference</option>' +
		'<option value="Phone">Phone</option>' +
		'<option value="Email">Email</option>' +
		'</select>' +
		'</div>' +
		'</div><div><button type="button" class="w3-btn w3-round w3-row-padding w3-pink w3-margin-bottom guest_remove" name="remove" id="g'+i+'">Remove</button></div></td></tr>';
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


		function childCheckbox(checkID, inputID){
 		 const table = document.querySelectorAll('table');
 		 var row, name, child_flag;
 		 var guest_num, child_num = -1;
 		 var adult_num = 0;

 		 //loop through each row in table
 		 for (let t = 0; t <= table.length; t++) {
 			 row = table[0].rows[(t)];
 			 var inputs = row.getElementsByTagName('input');
 			 var selects = row.getElementsByTagName('select');
 			 //console.log("checkbox: " && inputs[0]);
 			 //check if checkbox is checked
 			 if (inputs[0].checked && inputs[0].type == 'checkbox') {
 				 child_num++;
 				 child_flag = true;
 				 //rename each input in row
 				 //for (var q = 0; q < inputs.length; q++) {
 				 //	name = inputs[q].name;
 				 //	name = name.replace('Adults', 'Children');
 				 //	inputs[q].setAttribute('name', name);
 				 //	//console.log(name);
 				 // }
 				//check if checkbox is unchecked
 			}else if (!inputs[0].checked && inputs[0].type == 'checkbox') {
 				 adult_num++;
 				 child_flag = false;
 				 //rename each input in row
 				 //for (var w = 0; w < inputs.length; w++) {
 				 //	name = inputs[w].name;
 				 //	name = name.replace('Children', 'Adults');
 				 //	inputs[w].setAttribute('name', name);
 			 //		//console.log(name);
 				 //}
 			 }

 			 //loop through each input within a row
 			 for (var i = 0; i < inputs.length; i++) {
 				 name = inputs[i].name;

 				 if (child_flag) {
 					 guest_num = child_num;
 					 name = name.replace('Adults', 'Children');
 					 inputs[i].setAttribute('name', name);
 				 }else {
 					 guest_num = adult_num;
 					 name = name.replace('Children', 'Adults');
 					 inputs[i].setAttribute('name', name);
 				 }
 				 //renumber guests
 				 name = name.replace(/[0-9]/,(guest_num));
 				 inputs[i].setAttribute('name', name);
 				 //console.log(name);
 			 }

 			 //loop through each select within a row
 			 for (var q = 0; q < selects.length; q++) {
 				 name = selects[q].name;

 				 if (child_flag) {
 					 guest_num = child_num;
 					 name = name.replace('Adults', 'Children');
 					 selects[q].setAttribute('name', name);
 				 }else {
 					 guest_num = adult_num;
 					 name = name.replace('Children', 'Adults');
 					 selects[q].setAttribute('name', name);
 				 }
 				 //renumber guests
 				 name = name.replace(/[0-9]/,(guest_num));
 				 selects[q].setAttribute('name', name);
 				 //console.log(name);
 			 }


 		 }


 		 if (document.getElementById(checkID).checked){
 				 document.getElementById(inputID).style.display = 'block';
 		 }
 		 else if (!document.getElementById(checkID).checked){
 				 document.getElementById(inputID).style.display = 'none';
 			 }
 	 }


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
							var resorts = <?php echo json_encode($_SESSION['resorts']); ?>;
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
					  }


		</script>
		<script src="../js_functions/js_functions.js"></script>
  </footer>
