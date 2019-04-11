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
			<button class="w3-btn w3-round-large w3-pink" id="submit" onclick="form_submit()">Submit</button>

		</div>
		<br>
		<!-- ../disney-guest-db.php -->
		<form action="#" id="new_lead_form" name="new_lead_form" method="post">
			<input type="hidden" name="form_name" value="new_lead_form"></input>
		  <div id="test"><?php echo var_dump($form_values['resorts']);?></div>

			<div class="w3-container w3-cell-row">
				<!-- Vacation Info -->
				<div class="w3-container w3-panel w3-card w3-pale-red w3-margin c3-cell">
					<h3>Vacation Details</h3>
				  <div class="w3-row-padding w3-margin-bottom">
						<div class="w3-col m2">
							<label class="w3-small">Reservation Number</label>
							<input name="reservation_num" type="text" class="w3-input w3-round-large" value="<?php echo $reservation_num;?>"></input>
						</div>
						<div class="w3-col m2">
						  <label class="w3-small">Budget</label>
						  <input name="budget" type="text" class="w3-input w3-round-large" value="<?php echo $budget;?>"></input>
						</div>
						<div class="w3-col m2">
							<label class="w3-small fa fa-calendar-check-o">Check-In</label>
						  <input name="check_in" type="date" class="w3-input w3-round-large" value="<?php echo date('Y-m-d',strtotime($check_in));?>"></input>
						</div>
						<div class="w3-col m2">
						  <label class="w3-small fa fa-calendar-o">Check-Out</label>
						  <input name="check_out" type="date" class="w3-input w3-round-large" value="<?php echo date('Y-m-d',strtotime($check_out));?>"></input>
						</div>
						<div class="w3-col m2">
							<label class="w3-small">Guaranteed Quote?</label>
							<select class="w3-select w3-round-large w3-white" name="guaranteed_quote">
								<option value="No"  <?php if (!isset($guaranteed_quote) || $guaranteed_quote === "No") {
																										 echo "selected";
																								}?>>No</option>
								<option value="Yes" <?php if ($guaranteed_quote === "Yes") {
																										 echo "selected";
																								}?>>Yes</option>
							</select>
						</div>
						<div class="w3-col m2">
							<label class="w3-small fa fa-calendar-o">Hold Expires</label>
							<input name="courtesy_hld_exp_date" type="date" class="w3-input w3-round-large" value="<?php if (isset($courtesy_hld_exp_date)) {echo date('Y-m-d',strtotime($courtesy_hld_exp_date));};?>"></input>
						</div>

					</div>
				  <hr>
					<div class="w3-row-padding w3-margin-bottom">
						<h4>Hotel</h4>
						<div class="w3-col m3">
						  <label class="w3-small">Resort</label>
						  <input name="resort" type="text" class="w3-input w3-round-large" value="<?php echo $resort;?>"></input>
						</div>
						<div class="w3-col m2">
						  <label class="w3-small">Room Type</label>
						  <input name="resort_accomodations" type="text" class="w3-input w3-round-large" value="<?php echo $resort_accomodations;?>"></input>
					  </div>
						<div class="w3-col m2">
							<label class="w3-small">Number of Rooms</label>
							<input name="num_rooms" type="number" class="w3-input w3-round-large" value="<?php echo $num_rooms;?>"></input>
						</div>
						<div class="w3-col m2">
							<label class="w3-small">Room Bedding</label>
							<input name="room_bedding" type="text" class="w3-input w3-round-large" value="<?php echo $room_bedding;?>"></input>
						</div>
						<div class="w3-rest">
							<label class="w3-small">Refurb?</label>
							<input name="refurb" type="number" class="w3-input w3-round-large" value="<?php echo $refurb;?>"></input>
						</div>
					</div>
					 <div class="w3-row-padding w3-margin-bottom">
					   <div class="w3-col m2">
					  	 <label class="w3-small">Source</label>
					  	 <input name="source" type="text" class="w3-input w3-round-large" value="<?php echo $source;?>"></input>
					   </div>
					   <div class="w3-col m2">
					  	 <label class="w3-small">Transportation</label>
					  	 <input name="transportation" type="text" class="w3-input w3-round-large" value="<?php echo $transportation;?>"></input>
					   </div>
						 <div class="w3-col m2">
					  	 <label class="w3-small">Handicap</label>
							 <select class="w3-select w3-round-large  w3-white" name="guaranteed_quote">
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
					  	 <input name="handicap_details" type="text" class="w3-input w3-round-large" value="<?php echo $handicap_details;?>"></input>
					   </div>
          </div>
						<hr>
					<!-- Lead Guest Contact Info -->
			  	<h3 class="w3-col m2">Lead Guest</h3>
					<div class="w3-bar"><label class="w3-col">Room:</label>
						<input name="room" class="w3-input w3-round-large w3-col m1" type="text" placeholder="Room" value="<?php echo $room;?>">
					</div>
					<input type="hidden" name="lead_id" value=<?php echo $lead_id; ?>></input>
					<input type="hidden" name="lead_guest_guid" value=<?php echo $lead_guest_guid; ?>></input>
			        <div class="w3-row-padding w3-margin-bottom">
			          <div class="w3-col m2">
									<label class="w3-small">Prefix</label>
			            <input name="name_prefix" class="w3-input w3-round-large" type="text" placeholder="Prefix" value="<?php echo $name_prefix;?>">
								</div>
							  <div class="w3-col m3">
									<label class="w3-small">First Name</label>
			            <input name="first_name" class="w3-input w3-round-large" type="text" placeholder="First Name" value="<?php echo $first_name;?>">
								</div>
								<div class="w3-col m3">
									<label class="w3-small">Middle Name</label>
			            <input name="middle_name" class="w3-input w3-round-large" type="text" placeholder="Middle Name" value="<?php echo $middle_name;?>">
								</div>
								<div class="w3-col m3">
									<label class="w3-small">Last Name</label>
			            <input name="last_name" class="w3-input w3-round-large" type="text" placeholder="Last Name" value="<?php echo $last_name;?>">
                </div>
								<div class="w3-col m1">
									<label class="w3-small">Suffix</label>
			            <input name="name_suffix" class="w3-input w3-round-large" type="text" placeholder="Suffix" value="<?php echo $name_suffix;?>">
			          </div>
							</div>
							<div class="w3-cell-row w3-row-padding w3-margin-bottom">
								<div class="w3-col m4">
									<label class="w3-small">Address 1</label>
			            <input name="address1" class="w3-input w3-round-large" type="text" placeholder="Address 1" value="<?php echo $address1;?>">
								</div>
							  <div class="w3-col m4">
									<label class="w3-small">Address 2</label>
			            <input name="address2" class="w3-input w3-round-large" type="text" placeholder="Address 2" value="<?php echo $address2;?>">
								</div>
								<div class="w3-col m4">
									<label class="w3-small">Address 3</label>
			            <input name="address2" class="w3-input w3-round-large" type="text" placeholder="Address 3" value="<?php echo $address3;?>">
								</div>
							</div>
							<div class="w3-cell-row w3-row-padding w3-margin-bottom">
							  <div class="w3-col m4">
									<label class="w3-small">City</label>
									<input name="city" class="w3-input w3-round-large" type="text" placeholder="City" value="<?php echo $city;?>">
								</div>
							  <div class="w3-col m3">
									<label class="w3-small">State</label>
									<input name="state" class="w3-input w3-round-large" type="text" placeholder="State" value="<?php echo $state;?>">
								</div>
							  <div class="w3-col m2">
									<label class="w3-small">Zip</label>
									<input name="zip" class="w3-input w3-round-large" type="text" placeholder="Zip" value="<?php echo $zip;?>">
								</div>
							  <div class="w3-col m3">
									<label class="w3-small">Country</label>
									<input name="country" class="w3-input w3-round-large" type="text" placeholder="Country" value="<?php echo $country;?>">
								</div>
			        </div>
							<div class="w3-row-padding w3-margin-bottom">
								<div class="w3-col m2">
									<label class="w3-small">Phone</label>
									<input name="phone" class="w3-input w3-round-large" type="text" placeholder="Phone" value="<?php echo $phone;?>">
								</div>
								<div class="w3-col m2">
									<label class="w3-small">Cell</label>
									<input name="cell" class="w3-input w3-round-large" type="text" placeholder="Cell" value="<?php echo $cell;?>">
								</div>
								<div class="w3-col m2">
									<label class="w3-small">Fax</label>
									<input name="fax" class="w3-input w3-round-large" type="text" placeholder="Fax" value="<?php echo $fax;?>">
								</div>
								<div class="w3-col m3">
									<label class="w3-small">Email</label>
									<input name="email" class="w3-input w3-round-large" type="text" placeholder="Email" value="<?php echo $email;?>">
								</div>
								<div class="w3-col m3">
									<label class="w3-small">Preferred Contact Method</label>
									<select class="w3-select w3-round-large w3-white" name="contact_preference">
										<option value="No Preference"  <?php if (!isset($preferred_contact_method) || $preferred_contact_method === "No Preference") {
																												 echo "selected";
																										}?>>No Preference</option>
										<option value="Phone" <?php if ($preferred_contact_method === "Phone") {
																												 echo "selected";
																										}?>>Phone</option>
										<option value="Email" <?php if ($preferred_contact_method === "Email") {
																												 echo "selected";
																										}?>>Email</option>
									</select>
								</div>
							</div>
							<div class="w3-row-padding w3-margin-bottom">
								<div class="w3-rest">
									<label class="w3-small">Previous Disney Experience</label>
									<input name="previous_disney_experience" class="w3-input w3-round-large" type="text" placeholder="Previous Disney Experience" value="<?php echo $previous_disney_experience;?>">
								</div>
							</div>
							<hr>
							<!--end of lead guest info -->
					</div>

				<div class="w3-cell">
					<!--add-ons -->
					<div class="w3-container w3-panel w3-card w3-pale-red w3-margin">
						<h4>Tickets</h4>
						<label>Number of Passes:</label>
						<input id="num_of_passes" name="num_of_passes" type="text" class="w3-input w3-round-large" value="<?php echo $num_of_passes;?>"></input>
						<label>Ticket Type</label>
						<input id="ticket_type" name="ticket_type" type="text" class="w3-input w3-round-large" value="<?php echo $ticket_type;?>"></input>
					    <h4 class="w3-padding-small">Add-ons</h4>
						<label>Travel Insurance</label>
						<input id="travel_insurance" name="travel_insurance" type="text" class="w3-input w3-round-large" value="<?php echo $travel_insurance;?>"></input>
						<label>Memory Maker</label>
						<input id="memory_maker" name="memory_maker" type="text" class="w3-input w3-round-large" value="<?php echo $memory_maker;?>"></input>
						<label>Would you like to add a Cruise?</label>
						<input id="cruise_addon" name="cruise_addon" type="text" class="w3-input w3-round-large" value="<?php echo $cruise_addon;?>"></input>
						<label>Would you like to add Universal?</label>
						<input id="universal_addon" name="universal_addon" type="text" class="w3-input w3-round-large" value="<?php echo $universal_addon;?>"></input>
            <label>Special Requests</label>
						<input type="text" name="special_requests" class="w3-input w3-round-large" value=<?php echo $special_requests; ?>></input>
						<label>Special Occasion</label>
						<input type="text" name="special_occasion" class="w3-input w3-round-large w3-margin-bottom" value=<?php if (strpos($previous_disney_experience, 'first') > 0) {echo 'First Visit ';}else {echo '';}if (empty($special_occasion)) {echo '';}else {echo " - " .$special_occasion;} ?>></input>
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

        <!--travel group -->
				<div class="w3-cell w3-cell-row">
				  <!-- Adults -->
				  <div class="w3-container w3-card w3-pale-red w3-margin">
			      <h3>Adults - <?php if (isset($adult_num)) {echo $adult_num;};?></h3>
					  <?php echo $adult_table ?>
				  </div>
					<!-- Children -->
				  <div class="w3-container w3-card w3-pale-red w3-margin">
			      <h3>Children - <?php if (isset($child_num)) {echo $child_num;};?></h3>
					  <?php echo $child_table ?>
				  </div>
			  </div>
				<!--end travel group -->


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
									<td class="w3-border"></td>
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
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey w3-right-align"><b>Final payment due</b></td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border">Salutation</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border">House/Mouse/Self</td>
									<td class="w3-border"><?php echo $source." - ".$find_small_world; ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Celebration/1st Visit?</td>
									<td class="w3-border"><?php if (strpos($previous_disney_experience, 'first') > 0) {
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
									<td class="w3-border"><?php echo $budget ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Check in Date</td>
									<td class="w3-border"><?php echo strval($check_in) ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Check Out Date</td>
									<td class="w3-border"><?php echo strval($check_out) ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Room - people</td>
									<td class="w3-border"><?php echo "Adults: ".$adult_num." - Children: ".$child_num."<br>".$rooms_str ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Resort</td>
									<td class="w3-border"><?php echo $resort ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Room Type Preference</td>
									<td class="w3-border"><?php echo $resort_accomodations ?></td>
							  </tr>
								<tr>
									<td class="w3-border">     View/Bedding</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border">Tickets # and type</td>
									<td class="w3-border"><?php echo 'Number of Passes: '.$num_of_passes.' - Ticket Type: ';
									                           if ($park_hopper === 'Yes' && $park_hopper_plus === 'Yes') {
									                           	echo 'Park Hopper Plus';
									                           } elseif ($park_hopper === 'Yes' && $park_hopper_plus === 'No') {
									                           	echo 'Park Hopper';
									                           } else {
									                           	echo 'Standard';}; ?></td>
							  </tr>
								<tr>
									<td class="w3-border">     Ticket Valid</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border">Dining?</td>
									<td class="w3-border"><?php if (strpos($resort_pakage, 'No')) {
									                            	echo 'No dining package';
																							} elseif (strpos($resort_pakage, 'Quick Service plan')) {
																								echo 'Quick Service plan';
																							} elseif (strpos($resort_pakage, 'Table Service Dining plan')) {
																								echo 'Table Service Dining plan';
																							} elseif (strpos($resort_pakage, 'Deluxe Dining Plan')) {
																								echo 'Deluxe Dining Plan';
									                            } ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Memory maker</td>
									<td class="w3-border"><?php echo $memory_maker ?></td>
							  </tr>
								<tr>
									<td class="w3-border">Travel protection</td>
									<td class="w3-border"><?php echo $travel_insurance ?></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Refurb</b></td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Total Price</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Cost Savings?</td>
									<td class="w3-border"></td>
							  </tr>
								<tr>
									<td class="w3-border w3-text-grey"><b>Discount?</td>
									<td class="w3-border"></td>
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
