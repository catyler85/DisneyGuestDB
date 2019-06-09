--lead
select jsonb_build_object(''lead'', to_jsonb(x1.*)) jsonb_rtn from
(select *
from dgmain.leads l
join dgmain.guests g
  on l.lead_guest_guid = g.guid
where l.lead_id = $1) x1


--travel group
with
form_lead as (
select l.lead_id,
	   l.lead_guest_guid,
	   tg.group_name,
	   l.adults,
	   l.children
from dgmain.leads l
join dgmain.travel_groups tg
	on l.travel_group = tg.group_id
where lead_id = $1
),
lead_adults as (
select lead_id, room, g.* from (
	select l.lead_id,
	   jsonb_array_elements(l.adults) ->> ''room'' room,
	(jsonb_array_elements(l.adults) ->> ''dg_id'')::int dg_id
from form_lead l) x1
join dgmain.guests_trans gt
  on x1.dg_id = gt.dg_id
join dgmain.guests g
  on gt.guid = g.guid
),
lead_children as (
select lead_id, room, g.* from (
	select l.lead_id,
	   jsonb_array_elements(l.children) ->> ''room'' room,
	(jsonb_array_elements(l.children) ->> ''dg_id'')::int dg_id
from form_lead l) x1
join dgmain.guests_trans gt
  on x1.dg_id = gt.dg_id
join dgmain.guests g
  on gt.guid = g.guid
)
select jsonb_build_object(''travel_group'', array_agg(to_jsonb(x1.*))) jsonb_rtn
from (
select
l.group_name,
la.*,
case when l.lead_guest_guid = la.guid then ''Y'' end lead_guest_flag
from form_lead l
left join lead_adults la
  on l.lead_id = la.lead_id
union all
select l.group_name, lc.*, null lgf
from form_lead l
left join lead_children lc
  on l.lead_id = lc.lead_id
order by room, lead_guest_flag, age_at_travel nulls first
) x1


--resorts
select jsonb_build_object(''resorts'',array_agg(jsonb_build_object(x1.resort_name, x1.rooms))) jsonb_rtn
from (
select resort_name, to_jsonb(rooms) rooms from dgmain.resorts order by resort_name) x1
