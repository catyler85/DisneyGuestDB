CREATE OR REPLACE FUNCTION dgmain.webservice_insert_fn(
	p_params jsonb,
	p_trans_name text)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $webservice_insert_fn$
declare
  t_id                int;
  j_msg               jsonb;
	db_jsonb            jsonb;
	lov_function        text               := '';
	sql_str             text               := '';
	proc_str            text               := '';

begin

--raise notice '%', jsonb_pretty(p_params);

--insert params to webservice_trans table
t_id                                     := nextval('dgmain.trans_id_seq');
insert into dgmain.webservice_trans
values
(t_id, current_date, p_params, p_trans_name);

--get function name
proc_str                                := 'get_function_name';
select lookup_value into lov_function from dgmain.lov_table where lookup_type = 'function' and lookup_key = p_trans_name;
raise notice '%', lov_function;

--build function call and execute
proc_str                                := 'build_function_call - ';
sql_str                                 := 'select dgmain.' || lov_function || '('''|| p_params || ''')';

proc_str                                := 'execute_function_call';
execute sql_str into db_jsonb;

--assign return message
proc_str                                := 'assign_return_message';
if db_jsonb ->> 'rtn_code' <> '1'
then
  j_msg                                 := '{"rtn_code":-1,"message":"There was an issue in function call"}';
else
  j_msg                                 := '{"rtn_code":1,"message":"Success!"}';
end if;

return j_msg;
exception when others then
  --return failure
	j_msg = '{"rtn_code":-1,"message":"There was an issue submitting the data. proc_step: ' || proc_str || ' err_msg: ' || sqlerrm || '"}';
  return j_msg;
end $webservice_insert_fn$;
