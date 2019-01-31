CREATE OR REPLACE PROCEDURE dgmain.new_lead_email_ld_sp(
	INOUT   p_params       jsonb,
  INOUT   p_jsonb        jsonb)

AS $$
declare
  new_lead                  jsonb;
  db_jsonb                  jsonb;
	db_current_date           date               := current_date;
	v_message                 text;
	v_proc_step               text;

	--records
	guest_rec                 dgmain.guests_trans;
	lead_rec                  dgmain.leads;
	key_lookup_rec            dgmain.guid_key_lookup_trans;
	travel_group_rec          dgmain.travel_groups;

	--work fields
	adult_num                  int;
	child_num                  int;
	guest_num                  int                      := 0;

begin

  select max(v_adult_num) into adult_num from (select jsonb_object_keys(p_params -> 'Adults')::int as v_adult_num) a;
	select max(v_child_num) into child_num from (select jsonb_object_keys(p_params -> 'Children')::int as v_child_num) a;

	guest_num                                          := coalesce((adult_num + child_num),1);

  --------------------------------------------------------------------------
	v_proc_step                          := 'load guest_rec - ' || guest_num::text;
	--------------------------------------------------------------------------
  for i in 1..guest_num
	loop
    if i = 1 then
		  guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
	    guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
	    guest_rec.name_prefix                          := coalesce((p_params ->> 'name_prefix')::text,'');
	    guest_rec.first_name                           := coalesce((p_params ->> 'first_name')::text,'');
	    guest_rec.middle_name                          := coalesce((p_params ->> 'middle_name')::text,'');
	    guest_rec.last_name                            := coalesce((p_params ->> 'last_name')::text,'');
	    guest_rec.name_suffix                          := coalesce((p_params ->> 'name_suffix')::text,'');
	    guest_rec.address1                             := coalesce((p_params ->> 'address1')::text,'');
	    guest_rec.address2                             := coalesce((p_params ->> 'address2')::text,'');
	    guest_rec.address3                             := coalesce((p_params ->> 'address3')::text,'');
	    guest_rec.city                                 := coalesce((p_params ->> 'city')::text,'');
	    guest_rec.state                                := coalesce((p_params ->> 'state')::text,'');
	    guest_rec.zip                                  := coalesce((p_params ->> 'zip')::text,'');
	    guest_rec.country                              := coalesce((p_params ->> 'country')::text,'');
	    guest_rec.email                                := coalesce((p_params ->> 'email')::text,'');
	    guest_rec.phone                                := coalesce((p_params ->> 'phone')::text,'');
	    guest_rec.cell                                 := coalesce((p_params ->> 'cell')::text,'');
	    guest_rec.fax                                  := coalesce((p_params ->> 'fax')::text,'');
	    guest_rec.preferred_contact_method             := coalesce((p_params ->> 'preferred_contact_method')::text,'');

			insert into dgmain.guests_trans values (guest_rec.*);

		elsif i between 1 and adult_num
		then
		  guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
		  guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
		  guest_rec.name_prefix                          := split_part((p_params -> 'Adults' -> i::text ->> 'name')::text,' ',1);
		  guest_rec.first_name                           := split_part((p_params -> 'Adults' -> i::text ->> 'name')::text,' ',2);
		  guest_rec.middle_name                          := '';
		  guest_rec.last_name                            := split_part((p_params -> 'Adults' -> i::text ->> 'name')::text,' ',3);
		  guest_rec.name_suffix                          := '';
		  guest_rec.address1                             := coalesce((p_params ->> 'address1')::text,'');
		  guest_rec.address2                             := coalesce((p_params ->> 'address2')::text,'');
		  guest_rec.address3                             := coalesce((p_params ->> 'address3')::text,'');
		  guest_rec.city                                 := coalesce((p_params ->> 'city')::text,'');
		  guest_rec.state                                := coalesce((p_params ->> 'state')::text,'');
		  guest_rec.zip                                  := coalesce((p_params ->> 'zip')::text,'');
		  guest_rec.country                              := coalesce((p_params ->> 'country')::text,'');

			insert into dgmain.guests_trans values (guest_rec.*);

		else
		  guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
		  guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
		  guest_rec.name_prefix                          := split_part((p_params -> 'Children' -> (i - adult_num)::text ->> 'name')::text,' ',1);
		  guest_rec.first_name                           := split_part((p_params -> 'Children' -> (i - adult_num)::text ->> 'name')::text,' ',2);
		  guest_rec.middle_name                          := '';
		  guest_rec.last_name                            := split_part((p_params -> 'Children' -> (i - adult_num)::text ->> 'name')::text,' ',3);
		  guest_rec.name_suffix                          := '';
		  guest_rec.address1                             := coalesce((p_params ->> 'address1')::text,'');
		  guest_rec.address2                             := coalesce((p_params ->> 'address2')::text,'');
		  guest_rec.address3                             := coalesce((p_params ->> 'address3')::text,'');
		  guest_rec.city                                 := coalesce((p_params ->> 'city')::text,'');
		  guest_rec.state                                := coalesce((p_params ->> 'state')::text,'');
		  guest_rec.zip                                  := coalesce((p_params ->> 'zip')::text,'');
		  guest_rec.country                              := coalesce((p_params ->> 'country')::text,'');

		  insert into dgmain.guests_trans values (guest_rec.*);
		end if;
	end loop;


  db_jsonb                 := jsonb_build_object('rtn_code',1,'message','Success! - ' || v_proc_step);
  p_jsonb := db_jsonb;

end; $$ LANGUAGE plpgsql;
