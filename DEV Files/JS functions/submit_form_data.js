(function() {
	function toJSONString( form ) {
		//var obj = {};
		//var elements = form.querySelectorAll( "input, select, textarea, radio, checkbox, hidden" );
		//for( var i = 0; i < elements.length; ++i ) {
		//	var element = elements[i];
		//	var name = element.name;
		//	var value = element.value;

		//	if( name ) {
		//		obj[ name ] = value;
		//	}
		//}
    var FD = new FormData(form);
		//return JSON.stringify( obj );
    //return obj.serializearray();
    return FD;
	}

	document.addEventListener( "DOMContentLoaded", function() {
		//var form = document.getElementById( "test" );
    var obj, dbParam, xmlhttp, myObj, x, txt = "";
		form.addEventListener( "submit", function( e ) {
			e.preventDefault();
            xmlhttp = new XMLHttpRequest();
			//dbParam = toJSONString( this );

      xmlhttp.open("POST", "../db_files/webservice_submit_fn.php", true);
      xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xmlhttp.send( this );

      window.location.href = "../disney-guest-db.php";

		}, false);

	});

})();

xmlhttp.open("POST", "../db_files/webservice_submit_fn.php", true);
xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
xmlhttp.send(dbParam);
