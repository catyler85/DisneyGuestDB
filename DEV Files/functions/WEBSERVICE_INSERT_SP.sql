CREATE OR REPLACE procedure dgmain.webservice_insert_sp(
	INOUT    p_params       jsonb,
	INOUT    p_trans_name   text,
  INOUT    p_jsonb        jsonb)
AS $$
declare
  t_id                int;
  j_msg               jsonb;
	db_jsonb            jsonb;
	lov_function        text               := '';
	sql_str             text               := '';
	proc_str            text               := '';

begin


--insert params to webservice_trans table
t_id                                     := nextval('dgmain.trans_id_seq');
insert into dgmain.webservice_trans
values
(t_id, current_date, p_params, p_trans_name);
-------------------------------------------------------------
--get function name
proc_str                                := 'get_function_name';
select lookup_value into lov_function from dgmain.lov_table where lookup_type = 'function' and lookup_key = p_trans_name;
raise notice '%', lov_function;
-------------------------------------------------------------
--build function call and execute
proc_str                                := 'build_function_call - ';
db_jsonb                                := p_params;
db_jsonb                                := jsonb_set(db_jsonb,array['trans_id'], (t_id::text)::jsonb);
sql_str                                 := 'call dgmain.' || lov_function || '('''|| db_jsonb || ''',jsonb_build_object(''send'',''value''))';
--
proc_str                                := 'execute_function_call';
execute sql_str;
commit;

-------------------------------------------------------------
--call trans proc function





--assign return message
proc_str                                := 'assign_return_message';
if db_jsonb ->> 'rtn_code' <> '1'
then
  j_msg                                 := '{"rtn_code":-1,"message":"There was an issue in function call"}';
else
  j_msg                                 := '{"rtn_code":1,"message":"Success!"}';
end if;
p_jsonb  := j_msg;
--return p_jsonb;
/*
exception when others then
  --return failure
	j_msg = '{"rtn_code":-1,"message":"There was an issue submitting the data. proc_step: ' || proc_str || ' err_msg: ' || sqlerrm || '"}';
	p_jsonb  := j_msg;
	--return p_jsonb;
	*/
end; $$
	LANGUAGE plpgsql;
