CREATE OR REPLACE PROCEDURE dgmain.new_lead_email_ld_sp(
	INOUT   p_params       jsonb,
  INOUT   p_jsonb        jsonb)

AS $$
declare
  new_lead                  jsonb;
  db_jsonb                  jsonb;
	db_current_date           date               := current_date;
	db_int                    int;
	v_message                 text;
	v_proc_step               text;

	--guest rec
	guest_rec                 dgmain.guests_trans;
	--
	--lead rec
	lead_rec                  dgmain.leads_trans;
	travel_group_rec          dgmain.travel_groups;
  --
	--work fields
	adult_num                  int                      := 0;
	child_num                  int                      := 0;
	guest_num                  int                      := 0;
	v_sql                      text;
	lead_id                    int;

begin

  lead_id                                         := nextval('dgmain.lead_id_seq');
  --temp table of guests
  drop table if exists guest_rec_temp;
	create temp table guest_rec_temp as
	select * from dgmain.guests_trans
	where 1 <> 1;
	--temp table of key_lookup
	drop table if exists key_lookup_temp;
	create temp table key_lookup_temp as
		select * from dgmain.guid_key_lookup_trans
		where 1 <> 1;

  select max(v_adult_num) into adult_num from (select jsonb_object_keys(p_params -> 'Adults')::int as v_adult_num) a;
	select max(v_child_num) into child_num from (select jsonb_object_keys(p_params -> 'Children')::int as v_child_num) a;

	guest_num                                          := coalesce((adult_num + coalesce(child_num,0)),1);

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
			guest_rec.dg_id                                := nextval('dgmain.dg_id_seq');
			guest_rec.last_room                            := (p_params -> 'Adults' -> i::text ->> 'room')::text;

			insert into guest_rec_temp values (guest_rec.*);
      ------------------------------------------------
			--key lookup values
			--
			--name|address
			--if guest_rec.address1 || guest_rec.city || guest_rec.state || guest_rec.zip is not null then
			--	insert into key_lookup_temp
			--	values
			--	(guest_rec.trans_id
			--		, db_current_date
			--		, 'I'
			--		, 'name|address'
			--		,  lower(guest_rec.first_name
			--		|| guest_rec.middle_name  || guest_rec.last_name
			--		|| guest_rec.name_suffix
			--		|| '|'
			--		|| guest_rec.address1 || guest_rec.city || guest_rec.state || guest_rec.zip)
			--		, null
			--		, guest_rec.dg_id);
			--end if;

			--	--name|email
			--	if guest_rec.email is not null then
			--		insert into key_lookup_temp
			--		values
			--		(guest_rec.trans_id
			--		, db_current_date
			--		, 'I'
			--		, 'name|email'
			--		,  lower(guest_rec.first_name
			--		|| guest_rec.middle_name  || guest_rec.last_name
			--		|| guest_rec.name_suffix
			--		|| '|'
			--		|| guest_rec.email)
			--		, null
			--		, guest_rec.dg_id);
			--end if;
			--	--
			--	--name|phone
			--	if guest_rec.phone is not null then
			--		insert into key_lookup_temp
			--		values
			--		(guest_rec.trans_id
			--		, db_current_date
			--		, 'I'
			--		, 'name|phone'
			--		,  lower(guest_rec.first_name
			--		 || guest_rec.middle_name  || guest_rec.last_name
			--		 || guest_rec.name_suffix
			--		 || '|'
			--		 || guest_rec.phone)
			--		 , null
			--		, guest_rec.dg_id);
			--end if;
			--	--
			--	--name|cell
			--	if guest_rec.cell is not null then
			--		insert into key_lookup_temp
			--		values
			--		(guest_rec.trans_id
			--			, db_current_date
			--			, 'I'
			--			, 'name|cell'
			--			,  lower(guest_rec.first_name
			--			|| guest_rec.middle_name  || guest_rec.last_name
			--			|| guest_rec.name_suffix
			--			|| '|'
			--			|| guest_rec.cell)
			--			, null
			--			, guest_rec.dg_id);
			--		end if;
      select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
				------------------------------------------------
		elsif i between 2 and adult_num
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
			guest_rec.dg_id                                := nextval('dgmain.dg_id_seq');
			guest_rec.last_room                            := (p_params -> 'Adults' -> i::text ->> 'room')::text;

			insert into guest_rec_temp values (guest_rec.*);

				------------------------------------------------
				------------------------------------------------
				--key lookup values
				--
				--name|address
				--if guest_rec.address1 || guest_rec.city || guest_rec.state || guest_rec.zip is not null then
				--	insert into key_lookup_temp
				--	values
				--	(guest_rec.trans_id
				--		, db_current_date
				--		, 'I'
				--		, 'name|address'
				--		,  lower(guest_rec.first_name
				--		|| guest_rec.middle_name  || guest_rec.last_name
				--		|| guest_rec.name_suffix
				--		|| '|'
				--		|| guest_rec.address1 || guest_rec.city || guest_rec.state || guest_rec.zip)
				--		, null
				--		, guest_rec.dg_id);
				--end if;

				--	--name|email
				--	if guest_rec.email is not null then
				--		insert into key_lookup_temp
				--		values
				--		(guest_rec.trans_id
				--		, db_current_date
				--		, 'I'
				--		, 'name|email'
				--		,  lower(guest_rec.first_name
				--		|| guest_rec.middle_name  || guest_rec.last_name
				--		|| guest_rec.name_suffix
				--		|| '|'
				--		|| guest_rec.email)
				--		, null
				--		, guest_rec.dg_id);
				--end if;
				--	--
				--	--name|phone
				--	if guest_rec.phone is not null then
				--		insert into key_lookup_temp
				--		values
				--		(guest_rec.trans_id
				--		, db_current_date
				--		, 'I'
				--		, 'name|phone'
				--		,  lower(guest_rec.first_name
				--		 || guest_rec.middle_name  || guest_rec.last_name
				--		 || guest_rec.name_suffix
				--		 || '|'
				--		 || guest_rec.phone)
				--		 , null
				--		, guest_rec.dg_id);
				--end if;
				--	--
				--	--name|cell
				--	if guest_rec.cell is not null then
				--		insert into key_lookup_temp
				--		values
				--		(guest_rec.trans_id
				--			, db_current_date
				--			, 'I'
				--			, 'name|cell'
				--			,  lower(guest_rec.first_name
				--			|| guest_rec.middle_name  || guest_rec.last_name
				--			|| guest_rec.name_suffix
				--			|| '|'
				--			|| guest_rec.cell)
				--			, null
				--			, guest_rec.dg_id);
				--		end if;
	      select * into db_int from key_lookup_temp_ld_fn(guest_rec);

				guest_rec                                      := null;
					------------------------------------------------

		elsif i > adult_num
		then
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
			guest_rec.dg_id                                := nextval('dgmain.dg_id_seq');
			guest_rec.child_flag                           := true;
			guest_rec.age_at_travel                        := (p_params -> 'Children' -> (i - adult_num)::text ->> 'age')::int;
			guest_rec.last_travel_date                     := (p_params ->> 'check_in')::timestamp;
			guest_rec.last_room                            := (p_params -> 'Children' -> (i - adult_num)::text ->> 'room')::text;

		  insert into guest_rec_temp values (guest_rec.*);

				------------------------------------------------
				------------------------------------------------
				--key lookup values
				--
				--name|address
				--if guest_rec.address1 || guest_rec.city || guest_rec.state || guest_rec.zip is not null then
				--	insert into key_lookup_temp
				--	values
				--	(guest_rec.trans_id
				--		, db_current_date
				--		, 'I'
				--		, 'name|address'
				--		,  lower(guest_rec.first_name
				--		|| guest_rec.middle_name  || guest_rec.last_name
				--		|| guest_rec.name_suffix
				--		|| '|'
				--		|| guest_rec.address1 || guest_rec.city || guest_rec.state || guest_rec.zip)
				--		, null
				--		, guest_rec.dg_id);
				--end if;

				--	--name|email
				--	if guest_rec.email is not null then
				--		insert into key_lookup_temp
				--		values
				--		(guest_rec.trans_id
				--		, db_current_date
				--		, 'I'
				--		, 'name|email'
				--		,  lower(guest_rec.first_name
				--		|| guest_rec.middle_name  || guest_rec.last_name
				--		|| guest_rec.name_suffix
				--		|| '|'
				--		|| guest_rec.email)
				--		, null
				--		, guest_rec.dg_id);
				--end if;
				--	--
				--	--name|phone
				--	if guest_rec.phone is not null then
				--		insert into key_lookup_temp
				--		values
				--		(guest_rec.trans_id
				--		, db_current_date
				--		, 'I'
				--		, 'name|phone'
				--		,  lower(guest_rec.first_name
				--		 || guest_rec.middle_name  || guest_rec.last_name
				--		 || guest_rec.name_suffix
				--		 || '|'
				--		 || guest_rec.phone)
				--		 , null
				--		, guest_rec.dg_id);
				--end if;
				--	--
				--	--name|cell
				--	if guest_rec.cell is not null then
				--		insert into key_lookup_temp
				--		values
				--		(guest_rec.trans_id
				--			, db_current_date
				--			, 'I'
				--			, 'name|cell'
				--			,  lower(guest_rec.first_name
				--			|| guest_rec.middle_name  || guest_rec.last_name
				--			|| guest_rec.name_suffix
				--			|| '|'
				--			|| guest_rec.cell)
				--			, null
				--			, guest_rec.dg_id);
				--		end if;
	      select * into db_int from key_lookup_temp_ld_fn(guest_rec);

				guest_rec                                      := null;
					------------------------------------------------
		end if;
	end loop;
	--------------------------------------------------------------------------
	v_proc_step                          := 'load lead_rec';
	--------------------------------------------------------------------------
  --lead rec
	lead_rec.trans_id                              := (p_params ->> 'trans_id')::text;
	lead_rec.load_date                             := db_current_date;
	lead_rec.status                                := 'I';
	lead_rec.lead_id                               := lead_id;
	lead_rec.check_in                              := (p_params ->> 'check_in')::text;
	lead_rec.check_out                             := (p_params ->> 'check_out')::text;
	lead_rec.guaranteed_quote                      := (p_params ->> 'guaranteed_quote')::text;
	lead_rec.source                                := (p_params ->> 'source')::text;
	lead_rec.num_rooms                             := (p_params ->> 'num_rooms')::int;
	lead_rec.previous_disney_experience            := (p_params ->> 'previous_disney_experience')::text;
	lead_rec.budget                                := (p_params ->> 'budget')::text;
	lead_rec.special_occasion                      := (p_params ->> 'special_occasion')::text;
	lead_rec.adults                                := p_params -> 'Adults';
	lead_rec.children                              := p_params -> 'Children';
	lead_rec.handicap                              := (p_params ->> 'handicap')::text;
	lead_rec.handicap_details                      := (p_params ->> 'handicap_details')::text;
	lead_rec.potential_discounts                   := p_params -> 'discounts';
	lead_rec.unique_pin_info                       := (p_params ->> 'unique_pin_info')::text;
	lead_rec.other_discount_info                   := (p_params ->> 'other_discount_info')::text;
	lead_rec.resort                                := (p_params ->> 'resort')::text;
	lead_rec.resort_accomodations                  := (p_params ->> 'resort_accomodations')::text;
	lead_rec.package_type                          := (p_params ->> 'package_type')::text;
	lead_rec.resort_pakage                         := (p_params ->> 'resort_pakage')::text;
	lead_rec.num_of_passes                         := (p_params ->> 'num_of_passes')::text;
	lead_rec.ticket_type                           := (p_params ->> 'ticket_type')::text;
	lead_rec.transportation                        := (p_params ->> 'transportation')::text;
	lead_rec.travel_insurance                      := (p_params ->> 'travel_insurance')::text;
	lead_rec.memory_maker                          := (p_params ->> 'memory_maker')::text;
	lead_rec.universal_addon                       := (p_params ->> 'universal_addon')::text;
	lead_rec.cruise_addon                          := (p_params ->> 'cruise_addon')::text;
	lead_rec.special_requests                      := (p_params ->> 'special_occasion')::text;

	insert into dgmain.leads_trans values(lead_rec.*);
	--------------------------------------------------------------------------
	v_proc_step                          := 'merge temp tables';
	--------------------------------------------------------------------------
	--guest temp
	insert into dgmain.guests_trans as a
		select * from guest_rec_temp as b where not exists
		(select null from dgmain.guests_trans as a
		where b.trans_id = a.trans_id);
	--
	--key_lookup temp
	insert into dgmain.guid_key_lookup_trans as a
		select * from key_lookup_temp as b where not exists
		(select null from dgmain.guid_key_lookup_trans as a
		where b.trans_id = a.trans_id);
	--
  db_jsonb                 := jsonb_build_object('rtn_code',1,'message','Success! - ' || v_proc_step);
  p_jsonb := db_jsonb;

end; $$ LANGUAGE plpgsql;
