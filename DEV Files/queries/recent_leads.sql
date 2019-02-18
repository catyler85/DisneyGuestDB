with recent_leads as (
  select *
  from dgmain.leads
  order by lead_id desc
  limit 5
),
lead_adult_rooms as (
  select a.lead_id, adult_recs.value ->> 'name' adult_full_name, adult_recs.value ->> 'room' adult_room
  from dgmain.leads a,
  jsonb_each(a.adults) as adult_recs
),
lead_child_rooms as (
  select a.lead_id, child_recs.value ->> 'name' child_full_name, child_recs.value ->> 'room' child_room
  from dgmain.leads a,
  jsonb_each(a.children) as child_recs
),
room_arrays as (
  select lead_id, jsonb_build_array(room, array_agg(g.guid)) guid_array
  from (select lead_id, adult_full_name full_name, adult_room room from lead_adult_rooms
	    union all
	    select lead_id, child_full_name, child_room from lead_child_rooms ) x1
  join dgmain.guests g
	on lower(replace(x1.full_name, ' ', '')) = trim(lower(g.name_prefix ||g.first_name || g.middle_name || g.last_name || g.name_suffix))
  group by lead_id, room
)
select *
from recent_leads rl
left join room_arrays ra
  on rl.lead_id = ra.lead_id
