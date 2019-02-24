<?php
$my_obj =  new \stdClass();
$lov_arr = array("home_recent_leads");
$my_obj ->lov_values  = $lov_arr;

$form_json  =   json_encode($my_obj);
$form_name  =   "dashboard_ld";


require 'db_connect.php';
$result = pg_query_params($db, "call dgmain.webservice_insert_sp($1,$2)",array($form_json,$form_name));

while ($row = pg_fetch_row($result)) {
  $obj = json_decode($row[2]);

  $recent_lead_table =  $obj->{'home_recent_leads'};
}
pg_close($db);



?>
