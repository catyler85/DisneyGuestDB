create or replace function key_lookup_temp_ld_fn (
  p_guest_rec  record
)
returns int
LANGUAGE 'plpgsql'

COST 100
VOLATILE
as $key_lookup_temp_ld_fn$
declare
  db_current_date                      date;
begin

--key lookup values
--
--name|address
if coalesce(p_guest_rec.address1, '')
|| coalesce(p_guest_rec.city,'')
|| coalesce(p_guest_rec.state,'')
|| coalesce(p_guest_rec.zip,'') <> '' then
  insert into key_lookup_temp
  values
  (p_guest_rec.trans_id
    , db_current_date
    , 'I'
    , 'name|address'
    ,  lower(p_guest_rec.first_name
    || p_guest_rec.middle_name  || p_guest_rec.last_name
    || p_guest_rec.name_suffix
    || '|'
    || p_guest_rec.address1 || p_guest_rec.city || p_guest_rec.state || p_guest_rec.zip)
    , null
    , p_guest_rec.dg_id);
end if;

  --name|email
  if coalesce(p_guest_rec.email, '') <> '' then
    insert into key_lookup_temp
    values
    (p_guest_rec.trans_id
    , db_current_date
    , 'I'
    , 'name|email'
    ,  lower(p_guest_rec.first_name
    || p_guest_rec.middle_name  || p_guest_rec.last_name
    || p_guest_rec.name_suffix
    || '|'
    || p_guest_rec.email)
    , null
    , p_guest_rec.dg_id);
end if;
  --
  --name|phone
  if coalesce(p_guest_rec.phone,'') <> '' then
    insert into key_lookup_temp
    values
    (p_guest_rec.trans_id
    , db_current_date
    , 'I'
    , 'name|phone'
    ,  lower(p_guest_rec.first_name
     || p_guest_rec.middle_name  || p_guest_rec.last_name
     || p_guest_rec.name_suffix
     || '|'
     || p_guest_rec.phone)
     , null
    , p_guest_rec.dg_id);
end if;
  --
  --name|cell
  if coalesce(p_guest_rec.cell, '') <> '' then
    insert into key_lookup_temp
    values
    (p_guest_rec.trans_id
      , db_current_date
      , 'I'
      , 'name|cell'
      ,  lower(p_guest_rec.first_name
      || p_guest_rec.middle_name  || p_guest_rec.last_name
      || p_guest_rec.name_suffix
      || '|'
      || p_guest_rec.cell)
      , null
      , p_guest_rec.dg_id);
    end if;


return 1;
end $key_lookup_temp_ld_fn$;
