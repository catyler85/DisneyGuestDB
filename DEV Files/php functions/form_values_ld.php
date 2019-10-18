<?php
$my_obj =  new \stdClass();
$my_obj ->lookup_key  = $_GET["lookup_key"];
if (isset($_GET["lookup_value"])) {
  $my_obj ->lookup_value  = $_GET["lookup_value"];
}


$form_json  =   json_encode($my_obj);
$form_name  =   "get_form_values";


require 'db_connect.php';
$result = pg_query_params($db, "call dgmain.webservice_insert_sp($1,$2)",array($form_json,$form_name));

while ($row = pg_fetch_row($result)) {
  $obj = json_decode($row[2], TRUE);

  //$form_values =  $obj->{'travel_group'};
  $form_values =  $obj;
}
pg_close($db);



?>
