<!DOCTYPE html>
<html>
	<head>
    <title>Disney Guest DB - New Vacation</title>
    <meta name="dgdb" charset="utf-8" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="../w3css/w3.css">
</head>

<body>
    <?php 
       $path = $_SERVER['DOCUMENT_ROOT'];
       $path .= "/headers/header.html";
       include_once($path);      
    ?>
<br>
<div class="w3-container">
    <div class="w3-row">
    <!-- first half of first row -->
        <div class="w3-cell w3-half">
            <!-- Date and Reservation Number -->
            <div class="w3-panel w3-light-gray w3-card w3-round-large w3-half">
                <form class="w3-container" id="booking-sheet">
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
        </div>
    
   </div> 
   <div class="w3-row">
   <!-- first half of second row -->
       <div class="w3-cell w3-half">
           <form class="w3-container w3-panel w3-light-gray w3-card w3-round-large" id="booking-sheet">
           <h2>Main Contact</h2>
               <div class="w3-half m4 l3 w3-padding">
                   <input class="w3-input w3-row-padding w3-round" type="text" placeholder="First Name" name="bg-first-name" required>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Last Name" name="bg-last-name" required>
                   </p>
                   <p><input class="w3-input w3-row-padding w3-round" type="text" placeholder="Email" name="bg-email">
                   </p>
                   <hr>
               </div>
               <div class="w3-half m4 l3 w3-padding">
                   <input class="w3-input w3-row-padding w3-round" type="text" placeholder="Address1" name="bg-address1" required>
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
   </div>
</div>

</body>
</html>
