CREATE OR REPLACE PROCEDURE dgmain.build_table_sp(
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
     insert into lookup_temp values (v_lookup_key::text, v_sql_rec.table_row_json::json);
  end loop;

--  insert into lookup_temp values (v_lookup_key::text, lookup_json::json);

end loop;

for lookup_rec in
select a.lookup_json::json from lookup_temp a
loop
  v_table := v_table || (lookup_rec.lookup_json ->> 'table_row')::text;
end loop;
p_jsonb := jsonb_build_object('html_table', v_table) || ('{"rtn_code":1,"message":"Success!"}')::jsonb;

end; $$ LANGUAGE plpgsql;
