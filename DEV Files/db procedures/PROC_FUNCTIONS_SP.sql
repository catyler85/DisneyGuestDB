CREATE OR REPLACE PROCEDURE dgmain.proc_function_sp(
	INOUT   p_params       jsonb,
  INOUT   p_jsonb        jsonb)

AS $$
declare

  proc_str            text               := '';
  rtn_code            int;

begin

  -------------------------------------------------------------
  --call trans proc functions
  -------------------------------------------------------------
  --guid_assign
  proc_str                                := 'guid_assign_fn';
  rtn_code                                := dgmain.guid_assign_fn();
  if rtn_code = 1
  then
    commit;
  else raise 'The process failed at %', proc_str;
  end if;
  --
  --lead process
  proc_str                                := 'leads_pr_fn';
  rtn_code                                := dgmain.leads_pr_fn();
  if rtn_code = 1
  then
    commit;
  else raise 'The process failed at %', proc_str;
  end if;
  --
  --loads
  proc_str                                := 'final_load_fn';
  rtn_code                                := dgmain.final_load_fn();
  if rtn_code = 1
  then
    commit;
  else raise 'The process failed at %', proc_str;
  end if;

  p_jsonb := ('{"rtn_code":1,"message":"Success!"}')::jsonb;

end; $$ LANGUAGE plpgsql;
