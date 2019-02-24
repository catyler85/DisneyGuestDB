CREATE OR REPLACE PROCEDURE dgmain.dashboard_ld_sp(
	INOUT   p_params       jsonb,
  INOUT   p_jsonb        jsonb)

AS $$
declare
  db_jsonb                  jsonb;
  db_current_date           date               := current_date;
  i                         int;
  db_int                    int;
  v_lookup_key              text;
  lookup_json               json;
  v_sql                     text;
  v_sql_rec                 record;
  v_table                   text               := '';
  v_message                 text;
  v_proc_step               text;
  --
  --work variables
  lookup_rec                record;

begin

--temp table of guests
drop table if exists lookup_temp;
create temp table lookup_temp (
  lookup_key  text,
  lookup_json json
);

for i in 1..jsonb_array_length(p_params -> 'lov_values')
loop
  v_lookup_key                                         := (p_params -> 'lov_values' ->> (i-1))::text;
  raise notice 'lookup_key: %', v_lookup_key;
  select lookup_value into v_sql from dgmain.lov_table a where a.lookup_type = 'sql' and a.lookup_key = v_lookup_key;
  --raise notice 'v_sql: %', v_sql;
  for v_sql_rec in execute v_sql
  loop
     insert into lookup_temp values (v_lookup_key::text, v_sql_rec.recent_leads_json::json);
  end loop;

--  insert into lookup_temp values (v_lookup_key::text, lookup_json::json);

end loop;

for lookup_rec in
select a.lookup_json::json from lookup_temp a
loop
  v_table := v_table || '<tr>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || (lookup_rec.lookup_json ->> 'lead_guest')::text  || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || (lookup_rec.lookup_json ->> 'check_in')::text || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || (lookup_rec.lookup_json ->> 'check_out')::text || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || (lookup_rec.lookup_json ->> 'resort')::text || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td class=''w3-hide''>' || (lookup_rec.lookup_json ->> 'lead_id')::text || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td class=''w3-hide''>' || (lookup_rec.lookup_json ->> 'room_array')::text || '</td>' ||chr(10);
  v_table := v_table || '</tr>' ||chr(10);
end loop;

p_jsonb := jsonb_build_object('home_recent_leads', v_table) || ('{"rtn_code":1,"message":"Success!"}')::jsonb;

end; $$ LANGUAGE plpgsql;
