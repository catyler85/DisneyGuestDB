<?php
$my_obj =  new \stdClass();
if (isset($_POST['form_name'])) {

foreach ($_POST as $key => $value) {

  //$obj_arr -> $key = $value;
  $my_obj ->  $key = $value;

}
//echo json_encode($my_obj, JSON_FORCE_OBJECT);
//echo '~~~~~~~~~~~~~~~~';
//echo json_encode($my_obj);
//echo '~~~~~~~~~~~~~~~~';
//echo var_dump($_POST);
$form_json  =   json_encode($my_obj);
$form_name  =   $_POST['form_name'];
//echo $form_name;
//
require 'db_connect.php';
$result = pg_query_params($db, "SELECT * FROM dgmain.webservice_insert_fn($1,$2)",array($form_json,$form_name));

while ($row = pg_fetch_row($result)) {
  echo $row[0];
}
pg_close($db);
}

?>
