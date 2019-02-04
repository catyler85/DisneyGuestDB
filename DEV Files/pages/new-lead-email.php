<html>
<title>Disney Guest DB - New Lead Email</title>
	<head>
    <?php
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/db_files/webservice_submit_fn.php";
       include("..\db_files/webservice_submit_fn.php");?>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>

<body style="background-color:LavenderBlush;">
<h1 class="w3-panel w3-center w3-content">New Lead Email</h1>
<br>
<div class="w3-container w3-panel w3-card w3-pale-red w3-margin">
  <form method="POST" class="w3-container w3-responsive" action="new-lead.php" id="email_box">
	  <textarea class="w3-input w3-margin" rows="20" cols="15" name="lead_email_text" id="lead_email_text">
	  </textarea>
		<input class="w3-button w3-pink w3-round-large w3-hover-purple" type='submit' name='submit' id="submit" >
	</form>
</div>
<!--javascript section -->
	<script>
  //submit on "Enter"
	document.addEventListener("keyup", function(event) {
	  event.preventDefault();
	  if (event.keyCode === 13) {
	    document.getElementById("submit").click();
	  }
	});
	</script>
