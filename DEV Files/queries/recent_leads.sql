with recent_leads as (
  select *
  from dgmain.leads
  order by lead_id desc
  limit 5
),
lead_adult_rooms as (
  select a.lead_id, (adult_recs.value ->> 'dg_id')::int adult_dg_id, adult_recs.value ->> 'room' adult_room
  from dgmain.leads a,
  jsonb_each(a.adults) as adult_recs
),
lead_child_rooms as (
  select a.lead_id, (child_recs.value ->> 'dg_id')::int child_dg_id, child_recs.value ->> 'room' child_room
  from dgmain.leads a,
  jsonb_each(a.children) as child_recs
),
room_arrays as (
  select lead_id, array_agg(guid_array) guid_room_array
  from (
	select lead_id, jsonb_build_array(room, array_agg(g.guid)) guid_array
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
select row_to_json(rl.*), ra.guid_room_array
from recent_leads rl
left join room_arrays ra
  on rl.lead_id = ra.lead_id
