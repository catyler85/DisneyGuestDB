function submit_form_data(p_form) {
	var form = $( p_form ).serialize();
	var xhttp = new XMLHttpRequest();
	var x;
	//console.log(form);
	//x = $.post("../db_files/webservice_submit_fn.php", form, function(result,status){
  //  //console.log(result);
	//	if (status === "success") {
	//		return result;
  //  }else {
  //  	return "error";
  //  }

	//}, "json");

	var xhttp = new XMLHttpRequest();
	//xhttp.onreadystatechange = function() {
	//  if (this.readyState == 4 && this.status == 200) {
	//    //window.location.href = "../disney-guest-db.php";
	//		x = this.responseText;
	//  }
	//};
	xhttp.open("POST", "../db_files/webservice_submit_fn.php", true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send(form);


return xhttp;
};
