<!DOCTYPE html>
<html>
<title>Disney Guest DB</title>
	<head>
    <?php
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
			 $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/db_files/dashboard_ld_fn.php";
       include_once($path);
    ?>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../js_functions/row_select.js"></script>
</head>

<body style="background-color:LavenderBlush;">
<div class="w3-container">
	<div class="w3-half w3-center"><h3>Recent Leads</h3></div>
</div>
<div class="w3-container">
	<table id="recent_leads_table" class="w3-table-all w3-card-4 w3-hoverable w3-half w3-margin-left">
      <tr>
        <th class="w3-hide">row_id</th>
				<th class="w3-hide">id_type</th>
				<th>Lead Guest</th>
        <th>Check-in</th>
        <th>Check-out</th>
				<th>Resort</th>
      </tr>
			<?php echo $recent_lead_table; ?>
    </table>
    <ul class="w3-ul w3-border w3-hoverable w3-card-4 w3-quarter w3-margin-left w3-white">
    <li>Fast-Pass schedule email for Jill</li>
    <li>Dining reservation email for Eve</li>
    <li>Curtisy hold email for Adam</li>
  </ul>
</div>
</div>

</body>
</html>
