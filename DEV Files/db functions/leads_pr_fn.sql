create or replace function dgmain.leads_pr_fn()
returns int
LANGUAGE 'plpgsql'

COST 100
VOLATILE
as $leads_pr_fn$
declare


begin



return 1;
end $leads_pr_fn$;
