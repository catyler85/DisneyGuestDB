
  $("select[value]").each(function() {

    $(this).val(this.getAttribute("value"));

	});

	$("checkbox[value]").each(function() {

    console.log(this);

	});


			function createOption(ddl, text, value) {
			 var opt = document.createElement('option');
			 opt.value = value;
			 opt.text = text;
			 ddl.options.add(opt);
	    }

	    function createOptions(optionsArray, ddl) {
	   		 for (i = 0; i < optionsArray.length; i++) {
	   				 createOption(ddl, optionsArray[i], optionsArray[i]);
	   		 }
	    }

			function resortSelect(ddl1, ddl2){
				//var resorts = <?php echo json_encode($_SESSION['resorts']); ?>;
				var ddl1Clean = ddl1.value.replace("’", "'");

        //loop through resorts
				for (i = 0; i < resorts.length; i++) {

					//find the selected option in the resort array
					if (ddl1Clean == Object.keys(resorts[i])[0]) {

            //assign room values to ddl2keys
						var ddl2keys = Object.values(resorts[i])[0];

						//remove existing options
						ddl2.options.length = 0;

						//pass the rooms and room selection ID to populate options
						createOptions(ddl2keys.sort(), ddl2);
						return;
					}else {
							//document.getElementById("test").innerHTML = 'Sorry, there was no match!';
							createOption(ddl2,'~Least Expensive','Least Expensive');
					}
				}
		  }
