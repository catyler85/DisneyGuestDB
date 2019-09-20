<?php
function build_table($lov_name){
  $my_obj =  new \stdClass();
  $lov_arr = array($lov_name);
  $my_obj ->lov_values  = $lov_arr;


  //check if submited from a form
  if (isset($_GET['form_name'])) {

    //assign form values to object
    foreach ($_GET as $key => $value) {

      $my_obj ->  $key = $value;

    }
  }

  $form_json  =   json_encode($my_obj);
  $form_name  =   "build_table";

  require 'db_connect.php';
  $result = pg_query_params($db, "call dgmain.webservice_insert_sp($1,$2)",array($form_json,$form_name));

  while ($row = pg_fetch_row($result)) {
    $obj = json_decode($row[2]);

    $html_table =  $obj->{'html_table'};
  }
  pg_close($db);
  return $html_table;
}
?>
