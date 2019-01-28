create or replace function dgmain.dg_lead_email_parse_fn
  (
    in p_lead_email       text
  )
returns jsonb
volatile
language 'plpgsql'
as $dg_lead_email_parse_fn$
declare

v_int           int     := 0;
line_int        int     := 0;
str_sql         text    := 'select ';
db_delim        text    := chr(183);
delim_cnt       int;
db_text         text;
db_int          int     := 0;
v_column        text;
parse_rec       text[];
adults          jsonb    := '{"adults":[]}';
adult_cnt       int     := 0;
children        jsonb    := '{"children":[]}';
child_cnt       int     := 0;
discount        jsonb    := '{"discounts":[]}';
discount_cnt    int     := 0;
adult_flag      boolean := TRUE;
child_flag      boolean := TRUE;
discount_flag   boolean := TRUE;
v_jsonb         jsonb;
resort          text;

begin

if strpos(p_lead_email, chr(183)) > 0
then
  select (CHAR_LENGTH(p_lead_email) - CHAR_LENGTH(REPLACE(p_lead_email, chr(183), '')))
  / CHAR_LENGTH(chr(183)) into v_int;
  db_delim                 := chr(183);
ELSIF strpos(p_lead_email, '•') > 0
then
  select (CHAR_LENGTH(p_lead_email) - CHAR_LENGTH(REPLACE(p_lead_email, '•', '')))
  / CHAR_LENGTH('•') into v_int;
  db_delim                 := '•';
end if;

--select vtext into db_text from dgmain.test_table;
db_text        := p_lead_email;

--build the array: one "line" for each bullet point
for i in 1..v_int
loop

  line_int := i + 1;
  parse_rec[i] := replace(regexp_replace(trim(split_part(db_text,db_delim, line_int)),E'[\\n\\r]+','!'), e'\t', ' ');

end loop;

------------------------------------------------------
--loop through "lines"
for db_int in 1..v_int
loop
  --
  --guaranteed quite flag
  if position('which type of quote you prefer' in parse_rec[db_int]) > 0 then

    if position('I want a guaranteed' in parse_rec[db_int]) > 0

    then

      v_jsonb := jsonb_build_object('guaranteed_quote','Yes');

    else

      v_jsonb := jsonb_build_object('guaranteed_quote','No');

    end if;

  end if;
  --
  --Lead Guest Name
  --
  if db_int in (3,4,5) then
    if position('Your Name' in parse_rec[db_int]) > 0
    then
      if db_delim = chr(183)
      then
        v_jsonb := v_jsonb || jsonb_build_object('first_name',REPLACE(split_part(parse_rec[db_int],' ',3),'!',''));
        v_jsonb := v_jsonb || jsonb_build_object('last_name',REPLACE(split_part(parse_rec[db_int],' ',4),'!',''));
      else
        v_jsonb := v_jsonb || jsonb_build_object('first_name',REPLACE(split_part(parse_rec[db_int],' ',4),'!',''));
        v_jsonb := v_jsonb || jsonb_build_object('last_name',REPLACE(split_part(parse_rec[db_int],' ',5),'!',''));
      end if;

    end if;
  end if;
  --
  --Lead Guest Address
  --
  if position('Address:' in parse_rec[db_int]) > 0
  then
    --find total address parts
    select (CHAR_LENGTH(vtext) - CHAR_LENGTH(REPLACE(vtext, '!', '')))
    / CHAR_LENGTH('!') into delim_cnt from dgmain.test_table;
    --build address based on number of parts
    if delim_cnt = 6
    THEN
      v_jsonb := v_jsonb || jsonb_build_object('address1',trim(leading ' ' from split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',2)));
      v_jsonb := v_jsonb || jsonb_build_object('city',split_part(split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',3),' ',1));
      v_jsonb := v_jsonb || jsonb_build_object('zip',split_part(split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',3),' ',2));
    else
      v_jsonb := v_jsonb || jsonb_build_object('address1',trim(leading ' ' from split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',2)));
      v_jsonb := v_jsonb || jsonb_build_object('address2',trim(leading ' ' from split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',3)));
      v_jsonb := v_jsonb || jsonb_build_object('city',split_part(split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',4),' ',1));
      v_jsonb := v_jsonb || jsonb_build_object('zip',split_part(split_part(regexp_replace(parse_rec[db_int],E'[\\n\\r]+','!'),'!',4),' ',2));
    end if;
  end if;
  --
  --Lead Guest State
  --
  if position('State ' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('state',REPLACE(substring(trim(parse_rec[db_int]),7),'!',''));

  end if;
  --
  --Lead Guest Country
  --
  if position('Country' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('country',REPLACE(substring(trim(parse_rec[db_int]),9),'!',''));

  end if;
  --
  --Lead Guest Email
  --
  if position('Email Address' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('email',REPLACE(split_part(trim(parse_rec[db_int]),' ',3),'!',''));

  end if;
  --
  --Lead Guest Telephone
  --
  if position('Telephone' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('phone',REPLACE(substring(trim(parse_rec[db_int]),11),'!',''));

  end if;
  --
  --Lead Guest Cell Phone
  --
  if position('Cell' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('cell',REPLACE(substring(trim(parse_rec[db_int]),12),'!',''));

  end if;
  --
  --Lead Guest Preferred Contact method
  --
  if position('Preferred Contact Method' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('preferred_contact_method',REPLACE(substring(trim(parse_rec[db_int]),26),'!',''));

  end if;
  --
  --Lead Guest Previous Disney Experience
  --
  if position('previous Disney experience' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('previous_disney_experience',REPLACE(substring(trim(parse_rec[db_int]),47),'!',''));

  end if;
  --
  --Lead Guest Previous Small World
  --
  if position('a previous guest of Small World' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('previous_small_world',REPLACE(substring(trim(parse_rec[db_int]),48),'!',''));

  end if;
  --
  --How did you find us?
  --
  if position('How did you find Small World Vacations?' in parse_rec[db_int]) > 0
  then

    if position('please select' in parse_rec[db_int]) = 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('find_small_world',REPLACE(substring(trim(parse_rec[db_int]),41),'!',''));
    end if;

  end if;
  --
  --Specific Agent Question
  --
  if position('Would you like to work with a specific Small World' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('specific_agent_flag','Y');
    end if;

  end if;
  --
  --Agent Name
  --
  if position('Please select an agent' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('agent_name',REPLACE(substring(trim(parse_rec[db_int]),24),'!',''));

  end if;
  --
  --How did you find us?
  --
  if position('Are you celebrating a special occasion?' in parse_rec[db_int]) > 0
  then

    if position('please select' in parse_rec[db_int]) = 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('special_occasion',REPLACE(substring(trim(parse_rec[db_int]),96),'!',''));
    end if;

  end if;
  --
  --Number of Rooms
  --
  if position('How many rooms would you like?' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('num_rooms',REPLACE(substring(trim(parse_rec[db_int]),32),'!',''));

  end if;
  --
  --adult loop
  --
  if position('Adults' in parse_rec[db_int]) > 0
  then
  loop
  exit when adult_flag = FALSE;
    --exit loop after reaching child line
    if position('Child' in parse_rec[db_int]) > 0
    then
      adult_flag      := FALSE;
    end if;
    --if still in adult section, continue loop
    if adult_flag = TRUE THEN
      --if line contains 'Adult' move to next line
      if position('Adult' in parse_rec[db_int]) > 0
      then
        db_int        := db_int + 1;
      else
        --adult name
        adult_cnt     := adult_cnt + 1;
        adults        := jsonb_set(adults,array['adults',(adult_cnt-1)::text],jsonb_build_object('adult_name',REPLACE(trim(substring(parse_rec[db_int],position('Name' in parse_rec[db_int])+5)),'!','')),true);

        --adult room
        db_int        := db_int + 1;
        adults        := jsonb_set(adults,array['adults',(adult_cnt-1)::text,'room'],('"' || REPLACE(parse_rec[db_int],'!','') || '"')::jsonb,true);
        --raise notice 'ROOM>db_int=%:adult_cnt=%:adult array=%:adult=%:line_value=%' ,db_int,adult_cnt,adult_cnt-1,adults,parse_rec[db_int];
        db_int        := db_int + 1;
      end if;

    END IF;
  end loop;
  end if;

  --
  --child loop
  --
  if position('Children?' in parse_rec[db_int]) > 0
  then
  loop
  exit when child_flag = FALSE;
    --exit loop after reaching child line
    if position('accommodations' in parse_rec[db_int]) > 0
    then
      child_flag      := FALSE;
    end if;
    --if still in adult section, continue loop
    if child_flag = TRUE THEN
      --if line contains 'Adult' move to next line
      if position('Child' in parse_rec[db_int]) > 0
      then
        db_int        := db_int + 1;
      else
        --child name
        child_cnt     := child_cnt + 1;
        children      := jsonb_set(children,array['children',(child_cnt-1)::text],jsonb_build_object('child_name',REPLACE(trim(substring(parse_rec[db_int],position('Name' in parse_rec[db_int])+5)),'!','')),true);
        --raise notice 'NAME=>db_int=%:child_cnt=%:children=%', db_int,child_cnt,children;
        --child room
        db_int        := db_int + 1;
        children      := jsonb_set(children,array['children',(child_cnt-1)::text,'room'],('"' || REPLACE(parse_rec[db_int],'!','') || '"')::jsonb,true);
        --raise notice 'ROOM=>db_int=%:child_cnt=%:children=%', db_int,child_cnt,children;
        --age at travel
        db_int        := db_int + 1;
        children      := jsonb_set(children,array['children',(child_cnt-1)::text,'age_at_travel'],('"' || REPLACE(substring(trim(parse_rec[db_int]),23),'!','') || '"')::jsonb,true);
        --raise notice 'AGE=>db_int=%:child_cnt=%:children=%', db_int,child_cnt,children;
        db_int        := db_int + 1;
      end if;

    END IF;
  end loop;
  end if;

  --
  --Handicap accessible
  --
  if position('require handicap accessible' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('handicap',REPLACE(substring(trim(parse_rec[db_int]),78),'!',''));

  end if;
  --
  --Handicap accessible
  --
  if position('my needs ' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('handicap_details',REPLACE(substring(trim(parse_rec[db_int]),78),'!',''));

  end if;
  --
  --Budget
  --
  if position('estimated budget' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('budget',REPLACE(substring(trim(parse_rec[db_int]),83),'!',''));

  end if;
  --
  --discount loop
  --
  if position('We search for the best deal for you' in parse_rec[db_int]) > 0
  then
  loop
  exit when discount_flag = FALSE;
    --exit loop after reaching child line
    if position('Unique Pin Code' in parse_rec[db_int]) > 0
    then
      discount_flag      := FALSE;
    end if;
    --if still in adult section, continue loop
    if discount_flag = TRUE THEN
      --if line contains 'Adult' move to next line
      --if position('Child' in parse_rec[db_int]) > 0
      --then
      --  db_int        := db_int + 1;
      --else
        --discount
        --db_int        := db_int + 1;
        discount_cnt  := discount_cnt + 1;
        discount      := jsonb_set(discount,array['discounts',(discount_cnt-1)::text],jsonb_build_object('discount',regexp_replace(REPLACE(trim(split_part(parse_rec[db_int],'o   ',discount_cnt+1)),'!',''),E'[\\n\\r]+','')),true);

        --raise notice 'DISCOUNT=>db_int=%:child_cnt=%:children=%', db_int,discount_cnt,discount;
        db_int        := db_int + 1;
    end if;

  end loop;
  end if;
  --
  --Other Discount
  --
  if position('Other' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('other_discount_info',REPLACE(substring(trim(parse_rec[db_int]),7),'!',''));

  end if;
  --
  --Unique Pin Code
  --
  if position('Unique Pin Code' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('unique_pin_code',REPLACE(substring(trim(parse_rec[db_int]),69),'!',''));

  end if;
  --
  --unique pin info
  --
  if position('along with your unique pin code' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('unique_pin_info',REPLACE(substring(trim(parse_rec[db_int]),115),'!',''));

  end if;
  --
  --Check-in Date
  --
  if position('Check-In Date' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('check_in',REPLACE(substring(trim(parse_rec[db_int]),15),'!',''));

  end if;
  --
  --Check-out Date
  --
  if position('Check-Out Date' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('check_out',REPLACE(substring(trim(parse_rec[db_int]),15),'!',''));

  end if;
  --
  --Resort
  --
  if position('Please select your resort' in parse_rec[db_int]) > 0
  then

    resort  := REPLACE(substring(trim(parse_rec[db_int]),27),'!','');
    v_jsonb := v_jsonb || jsonb_build_object('resort',resort);
    db_int  := db_int + 1;

  end if;
  --
  --Resort accommodations
  --
  if position(resort in parse_rec[db_int]) > 0
  then
    --raise notice 'resort-length:%->line_value:%', CHAR_LENGTH(resort),parse_rec[db_int];
    v_jsonb := v_jsonb || jsonb_build_object('resort_accomodations',REPLACE(substring(trim(parse_rec[db_int]),CHAR_LENGTH(resort)+2),'!',''));

  end if;
  --
  --Package Type
  --
  if position('For my Disney Vacation...' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('package_type',REPLACE(substring(trim(parse_rec[db_int]),27),'!',''));

  end if;
  --
  --Resort Package
  --
  if position('Choose a Disney Resort Hotel Package that' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('resort_pakage',REPLACE(substring(trim(parse_rec[db_int]),70),'!',''));

  end if;
  --
  --Room Only
  --
  if position('Room Only Reservation' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('resort_pakage',REPLACE(substring(trim(parse_rec[db_int]),23),'!',''));

  end if;
  --
  --Number of Passes
  --
  if position('How many days of theme park passes' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('num_of_passes',REPLACE(substring(trim(parse_rec[db_int]),47),'!',''));

  end if;
  --
  --park hopper
  --
  if position('hop between theme parks' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('park_hopper','Yes');
    else
      v_jsonb := v_jsonb || jsonb_build_object('park_hopper','No');
    end if;

  end if;
  --
  --park hopper plus
  --
  if position('Park Hopper Plus' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('park_hopper_plus','Yes');
    else
      v_jsonb := v_jsonb || jsonb_build_object('park_hopper_plus','No');
    end if;

  end if;
  --
  --Memory Maker
  --
  if position('Memory Maker Digital Photo Package' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('memory_maker','Yes');
    else
      v_jsonb := v_jsonb || jsonb_build_object('memory_maker','No');
    end if;

  end if;
  --
  --transportation
  --
  if position('How will you get to your Walt Disney World Resort?' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('transportation',REPLACE(substring(trim(parse_rec[db_int]),110),'!',''));

  end if;
  --
  --travel insurance
  --
  if position('Do you want to add travel insurance' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('travel_insurance','Yes');
    else
      v_jsonb := v_jsonb || jsonb_build_object('travel_insurance','No');
    end if;

  end if;
  --
  --pre/post Universal
  --
  if position('pre/post stay at an on-site Universal Orlando' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('universal_addon','Yes');
    else
      v_jsonb := v_jsonb || jsonb_build_object('universal_addon','No');
    end if;

  end if;
  --
  --pre/post cruise
  --
  if position('cruise before or after' in parse_rec[db_int]) > 0
  then

    if position('Yes' in parse_rec[db_int]) > 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('cruise_addon','Yes');
    else
      v_jsonb := v_jsonb || jsonb_build_object('cruise_addon','No');
    end if;

  end if;
  --
  --special requests
  --
  if position('How can we make your Disney vacation special?' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('special_requests',REPLACE(substring(trim(parse_rec[db_int]),47),'!',''));

  end if;
----------------------------------------------------------------
end loop;

--add groups to json
v_jsonb         := v_jsonb || adults || children || discount;

raise notice '>: %' ,jsonb_pretty(v_jsonb);

return v_jsonb;

end $dg_lead_email_parse_fn$;
