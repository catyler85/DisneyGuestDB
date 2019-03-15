<?php
$my_obj =  new \stdClass();

//check if submited from a form
if (isset($_POST['form_name'])) {

  //assign form values to object
  foreach ($_POST as $key => $value) {

    $my_obj ->  $key = $value;

  }

  $params_json  =   json_encode($my_obj);
  $trans_name  =   $_POST['form_name'];

}elseif (isset($_POST['lookup_value']) and isset($_POST['lookup_key'])) {
  //assign values to object
  $my_obj ->  $lookup_value  = $_POST['lookup_value'];
  $my_obj ->  $lookup_key = $_POST['lookup_key'];

  $params_json  =   json_encode($my_obj);
  $trans_name  =   $_POST['get_form_values'];
}

//submit request to the DB
if (isset($params_json) and isset($trans_name)) {
  require 'db_connect.php';
  $result = pg_query_params($db, "call dgmain.webservice_insert_sp($1,$2)",array($params_json,$trans_name));
  while ($row = pg_fetch_row($result)) {
    echo $row[2];
  }
  pg_close($db);
}

?>
