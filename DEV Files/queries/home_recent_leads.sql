with recent_leads as (
  select *
  from dgmain.leads
  order by lead_id desc
  limit 5
),
lead_adult_rooms as (
  select a.lead_id, (jsonb_array_elements(adults) ->> ''dg_id'')::int adult_dg_id, jsonb_array_elements(adults) ->> ''room'' adult_room
  from dgmain.leads a
),
lead_child_rooms as (
  select a.lead_id, (jsonb_array_elements(children) ->> ''dg_id'')::int child_dg_id, jsonb_array_elements(children) ->> ''room'' child_room
  from dgmain.leads a
),
room_arrays as (
	select lead_id, array_agg(room || ''|'' || guid_array) room_array
	from (select lead_id, room, string_agg(g.guid::text, '','') guid_array
  from (select lead_id, adult_dg_id dg_id, adult_room room from lead_adult_rooms
	    union all
	    select lead_id, child_dg_id, child_room from lead_child_rooms ) x1
  join dgmain.guests_trans gt
	on gt.dg_id = x1.dg_id
  join dgmain.guests g
    on gt.guid = g.guid
  group by lead_id, room) x1
	group by lead_id
)
select row_to_json( x2.*) recent_leads_json
from (
select rl.lead_id,
       g.first_name || '' '' || g.last_name as lead_guest,
	   rl.check_in,
	   rl.check_out,
	   rl.resort,
	   ra.room_array
from recent_leads rl
left join room_arrays ra
  on rl.lead_id = ra.lead_id
left join dgmain.guests g
  on rl.lead_guest_guid = g.guid
order by rl.lead_id desc) x2
