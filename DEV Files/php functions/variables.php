<?php
$budget                     = $refurb                      = $resort                    = null;
$source                     = $country                     = $lead_id                   = null;
$address1                   = $address2                    = $address3                  = null;
$check_in                   = $handicap                    = $check_out                 = null;
$last_name                  = $state                       = $num_rooms                 = null;
$room_view                  = $first_name                  = $total_cost                = null;
$middle_name                = $name_prefix                 = $name_suffix               = null;
$ticket_type                = $cost_savings                = $cruise_addon              = null;
$memory_maker               = $room_bedding                = $other_discount            = null;
$num_of_passes              = $transportation              = $lead_guest_guid           = null;
$reservation_num            = $unique_pin_info             = $universal_addon           = null;
$discount_applied           = $guaranteed_quote            = $handicap_details          = null;
$special_occasion           = $special_requests            = $travel_insurance          = null;
$ticket_valid_thru          = $other_discount_info         = $potential_discounts       = null;
$resort_accomodations       = $courtesy_hld_exp_date       = $final_payment_due_date    = null;
$preferred_contact_method   = $previous_disney_experience  = $guid                      = null;
$no_dining                  = $dining                      = $qs_dining                 = null;
$rooms_str                  = $dlx_dining                  = $notes                     = null;
$room                       = $child_flag                  = $group_name                = null;
$age_at_travel              = $lead_guest_flag             = $fax                       = null;
$zip                        = $cell                        = $city                      = null;
$email                      = $phone                       = $disney_visa               = null;
$annual_passholder          = $military                    = $florida_resident          = null;
$canadian_resident          = $sue_says                    = $exclusive_promo_code      = null;
$resort_select              = $room_select                 = $source_select             = null;
$adult_table                = $unique_pin_code             = $group_table               = null;
$child_num                  = $adult_num                   = $guest_num                 = 0;

include_once ("../db_files/form_values_ld.php");
//resort arrays
$resort_arr                                                = $form_values['resorts'];
$_SESSION["resorts"]                                       = str_replace("'",  "’",$form_values['resorts']);
foreach ($resort_arr as $key => $value) {
  //ksort($value);
  foreach ($value as $resort_name => $resort_rooms) {
    if ($resort === $resort_name) {
      $v_select = "selected";
    }else {
      $v_select = "";
    }
    $resort_select   .= "<option value='".str_replace("'",  "’", $resort_name)."' ".$v_select."  >$resort_name</option>";

    if ($v_select === "selected") {
      foreach ($resort_rooms as $room_key => $room_value) {
        if ($resort_accomodations === $room_value) {
          $v_select = "selected";
        }else {
          $v_select = "";
        }
        $room_select   .= "<option value='".$room_value."' ".$v_select."  >$room_value</option>";
      }
    }


  }
}

 ?>
