<?php
session_start();
?>
<!DOCTYPE html>
<html>
<title>Disney Guest DB - View Leads</title>
	<head>
    <?php
       //$path = $_SERVER['DOCUMENT_ROOT'];
       //$path .= "/headers/header.html";
       include_once("../headers/header.html");
			 include_once("../db_files/build_table_fn.php");
			 $lead_table = build_table("view_leads");
    ?>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="../js_functions/js_functions.js"></script>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

  </head>

  <body style="background-color:LavenderBlush; right:200px">
    <?php //include "../headers/sidebar.html" ?>
		<div class="w3-card-4 w3-margin">
      <div class="w3-container w3-pink">
        <h2>Search</h2>
      </div>

      <form class="w3-container" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="get">
				<input type="hidden" name="form_name" value="lead_search"></input>
        <label>Keyword Search</label>
        <input class="w3-input w3-border" type="text" name="keyword">
				<button class="w3-btn w3-pink w3-hover-purple w3-margin-top">Search</button>
      </form>
    </div>

    </div>
		<div class="w3-container  w3-margin">
			<div class="w3-center"><h3>View Leads</h3></div>
			<table id="leads_table" class="w3-table-all w3-card-4 w3-hoverable">
		      <tr>
		        <th class="w3-hide">row_id</th>
						<th class="w3-hide">id_type</th>
						<th>Source</th>
						<th>Lead Guest</th>
						<th># of Guest</th>
						<th># of Rooms</th>
						<th>Budget</th>
		        <th>Check-in</th>
		        <th>Check-out</th>
						<th>Resort</th>
						<th>Resort Accommodations</th>
		      </tr>
					<?php echo $lead_table; ?>
		    </table>
			</div>
