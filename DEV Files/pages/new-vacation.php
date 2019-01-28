<!DOCTYPE html>
<html>
<title>Disney Guest DB - New Vacation</title>
	<head>
    <?php
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);
    ?>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>

<body style="background-color:LavenderBlush;">
<h1 class="w3-panel w3-center">New Vacation</h1>
<br>
<div class="w3-container">
    <div class="w3-row">
        <!-- first half of first row -->
        <div class="w3-cell w3-half">
            <!-- Date and Reservation Number -->
            <form class="w3-panel w3-pale-red w3-card w3-round-large" id="booking-sheet1">
                <div class="w3-cell-row">
                    <div class="w3-cell m4 l3 w3-cell-middle">
                        <div name="date" class="w3-col w3-large w3-row-padding"> Date: <?php print date("m/d/y", time());?></div>
                    </div>
                    <div class="w3-cell m4 l3 w3-padding">
                        <input class="w3-input w3-row-padding w3-round" type="number" placeholder="Reservation Number" name="resnum">
                    </div>
                </div>
            </form>
        </div>
				<div class="w3-cell w3-half w3-padding">
					<!-- Vacation Dates -->
					<div class="w3-panel w3-pale-red w3-card w3-round-large ">
							<form class="w3-container w3-panel w3-pale-red w3-card w3-round-large" id="vacation-dates">
									<div class="w3-cell-row">
											<div class="w3-cell m4 l3 w3-cell-middle">
													<div name="from-date" class="w3-col w3-large w3-row-padding"> From:
													  <input class="w3-input w3-row-padding w3-round" type="date" name="start-date">
													</div>
											</div>
											<div class="w3-cell m4 l3 w3-padding">
												<div name="to-date" class="w3-col w3-large w3-row-padding"> To:
													<input class="w3-input w3-row-padding w3-round" type="date" name="end-date">
												</div>
											</div>
									</div>
							</form>
					</div>
				</div>
   </div>
   <div class="w3-row">
   <!-- first half of second row -->
       <div class="w3-cell w3-half">
           <form class="w3-container w3-panel w3-pale-red w3-card w3-round-large" id="booking-sheet2">
           <h2>Lead Guest</h2>
               <div class="w3-half m4 l3 w3-padding">
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="First Name" name="bg-first-name" required>
                   </p>
				   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Last Name" name="bg-last-name" required>
                   </p>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Email" name="bg-email">
                   </p>
                   <hr>
				   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Cell #" name="bg-cell">
                   </p>
				   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Fax #" name="bg-fax">
                   </p>
               </div>
               <div class="w3-half m4 l3 w3-padding">
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Address1" name="bg-address1" required>
                   </p>
				   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Address2" name="bg-address2" required>
                   </p>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Address3" name="bg-address3" required>
                   </p>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="City" name="bg-city">
                   </p>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="State" name="bg-state">
                   </p>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Zip" name="bg-zip">
                   </p>
               </div>
           </form>
       </div>
     <!-- second half of second row -->
		 <div class="w3-cell w3-half">
       <form class="w3-container w3-panel w3-pale-red w3-card w3-round-large w3-margin-left" id="booking-sheet3">
		     <h2>Traveling With</h2>
			     <table class="w3-table w3-padding" id="travel-with">
			  	 <tr>
			  	 <td><button type="button" class="w3-round-large w3-border w3-hover-light-gray w3-pink material-icons" id="add-guest" name="add-guest">add</button> <i>add guest</i></td>
			  	 </tr>
			     </table>
       </form>
			 <form class="w3-container w3-panel w3-pale-red w3-card w3-round-large w3-margin-left" id="booking-sheet4">
		     <h2>Linked Reservations</h2>
			     <table class="w3-table w3-padding" id="linked-reservations">
			  	 <tr>
			  	 <td><button type="button" class="w3-round-large w3-border w3-hover-light-gray w3-pink material-icons" id="add-reservation" name="add-reservation">add</button> <i>add reservation</i></td>
			  	 </tr>
			     </table>
       </form>
	   </div>
   </div>
</div>
<!-- submit button -->
<div class="w3-container">
<button type="button" class="w3-button w3-round-large w3-pink" name="submit" id="submit">Submit</button>
</div>

<div id="test_data"></div>
</body>
</html>


<script>

$(document).ready(function(){
	var i=100;
	var q=200;

  //add guest functions
	$('#add-guest').click(function(){
		i++;
		$('#travel-with').append('<tr id="row'+i+'"><td><button type="button" class="w3-round-large w3-border material-icons guest_remove" name="remove" id="'+i+'">close</button></td><td><input type="text" name="ag'+i+'_first_name" placeholder="First Name" class="w3-input w3-row-padding w3-round" /></td><td><input type="text" name="ag'+i+'_last_name" placeholder="Last Name" class="w3-input w3-row-padding w3-round" /></td><td><input type="number" name="ag'+i+'_age" placeholder="Age" class="w3-input w3-row-padding w3-round" /></td></tr>');
	});

	$(document).on('click', '.guest_remove', function(){
		var button_id = $(this).attr("id");
		$('#row'+button_id+'').remove();
	});

		//add linked reservation functions
		$('#add-reservation').click(function(){
			q++;
			$('#linked-reservations').append('<tr id="row'+q+'"><td><button type="button" class="w3-round-large w3-border material-icons reservation_remove" name="remove" id="'+q+'">close</button></td><td><input type="number" name="lr'+q+'_num" placeholder="Reservation Number" class="w3-input w3-row-padding w3-round" /></td></tr>');
		});

		$(document).on('click', '.reservation_remove', function(){
			var button_id = $(this).attr("id");
			$('#row'+button_id+'').remove();
		});

  //submit forms functions
	$('#submit').click(function(){
        var x = $("#booking-sheet1, #booking-sheet2, #booking-sheet3").serializeArray();
				$("#test_data").append(x);
		$.each(x, function(i, field){
          $("#test_data").append(field.name + ":" + field.value + " ");
        });
		$.ajax({
			url:"name.php",
			method:"POST",
			data:$('#add_name').serialize(),
			success:function(data)
			{
				alert(data);
				$('#add_name')[0].reset();
			}
		});
	});

});
</script>
