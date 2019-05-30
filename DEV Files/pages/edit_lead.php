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
		<form action="#" id="edit_lead_form" name="edit_lead_form" method="post">
			<input type="hidden" name="form_name" value="edit_lead_form"></input>
		  <div id="test"></div>
			<div class="w3-container w3-cell-row">
				<!-- Vacation Info -->
				<div class="w3-container w3-panel w3-card w3-pale-red w3-margin c3-cell">
					<h3>Vacation Details</h3>
				  <div class="w3-row-padding w3-margin-bottom">
						<div class="w3-col m2">
							<label class="w3-small">Reservation Number</label>
							<input name="reservation_num" type="text" class="w3-input w3-round w3-row-padding" value="<?php echo $reservation_num;?>"></input>
						</div>
						<div class="w3-col m2">
						  <label class="w3-small">Budget</label>
						  <input name="budget" type="text" class="w3-input w3-round w3-row-padding" value="<?php echo $budget;?>"></input>
						</div>
						<div class="w3-col m2">
							<label class="w3-small fa fa-calendar-check-o">Check-In</label>
						  <input name="check_in" type="date" class="w3-input w3-round w3-row-padding" value="<?php echo date('Y-m-d',strtotime($check_in));?>"></input>
						</div>
						<div class="w3-col m2">
						  <label class="w3-small fa fa-calendar-o">Check-Out</label>
						  <input name="check_out" type="date" class="w3-input w3-round w3-row-padding" value="<?php echo date('Y-m-d',strtotime($check_out));?>"></input>
						</div>
						<div class="w3-col m2">
							<label class="w3-small">Guaranteed Quote?</label>
							<select class="w3-select w3-round w3-row-padding w3-white" name="guaranteed_quote" value="<?=$guaranteed_quote?>">
								<option value="No" >No</option>
								<option value="Yes">Yes</option>
							</select>
						</div>
						<div class="w3-col m2">
							<label class="w3-small fa fa-calendar-o">Hold Expires</label>
							<input name="courtesy_hld_exp_date" type="date" class="w3-input w3-round w3-row-padding" value="<?php if (isset($courtesy_hld_exp_date)) {echo date('Y-m-d',strtotime($courtesy_hld_exp_date));};?>"></input>
						</div>
					</div>
					<div class="w3-row-padding w3-margin-bottom">
						<div class="w3-third">
              <label>Special Requests</label>
						  <textarea name="special_requests" class="w3-input w3-round w3-row-padding" rows="5"><?php echo $special_requests; ?></textarea>
					  </div>
						<div class="w3-third">
						  <label>Special Occasion</label>
						  <textarea name="special_occasion" class="w3-input w3-round w3-row-padding" rows="5"><?php if (empty($special_occasion)) {echo '';} else {echo $special_occasion;} ?></textarea>
					  </div>
					  <div class="w3-third">
	              <label>Additional Notes</label>
							  <textarea name="notes" class="w3-input w3-round w3-row-padding" rows="5" ><?php echo $notes; ?></textarea>
						</div>
					</div>
				  <hr>
					<div class="w3-row-padding w3-margin-bottom">
						<h4>Hotel</h4>
						<div class="w3-col m5">
						  <label class="w3-small">Resort</label>
							<select id="resort" class="w3-select w3-round w3-row-padding w3-white" name="resort" onchange="resortSelect(this, document.getElementById('resort_accomodations'))">
								<?php echo $resort_select;  ?>
							</select>
						  <!--<input name="resort" type="text" class="w3-input w3-round-large" value="<?php //echo $resort;?>"></input>-->
						</div>
						<div class="w3-col m5">
						  <label class="w3-small">Room Type</label>
							<select id="resort_accomodations" class="w3-select w3-round w3-row-padding w3-white" name="resort_accomodations">
								<?php echo $room_select;  ?>
							</select>
						  <!--<input name="resort_accomodations" type="text" class="w3-input w3-round-large" value="<?php //echo $resort_accomodations;?>"></input>-->
					  </div>
						<div class="w3-col m2">
							<label class="w3-small">Number of Rooms</label>
							<input name="num_rooms" type="number" class="w3-input w3-round w3-row-padding" value="<?php echo $num_rooms;?>"></input>
						</div>
					</div>
					<div class="w3-row-padding w3-margin-bottom">
						<div class="w3-col m2">
							<label class="w3-small">Room Bedding</label>
							<input name="room_bedding" type="text" class="w3-input w3-round w3-row-padding" value="<?php echo $room_bedding;?>"></input>
						</div>
						<div class="w3-rest">
							<label class="w3-small">Refurb?</label>
							<input name="refurb" type="text" class="w3-input w3-round w3-row-padding" value="<?php echo $refurb;?>"></input>
						</div>
					</div>
					 <div class="w3-row-padding w3-margin-bottom">
					   <div class="w3-col m2">
					  	 <label class="w3-small">Source</label>
					  	 <select name="source" class="w3-input w3-round w3-row-padding w3-white" value="<?=$source?>">
                 <option value="House" >House</option>
								 <option value="Mouse" >Mouse</option>
								 <option value="Self"  >Self</option>
							 </select>
					   </div>
					   <div class="w3-col m2">
					  	 <label class="w3-small">Transportation</label>
					  	 <input name="transportation" type="text" class="w3-input w3-round w3-row-padding" value="<?php echo $transportation;?>"></input>
					   </div>
						 <div class="w3-col m2">
					  	 <label class="w3-small">Handicap</label>
							 <select class="w3-select w3-round w3-row-padding  w3-white" name="guaranteed_quote">
 								<option value="No"  <?php if (!isset($handicap) || $handicap === "No") {
 																										 echo "selected";
 																								}?>>No</option>
 								<option value="Yes" <?php if ($handicap === "Yes") {
 																										 echo "selected";
 																								}?>>Yes</option>
 							</select>
					   </div>
						 <div class="w3-rest">
					  	 <label class="w3-small">Handicap Details:</label>
					  	 <input name="handicap_details" type="text" class="w3-input w3-round w3-row-padding" value="<?php echo $handicap_details;?>"></input>
					   </div>
          </div>
						<hr>
					<!-- Lead Guest Contact Info -->
			  	<h3 class="w3-col m2">Lead Guest</h3>
					<div class="w3-row-padding w3-margin-bottom">
						<div class="w3-col m2">
						  <label>Room:</label>
              <select name="Adults[0][room]" class="w3-input w3-round w3-white w3-row-padding" value="<?php echo $room;?>">
						    <option value="Room 1">Room 1</option>
						  	<option value="Room 2">Room 2</option>
						  	<option value="Room 3">Room 3</option>
						  	<option value="Room 4">Room 4</option>
						  	<option value="Room 5">Room 5</option>
					    </select>
					  </div>
						<div class="w3-col m2">
							<label>Group Name:</label>
							<input name="group_name" class="w3-input w3-round w3-row-padding" type="text" value="<?php echo $group_name;?>">
						</div>
					</div>
					<input type="hidden" name="lead_id" value=<?php echo $lead_id; ?>></input>
					<input type="hidden" name="lead_guest_guid" value=<?php echo $lead_guest_guid; ?>></input>
			        <div class="w3-row-padding w3-margin-bottom">
			          <div class="w3-col m2">
			            <input name="Adults[0][name_prefix]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Prefix" value="<?php echo $name_prefix;?>">
								</div>
							  <div class="w3-col m3">
			            <input name="Adults[0][first_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="First Name" value="<?php echo $first_name;?>">
								</div>
								<div class="w3-col m3">
			            <input name="Adults[0][middle_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Middle Name" value="<?php echo $middle_name;?>">
								</div>
								<div class="w3-col m3">
			            <input name="Adults[0][last_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Last Name" value="<?php echo $last_name;?>">
                </div>
								<div class="w3-col m1">
			            <input name="Adults[0][name_suffix]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Suffix" value="<?php echo $name_suffix;?>">
			          </div>
							</div>
							<div class="w3-row-padding w3-margin-bottom">
								<div class="w3-col m4">
			            <input name="Adults[0][address1]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 1" value="<?php echo $address1;?>">
								</div>
							  <div class="w3-col m4">
			            <input name="Adults[0][address2]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 2" value="<?php echo $address2;?>">
								</div>
								<div class="w3-col m4">
			            <input name="Adults[0][address3]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 3" value="<?php echo $address3;?>">
								</div>
							</div>
							<div class="w3-row-padding w3-margin-bottom">
							  <div class="w3-col m4">
									<input name="Adults[0][city]" class="w3-input w3-round w3-row-padding" type="text" placeholder="City" value="<?php echo $city;?>">
								</div>
							  <div class="w3-col m3">
									<input name="Adults[0][state]" class="w3-input w3-round w3-row-padding" type="text" placeholder="State" value="<?php echo $state;?>">
								</div>
							  <div class="w3-col m2">
									<input name="Adults[0][zip]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Zip" value="<?php echo $zip;?>">
								</div>
							  <div class="w3-col m3">
									<input name="Adults[0][country]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Country" value="<?php echo $country;?>">
								</div>
			        </div>
							<div class="w3-row-padding w3-margin-bottom">
								<div class="w3-col m2">
					    	  <label class='w3-small'>Phone</label>
									<input name="Adults[0][phone]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" value="<?php echo $phone;?>">
								</div>
								<div class="w3-col m2">
					    	  <label class='w3-small'>Cell</label>
									<input name="Adults[0][cell]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" value="<?php echo $cell;?>">
								</div>
								<div class="w3-col m2">
					    	  <label class='w3-small'>Fax</label>
									<input name="Adults[0][fax]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" value="<?php echo $fax;?>">
								</div>
								<div class="w3-col m3">
					    	  <label class='w3-small'>Email</label>
									<input name="Adults[0][email]" class="w3-input w3-round w3-row-padding" type="text" placeholder="abc@xyz.com" value="<?php echo $email;?>">
								</div>
								<div class="w3-col m3">
									<label class="w3-small">Preferred Contact Method</label>
									<select class="w3-select w3-round w3-row-padding w3-white" name="Adults[0][contact_preference]" value="<?=$preferred_contact_method?>">
										<option value="" disabled hidden>Please Select</option>
										<option value="No Preference">No Preference</option>
										<option value="Phone" >Phone</option>
										<option value="Email" >Email</option>
									</select>
								</div>
							</div>
							<div class="w3-row-padding w3-margin-bottom">
								<div class="w3-rest">
									<label class="w3-small">Previous Disney Experience</label>
									<input name="Adults[0][previous_disney_experience]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Previous Disney Experience" value="<?php echo $previous_disney_experience;?>">
								</div>
							</div>
							<table id="guests"><?php echo $group_table; ?></table>
							<button type="button" class="w3-btn w3-round w3-row-padding w3-pink w3-margin-bottom" id="add-guest" name="add-guest">Add Guest</button>
							<!--end of lead guest info -->
					</div>

				<div class="w3-cell">
					<!--add-ons -->
					<div class="w3-container w3-panel w3-card w3-pale-red w3-margin">
						<h4>Tickets</h4>
						<label>Number of Passes:</label>
						<select id="num_of_passes" name="num_of_passes" type="text" class="w3-input w3-round w3-row-padding w3-white" value="<?=$num_of_passes?>">
						  <option value="Two Days">Two Days</option>
							<option value="Three Days">Three Days</option>
							<option value="Four Days">Four Days</option>
							<option value="Five Days">Five Days</option>
							<option value="Six Days">Six Days</option>
							<option value="Seven Days">Seven Days</option>
							<option value="Eight Days">Eight Days</option>
							<option value="Nine Days">Nine Days</option>
							<option value="Ten Days">Ten Days</option>
						</select>
						<label>Ticket Type</label>
						<select id="ticket_type" name="ticket_type" type="text" class="w3-input w3-round w3-row-padding w3-white" value="<?=$ticket_type?>">
						  <option value="Base">Base</option>
						  <option value="Park Hopper">Park Hopper</option>
						  <option value="Park Hopper Plus">Park Hopper Plus</option>
					  </select>
					    <h4 class="w3-padding-small">Add-ons</h4>
						<label>Dining</label>
						<select id="resort_pakage" name="resort_pakage" class="w3-input w3-round w3-row-padding w3-white" value="<?=$resort_package?>">
							<option value="No Dining Plan">No Dining Plan</option>
							<option value="Disney Quick-Service Dining Plan">Disney Quick-Service Dining Plan</option>
							<option value="Disney Dining Plan">Disney Dining Plan</option>
							<option value="Disney Deluxe Dining Plan">Disney Deluxe Dining Plan</option>
						</select>
						<label>Travel Insurance</label>
						<select id="travel_insurance" name="travel_insurance" type="text" class="w3-input w3-round w3-row-padding w3-white" value="<?=$travel_insurance?>">
						  <option value="No">No</option>
							<option value="Yes">Yes</option>
						</select>
						<label>Memory Maker</label>
						<select id="memory_maker" name="memory_maker" type="text" class="w3-input w3-round w3-row-padding w3-white" value="<?=$memory_maker?>">
						  <option value="No">No</option>
							<option value="Yes">Yes</option>
						</select>
						<label>Would you like to add a Cruise?</label>
						<select id="cruise_addon" name="cruise_addon" type="text" class="w3-input w3-round w3-row-padding w3-white" value="<?=$cruise_addon?>">
						  <option value="No">No</option>
							<option value="Yes">Yes</option>
						</select>
						<label>Would you like to add Universal?</label>
						<select id="universal_addon" name="universal_addon" type="text" class="w3-input w3-round w3-row-padding w3-margin-bottom w3-white" value="<?=$universal_addon?>">
						  <option value="No">No</option>
							<option value="Yes">Yes</option>
						</select>
						</div>
						<!--potential_discounts -->
					<div class="w3-container w3-panel w3-card w3-pale-red w3-margin">
						<h3>Potential Discounts</h3>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Disney Visa" type="checkbox" <?php echo $disney_visa;?>>
								<label>Disney Visa</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Annual Passholder" type="checkbox" <?php echo $annual_passholder;?>>
								<label>Annual Passholder</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Military" type="checkbox" <?php echo $military?>>
								<label>Military</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Florida Resident" type="checkbox" <?php echo $florida_resident?>>
								<label>Florida Resident</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Canadian Resident" type="checkbox" <?php echo $canadian_resident?>>
								<label>Canadian Resident</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Sue Says" type="checkbox" <?php echo $sue_says?>>
								<label>"Sue Says"</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Exclusive Promotional Code" type="checkbox" <?php echo $exclusive_promo_code?>>
								<label>Exclusive Promotional Code</label></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Unique Pin Code" type="checkbox" <?php echo $unique_pin_code?>>
								<label>Unique Pin Code</label></p>
				        <p><textarea name="unique_pin_info" class="w3-input w3-round-large" rows="3" cols="3"><?php echo $unique_pin_info?></textarea></p>
								<p>
								<input class="w3-check w3-padding" name="potential_discounts[]" value="Other" type="checkbox" <?php echo $other_discount?>>
								<label>Other</label></p>
								<p><textarea name="other_discount_info" class="w3-input w3-round-large" rows="3" cols="3"></textarea></p>
					</div>
				</div>
			  </div>


			</form>

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
				var row, name;

        //loop through each row in table
				for (let t = 0; t <= table.length; t++) {
	        row = table[0].rows[(t)];
	        var inputs = row.getElementsByTagName('input');

          //loop through each input within a row
					for (var i = 0; i < inputs.length; i++) {
						name = inputs[i].name;
            //check if checkbox is checked
						if (inputs[i].checked && inputs[i].type == 'checkbox') {
              //rename each input in row
							for (var q = 0; q < inputs.length; q++) {
								name = inputs[q].name;
								name = name.replace('Adults', 'Children');
								inputs[q].setAttribute('name', name);
								//console.log(name);

							}
             //check if checkbox is unchecked
						}else if (!inputs[i].checked && inputs[i].type == 'checkbox') {
              //rename each input in row
							for (var w = 0; w < inputs.length; w++) {
								name = inputs[w].name;
								name = name.replace('Children', 'Adults');
								inputs[w].setAttribute('name', name);
								//console.log(name);
							}
						}
            //renumber guests
						name = name.replace(/[0-9]/,(t+2));
						inputs[i].setAttribute('name', name);
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
