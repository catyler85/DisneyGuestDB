create or replace function dgmain.leads_pr_fn()
returns int
LANGUAGE 'plpgsql'

COST 100
VOLATILE
as $leads_pr_fn$
declare

  tg_rec             record;
  tg_id              int;

begin

  for tg_rec in
    select x1.trans_id,
           x1.lead_id,
           max(case when rn = 1 then guid end) lead_guest,
           array_agg(guid) travel_guests,
           max(case when rn = 1 then first_initial || '. ' || last_name || ' group' end ) group_name
      from (
      select lt.trans_id,
             lt.lead_id,
             lt.status,
             gt.guid,
             substring(first_name, 1,1) first_initial,
             gt.last_name,
             row_number() over (partition by lt.trans_id order by gt.dg_id) rn
      from dgmain.leads_trans lt
      join dgmain.guests_trans gt
      on lt.trans_id = gt.trans_id
      ) x1
      where status = 'I'
      group by x1.trans_id, x1.lead_id
      order by x1.trans_id, x1.lead_id
  loop

    insert into dgmain.travel_groups as a
    (group_name, lead_guest_guid, travel_guest_guids)
      values
      (tg_rec.group_name, tg_rec.lead_guest, tg_rec.travel_guests)
    on conflict (group_name) do update
      set lead_guest_guid     = tg_rec.lead_guest,
          travel_guest_guids  = tg_rec.travel_guests
    where a.group_name = tg_rec.group_name
    returning group_id into tg_id;

    update dgmain.leads_trans
      set lead_guest_guid     = tg_rec.lead_guest,
          travel_group        = tg_id
    where lead_id             = tg_rec.lead_id;

  end loop;

  --
  update dgmain.leads_trans
    set status = 'P'
    where status = 'I';

return 1;
end $leads_pr_fn$;
