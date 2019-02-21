<?php
$my_obj =  new \stdClass();
if (isset($_POST['form_name'])) {

  foreach ($_POST as $key => $value) {

    $my_obj ->  $key = $value;

  }

  $form_json  =   json_encode($my_obj);
  $form_name  =   $_POST['form_name'];


  require 'db_connect.php';
  $result = pg_query_params($db, "call dgmain.webservice_insert_sp($1,$2)",array($form_json,$form_name));

  while ($row = pg_fetch_row($result)) {
    echo $row[2];
  }
  pg_close($db);
  //return $row[2];
}

?>
