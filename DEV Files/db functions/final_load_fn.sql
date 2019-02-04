create or replace function dgmain.final_load_fn()
returns int
LANGUAGE 'plpgsql'

COST 100
VOLATILE
as $final_load_fn$
declare

  g_rec                     record;
  l_rec                     record;

  --work fields
  db_current_date           date                         := current_date;


begin

----------------------------------------------------
--load guests to final table
----------------------------------------------------
  for g_rec in
    select
       guid
     , max(name_prefix) name_prefix
     , max(first_name) first_name
     , max(middle_name) middle_name
     , max(last_name) last_name
     , max(name_suffix) name_suffix
     , max(address1) address1
     , max(address2) address2
     , max(address3) address3
     , max(city) city
     , max(state) state
     , max(zip) zip
     , max(country) country
     , max(email) email
     , max(phone) phone
     , max(cell) cell
     , max(fax) fax
     , max(preferred_contact_method) preferred_contact_method
    from dgmain.guests_trans
    where status = 'P'
    group by guid
  loop

    insert into dgmain.guests as a
    values
    (g_rec.guid, g_rec.name_prefix, g_rec.first_name, g_rec.middle_name, g_rec.last_name,
    g_rec.name_suffix, g_rec.address1, g_rec.address2, g_rec.address3, g_rec.city,
    g_rec.state, g_rec.zip, g_rec.country, g_rec.email, g_rec.phone, g_rec.cell, g_rec.fax,
    g_rec.preferred_contact_method, db_current_date )
    on conflict(guid) do update
      set guid                         = g_rec.guid,
          name_prefix                  = g_rec.name_prefix,
          first_name                   = g_rec.first_name,
          middle_name                  = g_rec.middle_name,
          last_name                    = g_rec.last_name,
          name_suffix                  = g_rec.name_suffix,
          address1                     = g_rec.address1,
          address2                     = g_rec.address2,
          address3                     = g_rec.address3,
          city                         = g_rec.city,
          state                        = g_rec.state,
          zip                          = g_rec.zip,
          country                      = g_rec.country,
          email                        = g_rec.email,
          phone                        = g_rec.phone,
          cell                         = g_rec.cell,
          fax                          = g_rec.fax,
          preferred_contact_method     = g_rec.preferred_contact_method,
          last_updated                 = db_current_date
    where a.guid = g_rec.guid;

  end loop;

  ----------------------------------------------------
  --load leads to final table
  ----------------------------------------------------
    for l_rec in
      select
        lead_id
        , lead_guest_guid
        , travel_group
        , check_in
        , check_out
        , guaranteed_quote
        , source
        , num_rooms
        , previous_disney_experience
        , budget
        , special_occasion
        , adults
        , children
        , handicap
        , handicap_details
        , potential_discounts
        , unique_pin_info
        , other_discount_info
        , resort
        , resort_accomodations
        , room_view
        , room_bedding
        , package_type
        , resort_pakage
        , num_of_passes
        , ticket_type
        , ticket_valid_thru
        , transportation
        , travel_insurance
        , memory_maker
        , universal_addon
        , cruise_addon
        , special_requests
        , reservation_num
        , courtesy_hld_exp_date
        , final_payment_due_date
        , refurb
        , total_cost
        , cost_savings
        , discount_applied
      from dgmain.leads_trans
      where status = 'P'
    loop

      insert into dgmain.leads as a
      values
      (l_rec.lead_id, l_rec.lead_guest_guid, l_rec.travel_group, l_rec.check_in,
       l_rec.check_out, l_rec.guaranteed_quote, l_rec.source, l_rec.num_rooms,
       l_rec.previous_disney_experience, l_rec.budget, l_rec.special_occasion,
       l_rec.adults, l_rec.children, l_rec.handicap, l_rec.handicap_details,
       l_rec.potential_discounts, l_rec.unique_pin_info, l_rec.other_discount_info,
       l_rec.resort, l_rec.resort_accomodations, l_rec.room_view, l_rec.room_bedding,
       l_rec.package_type, l_rec.resort_pakage, l_rec.num_of_passes, l_rec.ticket_type,
       l_rec.ticket_valid_thru, l_rec.transportation, l_rec.travel_insurance,
       l_rec.memory_maker, l_rec.universal_addon, l_rec.cruise_addon, l_rec.special_requests,
       l_rec.reservation_num, l_rec.courtesy_hld_exp_date, l_rec.final_payment_due_date,
       l_rec.refurb, l_rec.total_cost, l_rec.cost_savings, l_rec.discount_applied )
      on conflict(lead_id) do update
        set lead_id                         = l_rec.lead_id                   ,
            lead_guest_guid                 = l_rec.lead_guest_guid           ,
            travel_group                    = l_rec.travel_group              ,
            check_in                        = l_rec.check_in                  ,
            check_out                       = l_rec.check_out                 ,
            guaranteed_quote                = l_rec.guaranteed_quote          ,
            source                          = l_rec.source                    ,
            num_rooms                       = l_rec.num_rooms                 ,
            previous_disney_experience      = l_rec.previous_disney_experience,
            budget                          = l_rec.budget                    ,
            special_occasion                = l_rec.special_occasion          ,
            adults                          = l_rec.adults                    ,
            children                        = l_rec.children                  ,
            handicap                        = l_rec.handicap                  ,
            handicap_details                = l_rec.handicap_details          ,
            potential_discounts             = l_rec.potential_discounts       ,
            unique_pin_info                 = l_rec.unique_pin_info           ,
            other_discount_info             = l_rec.other_discount_info       ,
            resort                          = l_rec.resort                    ,
            resort_accomodations            = l_rec.resort_accomodations      ,
            room_view                       = l_rec.room_view                 ,
            room_bedding                    = l_rec.room_bedding              ,
            package_type                    = l_rec.package_type              ,
            resort_pakage                   = l_rec.resort_pakage             ,
            num_of_passes                   = l_rec.num_of_passes             ,
            ticket_type                     = l_rec.ticket_type               ,
            ticket_valid_thru               = l_rec.ticket_valid_thru         ,
            transportation                  = l_rec.transportation            ,
            travel_insurance                = l_rec.travel_insurance          ,
            memory_maker                    = l_rec.memory_maker              ,
            universal_addon                 = l_rec.universal_addon           ,
            cruise_addon                    = l_rec.cruise_addon              ,
            special_requests                = l_rec.special_requests          ,
            reservation_num                 = l_rec.reservation_num           ,
            courtesy_hld_exp_date           = l_rec.courtesy_hld_exp_date     ,
            final_payment_due_date          = l_rec.final_payment_due_date    ,
            refurb                          = l_rec.refurb                    ,
            total_cost                      = l_rec.total_cost                ,
            cost_savings                    = l_rec.cost_savings              ,
            discount_applied                = l_rec.discount_applied
      where a.lead_id = l_rec.lead_id;

    end loop;

    --
    update dgmain.leads_trans
      set status = 'C'
      where status = 'P';

      --
      update dgmain.guests_trans
        set status = 'C'
        where status = 'P';

return 1;
end $final_load_fn$;
