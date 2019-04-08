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
$adult_table                = $unique_pin_code             = $group_table               = '';
$child_num                  = $adult_num                   = $guest_num                 = 0;

//travel group info
//$group_name                                                = $form_values['travel_group'][i]['group_name'];
//$guid                                                      = $form_values['travel_group'][i]['guid'];
//$room                                                      = $form_values['travel_group'][i]['room'];
//$child_flag                                                = $form_values['travel_group'][i]['child_flag'];
//$age_at_travel                                             = $form_values['travel_group'][i]['age_at_travel'];
//$lead_guest_flag                                           = $form_values['travel_group'][i]['lead_guest_flag'];

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
//discounts and add-ons
$potential_discounts                                       = $form_values['lead']['potential_discounts'];
$discount_arr                                              = $potential_discounts;
if (isset($discount_arr)) {

for ($i = 0; $i < count($discount_arr); $i++) {
  if (strpos($discount_arr[$i], 'Visa') > 0) {
    $disney_visa           = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'Passholder') > 0) {
    $annual_passholder     = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'ilitary') > 0) {
    $military              = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'lorida Resident') > 0) {
    $florida_resident      = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'anadian Resident') > 0) {
    $canadian_resident     = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'ue Says') > 0) {
    $sue_says              = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'xclusive Promo') > 0) {
    $exclusive_promo_code  = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'nique') > 0) {
    $unique_pin_code       = "checked='Checked'";
  } elseif (strpos($discount_arr[$i], 'ther') > 0) {
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
