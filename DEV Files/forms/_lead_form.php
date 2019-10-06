<script type="text/javascript">
  var validationARR = {Email:"email"
                     , Phone:"phone"
                     , Cell:"phone"
                     , Fax:"phone"
                     , FName:"notnull"
                     , LName:"notnull"
                     , CheckIn:"notnull"
                     , CheckOut:"notnull"
                     , numRooms:"notnull"}
</script>
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
          <input id="CheckIn" name="check_in" type="date" class="w3-input w3-round w3-row-padding" value="<?php if (isset($check_in)) {echo date('Y-m-d',strtotime($check_in));};?>" onblur="validationCheck(validationARR,this.id)" required></input>
          <p id="vCheckIn" class="w3-tiny w3-text-red"></p>
        </div>
        <div class="w3-col m2">
          <label class="w3-small fa fa-calendar-o">Check-Out</label>
          <input id="CheckOut" name="check_out" type="date" class="w3-input w3-round w3-row-padding" value="<?php if (isset($check_out)) {echo date('Y-m-d',strtotime($check_out));};?>" onblur="validationCheck(validationARR,this.id)" required></input>
          <p id="vCheckOut" class="w3-tiny w3-text-red"></p>
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
            <?=$resort_select?>
          </select>
        </div>
        <div class="w3-col m5">
          <label class="w3-small">Room Type</label>
          <select id="resort_accomodations" class="w3-select w3-round w3-row-padding w3-white" name="resort_accomodations">
            <?=$room_select?>
          </select>
        </div>
        <div class="w3-col m2">
          <label class="w3-small">Number of Rooms</label>
          <input id="numRooms" name="num_rooms" type="number" class="w3-input w3-round w3-row-padding" value="<?php echo $num_rooms;?>" onblur="validationCheck(validationARR,this.id)"></input>
          <p id="vnumRooms" class="w3-tiny w3-text-red"></p>
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
              <input id="FName" name="Adults[0][first_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="First Name" value="<?php echo $first_name;?>" onblur="validationCheck(validationARR,this.id)" required>
              <p id="vFName" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m3">
              <input name="Adults[0][middle_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Middle Name" value="<?php echo $middle_name;?>">
            </div>
            <div class="w3-col m3">
              <input id="LName" name="Adults[0][last_name]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Last Name" value="<?php echo $last_name;?>" onblur="validationCheck(validationARR,this.id)" required>
              <p id="vLName" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m1">
              <input name="Adults[0][name_suffix]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Suffix" value="<?php echo $name_suffix;?>">
            </div>
          </div>
          <div class="w3-row-padding w3-margin-bottom">
            <div class="w3-col m3">
              <label class='w3-small'>Email</label>
              <input id="Email" name="Adults[0][email]" class="w3-input w3-round w3-row-padding" type="text" placeholder="abc@xyz.com" value="<?php echo $email;?>" onblur="validationCheck(validationARR,this.id)">
              <p id="vEmail" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m2">
              <label class='w3-small'>Phone</label>
              <input id="Phone" name="Adults[0][phone]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" value="<?php echo $phone;?>" onblur="validationCheck(validationARR,this.id)">
              <p id="vPhone" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m2">
              <label class='w3-small'>Cell</label>
              <input id="Cell" name="Adults[0][cell]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" value="<?php echo $cell;?>" onblur="validationCheck(validationARR,this.id)">
              <p id="vCell" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m2">
              <label class='w3-small'>Fax</label>
              <input id="Fax" name="Adults[0][fax]" class="w3-input w3-round w3-row-padding" type="text" placeholder="123-456-5555" value="<?php echo $fax;?>" onblur="validationCheck(validationARR,this.id)">
              <p id="vFax" class="w3-tiny w3-text-red"></p>
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
          <h5>Address</h5>
          <div class="w3-row-padding w3-margin-bottom">
            <div class="w3-col m4">
              <input id="Address" name="Adults[0][address1]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Address 1" value="<?php echo $address1;?>">
              <p id="vAddress" class="w3-tiny w3-text-red"></p>
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
              <input id="City" name="Adults[0][city]" class="w3-input w3-round w3-row-padding" type="text" placeholder="City" value="<?php echo $city;?>" >
              <p id="vCity" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m3">
              <input id="State" name="Adults[0][state]" class="w3-input w3-round w3-row-padding" type="text" placeholder="State" value="<?php echo $state;?>" >
              <p id="vState" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m2">
              <input id="Zip" name="Adults[0][zip]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Zip" value="<?php echo $zip;?>">
              <p id="vZip" class="w3-tiny w3-text-red"></p>
            </div>
            <div class="w3-col m3">
              <input name="Adults[0][country]" class="w3-input w3-round w3-row-padding" type="text" placeholder="Country" value="<?php echo $country;?>">
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
