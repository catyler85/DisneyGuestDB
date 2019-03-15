<!DOCTYPE html>
<html>
<title>Disney Guest DB - Verify Lead Data</title>
	<head>
    <?php
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
			 $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/db_files/form_values_ld.php";
       include_once($path);
    ?>
    <script src="../js_functions/submit_form_data.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  </head>

  <body style="background-color:LavenderBlush;">

    <h1 class="w3-panel w3-center w3-content">Verify Lead Data</h1>
    <hr>
		<div id="test"><?php $my_values = json_decode($form_values,TRUE); echo var_dump($my_values['travel_group'][0]);?></div>

  </body>
	<footer>
