CREATE OR REPLACE PROCEDURE dgmain.form_ld_sp(
	INOUT   p_params       jsonb,
  INOUT   p_jsonb        jsonb)

AS $$
declare
  db_jsonb                  jsonb;
  db_current_date           date               := current_date;
  i                         int;
  db_int                    int;
  v_lookup_key              text;
  v_lookup_value            text;
  v_lookup_rec              record;
  v_sql                     text;
  v_sql_rec                 record;
  v_table                   text               := '';
  v_message                 text;
  v_proc_step               text;
begin
  -----------------------------------------
  --init section
  -----------------------------------------
  v_proc_step                                  := 'init section';
  --
  v_lookup_key                                 := p_params ->> 'lookup_key';
  v_lookup_value                               := coalesce(p_params ->> 'lookup_value','x');
  db_jsonb                                     := jsonb_build_object('form_ld_sp',null);
  -----------------------------------------

  -----------------------------------------
  --main section
  -----------------------------------------
  v_proc_step                                  := 'main section';
  --
  for v_sql_rec in
    (select * from dgmain.lov_table lov
    where lov.lookup_key = v_lookup_key
    and lov.lookup_type = 'sql'
    order by lov.lookup_seq)
  loop
    v_sql                                      := v_sql_rec.lookup_value;
		--
    if coalesce(v_sql, '') = ''
		then raise 'Lookup key does not match';
		end if;
		--
		if v_lookup_value = 'x'
		then
		  execute v_sql into v_lookup_rec;
		else
      execute v_sql into v_lookup_rec using v_lookup_value;
		end if;

    db_jsonb                                   := db_jsonb || v_lookup_rec.jsonb_rtn;
    --raise notice '%', db_jsonb;


  end loop;

  p_jsonb := db_jsonb || ('{"rtn_code":"1","message":"Success!"}')::jsonb;
  raise notice '%', p_jsonb;

end; $$ LANGUAGE plpgsql;
