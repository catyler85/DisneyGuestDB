<?php
$budget                     = $refurb                      = $resort                    = '';
$source                     = $country                     = $lead_id                   = '';
$address1                   = $address2                    = $address3                  = '';
$check_in                   = $handicap                    = $check_out                 = '';
$last_name                  = $state                       = $num_rooms                 = '';
$room_view                  = $first_name                  = $total_cost                = '';
$middle_name                = $name_prefix                 = $name_suffix               = '';
$ticket_type                = $cost_savings                = $cruise_addon              = '';
$memory_maker               = $room_bedding                = $other_discount            = '';
$num_of_passes              = $transportation              = $lead_guest_guid           = '';
$reservation_num            = $unique_pin_info             = $universal_addon           = '';
$discount_applied           = $guaranteed_quote            = $handicap_details          = '';
$special_occasion           = $special_requests            = $travel_insurance          = '';
$ticket_valid_thru          = $other_discount_info         = $potential_discounts       = '';
$resort_accomodations       = $courtesy_hld_exp_date       = $final_payment_due_date    = '';
$preferred_contact_method   = $previous_disney_experience  = $guid                      = '';
$room                       = $child_flag                  = $group_name                = '';
$age_at_travel              = $lead_guest_flag             = $fax                       = '';
$zip                        = $cell                        = $city                      = '';
$email                      = $phone                       = $disney_visa               = '';
$annual_passholder          = $military                    = $florida_resident          = '';
$canadian_resident          = $sue_says                    = $exclusive_promo_code      = '';
$adult_table                = $unique_pin_code             = $group_table               = $notes = '';
$child_num                  = $adult_num                   = $guest_num                 = 0;

//travel group info
$tg_arr                                                    = $form_values['travel_group'];
if (isset($tg_arr)) {
  for ($i = 0; $i < count($tg_arr); $i++) {

  $group_name                                                = $form_values['travel_group'][$i]['group_name'];
  $guid                                                      = $form_values['travel_group'][$i]['guid'];
  $room                                                      = $form_values['travel_group'][$i]['room'];
  $child_flag                                                = $form_values['travel_group'][$i]['child_flag'];
  if($child_flag){
    $tg_arr_name                                             = "Children";
  }else {
    $tg_arr_name                                             = "Adults";
  }
  if($child_flag){
    $cf_checked                                              = "checked";
    $cf_display                                              = "";
    //$child_num                                               = $child_num++;
    $guest_num                                               = $child_num++;
  }else {
    $cf_checked                                              = "";
    $cf_display                                              = "display:none";
    //$adult_num                                               = $adult_num++;
    $guest_num                                               = $adult_num++;
  }
  $age_at_travel                                             = $form_values['travel_group'][$i]['age_at_travel'];
  $lead_guest_flag                                           = $form_values['travel_group'][$i]['lead_guest_flag'];
  $name_prefix                                               = $form_values['travel_group'][$i]['name_prefix'];
  $first_name                                                = $form_values['travel_group'][$i]['first_name'];
  $middle_name                                               = $form_values['travel_group'][$i]['middle_name'];
  $last_name                                                 = $form_values['travel_group'][$i]['last_name'];
  $name_suffix                                               = $form_values['travel_group'][$i]['name_suffix'];
  $address1                                                  = $form_values['travel_group'][$i]['address1'];
  $address2                                                  = $form_values['travel_group'][$i]['address2'];
  $address3                                                  = $form_values['travel_group'][$i]['address3'];
  $city                                                      = $form_values['travel_group'][$i]['city'];
  $state                                                     = $form_values['travel_group'][$i]['state'];
  $zip                                                       = $form_values['travel_group'][$i]['zip'];
  $country                                                   = $form_values['travel_group'][$i]['country'];
  $phone                                                     = $form_values['travel_group'][$i]['phone'];
  $cell                                                      = $form_values['travel_group'][$i]['cell'];
  $email                                                     = $form_values['travel_group'][$i]['email'];
  $fax                                                       = $form_values['travel_group'][$i]['fax'];
  $preferred_contact_method                                  = $form_values['travel_group'][$i]['preferred_contact_method'];

  if (!isset($preferred_contact_method) || $preferred_contact_method === "No Preference") {
    $np_contact                                              = "selected";
    $em_contact                                              = "";
    $ph_contact                                              = "";
  }elseif ($preferred_contact_method === "Email") {
    $np_contact                                              = "";
    $em_contact                                              = "selected";
    $ph_contact                                              = "";
  }elseif ($preferred_contact_method === "Phone") {
    $np_contact                                              = "";
    $em_contact                                              = "";
    $ph_contact                                              = "selected";
  }

  $cfcheckID                                                 = "'cfcheck".$i."'";
  $aatvalueID                                                = "'aatvalue".$i."'";
  if ($lead_guest_flag != 'Y') {
    $group_table                                              .= "<hr>
      <h3 class='w3-col m2'>Guest ".($i+1)."</h3>
	    <div class='w3-bar w3-col-row w3-row-padding'>
        <div class='w3-col m1'>
          <label>Room:</label>
	        <input name='".$tg_arr_name."[".$guest_num."][room]' class='w3-input w3-round-large' type='text' placeholder='Room' value='".$room."'>
        </div>
        <div class='w3-col m1'>
          <label>Child Flag</label>
	        <input id=$cfcheckID name='".$tg_arr_name."[".$guest_num."][child_flag]' onchange=valueChanged($cfcheckID,$aatvalueID) class='w3-check w3-round-large' type='checkbox' $cf_checked>
        </div>
        <div class='w3-col m1' id=$aatvalueID style='$cf_display'>
          <label>Age at Travel</label>
	        <input name='".$tg_arr_name."[".$guest_num."][age_at_travel]' class='w3-input w3-round-large' type='text' placeholder='age at travel' value='".$age_at_travel."'>
        </div>
	    </div>
	    <div class='w3-row-padding w3-margin-bottom'>
	      <div class='w3-col m2'>
	        <label class='w3-small'>Prefix</label>
	        <input name='".$tg_arr_name."[".$guest_num."][name_prefix]' class='w3-input w3-round-large' type='text' placeholder='Prefix' value='".$name_prefix."'>
	      </div>
	      <div class='w3-col m3'>
	        <label class='w3-small'>First Name</label>
	        <input name='".$tg_arr_name."[".$guest_num."][first_name]' class='w3-input w3-round-large' type='text' placeholder='First Name' value='".$first_name."'>
	      </div>
	      <div class='w3-col m3'>
	        <label class='w3-small'>Middle Name</label>
	        <input name='".$tg_arr_name."[".$guest_num."][middle_name]' class='w3-input w3-round-large' type='text' placeholder='Middle Name' value='".$middle_name."'>
	      </div>
	      <div class='w3-col m3'>
            <label class='w3-small'>Last Name</label>
	        <input name='".$tg_arr_name."[".$guest_num."][last_name]' class='w3-input w3-round-large' type='text' placeholder='Last Name' value='".$last_name."'>
          </div>
	      <div class='w3-col m1'>
	        <label class='w3-small'>Suffix</label>
	        <input name='".$tg_arr_name."[".$guest_num."][name_suffix]' class='w3-input w3-round-large' type='text' placeholder='Suffix' value='".$name_suffix."'>
	      </div>
	    </div>
	    <div class='w3-cell-row w3-row-padding w3-margin-bottom'>
	      <div class='w3-col m4'>
	        <label class='w3-small'>Address 1</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][address1]' class='w3-input w3-round-large' type='text' placeholder='Address 1' value='".$address1."'>
	      </div>
	      <div class='w3-col m4'>
	        <label class='w3-small'>Address 2</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][address2]' class='w3-input w3-round-large' type='text' placeholder='Address 2' value='".$address2."'>
	      </div>
	      <div class='w3-col m4'>
	    	<label class='w3-small'>Address 3</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][address3]' class='w3-input w3-round-large' type='text' placeholder='Address 3' value='".$address3."'>
	      </div>
	    </div>
	    <div class='w3-cell-row w3-row-padding w3-margin-bottom'>
	      <div class='w3-col m4'>
	    	<label class='w3-small'>City</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][city]' class='w3-input w3-round-large' type='text' placeholder='City' value='".$city."'>
	      </div>
	      <div class='w3-col m3'>
	    	<label class='w3-small'>State</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][state]' class='w3-input w3-round-large' type='text' placeholder='State' value='".$state."'>
	      </div>
	      <div class='w3-col m2'>
	        <label class='w3-small'>Zip</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][zip]' class='w3-input w3-round-large' type='text' placeholder='Zip' value='".$zip."'>
	      </div>
	      <div class='w3-col m3'>
	    	<label class='w3-small'>Country</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][country]' class='w3-input w3-round-large' type='text' placeholder='Country' value='".$country."'>
	      </div>
	    </div>
	    <div class='w3-row-padding w3-margin-bottom'>
	      <div class='w3-col m2'>
	    	<label class='w3-small'>Phone</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][phone]' class='w3-input w3-round-large' type='text' placeholder='Phone' value='".$phone."'>
	      </div>
	      <div class='w3-col m2'>
	    	<label class='w3-small'>Cell</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][cell]' class='w3-input w3-round-large' type='text' placeholder='Cell' value='".$cell."'>
	      </div>
	      <div class='w3-col m2'>
	    	<label class='w3-small'>Fax</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][fax]' class='w3-input w3-round-large' type='text' placeholder='Fax' value='".$fax."'>
	      </div>
	      <div class='w3-col m3'>
	    	<label class='w3-small'>Email</label>
	    	<input name='".$tg_arr_name."[".$guest_num."][email]' class='w3-input w3-round-large' type='text' placeholder='Email' value='".$email."'>
	      </div>
	      <div class='w3-col m3'>
	    	<label class='w3-small'>Preferred Contact Method</label>
	    	<select class='w3-select w3-round-large w3-white' name='".$tg_arr_name."[".$guest_num."][contact_preference]'>
	    		<option value='No Preference'  $np_contact>No Preference</option>
	    		<option value='Phone'          $ph_contact>Phone</option>
	    		<option value='Email'          $em_contact>Email</option>
	    	</select>
	      </div>
	    </div>";
    }
  $guest_num                                                 = $i;
  }
}
//lead guest info
$lead_id                                                   = $form_values['lead']['lead_id'];
$source                                                    = $form_values['lead']['source'];
$lead_guest_guid                                           = $form_values['lead']['lead_guest_guid'];
$name_prefix                                               = $form_values['lead']['name_prefix'];
$first_name                                                = $form_values['lead']['first_name'];
$middle_name                                               = $form_values['lead']['middle_name'];
$last_name                                                 = $form_values['lead']['last_name'];
$name_suffix                                               = $form_values['lead']['name_suffix'];
$address1                                                  = $form_values['lead']['address1'];
$address2                                                  = $form_values['lead']['address2'];
$address3                                                  = $form_values['lead']['address3'];
$city                                                      = $form_values['lead']['city'];
$state                                                     = $form_values['lead']['state'];
$zip                                                       = $form_values['lead']['zip'];
$country                                                   = $form_values['lead']['country'];
$phone                                                     = $form_values['lead']['phone'];
$cell                                                      = $form_values['lead']['cell'];
$email                                                     = $form_values['lead']['email'];
$fax                                                       = $form_values['lead']['fax'];
$preferred_contact_method                                  = $form_values['lead']['preferred_contact_method'];
$previous_disney_experience                                = $form_values['lead']['previous_disney_experience'];

//vacation info
$special_occasion                                          = $form_values['lead']['special_occasion'];
$special_requests                                          = $form_values['lead']['special_requests'];
$budget                                                    = $form_values['lead']['budget'];
$check_in                                                  = $form_values['lead']['check_in'];
$check_out                                                 = $form_values['lead']['check_out'];
$transportation                                            = $form_values['lead']['transportation'];
$guaranteed_quote                                          = $form_values['lead']['guaranteed_quote'];
$reservation_num                                           = $form_values['lead']['reservation_num'];
$resort                                                    = $form_values['lead']['resort'];
$refurb                                                    = $form_values['lead']['refurb'];
$resort                                                    = $form_values['lead']['resort'];
$resort_accomodations                                      = $form_values['lead']['resort_accomodations'];
$num_rooms                                                 = $form_values['lead']['num_rooms'];
$room_bedding                                              = $form_values['lead']['room_bedding'];
$room_view                                                 = $form_values['lead']['room_view'];
$handicap                                                  = $form_values['lead']['handicap'];
$handicap_details                                          = $form_values['lead']['handicap_details'];
$ticket_type                                               = $form_values['lead']['ticket_type'];
$num_of_passes                                             = $form_values['lead']['num_of_passes'];
$notes                                                     = $form_values['lead']['notes'];
//discounts and add-ons
$potential_discounts                                       = $form_values['lead']['potential_discounts'];
$discount_arr                                              = $potential_discounts;
if (isset($discount_arr)) {

for ($q = 0; $q < count($discount_arr); $q++) {
  if (strpos($discount_arr[$q], 'Visa') > 0) {
    $disney_visa           = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'Passholder') > 0) {
    $annual_passholder     = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'ilitary') > 0) {
    $military              = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'lorida Resident') > 0) {
    $florida_resident      = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'anadian Resident') > 0) {
    $canadian_resident     = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'ue Says') > 0) {
    $sue_says              = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'xclusive Promo') > 0) {
    $exclusive_promo_code  = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'nique') > 0) {
    $unique_pin_code       = "checked='Checked'";
  } elseif (strpos($discount_arr[$q], 'ther') > 0) {
    $other_discount        = "checked='Checked'";
  }
}
}
$unique_pin_info                                           = $form_values['lead']['unique_pin_info'];
$other_discount_info                                       = $form_values['lead']['other_discount_info'];
$discount_applied                                          = $form_values['lead']['discount_applied'];
$memory_maker                                              = $form_values['lead']['memory_maker'];
$travel_insurance                                          = $form_values['lead']['travel_insurance'];
$cost_savings                                              = $form_values['lead']['cost_savings'];
$cruise_addon                                              = $form_values['lead']['cruise_addon'];
$universal_addon                                           = $form_values['lead']['universal_addon'];

//important booking info
$ticket_valid_thru                                         = $form_values['lead']['ticket_valid_thru'];
$courtesy_hld_exp_date                                     = $form_values['lead']['courtesy_hld_exp_date'];
$total_cost                                                = $form_values['lead']['total_cost'];
$final_payment_due_date                                    = $form_values['lead']['final_payment_due_date'];







?>
