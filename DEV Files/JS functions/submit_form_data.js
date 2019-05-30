function submit_form_data(p_form) {
	var form = $( p_form ).serialize();
	var x;
	x = $.post("../db_files/webservice_submit_fn.php", form, function(result,status){

		if (status === "success") {
			return 'result';
    }else {
    	return "error";
    }

	}, "json");
return x;
};
