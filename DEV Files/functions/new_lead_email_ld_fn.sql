create or replace function dgmain.new_lead_email_ld_fn (
		p_params jsonb)
RETURNS jsonb
LANGUAGE 'plpgsql'

COST 100
VOLATILE
AS $new_lead_email_ld_fn$
declare
  new_lead                  jsonb;
  db_jsonb                  jsonb;

begin

  db_jsonb                 := jsonb_build_object('rtn_code',1,'message','Success!');
  return db_jsonb;


end $new_lead_email_ld_fn$;
