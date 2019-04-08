create or replace function dgmain.guid_assign_fn ()
returns int
LANGUAGE 'plpgsql'

COST 100
VOLATILE
as $guid_assign_fn$
declare

  v_guid            int;
  hld_dgid          int                             := 0;
  guid_rec          record;

begin

  for guid_rec in
    select a.trans_id,
           a.dg_id,
           a.key_name,
           a.key_value,
	         b.guid key_guid,
           x1.guid
    from dgmain.guid_key_lookup_trans a
    left join dgmain.guid_key_lookup b
       on a.key_name = b.key_name
       and a.key_value = b.key_value
    left join (
      select a.trans_id,
           a.dg_id,
           b.guid
      from dgmain.guid_key_lookup_trans a
      left join dgmain.guid_key_lookup b
        on a.key_name = b.key_name
        and a.key_value = b.key_value) x1
        on a.dg_id = x1.dg_id
        and x1.guid is not null
    where a.status = 'I'
  loop

    if guid_rec.guid is null
    then
      if hld_dgid <> guid_rec.dg_id
      then
        hld_dgid                           := guid_rec.dg_id;
        v_guid                             := nextval('dgmain.guid_seq');
        --
        insert into dgmain.guid_key_lookup
        values
        (guid_rec.key_name, guid_rec.key_value, v_guid)
        on conflict(key_name, key_value, guid) do nothing;
        --
        update dgmain.guid_key_lookup_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
        update dgmain.guests_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
      else
        --
        insert into dgmain.guid_key_lookup
        values
        (guid_rec.key_name, guid_rec.key_value, v_guid)
        on conflict(key_name, key_value, guid) do nothing;
        --
        update dgmain.guid_key_lookup_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
        update dgmain.guests_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
      end if;
    elsif guid_rec.guid is not null
          and guid_rec.key_guid is null
    then
      --
      insert into dgmain.guid_key_lookup
      values
      (guid_rec.key_name, guid_rec.key_value, guid_rec.guid)
      on conflict(key_name, key_value, guid) do nothing;
      --
      update dgmain.guid_key_lookup_trans
        set guid = guid_rec.guid
      where dg_id = guid_rec.dg_id;
      --
      update dgmain.guests_trans
        set guid = guid_rec.guid
      where dg_id = guid_rec.dg_id;
      --
    elsif guid_rec.guid is not null
          and guid_rec.key_guid is not null
      then
        --
        update dgmain.guid_key_lookup_trans
          set guid = guid_rec.guid
        where dg_id = guid_rec.dg_id;
        --
        update dgmain.guests_trans
          set guid = guid_rec.guid
        where dg_id = guid_rec.dg_id;
        --
    end if;

  end loop;

  update dgmain.guid_key_lookup_trans
    set status = 'C'
    where status = 'I';
  --
  update dgmain.guests_trans
    set status = 'P'
    where status = 'I';

  return 1;
end $guid_assign_fn$;
