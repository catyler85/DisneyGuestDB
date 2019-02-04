<?php

$first_name                 = $last_name                   = $address1              = '';
$address2                   = $city                        = $state                 = '';
$zip                        = $phone                       = $cell                  = '';
$email                      = $budget                      = $resort                = '';
$country                    = $check_in                    = $handicap              = '';
$check_out                  = $num_rooms                   = $park_hopper           = '';
$cruise_addon               = $memory_maker                = $package_type          = '';
$num_of_passes              = $resort_pakage               = $transportation        ='';
$travel_insurance           = $unique_pin_code             = $universal_addon       = '';
$find_small_world           = $guaranteed_quote            = $park_hopper_plus      = '';
$special_requests           = $previous_small_world        = $resort_accomodations  = '';
$preferred_contact_method   = $previous_disney_experience  = $park_hopper_plus      = '';
$adult_table                = $child_table                 = $discount_table        = '';
$disney_visa                = $annual_passholder           = $military              = "";
$florida_resident           = $other_discount_info         = $other_discount        = '';
$canadian_resident          = $sue_says                    = $exclusive_promo_code  = '';
$agent_name                 = $source                      = $unique_pin_info       = '';
$handicap_details           = $special_occasion            = $adults_str            = '';
$children_str               = $rooms_str                   = '';
$child_num                  = $adult_num                   = 0;

$house_arr = array("Previous Guest of Small World Vacations", "Small World Vacations Blog", "Family or Friend is currently using Small World Vacations", "Family or Friends Referred Me","Small World Vacations Billboard");
$mouse_arr = array("Touringplans.com", "Disney Food Blog", "MouseSavers.com Hot Deals", "MouseSavers.com","MouseSavers");


if (isset($_POST["lead_email_text"])) {

	$email_var = $_POST["lead_email_text"];
	$value = htmlspecialchars($email_var, ENT_QUOTES);
	require 'db_connect.php';
	$result = pg_query($db, "SELECT * FROM dgmain.dg_lead_email_parse_fn('$value')");

	$row = pg_fetch_row($result);
	$lead = json_decode($row[0]);

pg_close($db);
if (isset($lead)) {

foreach ($lead as $key => $value) {
	if ($key === 'first_name') {
		$first_name                  = $value;
	} elseif ($key === 'last_name') {
		$last_name                   = $value;
	} elseif ($key === 'address1') {
	  $address1                    = $value;
  } elseif ($key === 'address2') {
	  $address2                    = $value;
  } elseif ($key === 'city') {
	  $city                        = $value;
  } elseif ($key === 'state') {
	  $state                       = $value;
  } elseif ($key === 'zip') {
	  $zip                         = $value;
  } elseif ($key === 'phone') {
	  $phone                       = $value;
  } elseif ($key === 'email') {
	  $email                       = $value;
  } elseif ($key === 'cell') {
	  $cell                        = $value;
  } elseif ($key === 'check_in') {
	  $check_in                    = $value;
  } elseif ($key === 'check_out') {
	  $check_out                   = $value;
  } elseif ($key === 'budget') {
	  $budget                      = $value;
  } elseif ($key === 'resort') {
	  $resort                      = $value;
  } elseif ($key === 'country') {
	  $country                     = $value;
  } elseif ($key === 'handicap') {
	  $handicap                    = $value;
  } elseif ($key === 'handicap_details') {
	  $handicap_details            = $value;
  } elseif ($key === 'num_rooms') {
	  $num_rooms                   = $value;
  } elseif ($key === 'park_hopper') {
	  $park_hopper                 = $value;
  } elseif ($key === 'park_hopper_plus') {
	  $park_hopper_plus            = $value;
  } elseif ($key === 'cruise_addon') {
	  $cruise_addon                = $value;
  } elseif ($key === 'memory_maker') {
	  $memory_maker                = $value;
  } elseif ($key === 'package_type') {
	  $package_type                = $value;
  } elseif ($key === 'num_of_passes') {
	  $num_of_passes               = $value;
  } elseif ($key === 'resort_pakage') {
	  $resort_pakage               = $value;
  } elseif ($key === 'transportation') {
	  $transportation              = $value;
  } elseif ($key === 'travel_insurance') {
	  $travel_insurance            = $value;
  } elseif ($key === 'unique_pin_code') {
	    if (strpos($value, 'Yes') > 0) {
	    	$unique_pin_code         = "checked='Checked'";
	    }
  } elseif ($key === 'unique_pin_info') {
	  $unique_pin_info             = $value;
  } elseif ($key === 'universal_addon') {
	  $universal_addon             = $value;
  } elseif ($key === 'find_small_world') {
	  $find_small_world            = $value;
  } elseif ($key === 'agent_name') {
	  $agent_name                  = $value;
  } elseif ($key === 'guaranteed_quote') {
	  $guaranteed_quote            = $value;
  } elseif ($key === 'special_requests') {
	  $special_requests            = $value;
  } elseif ($key === 'previous_small_world') {
	  $previous_small_world        = $value;
  } elseif ($key === 'special_occasion') {
	  $special_occasion            = $value;
  } elseif ($key === 'resort_accomodations') {
	  $resort_accomodations        = $value;
  } elseif ($key === 'preferred_contact_method') {
	  $preferred_contact_method    = $value;
  } elseif ($key === 'previous_disney_experience') {
	  $previous_disney_experience  = $value;
  } elseif ($key === 'other_discount_info') {
	  $other_discount_info  = $value;
  }
  //Adults
	elseif ($key === 'adults') {

		$adult_arr  = $value;
		$adult_table .= "<table class='w3-table w3-padding' id='adult_table'>";

		for ($i = 0; $i < count($adult_arr); $i++) {

			${"adult" . $i} = $adult_arr[$i];
      $adult_num      = $i + 1;
			//$adult_table   .= "<tr><td><div'><label class='w3-small'>Adult ".$adult_num."</label><input name='a".$adult_num."-name' class='w3-input w3-round-large' type='text' placeholder='Name' value='".${"adult" . $i}->{'adult_name'}."'></div></td><td><div><label class='w3-small'>Room</label><input name='a".$adult_num."-room' class='w3-input w3-round-large' type='text' placeholder='Room' value='".${"adult" . $i}->{'room'}."'></div></td></tr>";
			//"Adults":[{"Adult":{"name":"value","room":"value"}}]
			$adult_table   .= "<tr><td><div'><label class='w3-small'>Adult ".$adult_num."</label><input name='Adults[".$adult_num."][name]' class='w3-input w3-round-large' type='text' placeholder='Name' value='".${"adult" . $i}->{'adult_name'}."'></div></td><td><div><label class='w3-small'>Room</label><input name='Adults[".$adult_num."][room]' class='w3-input w3-round-large' type='text' placeholder='Room' value='".${"adult" . $i}->{'room'}."'></div></td></tr>";
			$adults_str    .= "<br>Name: ".${"adult" . $i}->{'adult_name'}." Room: ".${"adult" . $i}->{'room'}."</br>";
		}
		$adult_table .= "</table>";
  }
	//Children
	elseif ($key === 'children') {

		$child_arr  = $value;
		$child_table .= "<table class='w3-table w3-padding' id='child_table'>";

		for ($i = 0; $i < count($child_arr); $i++) {

			${"child" . $i} = $child_arr[$i];
			$child_num      = $i + 1;
			$child_table   .= "<tr><td><div ><label class='w3-small'>Child ".$child_num."</label><input name='Children[".$child_num."][name]' class='w3-input w3-round-large' type='text' placeholder='Name' value='".${"child" . $i}->{'child_name'}."'></div></td><td><div><label class='w3-small'>Room</label><input name='Children[".$child_num."][room]' class='w3-input w3-round-large' type='text' placeholder='Room' value='".${"child" . $i}->{'room'}."'></div></td><td><div><label class='w3-small'>Age at Travel</label><input name='Children[".$child_num."][age]' class='w3-input w3-round-large' type='text' placeholder='Age at Travel' value='".${"child" . $i}->{'age_at_travel'}."'></div></td></tr>";
			$children_str  .= "<br>Name: ".${"child" . $i}->{'child_name'}." Room: ".${"child" . $i}->{'room'}." Age at Travel: ".${"child" . $i}->{'age_at_travel'}."</br>";
		}
		$child_table .= "</table>";
	}
	//Discounts
	elseif ($key === 'discounts') {

		$discount_arr = $value;

		for ($i = 0; $i < count($discount_arr); $i++) {
			if (strpos($discount_arr[$i]->{'discount'}, 'Visa') > 0) {
				$disney_visa           = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Annual Passholder') > 0) {
				$annual_passholder     = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Military') > 0) {
				$annual_passholder     = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Florida Resident') > 0) {
				$florida_resident      = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Canadian Resident') > 0) {
				$canadian_resident     = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Sue Says') > 0) {
				$sue_says              = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Exclusive Promo') > 0) {
				$exclusive_promo_code  = "checked='Checked'";
			} elseif (strpos($discount_arr[$i]->{'discount'}, 'Other') > 0) {
				$other_discount        = "checked='Checked'";
			}
		}
	}
}
if ($agent_name === 'Meredith') {
												$source     = 'Self';
											}elseif ( in_array($find_small_world,$house_arr) ) {
												$source     = 'House';
											}elseif (in_array($find_small_world,$mouse_arr)) {
												$source     = 'Mouse';
											}else {
												$source     = 'House';
											}
$rooms_str          = $adults_str.$children_str;
}}
?>
