<!DOCTYPE html>
<html>
<title>Disney Guest DB</title>
	<head>
    <?php
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
			 $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/db_files/webservice_submit_fn.php";
       include_once($path);
    ?>
	<?php include("pages/sidebar.html");?>
</head>

<body style="background-color:LavenderBlush;">
<?php //include('..\db_files\webservice_submit_fn.php');//require '..\db_files\webservice_submit_fn.php'?>
<div class="w3-container">
	<table class="w3-table-all w3-card-4 w3-hoverable w3-third w3-margin-left">
      <tr>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Vacation Date</th>
      </tr>
      <tr>
        <td>Jill</td>
        <td>Smith</td>
        <td>1/1/2019</td>
      </tr>
      <tr>
        <td>Eve</td>
        <td>Jackson</td>
        <td>3/1/2019</td>
      </tr>
      <tr>
        <td>Adam</td>
        <td>Johnson</td>
        <td>5/5/2019</td>
      </tr>
    </table>
    <ul class="w3-ul w3-border w3-hoverable w3-card-4 w3-third w3-margin-left w3-white">
    <li>Fast-Pass schedule email for Jill</li>
    <li>Dining reservation email for Eve</li>
    <li>Curtisy hold email for Adam</li>
  </ul>
</div>
</div>

</body>
</html>
