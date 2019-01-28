<!DOCTYPE html>
<html>
	<head>
    <title>Disney Guest DB</title>
    <meta name="dgdb" charset="utf-8" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="w3css/w3.css">
</head>

<body>
<?php 
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
    ?>
<?php include("pages/sidebar.html");?>

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
    <ul class="w3-ul w3-border w3-hoverable w3-card-4 w3-third w3-margin-left">
    <li>Fast-Pass schedule email for Jill</li>
    <li>Dining reservation email for Eve</li>
    <li>Curtisy hold email for Adam</li>
  </ul>
</div>
</div>

</body>
</html>
