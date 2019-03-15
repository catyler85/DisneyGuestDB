function row_select(x) {
//var table = document.getElementById('recent_leads_table');
var table_id = $(x).parents('table').attr('id');
var table = document.getElementById(table_id);
var sel_row_id = table.rows[x.rowIndex].cells[0].innerHTML;
var sel_id_type = table.rows[x.rowIndex].cells[1].innerHTML;
  //'<?php $_SESSION["lead_id"] = "' + sel_lead_id + '";?>';
  //sessionStorage.setItem('lead_id', 'sel_lead_id');
  //alert("lead_id is: " + table.rows[x.rowIndex].cells[4].innerHTML);
  window.location.assign('/pages/edit_lead.php?lookup_value='+sel_row_id+'&lookup_key='+sel_id_type);
}
