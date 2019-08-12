--leads search
select to_jsonb(x1.table_row) table_row_json, similarity(search_string, 'disney|visa') * 10 match_num from (
select
'<tr onclick="row_select(this,''../pages/edit_lead.php'')">'                                              ||chr(10)
|| chr(9) || '<td class="w3-hide">' || l.lead_id                                           || '</td>' ||chr(10)
|| chr(9) || '<td class="w3-hide">lead_id</td>'                                                         ||chr(10)
|| chr(9) || '<td>' || l.source                                                            || '</td>' ||chr(10)
|| chr(9) || '<td>' || g.first_name || ' ' || g.last_name                                || '</td>' ||chr(10)
|| chr(9) || '<td>' || jsonb_array_length(l.adults) + jsonb_array_length(l.children)       || '</td>' ||chr(10)
|| chr(9) || '<td>' || l.num_rooms                                                         || '</td>' ||chr(10)
|| chr(9) || '<td>' || l.budget                                                            || '</td>' ||chr(10)
|| chr(9) || '<td>' || l.check_in                                                          || '</td>' ||chr(10)
|| chr(9) || '<td>' || l.check_out                                                         || '</td>' ||chr(10)
|| chr(9) || '<td>' || l.resort                                                            || '</td>' ||chr(10)
|| chr(9) || '<td>' || l.resort_accomodations                                              || '</td>' ||chr(10)
|| '</tr>' ||chr(10) table_row, concat_ws(' ', l.*, g.*) search_string
from dgmain.leads l
join dgmain.guests g
  on l.lead_guest_guid = g.guid
) x1
where search_string @@ to_tsquery('disney|visa:*')
order by similarity(search_string, 'disney|visa') desc
