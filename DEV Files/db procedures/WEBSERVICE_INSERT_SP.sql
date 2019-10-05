CREATE OR REPLACE procedure dgmain.webservice_insert_sp(
	INOUT    p_params       jsonb,
	INOUT    p_trans_name   text,
  INOUT    p_jsonb        jsonb default null)
AS $$
declare
  t_id                int;
  j_msg               jsonb;
	db_jsonb            jsonb;
	return_msg          jsonb;
	return_params       jsonb;
	f_rec               record;
	lov_function        text               := '';
	sql_str             text               := '';
	proc_str            text               := '';
	rtn_code            int;
	results_str         text;
	------------------------------------------------------------------------------
  --exception handling
	v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_hint    TEXT;
  v_context TEXT;

begin

return_msg                               := jsonb_build_object('ws_insert_sp','');
return_params                            := jsonb_build_object('ws_insert_sp','');

--insert params to webservice_trans table
t_id                                     := nextval('dgmain.trans_id_seq');
insert into dgmain.webservice_trans
values
(t_id, current_date, p_params, p_trans_name, 'Started');
-------------------------------------------------------------
--get function name
proc_str                                := 'get_function_name';
for f_rec in
  (select * from dgmain.lov_table
  where lookup_type = 'procedure'
  and lookup_key = p_trans_name
  order by lookup_seq)
loop
  lov_function                            := f_rec.lookup_value;
  if coalesce(lov_function, '') = '' then raise exception 'The trans_name does not match!';
	end if;
	raise notice '%', lov_function;
  -------------------------------------------------------------
  --build function call and execute
  proc_str                                := 'build_function_call';
  db_jsonb                                := p_params;
  db_jsonb                                := jsonb_set(db_jsonb,array['trans_id'], (t_id::text)::jsonb);
  sql_str                                 := 'call dgmain.' || lov_function || '('''|| db_jsonb || ''',''{"send":"value"}'')';
  --
  proc_str                                := 'execute_function_call';
  execute sql_str into db_jsonb, j_msg;
	if j_msg ->> 'rtn_code' = '1'
	then
	return_params                           := return_params || db_jsonb;
	return_msg                              := return_msg || j_msg;
  --commit;
	else


		--j_msg                                 := '{"rtn_code":-1,"message":"There was an issue in function call -' || lov_function || ' ERROR DETAILS: ' || results_str || '"}';
	  --p_jsonb                               := j_msg;
	  --insert into dgmain.error_log values (t_id, p_jsonb);
		raise exception 'The process failed at % call', lov_function;

	end if;

end loop;
--
if coalesce(lov_function, '') = '' then raise exception 'The trans_name does not match!';
end if;
--
call dgmain.proc_function_sp(p_params,p_jsonb);

--assign return message
proc_str                                := 'assign_return_message';
if (p_jsonb ->> 'rtn_code' <> '1')
then
  --j_msg                                 := '{"rtn_code":-1,"message":"There was an issue in function call ' || lov_function || '"}';
	--p_jsonb                               := j_msg;
	--insert into dgmain.error_log values (t_id, p_jsonb);
	raise exception 'Called procedure failed';
else
  p_jsonb                               := return_msg;
end if;
--------------------------------------------------------------------------------
results_str                             := 'Finished';
--
update dgmain.webservice_trans
	set results     = results_str
where trans_id    =   t_id;
--------------------------------------------------------------------------------
--return p_jsonb;

exception when others then

  get stacked diagnostics
      v_state   = returned_sqlstate,
      v_msg     = message_text,
      v_detail  = pg_exception_detail,
      v_hint    = pg_exception_hint,
      v_context = pg_exception_context;


  results_str   := 'Failure at proc_step: '
	              || proc_str
								|| 'with the following '
								|| 'state: '      || v_state || chr(10)
								|| 'message: '    || v_msg || chr(10)
								|| 'detail: '     || v_detail || chr(10)
								|| 'hint: '       || v_hint || chr(10)
								|| 'context: '    || v_context || chr(10)
								|| 'error message:' || SQLERRM;
	--
	insert into dgmain.error_log values (t_id, results_str,current_timestamp);
	commit;
	--
  insert into dgmain.webservice_trans
		values (t_id, current_date, null, null, results_str)
	on conflict ON CONSTRAINT webservice_trans_pkey do
	update
		set results     = results_str;
	commit;
	--
	j_msg = '{"rtn_code":-1,"message":"There was an issue submitting the data. proc_step: ' || proc_str || ' err_msg: ' || sqlerrm || '"}';
	p_jsonb  := j_msg;
	--return p_jsonb;


end; $$
	LANGUAGE plpgsql;
