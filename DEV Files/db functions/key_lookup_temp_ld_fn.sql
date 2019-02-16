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
if p_guest_rec.address1 || p_guest_rec.city || p_guest_rec.state || p_guest_rec.zip is not null then
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
  if p_guest_rec.email is not null then
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
  if p_guest_rec.phone is not null then
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
  if p_guest_rec.cell is not null then
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
