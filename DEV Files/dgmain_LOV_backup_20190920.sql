PGDMP         4                w           DGD     11.5 (Ubuntu 11.5-1.pgdg18.04+1)     11.5 (Ubuntu 11.5-1.pgdg18.04+1) f    "           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            #           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            $           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            %           1262    16393    DGD    DATABASE     w   CREATE DATABASE "DGD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE "DGD";
             dgadmin    false            	            2615    16394    dgmain    SCHEMA        CREATE SCHEMA dgmain;
    DROP SCHEMA dgmain;
             dgadmin    false                        3079    33427    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                  false            &           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                       false    2                       1255    35906    build_table_sp(jsonb, jsonb) 	   PROCEDURE     F  CREATE PROCEDURE dgmain.build_table_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)
    LANGUAGE plpgsql
    AS $$
declare
  db_jsonb                  jsonb;
  db_current_date           date               := current_date;
  i                         int;
  db_int                    int;
  v_lookup_key              text;
  lookup_json               json;
  v_sql_var                 text;
	v_sql                     text;
  v_sql_rec                 record;
  v_table                   text               := '';
  v_message                 text;
  v_proc_step               text;
  --
  --work variables
  lookup_rec                record;
	v_keyword                 text               := '';

begin

--temp table of guests
drop table if exists lookup_temp;
create temp table lookup_temp (
  lookup_key  text,
  lookup_json json
);


v_keyword                                            := replace((p_params ->> 'keyword')::text, ' ', '|');

for i in 1..jsonb_array_length(p_params -> 'lov_values')
loop
  v_lookup_key                                         := (p_params -> 'lov_values' ->> (i-1))::text;
  raise notice 'lookup_key: %', v_lookup_key;
  select lookup_value into v_sql from dgmain.lov_table a where a.lookup_type = 'sql' and a.lookup_key = v_lookup_key;
  --raise notice 'v_sql: %', v_sql;

  --prepare v_sql_var(text) as v_sql;

  for v_sql_rec in execute v_sql using v_keyword
  loop
     insert into lookup_temp values (v_lookup_key::text, v_sql_rec.table_row_json::json);
  end loop;

--  insert into lookup_temp values (v_lookup_key::text, lookup_json::json);

end loop;

for lookup_rec in
select a.lookup_json::json from lookup_temp a
loop
  v_table := v_table || (lookup_rec.lookup_json ->> 'table_row_json')::text;
end loop;
p_jsonb := jsonb_build_object('html_table', v_table) || ('{"rtn_code":1,"message":"Success!"}')::jsonb;

end; $$;
 Q   DROP PROCEDURE dgmain.build_table_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            '           0    0 C   PROCEDURE build_table_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)    ACL     �   REVOKE ALL ON PROCEDURE dgmain.build_table_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.build_table_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    286                       1255    16481    dashboard_ld_sp(jsonb, jsonb) 	   PROCEDURE     l	  CREATE PROCEDURE dgmain.dashboard_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)
    LANGUAGE plpgsql
    AS $$
declare
  db_jsonb                  jsonb;
  db_current_date           date               := current_date;
  i                         int;
  db_int                    int;
  v_lookup_key              text;
  lookup_json               json;
  v_sql                     text;
  v_sql_rec                 record;
  v_table                   text               := '';
  v_message                 text;
  v_proc_step               text;
  --
  --work variables
  lookup_rec                record;

begin

--temp table of guests
drop table if exists lookup_temp;
create temp table lookup_temp (
  lookup_key  text,
  lookup_json json
);

for i in 1..jsonb_array_length(p_params -> 'lov_values')
loop
  v_lookup_key                                         := (p_params -> 'lov_values' ->> (i-1))::text;
  raise notice 'lookup_key: %', v_lookup_key;
  select lookup_value into v_sql from dgmain.lov_table a where a.lookup_type = 'sql' and a.lookup_key = v_lookup_key;
  --raise notice 'v_sql: %', v_sql;
  for v_sql_rec in execute v_sql
  loop
     insert into lookup_temp values (v_lookup_key::text, v_sql_rec.recent_leads_json::json);
  end loop;

--  insert into lookup_temp values (v_lookup_key::text, lookup_json::json);

end loop;

for lookup_rec in
select a.lookup_json::json from lookup_temp a
loop
  v_table := v_table || '<tr onclick=''row_select(this)''>' ||chr(10);
	v_table := v_table || chr(9) || '<td class=''w3-hide''>' || (lookup_rec.lookup_json ->> 'lead_id')::text || '</td>' ||chr(10);
	v_table := v_table || chr(9) || '<td class=''w3-hide''>lead_id</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || (lookup_rec.lookup_json ->> 'lead_guest')::text  || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || to_char(to_date(lookup_rec.lookup_json ->> 'check_in','yyyy-mm-dd'),'mm/dd/yy')::text || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || to_char(to_date(lookup_rec.lookup_json ->> 'check_out','yyyy-mm-dd'),'mm/dd/yy')::text || '</td>' ||chr(10);
  v_table := v_table || chr(9) || '<td>' || coalesce((lookup_rec.lookup_json ->> 'resort')::text,'X') || '</td>' ||chr(10);
  v_table := v_table || '</tr>' ||chr(10);
end loop;
p_jsonb := jsonb_build_object('home_recent_leads', v_table) || ('{"rtn_code":1,"message":"Success!"}')::jsonb;

end; $$;
 R   DROP PROCEDURE dgmain.dashboard_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            (           0    0 D   PROCEDURE dashboard_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)    ACL     �   REVOKE ALL ON PROCEDURE dgmain.dashboard_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.dashboard_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    281            �            1255    16472    dg_lead_email_parse_fn(text)    FUNCTION     D  CREATE FUNCTION dgmain.dg_lead_email_parse_fn(p_lead_email text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
  parse_rec[i] := replace(regexp_replace(trim(split_part(db_text,db_delim, line_int)),E'[\\n\\r]+','~'), e'\t', ' ');

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
        v_jsonb := v_jsonb || jsonb_build_object('first_name',REPLACE(split_part(parse_rec[db_int],' ',3),'~',''));
        v_jsonb := v_jsonb || jsonb_build_object('last_name',REPLACE(split_part(parse_rec[db_int],' ',4),'~',''));
      else
        v_jsonb := v_jsonb || jsonb_build_object('first_name',REPLACE(split_part(parse_rec[db_int],' ',4),'~',''));
        v_jsonb := v_jsonb || jsonb_build_object('last_name',REPLACE(split_part(parse_rec[db_int],' ',5),'~',''));
      end if;

    end if;
  end if;
  --
  --Lead Guest Address
  --
  if position('Address:' in parse_rec[db_int]) > 0
  then
    --find total address parts
    select (CHAR_LENGTH(parse_rec[db_int]) - CHAR_LENGTH(REPLACE(parse_rec[db_int], '~', '')))
    / CHAR_LENGTH('~') into delim_cnt ;
    --build address based on number of parts
    if delim_cnt = 1
    THEN
      v_jsonb := v_jsonb || jsonb_build_object('address1',trim(leading ' ' from split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',2)));
      v_jsonb := v_jsonb || jsonb_build_object('city',split_part(split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',3),' ',1));
      v_jsonb := v_jsonb || jsonb_build_object('zip',split_part(split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',3),' ',2));
    else
      v_jsonb := v_jsonb || jsonb_build_object('address1',trim(leading ' ' from split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',2)));
      v_jsonb := v_jsonb || jsonb_build_object('address2',trim(leading ' ' from split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',3)));
      v_jsonb := v_jsonb || jsonb_build_object('city',split_part(split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',4),' ',1));
      v_jsonb := v_jsonb || jsonb_build_object('zip',split_part(split_part(regexp_replace(replace(parse_rec[db_int],'!','~'),E'[\\n\\r]+','~'),'~',4),' ',2));
    end if;
  end if;
  --
  --Lead Guest State
  --
  if position('State ' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('state',REPLACE(substring(trim(parse_rec[db_int]),7),'~',''));

  end if;
  --
  --Lead Guest Country
  --
  if position('Country' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('country',REPLACE(substring(trim(parse_rec[db_int]),9),'~',''));

  end if;
  --
  --Lead Guest Email
  --
  if position('Email Address' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('email',REPLACE(split_part(trim(parse_rec[db_int]),' ',3),'~',''));

  end if;
  --
  --Lead Guest Telephone
  --
  if position('Telephone' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('phone',REPLACE(substring(trim(parse_rec[db_int]),11),'~',''));

  end if;
  --
  --Lead Guest Cell Phone
  --
  if position('Cell' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('cell',REPLACE(substring(trim(parse_rec[db_int]),12),'~',''));

  end if;
  --
  --Lead Guest Preferred Contact method
  --
  if position('Preferred Contact Method' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('preferred_contact_method',REPLACE(substring(trim(parse_rec[db_int]),26),'~',''));

  end if;
  --
  --Lead Guest Previous Disney Experience
  --
  if position('previous Disney experience' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('previous_disney_experience',REPLACE(substring(trim(parse_rec[db_int]),47),'~',''));

  end if;
  --
  --Lead Guest Previous Small World
  --
  if position('a previous guest of Small World' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('previous_small_world',REPLACE(substring(trim(parse_rec[db_int]),48),'~',''));

  end if;
  --
  --How did you find us?
  --
  if position('How did you find Small World Vacations?' in parse_rec[db_int]) > 0
  then

    if position('please select' in parse_rec[db_int]) = 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('find_small_world',REPLACE(substring(trim(parse_rec[db_int]),41),'~',''));
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

    v_jsonb := v_jsonb || jsonb_build_object('agent_name',REPLACE(substring(trim(parse_rec[db_int]),24),'~',''));

  end if;
  --
  --How did you find us?
  --
  if position('Are you celebrating a special occasion?' in parse_rec[db_int]) > 0
  then

    if position('please select' in parse_rec[db_int]) = 0
    then
      v_jsonb := v_jsonb || jsonb_build_object('special_occasion',REPLACE(substring(trim(parse_rec[db_int]),96),'~',''));
    end if;

  end if;
  --
  --Number of Rooms
  --
  if position('How many rooms would you like?' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('num_rooms',REPLACE(substring(trim(parse_rec[db_int]),32),'~',''));

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
        adults        := jsonb_set(adults,array['adults',(adult_cnt-1)::text],jsonb_build_object('adult_name',REPLACE(trim(substring(parse_rec[db_int],position('Name' in parse_rec[db_int])+5)),'~','')),true);

        --adult room
        db_int        := db_int + 1;
        adults        := jsonb_set(adults,array['adults',(adult_cnt-1)::text,'room'],('"' || REPLACE(parse_rec[db_int],'~','') || '"')::jsonb,true);
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
        children      := jsonb_set(children,array['children',(child_cnt-1)::text],jsonb_build_object('child_name',REPLACE(trim(substring(parse_rec[db_int],position('Name' in parse_rec[db_int])+5)),'~','')),true);
        --raise notice 'NAME=>db_int=%:child_cnt=%:children=%', db_int,child_cnt,children;
        --child room
        db_int        := db_int + 1;
        children      := jsonb_set(children,array['children',(child_cnt-1)::text,'room'],('"' || REPLACE(parse_rec[db_int],'~','') || '"')::jsonb,true);
        --raise notice 'ROOM=>db_int=%:child_cnt=%:children=%', db_int,child_cnt,children;
        --age at travel
        db_int        := db_int + 1;
        children      := jsonb_set(children,array['children',(child_cnt-1)::text,'age_at_travel'],('"' || REPLACE(substring(trim(parse_rec[db_int]),23),'~','') || '"')::jsonb,true);
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

    v_jsonb := v_jsonb || jsonb_build_object('handicap',REPLACE(substring(trim(parse_rec[db_int]),78),'~',''));

  end if;
  --
  --Handicap accessible
  --
  if position('my needs ' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('handicap_details',REPLACE(substring(trim(parse_rec[db_int]),78),'~',''));

  end if;
  --
  --Budget
  --
  if position('estimated budget' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('budget',REPLACE(substring(trim(parse_rec[db_int]),83),'~',''));

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
        discount      := jsonb_set(discount,array['discounts',(discount_cnt-1)::text],jsonb_build_object('discount',regexp_replace(REPLACE(trim(split_part(parse_rec[db_int],'o   ',discount_cnt+1)),'~',''),E'[\\n\\r]+','')),true);

        raise notice 'DISCOUNT=>db_int=%:discount_cnt=%:discount=%', db_int,discount_cnt,discount;
        db_int        := db_int + 1;
    end if;

  end loop;
  end if;
  --
  --Other Discount
  --
  if position('Other' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('other_discount_info',REPLACE(substring(trim(parse_rec[db_int]),7),'~',''));

  end if;
  --
  --Unique Pin Code
  --
  if position('Unique Pin Code' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('unique_pin_code',REPLACE(substring(trim(parse_rec[db_int]),69),'~',''));

  end if;
  --
  --unique pin info
  --
  if position('along with your unique pin code' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('unique_pin_info',REPLACE(substring(trim(parse_rec[db_int]),115),'~',''));

  end if;
  --
  --Check-in Date
  --
  if position('Check-In Date' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('check_in',REPLACE(substring(trim(parse_rec[db_int]),15),'~',''));

  end if;
  --
  --Check-out Date
  --
  if position('Check-Out Date' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('check_out',REPLACE(substring(trim(parse_rec[db_int]),15),'~',''));

  end if;
  --
  --Resort
  --
  if position('Please select your resort' in parse_rec[db_int]) > 0
  then

    resort  := REPLACE(substring(trim(parse_rec[db_int]),27),'~','');
    v_jsonb := v_jsonb || jsonb_build_object('resort',resort);
    db_int  := db_int + 1;

  end if;
  --
  --Resort accommodations
  --
  if position(resort in parse_rec[db_int]) > 0
  then
    --raise notice 'resort-length:%->line_value:%', CHAR_LENGTH(resort),parse_rec[db_int];
    v_jsonb := v_jsonb || jsonb_build_object('resort_accomodations',REPLACE(substring(trim(parse_rec[db_int]),CHAR_LENGTH(resort)+2),'~',''));

  end if;
  --
  --Package Type
  --
  if position('For my Disney Vacation...' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('package_type',REPLACE(substring(trim(parse_rec[db_int]),27),'~',''));

  end if;
  --
  --Resort Package
  --
  if position('Choose a Disney Resort Hotel Package that' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('resort_pakage',REPLACE(substring(trim(parse_rec[db_int]),70),'~',''));

  end if;
  --
  --Room Only
  --
  if position('Room Only Reservation' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('resort_pakage',REPLACE(substring(trim(parse_rec[db_int]),23),'~',''));

  end if;
  --
  --Number of Passes
  --
  if position('How many days of theme park passes' in parse_rec[db_int]) > 0
  then

    v_jsonb := v_jsonb || jsonb_build_object('num_of_passes',REPLACE(substring(trim(parse_rec[db_int]),47),'~',''));

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

    v_jsonb := v_jsonb || jsonb_build_object('transportation',REPLACE(substring(trim(parse_rec[db_int]),110),'~',''));

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

    v_jsonb := v_jsonb || jsonb_build_object('special_requests',REPLACE(substring(trim(parse_rec[db_int]),47),'~',''));

  end if;
----------------------------------------------------------------
end loop;

--add groups to json
v_jsonb         := v_jsonb || adults || children || discount;

raise notice '>: %' ,jsonb_pretty(v_jsonb);

return v_jsonb;

end $$;
 @   DROP FUNCTION dgmain.dg_lead_email_parse_fn(p_lead_email text);
       dgmain       dgadmin    false    9            )           0    0 2   FUNCTION dg_lead_email_parse_fn(p_lead_email text)    ACL     �   REVOKE ALL ON FUNCTION dgmain.dg_lead_email_parse_fn(p_lead_email text) FROM dgadmin;
GRANT ALL ON FUNCTION dgmain.dg_lead_email_parse_fn(p_lead_email text) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    232                       1255    33382    edit_lead_ld_sp(jsonb, jsonb) 	   PROCEDURE     �<  CREATE PROCEDURE dgmain.edit_lead_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)
    LANGUAGE plpgsql
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
	v_resort_name             text                     := '';
	v_room                    text                     := '';
  --
	--work fields
	adult_num                 int                      := 0;
	child_num                 int                      := 0;
	guest_num                 int                      := 0;
	v_sql                     text;
	v_lead_id                   int;

begin

  v_lead_id                                         := coalesce((p_params ->> 'lead_id')::int, nextval('dgmain.lead_id_seq'));
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

  select max(v_adult_num) into adult_num from (select jsonb_array_length(p_params -> 'Adults')::int as v_adult_num) a;
	select max(v_child_num) into child_num from (select jsonb_array_length(p_params -> 'Children')::int as v_child_num) a;

	guest_num                                          := coalesce((adult_num + coalesce(child_num,0)),1);

  --------------------------------------------------------------------------
	v_proc_step                          := 'load guest_rec - ' || guest_num::text;
	--------------------------------------------------------------------------
  for i in 1..guest_num
	loop
    --if i = 1 then
    if i <= adult_num then
    /*  db_int                                         := nextval('dgmain.dg_id_seq');
			p_params                                       := jsonb_set(p_params, array['Adults', '1'::text, 'dg_id'], ('"' || db_int || '"')::jsonb );
			--
			guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
	    guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
	    guest_rec.name_prefix                          := coalesce((p_params 'Adults' -> i::text ->> 'name_prefix')::text,'');
	    guest_rec.first_name                           := coalesce((p_params 'Adults' -> i::text ->> 'first_name')::text,'');
	    guest_rec.middle_name                          := coalesce((p_params 'Adults' -> i::text ->> 'middle_name')::text,'');
	    guest_rec.last_name                            := coalesce((p_params 'Adults' -> i::text ->> 'last_name')::text,'');
	    guest_rec.name_suffix                          := coalesce((p_params 'Adults' -> i::text ->> 'name_suffix')::text,'');
	    guest_rec.address1                             := coalesce((p_params 'Adults' -> i::text ->> 'address1')::text,'');
	    guest_rec.address2                             := coalesce((p_params 'Adults' -> i::text ->> 'address2')::text,'');
	    guest_rec.address3                             := coalesce((p_params 'Adults' -> i::text ->> 'address3')::text,'');
	    guest_rec.city                                 := coalesce((p_params 'Adults' -> i::text ->> 'city')::text,'');
	    guest_rec.state                                := coalesce((p_params 'Adults' -> i::text ->> 'state')::text,'');
	    guest_rec.zip                                  := coalesce((p_params 'Adults' -> i::text ->> 'zip')::text,'');
	    guest_rec.country                              := coalesce((p_params 'Adults' -> i::text ->> 'country')::text,'');
	    guest_rec.email                                := coalesce((p_params 'Adults' -> i::text ->> 'email')::text,'');
	    guest_rec.phone                                := coalesce((p_params 'Adults' -> i::text ->> 'phone')::text,'');
	    guest_rec.cell                                 := coalesce((p_params 'Adults' -> i::text ->> 'cell')::text,'');
	    guest_rec.fax                                  := coalesce((p_params 'Adults' -> i::text ->> 'fax')::text,'');
	    guest_rec.preferred_contact_method             := coalesce((p_params 'Adults' -> i::text ->> 'contact_preference')::text,'');
			guest_rec.dg_id                                := db_int;
			guest_rec.last_room                            := (p_params -> 'Adults' -> i::text ->> 'room')::text;

			insert into guest_rec_temp values (guest_rec.*);
      ------------------------------------------------
      select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
				------------------------------------------------
		elsif i <= adult_num
		then*/
		  db_int                                         := nextval('dgmain.dg_id_seq');
		  p_params                                       := jsonb_set(p_params, array['Adults', (i-1)::text, 'dg_id'], ('"' || db_int || '"')::jsonb );
			--
			guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
		  guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
		  guest_rec.name_prefix                          := (p_params -> 'Adults' -> (i-1) ->> 'name_prefix');
		  guest_rec.first_name                           := (p_params -> 'Adults' -> (i-1) ->> 'first_name');
		  guest_rec.middle_name                          := (p_params -> 'Adults' -> (i-1) ->> 'middle_name');
		  guest_rec.last_name                            := (p_params -> 'Adults' -> (i-1) ->> 'last_name');
		  guest_rec.name_suffix                          := (p_params -> 'Adults' -> (i-1) ->> 'name_suffix');
		  guest_rec.address1                             := coalesce((p_params -> 'Adults' -> (i-1) ->> 'address1')::text,'');
		  guest_rec.address2                             := coalesce((p_params -> 'Adults' -> (i-1) ->> 'address2')::text,'');
		  guest_rec.address3                             := coalesce((p_params -> 'Adults' -> (i-1) ->> 'address3')::text,'');
		  guest_rec.city                                 := coalesce((p_params -> 'Adults' -> (i-1) ->> 'city')::text,'');
		  guest_rec.state                                := coalesce((p_params -> 'Adults' -> (i-1) ->> 'state')::text,'');
		  guest_rec.zip                                  := coalesce((p_params -> 'Adults' -> (i-1) ->> 'zip')::text,'');
		  guest_rec.country                              := coalesce((p_params -> 'Adults' -> (i-1) ->> 'country')::text,'');
	    guest_rec.email                                := coalesce((p_params -> 'Adults' -> (i-1) ->> 'email')::text,'');
	    guest_rec.phone                                := coalesce((p_params -> 'Adults' -> (i-1) ->> 'phone')::text,'');
	    guest_rec.cell                                 := coalesce((p_params -> 'Adults' -> (i-1) ->> 'cell')::text,'');
	    guest_rec.fax                                  := coalesce((p_params -> 'Adults' -> (i-1) ->> 'fax')::text,'');
	    guest_rec.preferred_contact_method             := coalesce((p_params -> 'Adults' -> (i-1) ->> 'contact_preference')::text,'');
			guest_rec.dg_id                                := db_int;
			guest_rec.last_room                            := (p_params -> 'Adults' -> (i-1) ->> 'room')::text;
      --raise notice 'guest %: values: %', i, guest_rec;
			insert into guest_rec_temp values (guest_rec.*);
			------------------------------------------------
	    select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
			------------------------------------------------

		elsif i > adult_num
		then
		  db_int                                         := nextval('dgmain.dg_id_seq');
		  p_params                                       := jsonb_set(p_params, array['Children', (i - (adult_num +1))::text, 'dg_id'], ('"' || db_int || '"')::jsonb );
		  --
			guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
		  guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
		  guest_rec.name_prefix                          := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'name_prefix');
		  guest_rec.first_name                           := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'first_name');
		  guest_rec.middle_name                          := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'middle_name');
		  guest_rec.last_name                            := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'last_name');
		  guest_rec.name_suffix                          := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'name_suffix');
		  guest_rec.address1                             := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'address1')::text,'');
		  guest_rec.address2                             := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'address2')::text,'');
		  guest_rec.address3                             := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'address3')::text,'');
		  guest_rec.city                                 := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'city')::text,'');
		  guest_rec.state                                := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'state')::text,'');
		  guest_rec.zip                                  := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'zip')::text,'');
		  guest_rec.country                              := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'country')::text,'');
	    guest_rec.email                                := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'email')::text,'');
	    guest_rec.phone                                := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'phone')::text,'');
	    guest_rec.cell                                 := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'cell')::text,'');
	    guest_rec.fax                                  := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'fax')::text,'');
	    guest_rec.preferred_contact_method             := coalesce((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'contact_preference')::text,'');
			guest_rec.dg_id                                := db_int;
			guest_rec.child_flag                           := true;
			guest_rec.age_at_travel                        := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'age_at_travel')::int;
			guest_rec.last_travel_date                     := (p_params ->> 'check_in')::timestamp;
			guest_rec.last_room                            := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'room')::text;

		  insert into guest_rec_temp values (guest_rec.*);
			------------------------------------------------
      select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
			------------------------------------------------
		end if;
	end loop;
	--------------------------------------------------------------------------
	v_proc_step                          := 'load lead_rec';
	--------------------------------------------------------------------------
	select resort_name, room into v_resort_name, v_room from (
  select a.resort_name, a.room, similarity(a.room, l.resort_accomodations) match_value,
  row_number() over (partition by a.resort_name order by similarity(a.room, l.resort_accomodations) desc) rn
  from (
  select r.resort_name, unnest(r.rooms) room
  from dgmain.resorts r) a
  join dgmain.leads l
    on a.resort_name = replace(l.resort, '’', '''')
  where l.lead_id = v_lead_id) b
  where rn = 1;


	--lead rec
	lead_rec.trans_id                              := (p_params ->> 'trans_id')::text;
	lead_rec.load_date                             := db_current_date;
	lead_rec.status                                := 'I';
	lead_rec.lead_id                               := v_lead_id;
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
	lead_rec.potential_discounts                   := p_params -> 'potential_discounts';
	lead_rec.unique_pin_info                       := (p_params ->> 'unique_pin_info')::text;
	lead_rec.other_discount_info                   := (p_params ->> 'other_discount_info')::text;
	lead_rec.resort                                := v_resort_name;
	lead_rec.resort_accomodations                  := v_room;
	lead_rec.package_type                          := (p_params ->> 'package_type')::text;
	lead_rec.resort_pakage                         := (p_params ->> 'resort_pakage')::text;
	lead_rec.num_of_passes                         := (p_params ->> 'num_of_passes')::text;
	lead_rec.ticket_type                           := (p_params ->> 'ticket_type')::text;
	lead_rec.transportation                        := (p_params ->> 'transportation')::text;
	lead_rec.travel_insurance                      := (p_params ->> 'travel_insurance')::text;
	lead_rec.memory_maker                          := (p_params ->> 'memory_maker')::text;
	lead_rec.universal_addon                       := (p_params ->> 'universal_addon')::text;
	lead_rec.cruise_addon                          := (p_params ->> 'cruise_addon')::text;
	lead_rec.special_requests                      := (p_params ->> 'special_requests')::text;

	insert into dgmain.leads_trans as a values(lead_rec.*);
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

end; $$;
 R   DROP PROCEDURE dgmain.edit_lead_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            *           0    0 D   PROCEDURE edit_lead_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)    ACL     �   REVOKE ALL ON PROCEDURE dgmain.edit_lead_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.edit_lead_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    272            �            1255    16474    final_load_fn()    FUNCTION     �  CREATE FUNCTION dgmain.final_load_fn() RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
    select * from (
      select
         a.*
       , row_number() over (partition by a.guid order by a.dg_id desc) rn
      from dgmain.guests_trans a
      where status = 'P'
    ) x1
    where rn = 1
  loop

    insert into dgmain.guests as a
    values
    (g_rec.guid, g_rec.name_prefix, g_rec.first_name, g_rec.middle_name, g_rec.last_name,
    g_rec.name_suffix, g_rec.address1, g_rec.address2, g_rec.address3, g_rec.city,
    g_rec.state, g_rec.zip, g_rec.country, g_rec.email, g_rec.phone, g_rec.cell, g_rec.fax,
    g_rec.preferred_contact_method, db_current_date, g_rec.child_flag,
    g_rec.age_at_travel, g_rec.last_travel_date )
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
          last_updated                 = db_current_date,
          child_flag                   = g_rec.child_flag,
          age_at_travel                = g_rec.age_at_travel,
          last_travel_date             = g_rec.last_travel_date
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
        , notes
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
       l_rec.refurb, l_rec.total_cost, l_rec.cost_savings, l_rec.discount_applied, l_rec.notes )
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
            discount_applied                = l_rec.discount_applied          ,
            notes                           = l_rec.notes
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
end $$;
 &   DROP FUNCTION dgmain.final_load_fn();
       dgmain       dgadmin    false    9            +           0    0    FUNCTION final_load_fn()    ACL     �   REVOKE ALL ON FUNCTION dgmain.final_load_fn() FROM dgadmin;
GRANT ALL ON FUNCTION dgmain.final_load_fn() TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    233                       1255    16482    form_ld_sp(jsonb, jsonb) 	   PROCEDURE     �  CREATE PROCEDURE dgmain.form_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)
    LANGUAGE plpgsql
    AS $$
declare
  db_jsonb                  jsonb;
  db_current_date           date               := current_date;
  i                         int;
  db_int                    int;
  v_lookup_key              text;
  v_lookup_value            text;
  v_lookup_rec              record;
  v_sql                     text;
  v_sql_rec                 record;
  v_table                   text               := '';
  v_message                 text;
  v_proc_step               text;
begin
  -----------------------------------------
  --init section
  -----------------------------------------
  v_proc_step                                  := 'init section';
  --
  v_lookup_key                                 := p_params ->> 'lookup_key';
  v_lookup_value                               := p_params ->> 'lookup_value';
  db_jsonb                                     := jsonb_build_object('form_ld_sp',null);
  -----------------------------------------

  -----------------------------------------
  --main section
  -----------------------------------------
  v_proc_step                                  := 'main section';
  --
  for v_sql_rec in
    (select * from dgmain.lov_table lov
    where lov.lookup_key = v_lookup_key
    and lov.lookup_type = 'sql'
    order by lov.lookup_seq)
  loop
    v_sql                                      := v_sql_rec.lookup_value;

    execute v_sql into v_lookup_rec using v_lookup_value::int;

    db_jsonb                                   := db_jsonb || v_lookup_rec.jsonb_rtn;
    --raise notice '%', db_jsonb;


  end loop;

  p_jsonb := db_jsonb || ('{"rtn_code":"1","message":"Success!"}')::jsonb;
  raise notice '%', p_jsonb;

end; $$;
 M   DROP PROCEDURE dgmain.form_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            ,           0    0 ?   PROCEDURE form_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)    ACL     �   REVOKE ALL ON PROCEDURE dgmain.form_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.form_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    282            �            1255    16476    guid_assign_fn()    FUNCTION     �  CREATE FUNCTION dgmain.guid_assign_fn() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare

  v_guid            int;
  hld_dgid          int                             := 0;
  guid_rec          record;

begin

  for guid_rec in
    select a.trans_id,
           a.dg_id,
           a.key_name,
           a.key_value,
	         b.guid key_guid,
           x1.guid
    from dgmain.guid_key_lookup_trans a
    left join dgmain.guid_key_lookup b
       on a.key_name = b.key_name
       and a.key_value = b.key_value
    left join (
      select a.trans_id,
           a.dg_id,
           b.guid
      from dgmain.guid_key_lookup_trans a
      left join dgmain.guid_key_lookup b
        on a.key_name = b.key_name
        and a.key_value = b.key_value) x1
        on a.dg_id = x1.dg_id
        and x1.guid is not null
    where a.status = 'I'
  loop

    if guid_rec.guid is null
    then
      if hld_dgid <> guid_rec.dg_id
      then
        hld_dgid                           := guid_rec.dg_id;
        v_guid                             := nextval('dgmain.guid_seq');
        --
        insert into dgmain.guid_key_lookup
        values
        (guid_rec.key_name, guid_rec.key_value, v_guid)
        on conflict(key_name, key_value, guid) do nothing;
        --
        update dgmain.guid_key_lookup_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
        update dgmain.guests_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
      else
        --
        insert into dgmain.guid_key_lookup
        values
        (guid_rec.key_name, guid_rec.key_value, v_guid)
        on conflict(key_name, key_value, guid) do nothing;
        --
        update dgmain.guid_key_lookup_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
        update dgmain.guests_trans
          set guid = v_guid
        where dg_id = guid_rec.dg_id;
        --
      end if;
    elsif guid_rec.guid is not null
          and guid_rec.key_guid is null
    then
      --
      insert into dgmain.guid_key_lookup
      values
      (guid_rec.key_name, guid_rec.key_value, guid_rec.guid)
      on conflict(key_name, key_value, guid) do nothing;
      --
      update dgmain.guid_key_lookup_trans
        set guid = guid_rec.guid
      where dg_id = guid_rec.dg_id;
      --
      update dgmain.guests_trans
        set guid = guid_rec.guid
      where dg_id = guid_rec.dg_id;
      --
    elsif guid_rec.guid is not null
          and guid_rec.key_guid is not null
      then
        --
        update dgmain.guid_key_lookup_trans
          set guid = guid_rec.guid
        where dg_id = guid_rec.dg_id;
        --
        update dgmain.guests_trans
          set guid = guid_rec.guid
        where dg_id = guid_rec.dg_id;
        --
    end if;

  end loop;

  update dgmain.guid_key_lookup_trans
    set status = 'C'
    where status = 'I';
  --
  update dgmain.guests_trans
    set status = 'P'
    where status = 'I';

  return 1;
end $$;
 '   DROP FUNCTION dgmain.guid_assign_fn();
       dgmain       dgadmin    false    9            -           0    0    FUNCTION guid_assign_fn()    ACL     �   REVOKE ALL ON FUNCTION dgmain.guid_assign_fn() FROM dgadmin;
GRANT ALL ON FUNCTION dgmain.guid_assign_fn() TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    234                       1255    16478    leads_pr_fn()    FUNCTION     8  CREATE FUNCTION dgmain.leads_pr_fn() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare

  tg_rec             record;
  tg_id              int;

begin

  for tg_rec in
    select x1.trans_id,
           x1.lead_id,
           max(case when rn = 1 then guid end) lead_guest,
           array_agg(guid) travel_guests,
           max(case when rn = 1 then first_initial || '. ' || last_name || ' group' end ) group_name
      from (
      select lt.trans_id,
             lt.lead_id,
             lt.status,
             gt.guid,
             substring(first_name, 1,1) first_initial,
             gt.last_name,
             row_number() over (partition by lt.trans_id order by gt.dg_id) rn
      from dgmain.leads_trans lt
      join dgmain.guests_trans gt
      on lt.trans_id = gt.trans_id
      ) x1
      where status = 'I'
      group by x1.trans_id, x1.lead_id
      order by x1.trans_id, x1.lead_id
  loop

    insert into dgmain.travel_groups as a
    (group_name, lead_guest_guid, travel_guest_guids)
      values
      (tg_rec.group_name, tg_rec.lead_guest, tg_rec.travel_guests)
    on conflict (group_name) do update
      set lead_guest_guid     = tg_rec.lead_guest,
          travel_guest_guids  = tg_rec.travel_guests
    where a.group_name = tg_rec.group_name
    returning group_id into tg_id;

    update dgmain.leads_trans
      set lead_guest_guid     = tg_rec.lead_guest,
          travel_group        = tg_id
    where lead_id             = tg_rec.lead_id;

  end loop;

  --
  update dgmain.leads_trans
    set status = 'P'
    where status = 'I';

return 1;
end $$;
 $   DROP FUNCTION dgmain.leads_pr_fn();
       dgmain       dgadmin    false    9            .           0    0    FUNCTION leads_pr_fn()    ACL     �   REVOKE ALL ON FUNCTION dgmain.leads_pr_fn() FROM dgadmin;
GRANT ALL ON FUNCTION dgmain.leads_pr_fn() TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    273            �            1255    33356 "   new_lead_email_ld_sp(jsonb, jsonb) 	   PROCEDURE     �4  CREATE PROCEDURE dgmain.new_lead_email_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)
    LANGUAGE plpgsql
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
	v_resort_name             text                     := '';
	v_room                    text                     := '';
  --
	--work fields
	adult_num                 int                      := 0;
	child_num                 int                      := 0;
	guest_num                 int                      := 0;
	v_sql                     text;
	lead_id                   int;

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

  --select max(v_adult_num) into adult_num from (select jsonb_object_keys(p_params -> 'Adults')::int as v_adult_num) a;
	--select max(v_child_num) into child_num from (select jsonb_object_keys(p_params -> 'Children')::int as v_child_num) a;
	select max(v_adult_num) into adult_num from (select jsonb_array_length(p_params -> 'Adults')::int as v_adult_num) a;
	select max(v_child_num) into child_num from (select jsonb_array_length(p_params -> 'Children')::int as v_child_num) a;

	guest_num                                          := coalesce((adult_num + coalesce(child_num,0)),1);

  --------------------------------------------------------------------------
	v_proc_step                          := 'load guest_rec - ' || guest_num::text;
	--------------------------------------------------------------------------
  for i in 1..guest_num
	loop
    if i = 1 then
      db_int                                         := nextval('dgmain.dg_id_seq');
			p_params                                       := jsonb_set(p_params, array['Adults', (i-1)::text, 'dg_id'], ('"' || db_int || '"')::jsonb );
			--
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
	    guest_rec.preferred_contact_method             := coalesce((p_params ->> 'contact_preference')::text,'');
			guest_rec.dg_id                                := db_int;
			guest_rec.last_room                            := (p_params -> 'Adults' -> (i-1) ->> 'room')::text;

			insert into guest_rec_temp values (guest_rec.*);
      ------------------------------------------------
      select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
				------------------------------------------------
		elsif i > 1 and i <= adult_num
		then
		  db_int                                         := nextval('dgmain.dg_id_seq');
		  p_params                                       := jsonb_set(p_params, array['Adults', (i-1)::text, 'dg_id'], ('"' || db_int || '"')::jsonb );
			--
			guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
		  guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
		  guest_rec.name_prefix                          := split_part((p_params -> 'Adults' -> (i-1) ->> 'name')::text,' ',1);
		  guest_rec.first_name                           := split_part((p_params -> 'Adults' -> (i-1) ->> 'name')::text,' ',2);
		  guest_rec.middle_name                          := '';
		  guest_rec.last_name                            := split_part((p_params -> 'Adults' -> (i-1)->> 'name')::text,' ',3);
		  guest_rec.name_suffix                          := '';
		  guest_rec.address1                             := coalesce((p_params ->> 'address1')::text,'');
		  guest_rec.address2                             := coalesce((p_params ->> 'address2')::text,'');
		  guest_rec.address3                             := coalesce((p_params ->> 'address3')::text,'');
		  guest_rec.city                                 := coalesce((p_params ->> 'city')::text,'');
		  guest_rec.state                                := coalesce((p_params ->> 'state')::text,'');
		  guest_rec.zip                                  := coalesce((p_params ->> 'zip')::text,'');
		  guest_rec.country                              := coalesce((p_params ->> 'country')::text,'');
			guest_rec.dg_id                                := db_int;
			guest_rec.last_room                            := (p_params -> 'Adults' -> (i-1) ->> 'room')::text;

			insert into guest_rec_temp values (guest_rec.*);
			------------------------------------------------
	    select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
			------------------------------------------------

		elsif i > adult_num
		then
		  db_int                                         := nextval('dgmain.dg_id_seq');
		  p_params                                       := jsonb_set(p_params, array['Children', (i - (adult_num +1))::text, 'dg_id'], ('"' || db_int || '"')::jsonb );
		  --
			guest_rec.trans_id                             := (p_params ->> 'trans_id')::text;
		  guest_rec.load_date                            := db_current_date;
			guest_rec.status                               := 'I';
		  guest_rec.name_prefix                          := split_part((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'name')::text,' ',1);
		  guest_rec.first_name                           := split_part((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'name')::text,' ',2);
		  guest_rec.middle_name                          := '';
		  guest_rec.last_name                            := split_part((p_params -> 'Children' -> (i - (adult_num +1)) ->> 'name')::text,' ',3);
		  guest_rec.name_suffix                          := '';
		  guest_rec.address1                             := coalesce((p_params ->> 'address1')::text,'');
		  guest_rec.address2                             := coalesce((p_params ->> 'address2')::text,'');
		  guest_rec.address3                             := coalesce((p_params ->> 'address3')::text,'');
		  guest_rec.city                                 := coalesce((p_params ->> 'city')::text,'');
		  guest_rec.state                                := coalesce((p_params ->> 'state')::text,'');
		  guest_rec.zip                                  := coalesce((p_params ->> 'zip')::text,'');
		  guest_rec.country                              := coalesce((p_params ->> 'country')::text,'');
			guest_rec.dg_id                                := db_int;
			guest_rec.child_flag                           := true;
			guest_rec.age_at_travel                        := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'age')::int;
			guest_rec.last_travel_date                     := (p_params ->> 'check_in')::timestamp;
			guest_rec.last_room                            := (p_params -> 'Children' -> (i - (adult_num +1)) ->> 'room')::text;

		  insert into guest_rec_temp values (guest_rec.*);
			------------------------------------------------
      select * into db_int from key_lookup_temp_ld_fn(guest_rec);
			guest_rec                                      := null;
			------------------------------------------------
		end if;
	end loop;
	--------------------------------------------------------------------------
	v_proc_step                          := 'load lead_rec';
	--------------------------------------------------------------------------
	select resort_name, room into v_resort_name, v_room from (
  select a.resort_name, a.room, similarity(a.room, l.resort_accomodations) match_value,
  row_number() over (partition by a.resort_name order by similarity(a.room, l.resort_accomodations) desc) rn
  from (
  select r.resort_name, unnest(r.rooms) room
  from dgmain.resorts r) a
  join (select (p_params ->> 'resort') as resort, (p_params ->> 'resort_accomodations') as resort_accomodations) l
    on a.resort_name = replace(l.resort, '’', '''')
  ) b
  where rn = 1;


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
	lead_rec.potential_discounts                   := p_params -> 'potential_discounts';
	lead_rec.unique_pin_info                       := (p_params ->> 'unique_pin_info')::text;
	lead_rec.other_discount_info                   := (p_params ->> 'other_discount_info')::text;
	lead_rec.resort                                := v_resort_name;
	lead_rec.resort_accomodations                  := v_room;
	lead_rec.package_type                          := (p_params ->> 'package_type')::text;
	lead_rec.resort_pakage                         := (p_params ->> 'resort_pakage')::text;
	lead_rec.num_of_passes                         := (p_params ->> 'num_of_passes')::text;
	lead_rec.ticket_type                           := (p_params ->> 'ticket_type')::text;
	lead_rec.transportation                        := (p_params ->> 'transportation')::text;
	lead_rec.travel_insurance                      := (p_params ->> 'travel_insurance')::text;
	lead_rec.memory_maker                          := (p_params ->> 'memory_maker')::text;
	lead_rec.universal_addon                       := (p_params ->> 'universal_addon')::text;
	lead_rec.cruise_addon                          := (p_params ->> 'cruise_addon')::text;
	lead_rec.special_requests                      := (p_params ->> 'special_requests')::text;

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

end; $$;
 W   DROP PROCEDURE dgmain.new_lead_email_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            /           0    0 I   PROCEDURE new_lead_email_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)    ACL     �   REVOKE ALL ON PROCEDURE dgmain.new_lead_email_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.new_lead_email_ld_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    235                       1255    16483    proc_function_sp(jsonb, jsonb) 	   PROCEDURE     �  CREATE PROCEDURE dgmain.proc_function_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)
    LANGUAGE plpgsql
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
    --commit;
		null;
  else raise 'The process failed at %', proc_str;
  end if;
  --
  --lead process
  proc_str                                := 'leads_pr_fn';
  rtn_code                                := dgmain.leads_pr_fn();
  if rtn_code = 1
  then
    --commit;
		null;
  else raise 'The process failed at %', proc_str;
  end if;
  --
  --loads
  proc_str                                := 'final_load_fn';
  rtn_code                                := dgmain.final_load_fn();
  if rtn_code = 1
  then
    --commit;
		null;
  else raise 'The process failed at %', proc_str;
  end if;

  p_jsonb := ('{"rtn_code":1,"message":"Success!"}')::jsonb;

end; $$;
 S   DROP PROCEDURE dgmain.proc_function_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            0           0    0 E   PROCEDURE proc_function_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb)    ACL     �   REVOKE ALL ON PROCEDURE dgmain.proc_function_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.proc_function_sp(INOUT p_params jsonb, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    285                       1255    16480 !   webservice_insert_fn(jsonb, text)    FUNCTION     Y  CREATE FUNCTION dgmain.webservice_insert_fn(p_params jsonb, p_trans_name text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
db_jsonb                                := p_params;
db_jsonb                                := jsonb_set(db_jsonb,array['trans_id'], (t_id::text)::jsonb);
sql_str                                 := 'select dgmain.' || lov_function || '('''|| db_jsonb || ''')';

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
end $$;
 N   DROP FUNCTION dgmain.webservice_insert_fn(p_params jsonb, p_trans_name text);
       dgmain       dgadmin    false    9            1           0    0 @   FUNCTION webservice_insert_fn(p_params jsonb, p_trans_name text)    ACL     �   REVOKE ALL ON FUNCTION dgmain.webservice_insert_fn(p_params jsonb, p_trans_name text) FROM dgadmin;
GRANT ALL ON FUNCTION dgmain.webservice_insert_fn(p_params jsonb, p_trans_name text) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    274                       1255    16484 (   webservice_insert_sp(jsonb, text, jsonb) 	   PROCEDURE     ]  CREATE PROCEDURE dgmain.webservice_insert_sp(INOUT p_params jsonb, INOUT p_trans_name text, INOUT p_jsonb jsonb DEFAULT NULL::jsonb)
    LANGUAGE plpgsql
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

begin

return_msg                               := jsonb_build_object('ws_insert_sp','');
return_params                            := jsonb_build_object('ws_insert_sp','');

--insert params to webservice_trans table
t_id                                     := nextval('dgmain.trans_id_seq');
insert into dgmain.webservice_trans
values
(t_id, current_date, p_params, p_trans_name);
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

	raise notice '%', lov_function;
  -------------------------------------------------------------
  --build function call and execute
  proc_str                                := 'build_function_call';
  db_jsonb                                := p_params;
  db_jsonb                                := jsonb_set(db_jsonb,array['trans_id'], (t_id::text)::jsonb);
  sql_str                                 := 'call dgmain.' || lov_function || '('''|| db_jsonb || ''',jsonb_build_object(''send'',''value''))';
  --
  proc_str                                := 'execute_function_call';
  execute sql_str into db_jsonb, j_msg;
	if j_msg ->> 'rtn_code' = '1'
	then
	return_params                           := return_params || db_jsonb;
	return_msg                              := return_msg || j_msg;
	raise notice 'SP Calls: %', return_msg;
  commit;
	else raise 'The process failed at % call', lov_function;
	end if;

end loop;

call dgmain.proc_function_sp(p_params,p_jsonb);

--assign return message
proc_str                                := 'assign_return_message';
if (p_jsonb ->> 'rtn_code' <> '1')
then
  j_msg                                 := '{"rtn_code":-1,"message":"There was an issue in function call ' || lov_function || '"}';
	p_jsonb                               := j_msg;
	insert into dgmain.error_log values (t_id, p_jsonb);
else
  p_jsonb                               := return_msg;
end if;

--return p_jsonb;
/*
exception when others then
  --return failure
	j_msg = '{"rtn_code":-1,"message":"There was an issue submitting the data. proc_step: ' || proc_str || ' err_msg: ' || sqlerrm || '"}';
	p_jsonb  := j_msg;
	--return p_jsonb;
	*/
end; $$;
 p   DROP PROCEDURE dgmain.webservice_insert_sp(INOUT p_params jsonb, INOUT p_trans_name text, INOUT p_jsonb jsonb);
       dgmain       dgadmin    false    9            2           0    0 b   PROCEDURE webservice_insert_sp(INOUT p_params jsonb, INOUT p_trans_name text, INOUT p_jsonb jsonb)    ACL       REVOKE ALL ON PROCEDURE dgmain.webservice_insert_sp(INOUT p_params jsonb, INOUT p_trans_name text, INOUT p_jsonb jsonb) FROM dgadmin;
GRANT ALL ON PROCEDURE dgmain.webservice_insert_sp(INOUT p_params jsonb, INOUT p_trans_name text, INOUT p_jsonb jsonb) TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    284                       1255    34131    key_lookup_temp_ld_fn(record)    FUNCTION     �  CREATE FUNCTION public.key_lookup_temp_ld_fn(p_guest_rec record) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
  db_current_date                      date;
begin

--key lookup values
--
--name|address
if coalesce(p_guest_rec.address1, '')
|| coalesce(p_guest_rec.city,'')
|| coalesce(p_guest_rec.state,'')
|| coalesce(p_guest_rec.zip,'') <> '' then
  insert into key_lookup_temp
  values
  (p_guest_rec.trans_id
    , db_current_date
    , 'I'
    , 'name|address'
    ,  lower(p_guest_rec.first_name
    || p_guest_rec.middle_name  || p_guest_rec.last_name
    || p_guest_rec.name_suffix
    || '|'
    || p_guest_rec.address1 || p_guest_rec.city || p_guest_rec.state || p_guest_rec.zip)
    , null
    , p_guest_rec.dg_id);
end if;

  --name|email
  if coalesce(p_guest_rec.email, '') <> '' then
    insert into key_lookup_temp
    values
    (p_guest_rec.trans_id
    , db_current_date
    , 'I'
    , 'name|email'
    ,  lower(p_guest_rec.first_name
    || p_guest_rec.middle_name  || p_guest_rec.last_name
    || p_guest_rec.name_suffix
    || '|'
    || p_guest_rec.email)
    , null
    , p_guest_rec.dg_id);
end if;
  --
  --name|phone
  if coalesce(p_guest_rec.phone,'') <> '' then
    insert into key_lookup_temp
    values
    (p_guest_rec.trans_id
    , db_current_date
    , 'I'
    , 'name|phone'
    ,  lower(p_guest_rec.first_name
     || p_guest_rec.middle_name  || p_guest_rec.last_name
     || p_guest_rec.name_suffix
     || '|'
     || p_guest_rec.phone)
     , null
    , p_guest_rec.dg_id);
end if;
  --
  --name|cell
  if coalesce(p_guest_rec.cell, '') <> '' then
    insert into key_lookup_temp
    values
    (p_guest_rec.trans_id
      , db_current_date
      , 'I'
      , 'name|cell'
      ,  lower(p_guest_rec.first_name
      || p_guest_rec.middle_name  || p_guest_rec.last_name
      || p_guest_rec.name_suffix
      || '|'
      || p_guest_rec.cell)
      , null
      , p_guest_rec.dg_id);
    end if;


return 1;
end $$;
 @   DROP FUNCTION public.key_lookup_temp_ld_fn(p_guest_rec record);
       public       dgadmin    false            �            1259    16398    call_log    TABLE     �   CREATE TABLE dgmain.call_log (
    call_log_id integer NOT NULL,
    call_date date,
    lead_ids integer[],
    vacation_ids integer[],
    guid integer,
    cast_member_name text,
    notes text[]
);
    DROP TABLE dgmain.call_log;
       dgmain         dgadmin    false    9            3           0    0    TABLE call_log    ACL     s   REVOKE ALL ON TABLE dgmain.call_log FROM dgadmin;
GRANT ALL ON TABLE dgmain.call_log TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    212            �            1259    16485    call_log_id_seq    SEQUENCE     x   CREATE SEQUENCE dgmain.call_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE dgmain.call_log_id_seq;
       dgmain       dgadmin    false    9            4           0    0    SEQUENCE call_log_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.call_log_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.call_log_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.call_log_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    222            �            1259    16487 	   dg_id_seq    SEQUENCE     r   CREATE SEQUENCE dgmain.dg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE dgmain.dg_id_seq;
       dgmain       dgadmin    false    9            5           0    0    SEQUENCE dg_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.dg_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.dg_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.dg_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    223            �            1259    35029 	   error_log    TABLE     J   CREATE TABLE dgmain.error_log (
    trans_id integer,
    err_msg text
);
    DROP TABLE dgmain.error_log;
       dgmain         dgadmin    false    9            6           0    0    TABLE error_log    ACL     u   REVOKE ALL ON TABLE dgmain.error_log FROM dgadmin;
GRANT ALL ON TABLE dgmain.error_log TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    231            �            1259    16489    group_id_seq    SEQUENCE     u   CREATE SEQUENCE dgmain.group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE dgmain.group_id_seq;
       dgmain       dgadmin    false    9            7           0    0    SEQUENCE group_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.group_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.group_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.group_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    224            �            1259    16412    guests    TABLE     �  CREATE TABLE dgmain.guests (
    guid integer NOT NULL,
    name_prefix text,
    first_name text,
    middle_name text,
    last_name text,
    name_suffix text,
    address1 text,
    address2 text,
    address3 text,
    city text,
    state text,
    zip text,
    country text,
    email text,
    phone text,
    cell text,
    fax text,
    preferred_contact_method text,
    last_updated date,
    child_flag boolean,
    age_at_travel integer,
    last_travel_date date,
    last_room text
);
    DROP TABLE dgmain.guests;
       dgmain         dgadmin    false    9            8           0    0    TABLE guests    ACL     o   REVOKE ALL ON TABLE dgmain.guests FROM dgadmin;
GRANT ALL ON TABLE dgmain.guests TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    214            �            1259    16406    guests_trans    TABLE     *  CREATE TABLE dgmain.guests_trans (
    trans_id integer,
    load_date date,
    status text,
    guid integer,
    name_prefix text,
    first_name text,
    middle_name text,
    last_name text,
    name_suffix text,
    address1 text,
    address2 text,
    address3 text,
    city text,
    state text,
    zip text,
    country text,
    email text,
    phone text,
    cell text,
    fax text,
    preferred_contact_method text,
    dg_id integer,
    child_flag boolean,
    age_at_travel integer,
    last_travel_date date,
    last_room text
);
     DROP TABLE dgmain.guests_trans;
       dgmain         dgadmin    false    9            9           0    0    TABLE guests_trans    ACL     {   REVOKE ALL ON TABLE dgmain.guests_trans FROM dgadmin;
GRANT ALL ON TABLE dgmain.guests_trans TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    213            �            1259    16426    guid_key_lookup    TABLE     |   CREATE TABLE dgmain.guid_key_lookup (
    key_name text NOT NULL,
    key_value text NOT NULL,
    guid integer NOT NULL
);
 #   DROP TABLE dgmain.guid_key_lookup;
       dgmain         dgadmin    false    9            :           0    0    TABLE guid_key_lookup    ACL     �   REVOKE ALL ON TABLE dgmain.guid_key_lookup FROM dgadmin;
GRANT ALL ON TABLE dgmain.guid_key_lookup TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    216            �            1259    16420    guid_key_lookup_trans    TABLE     �   CREATE TABLE dgmain.guid_key_lookup_trans (
    trans_id integer,
    load_date date,
    status text,
    key_name text,
    key_value text,
    guid integer,
    dg_id integer
);
 )   DROP TABLE dgmain.guid_key_lookup_trans;
       dgmain         dgadmin    false    9            ;           0    0    TABLE guid_key_lookup_trans    ACL     �   REVOKE ALL ON TABLE dgmain.guid_key_lookup_trans FROM dgadmin;
GRANT ALL ON TABLE dgmain.guid_key_lookup_trans TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    215            �            1259    16491    guid_seq    SEQUENCE     q   CREATE SEQUENCE dgmain.guid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE dgmain.guid_seq;
       dgmain       dgadmin    false    9            <           0    0    SEQUENCE guid_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.guid_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.guid_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.guid_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    225            �            1259    16493    lead_id_seq    SEQUENCE     t   CREATE SEQUENCE dgmain.lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE dgmain.lead_id_seq;
       dgmain       dgadmin    false    9            =           0    0    SEQUENCE lead_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.lead_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.lead_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.lead_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    226            �            1259    16440    leads    TABLE     
  CREATE TABLE dgmain.leads (
    lead_id integer NOT NULL,
    lead_guest_guid integer,
    travel_group integer,
    check_in date,
    check_out date,
    guaranteed_quote text,
    source text,
    num_rooms integer,
    previous_disney_experience text,
    budget text,
    special_occasion text,
    adults jsonb,
    children jsonb,
    handicap text,
    handicap_details text,
    potential_discounts jsonb,
    unique_pin_info text,
    other_discount_info text,
    resort text,
    resort_accomodations text,
    room_view text,
    room_bedding text,
    package_type text,
    resort_pakage text,
    num_of_passes text,
    ticket_type text,
    ticket_valid_thru date,
    transportation text,
    travel_insurance text,
    memory_maker text,
    universal_addon text,
    cruise_addon text,
    special_requests text,
    reservation_num text,
    courtesy_hld_exp_date date,
    final_payment_due_date date,
    refurb text,
    total_cost integer,
    cost_savings text,
    discount_applied text,
    notes text
);
    DROP TABLE dgmain.leads;
       dgmain         dgadmin    false    9            >           0    0    TABLE leads    ACL     m   REVOKE ALL ON TABLE dgmain.leads FROM dgadmin;
GRANT ALL ON TABLE dgmain.leads TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    218            �            1259    16434    leads_trans    TABLE     B  CREATE TABLE dgmain.leads_trans (
    trans_id integer,
    load_date date,
    status text,
    lead_id integer,
    lead_guest_guid integer,
    travel_group integer,
    check_in date,
    check_out date,
    guaranteed_quote text,
    source text,
    num_rooms integer,
    previous_disney_experience text,
    budget text,
    special_occasion text,
    adults jsonb,
    children jsonb,
    handicap text,
    handicap_details text,
    potential_discounts jsonb,
    unique_pin_info text,
    other_discount_info text,
    resort text,
    resort_accomodations text,
    room_view text,
    room_bedding text,
    package_type text,
    resort_pakage text,
    num_of_passes text,
    ticket_type text,
    ticket_valid_thru date,
    transportation text,
    travel_insurance text,
    memory_maker text,
    universal_addon text,
    cruise_addon text,
    special_requests text,
    reservation_num text,
    courtesy_hld_exp_date date,
    final_payment_due_date date,
    refurb text,
    total_cost integer,
    cost_savings text,
    discount_applied text,
    notes text
);
    DROP TABLE dgmain.leads_trans;
       dgmain         dgadmin    false    9            ?           0    0    TABLE leads_trans    ACL     y   REVOKE ALL ON TABLE dgmain.leads_trans FROM dgadmin;
GRANT ALL ON TABLE dgmain.leads_trans TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    217            �            1259    16448 	   lov_table    TABLE     |   CREATE TABLE dgmain.lov_table (
    lookup_type text,
    lookup_key text,
    lookup_value text,
    lookup_seq integer
);
    DROP TABLE dgmain.lov_table;
       dgmain         dgadmin    false    9            @           0    0    TABLE lov_table    ACL     u   REVOKE ALL ON TABLE dgmain.lov_table FROM dgadmin;
GRANT ALL ON TABLE dgmain.lov_table TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    219            �            1259    16495    resort_id_seq    SEQUENCE     v   CREATE SEQUENCE dgmain.resort_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE dgmain.resort_id_seq;
       dgmain       dgadmin    false    9            A           0    0    SEQUENCE resort_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.resort_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.resort_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.resort_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    227            �            1259    16454    resorts    TABLE     �   CREATE TABLE dgmain.resorts (
    resort_id integer NOT NULL,
    location text,
    resort_name text,
    resort_type text,
    rooms text[],
    dining jsonb[],
    entertainment jsonb[]
);
    DROP TABLE dgmain.resorts;
       dgmain         dgadmin    false    9            B           0    0    TABLE resorts    ACL     q   REVOKE ALL ON TABLE dgmain.resorts FROM dgadmin;
GRANT ALL ON TABLE dgmain.resorts TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    220            �            1259    16499    trans_id_seq    SEQUENCE     u   CREATE SEQUENCE dgmain.trans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE dgmain.trans_id_seq;
       dgmain       dgadmin    false    9            C           0    0    SEQUENCE trans_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.trans_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.trans_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.trans_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    229            �            1259    24592    travel_groups    TABLE     �   CREATE TABLE dgmain.travel_groups (
    group_id integer DEFAULT nextval('dgmain.group_id_seq'::regclass) NOT NULL,
    group_name text NOT NULL,
    lead_guest_guid integer,
    travel_guest_guids integer[]
);
 !   DROP TABLE dgmain.travel_groups;
       dgmain         dgadmin    false    224    9            D           0    0    TABLE travel_groups    ACL     }   REVOKE ALL ON TABLE dgmain.travel_groups FROM dgadmin;
GRANT ALL ON TABLE dgmain.travel_groups TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    230            �            1259    16497    vacation_id_seq    SEQUENCE     x   CREATE SEQUENCE dgmain.vacation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE dgmain.vacation_id_seq;
       dgmain       dgadmin    false    9            E           0    0    SEQUENCE vacation_id_seq    ACL     �   REVOKE ALL ON SEQUENCE dgmain.vacation_id_seq FROM dgadmin;
GRANT UPDATE ON SEQUENCE dgmain.vacation_id_seq TO dgadmin;
GRANT SELECT,USAGE ON SEQUENCE dgmain.vacation_id_seq TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    228            �            1259    16465    webservice_trans    TABLE     {   CREATE TABLE dgmain.webservice_trans (
    trans_id integer,
    trans_date date,
    params jsonb,
    trans_name text
);
 $   DROP TABLE dgmain.webservice_trans;
       dgmain         dgadmin    false    9            F           0    0    TABLE webservice_trans    ACL     �   REVOKE ALL ON TABLE dgmain.webservice_trans FROM dgadmin;
GRANT ALL ON TABLE dgmain.webservice_trans TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    221                      0    16398    call_log 
   TABLE DATA               q   COPY dgmain.call_log (call_log_id, call_date, lead_ids, vacation_ids, guid, cast_member_name, notes) FROM stdin;
    dgmain       dgadmin    false    212   ��                0    35029 	   error_log 
   TABLE DATA               6   COPY dgmain.error_log (trans_id, err_msg) FROM stdin;
    dgmain       dgadmin    false    231   �                0    16412    guests 
   TABLE DATA                 COPY dgmain.guests (guid, name_prefix, first_name, middle_name, last_name, name_suffix, address1, address2, address3, city, state, zip, country, email, phone, cell, fax, preferred_contact_method, last_updated, child_flag, age_at_travel, last_travel_date, last_room) FROM stdin;
    dgmain       dgadmin    false    214   0�                0    16406    guests_trans 
   TABLE DATA               2  COPY dgmain.guests_trans (trans_id, load_date, status, guid, name_prefix, first_name, middle_name, last_name, name_suffix, address1, address2, address3, city, state, zip, country, email, phone, cell, fax, preferred_contact_method, dg_id, child_flag, age_at_travel, last_travel_date, last_room) FROM stdin;
    dgmain       dgadmin    false    213   ��                0    16426    guid_key_lookup 
   TABLE DATA               D   COPY dgmain.guid_key_lookup (key_name, key_value, guid) FROM stdin;
    dgmain       dgadmin    false    216   @�                0    16420    guid_key_lookup_trans 
   TABLE DATA               n   COPY dgmain.guid_key_lookup_trans (trans_id, load_date, status, key_name, key_value, guid, dg_id) FROM stdin;
    dgmain       dgadmin    false    215    �                0    16440    leads 
   TABLE DATA                 COPY dgmain.leads (lead_id, lead_guest_guid, travel_group, check_in, check_out, guaranteed_quote, source, num_rooms, previous_disney_experience, budget, special_occasion, adults, children, handicap, handicap_details, potential_discounts, unique_pin_info, other_discount_info, resort, resort_accomodations, room_view, room_bedding, package_type, resort_pakage, num_of_passes, ticket_type, ticket_valid_thru, transportation, travel_insurance, memory_maker, universal_addon, cruise_addon, special_requests, reservation_num, courtesy_hld_exp_date, final_payment_due_date, refurb, total_cost, cost_savings, discount_applied, notes) FROM stdin;
    dgmain       dgadmin    false    218   ��                0    16434    leads_trans 
   TABLE DATA               �  COPY dgmain.leads_trans (trans_id, load_date, status, lead_id, lead_guest_guid, travel_group, check_in, check_out, guaranteed_quote, source, num_rooms, previous_disney_experience, budget, special_occasion, adults, children, handicap, handicap_details, potential_discounts, unique_pin_info, other_discount_info, resort, resort_accomodations, room_view, room_bedding, package_type, resort_pakage, num_of_passes, ticket_type, ticket_valid_thru, transportation, travel_insurance, memory_maker, universal_addon, cruise_addon, special_requests, reservation_num, courtesy_hld_exp_date, final_payment_due_date, refurb, total_cost, cost_savings, discount_applied, notes) FROM stdin;
    dgmain       dgadmin    false    217   ��                0    16448 	   lov_table 
   TABLE DATA               V   COPY dgmain.lov_table (lookup_type, lookup_key, lookup_value, lookup_seq) FROM stdin;
    dgmain       dgadmin    false    219   ��                0    16454    resorts 
   TABLE DATA               n   COPY dgmain.resorts (resort_id, location, resort_name, resort_type, rooms, dining, entertainment) FROM stdin;
    dgmain       dgadmin    false    220   ��                0    24592    travel_groups 
   TABLE DATA               b   COPY dgmain.travel_groups (group_id, group_name, lead_guest_guid, travel_guest_guids) FROM stdin;
    dgmain       dgadmin    false    230   *�                0    16465    webservice_trans 
   TABLE DATA               T   COPY dgmain.webservice_trans (trans_id, trans_date, params, trans_name) FROM stdin;
    dgmain       dgadmin    false    221   ��      G           0    0    call_log_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('dgmain.call_log_id_seq', 1, false);
            dgmain       dgadmin    false    222            H           0    0 	   dg_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('dgmain.dg_id_seq', 674, true);
            dgmain       dgadmin    false    223            I           0    0    group_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('dgmain.group_id_seq', 121, true);
            dgmain       dgadmin    false    224            J           0    0    guid_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('dgmain.guid_seq', 112, true);
            dgmain       dgadmin    false    225            K           0    0    lead_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('dgmain.lead_id_seq', 219, true);
            dgmain       dgadmin    false    226            L           0    0    resort_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('dgmain.resort_id_seq', 66, true);
            dgmain       dgadmin    false    227            M           0    0    trans_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('dgmain.trans_id_seq', 1539, true);
            dgmain       dgadmin    false    229            N           0    0    vacation_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('dgmain.vacation_id_seq', 1, false);
            dgmain       dgadmin    false    228            �           2606    16405    call_log call_log_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY dgmain.call_log
    ADD CONSTRAINT call_log_pkey PRIMARY KEY (call_log_id);
 @   ALTER TABLE ONLY dgmain.call_log DROP CONSTRAINT call_log_pkey;
       dgmain         dgadmin    false    212            �           2606    16419    guests guests_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY dgmain.guests
    ADD CONSTRAINT guests_pkey PRIMARY KEY (guid);
 <   ALTER TABLE ONLY dgmain.guests DROP CONSTRAINT guests_pkey;
       dgmain         dgadmin    false    214            �           2606    16433 $   guid_key_lookup guid_key_lookup_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY dgmain.guid_key_lookup
    ADD CONSTRAINT guid_key_lookup_pkey PRIMARY KEY (key_name, key_value, guid);
 N   ALTER TABLE ONLY dgmain.guid_key_lookup DROP CONSTRAINT guid_key_lookup_pkey;
       dgmain         dgadmin    false    216    216    216            �           2606    16447    leads leads_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY dgmain.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (lead_id);
 :   ALTER TABLE ONLY dgmain.leads DROP CONSTRAINT leads_pkey;
       dgmain         dgadmin    false    218            �           2606    16461    resorts resorts_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY dgmain.resorts
    ADD CONSTRAINT resorts_pkey PRIMARY KEY (resort_id);
 >   ALTER TABLE ONLY dgmain.resorts DROP CONSTRAINT resorts_pkey;
       dgmain         dgadmin    false    220            �           2606    24602 *   travel_groups travel_groups_group_name_key 
   CONSTRAINT     k   ALTER TABLE ONLY dgmain.travel_groups
    ADD CONSTRAINT travel_groups_group_name_key UNIQUE (group_name);
 T   ALTER TABLE ONLY dgmain.travel_groups DROP CONSTRAINT travel_groups_group_name_key;
       dgmain         dgadmin    false    230            �           2606    24600     travel_groups travel_groups_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY dgmain.travel_groups
    ADD CONSTRAINT travel_groups_pkey PRIMARY KEY (group_id, group_name);
 J   ALTER TABLE ONLY dgmain.travel_groups DROP CONSTRAINT travel_groups_pkey;
       dgmain         dgadmin    false    230    230                        826    16396     DEFAULT PRIVILEGES FOR SEQUENCES    DEFAULT ACL     �   ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain REVOKE ALL ON SEQUENCES  FROM dgadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain GRANT SELECT,USAGE ON SEQUENCES  TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    9            !           826    16397     DEFAULT PRIVILEGES FOR FUNCTIONS    DEFAULT ACL     4  ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain REVOKE ALL ON FUNCTIONS  FROM dgadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain GRANT ALL ON FUNCTIONS  TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    9                       826    16395    DEFAULT PRIVILEGES FOR TABLES    DEFAULT ACL     �   ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain REVOKE ALL ON TABLES  FROM dgadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE dgadmin IN SCHEMA dgmain GRANT ALL ON TABLES  TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    9                  x������ � �            x������ � �         o  x���MS�0��ʯ�198cْ���ה	��ʉ���"KI	�_9c�Ж�ģ�J���ﾻJtŭ�?�� MD>ג[�f��%!B��Q<�n��/B���7�Y����\�������w`�ݤ������$EeMQ�K�a12��`�0EW������1B�S�?qS�k͋�-�R+�I�ֶO��+am��0r����9�+�C�:$$ /
��gK���3�``ٺ�`�h�EIH�0�B	o���
J�J.�?�B%XG�K���ׄ1�I���G���/^AҴ-�X��R�Ss�d�;YԦ��ś3ϐĸ�F	�hE�0b	�~���N���D/1�pED�D�\�F��W(�(ŧ�{)��Cr$�=/��%I@��~�'/��?H�	R�!���w�v���fs��V�x/r�*	&c�K.�0�%B���30�m��꣏G���T;�ۀ�Yp�y�����x̳�u�7VMw�<[���ŲV�|7�٪W2_�$�/l�h����P^�@kag��n���J��'|�r�x�z�;g�0�� ɢxC�8�["?�;y��k��_���t�S��7�������̪���a������         �  x�͜�s�:����ұ>,۷BaS�Ӂy���� ����.L�_�d�I�Z�CV6�K����Z�ą��y��������5��_��6'�2_��"k{g�2+W�?ƸJe\f��.>���������Xo
�;�c�ٿeޚU��Zc���I�Z�����B(���n��{G�����yӼ�'��vQիMi;�~�4Ea�6�;=����� �(�J�Z�pE����	�T��@�v�ثb��:+˪���~̊��N��"�eN��-c/�N�E�#����,/X��-L���xl٢���4�2c�*���r�(���.�2X��A��M�sm���Ȯ�یI�!ۏ����F���{���ad�t���>m�]V�Um��ڔK�d*�m��>��w��C�w�#S��o��2k�$�O<�}�<���_��Gv۱��s�c�K�� ��}�;6P�hQ��)j�Rq�Z eߨ���mb��g�Z�b�'���(��fh,��hr!�O/��/؅I�H�[�@d��C ,���յ}֫�С
�����̭²Ξ؅�Wc{eʲ��2��I*�?����$��-�H+���0�P	"D1b�k�sk~K{���_����-��M���u�-o~WՊ]������aa��]����5�;�	; ���f�6�ހ�!!��$p(��B61�i7��9;1�|
�~�ǅ<Ճ�}��3�F���J�w��(����8�w�� 
q�7� �S�R��}D�(�Aj?����H�(��;R�8�+ǒ(�O�UV|��QY(��3ښ��i��4��F�X�;L>m°����EF�}�=���fr�j�9e�el�2���*�L¬<�"?N:^�_eW8��� �6�Mc�В��ˇ/�SR`�>vr���P����$�k���p���wfe>A��~��0�����*�;o����,�����i-��O%�B'�я������UV����
3ӶB�T�F9�}����E���o��͏��n�Z�U]���&_�{��Xyw���
v^��Y���e��`A�������jΚ�����Ί^�;uk,��b�x��:�b��*�;�@ﺏL�vq��x�b��1ٛ�ܭDr���,y��K�Е�Ϧ��T:��P��ӨH�1"&�vl}X
�n�B)Ф{m�?h�*j0��_��VM�J��Q9H�'S&� d�M�RG�Ph���1��[*��A���(��u�{�Lc��c�br@!��;�'�G��O!�s��
��q\�����4���V��3��8W��j\��3(��WE�d,�|8D=�"GFV6�E.Q�o���%�o��[l���-�Fq�e�B�C�q�����}B�Y���&>�jwa����xm�E���ܻ�C �XA�'�q�i� l�����oǐ@!>��p�i�i�Gb����5ۃd�a!`#�&�����y 
�a+G�o�ض�4������BN��9�	<���X�m���`�Ր�v�)G���b���rxy"�����Xc��7���P��Ǒ� O�iE�Î��Z)�a�X�؈o p���Q�>@�5�ȵ��,�'�B}�F�1G��7��+P���9W�Ld<X.��Ot����a�l6���F؈���Ph���Áޥ�:�0�!�[t����#�(�'@�t�w���%|b��+6b1�� �(���������4vN�{����P��8� ����];��I�ǁ�A)�ql͑�(��ql� �my��i[���#��dq}���F��]�~oZK�_�Rq�gG�&2�T؈�X]���x��Q*�-W::��؝���Rcۙ�plw��Ae<H�*����þ	��[m6���i��Y�X%Qp�-o�z|���~���}1�mU�,����m���W�m�uU����P�Ib	�V×[`��%�A�4��5V��ДM�9�	|4���[�4��W�/���#%�kan��� 4�ia�������x3�ѫ~�����2���#�y��� �+����u���j[C�>&��/�ra�r����h���]�L��i���@6�D����k9��C&_�z�5������/��h�1�8��v�����n���I��ncW �ʚ��C�����/�A��         �  x��V˒�0<����9$�6pˇ�EMpblʐL���_�E���S���R�%�����Ŷ�P�Z�.�p"<kc���V��V1Dh��ʶ3J�QtR��G$
]�3�@����� $�����jk*��;��$�����&vn�Bl�)@�5vC佀i�J��*p�6`;�O4Β$,���
UBSi�sFy��1B
��/i�>g+�006a��?�]#�
�$�l��0�0�2	y��@��Z�Y|���A͊OGd*l�tv��!��<%+�lL�ݮ$>܆'B��l��#��(	��n���v�33��j����;�r�?�
�b�S(�f��7���d�S��t-��
ke��z����2����ж�GYDh������vx�B���Ʀ%��G�P����{c���HƚC\�� ��G6NP���zz�|����f
/mtk��:zԍ��9�~>�O�90��x��V���Z����'��qjh��S�.̗tT����h����j'��Ӎr\^�:�
��Wi��%M"7�Y1���|/@KQ�ҝS{�נu����ޔ�����>?-���J{y�X�89�-Ck�tr<�zD[�E,�, ����P���c�ϛ*c.w;~ߩ~�2��G�e���<�o��U�{m�:�FHs�K}�ʸ���8^��9�&�\��gT��T�yT��PM��PM��&t�k�X,� ���         �  x��]�r�]K_�e�H���.U��_0����-�\���o��/�rn,��I���I&�1I����=�{���?��V��8���i<�W�a����x��y?���+/�f�w���0o�?��q8��f�YY��L��-`�K�!�{��Y�o����uw|D�w�!#�I(�y#5����语����x�ً��;����<����r�J m�tk.��A.!`�S�b�����UwD�!�5ȃ�	��iPhX��T�X��h�y�pȈC$kP�;�T?:�U����[T���H��3/>�T��p���1D�}*�����fOR�~f�-�2�T���R������=�H�	��tt��C�*���LE[���~޲�"#_r]���J��x�S����I����50w���wޣa�
sg;��僉xy>��6go�;����`��\t�-����|0m��\wD�!ҳ�F���52�rk���
��e�_�tJm����4o������t7��a���4!�a%���W�������n4�~��x1�����q��'�t0��5"��A��<χ��ۀ�0��!(�
N8��m��~x��*D4����C���?mΆ��@F�"�����d��EqX��T�X��h�y+�pȈC�g�1j��up�!`]ꒈ��.�hsV`0Dz�b�/2�v��ך���&�e�˂\F�(�e������2R`���	`]���L���iF�"�� 0{���9G�)��!�a�2S�[�;Ɉ_ol"�����m4K#��"� U�-�;�5���D���&��])�Qb���4�$�Q�RB��NP"^�	JD��
�pȈC�g*��Ɏ�f�!`]����g*�hs^��b��L%��L����.SI��3�D���-���my�EFW߳��b���)�YwD�!���$�Uz�57!#^zQ���Ll~��l%#^���hsOJ`�T�1���y�1�ˎIoL�o�k"^X��Y��c�dG�Qa;�[+!`�S�b���1Ka�����/���Zנ�P�|�.m6`"}Z�w_���qQ�L {
�������o����.���4�?_C��7ʮ����1㾈C$Ǽ8f,u�&��
C�U�~��'J�ȍ�<O�4?O����e{�Η�aw���\���.¢�ML4n��J�7������:~;ow���p�:���8�M�k��R�]-!`U�B/���#|)`�f"^>��n�L:TwD�!�iLbQ�}��r��N�\��>aqu�3�⊕�����&Z��o�6��5����>��8�Xyȣ�����^if�R9���u</��Q��K��.���ђ���9��{,�;tߟc��E�!�+���� �����»�W�'�u#�x�9�r¤0DzV��/22�����s_��x���azuz�4���~s:������x�/L+�W�E�`!�0�����pw<.�D@~���1�y�\P�2
�~�4�_g����e���S	��W=�p:CR����P���e��<,����L|_#��q��8���:����3���q"���6�a<�@ŦWa����Nߧy
P�<Fw>�O�<�_?��߹�� 5����7�����f������'�=��12�u^h�{�L��9lk�L��4��ؕw�UB��J(�O{:����8�p��N`���K�_O�,C��Z�Έ��D������ތ/�n�8*z��&�����v-Y�%*+p��Zv*ꊐЫ��h�!UX\��"�2���K�6��)�e�/����p�=\���@q~��y��	�<�0�"�Q+��	&)rT�J��h7��y��Z���l.�	)ך�L�Z���<��S��s�.?x�t(�֔Ԗ?�.�Ln2��,��:[ҕ�JKJ��̡1d�WgR���{,"�
�~��`-2;?O��<0�v�d���`���\���^Q�`C��ۿK�I��Q;���b�;��:8�� �¿�`�b��ӕ��r}�6.(�%��� �������uR�s^�t B+����A��`T���w�
��L�Z#�
D��v�I�� �-����XĝF�1Vs�(��Ӽ;�O���%����r["^H�lps��Ͷ�қE����H9%�M`�F ��a ��G!�i�$D83�*\��d*m���.,3�P������a�^����6S���ߺ�p .��i[���K��yP�1�@�4�@:si{���ǌr-.�Z�I���p>\�2����eWĺ����D@�5���k��X��Y�J �ܸc^�u��w��#�'k�����Ӂ������Ԗh�����x�q��J��L�5M�) Qkc�"< f�J��&\.U _� �9�GKj� �+u59H�`Tf�������=�0`�_�.��m^Sx9����4Tu��"�ŭ�]��}D��JV�I��µP���}
+�X����ر����fx6�*�s˂q��:���I��f�,��+��� M�A�p!�ܛ�Q+�A��5��k�IV��h�;��֋�y�@U���/Sf��0��ڋ��P/��l	���Ð�1��wĺ����iK,����s�}��J>j^!��:n^�.����F������vm�K�;�	��뻄�\-�CH�  dӶ��g�#��E]�c�̱��5s����u܎���Xɦ�D'�&�,�lc�/�G2��3�)j:,��ae�R��@/��1�G10.q�W?NXl���3��fX�_�~��jUiuV�����R�;!�<(V�`�\j� 6R��"J��.��p��,1X"B�)QFG���y�j�5Y�t����([.D�pPݬ�2H'qVJ�v�c����l��#o�	Ћ��Sn��$Z˂]�,Y�d��!٠����2�Fm�3�9e��*�g�{�PI%r�Y�Oӛ��Z��P#n��3�Ό�����F7���	���2�S�5rK��Dm�ӼD����Z��;�IkxOl�g�����G/sK�J�����e7��R �ƪ$6戦jl��5�������!lF�d�R2���C�W�%1ꈼE�*%&C��%H$[K�k�)ǶG!�ƃBzU:)��h�KwW׍��֤���¨q��i��6��U�tN�r��\��#�])� A���æ�$���v��<�U/
���Z�ܤ}��be�nd���>�"5atϲ�ۄ�ma�䡀���24F3�XA�6�g=�Ho14ie����N�T��HE��C[��K߶B/Y�"�!�HOR<Rs��U�ƚ�Ƒy�.~V&�
��T)p�b�/+�Z�m�)�30ǩ���P�{�!s�#Y�L&M�<UP`\����5ӂ@`�.�0ą��c��V�'K�$;�҅bs:����Y=�o9P{�]R�|��^FR�ࠎ�դbg;�����/���H�T}�@}c��7���C$M-9�� �_�؃	�^�F,��+�N}����j=Z~Tz?���b�W�K��9�T�-ހ��S�|)��;Z��o��~����\�Ǫ��K��F���E�"�hĪ���sM5�����b����� �l�u��u�M���@J�����MÆc}u��Su��BG���`�h^��݇��%-�r`fbu���{��ebq���z�U����>�G��������uG�"�������^���v�         �  x��Wmo�6�����Q`	{�-Yξ�Y��mI�bh����k�Hʎ7�ا����e%��8v��݆��x<>�=ǎ� `�u��F��kz�O��;R�A汗�0@-��@hc���X>r��W<��#��)�R:�A�Qڶ��n�݆&<��g���������!y���q�M�q8��
�X��V*s�Ϩ�}�����}����u�i�E3�t��~��[�����ږ0f�{��5��i���f.U&�5��Xԫ[j�[(��L�e����Ǌ�7ǌ�Y��1��-�lJ�q+���2��i-xq��4b�n�}�p鎪:��`�S]̢ya:�h�ְ�C O?���"B��%�U��>5��8"y��yq�Ř[���o�\��\�j���0G�}�~
	#HQZ �U���&x�F��׮�	���ɇ�]� �a�8�j�4��Q��h�{$bF�
�~��e\�֔s��%�x��oA����>���PGf��ZHZ� �h����(b�H��j��ÄP�:�;m�CL��=�yጜ������N�k�Ih�W4��c�`�i��@�c�Fb!~��L%�o'Z?��~����n'\���a{��]��cL��v{���{�u�S$�_�	�����(1aΈ���'���-8>!{ҁ�y��)��l���0pć��S�^�����Ù*dl��a[eyJ���kB��x��$n�Kڑ,�D�7�Ν[�G�'k�g�Җc�"��
���������S�0@yo����f.(K��[��KJ�3�viBMĈ���� +{,�Yث3h^�h��znO#�����E�y�p)){.�2�_�һ���"JTJyty+�:!���/��������@�x*�))#I���)�ϣ$��[�+b�\!��������_��P dA�u+���g�����J�3w��0>�x�Kz'ؙ�x�x�-E������џC4�XnzoI�/�NXC����Eʗ������ۗ��bx�/����uMjȇ;u"�*�D�B�G���H��T0с�ܨ�j��
�����{7��߃j-Y߄ꁚҶ�x$��H-<΍:ܼ����)��!�����U��F��x� �}��ĝ*�\\�#��ƿ���#���6����6���rm����������Mkee�OD��*         �
  x��]�n�F��<�T(�	y9$������4�Ǝ7�n�hc,���(RR��"@�a���I�Eɢ���4�S���s.߹�:vd96���ߥ��oQǳ���nօ�M�ZG�u�MraQ�#�[Ƕm�%ߺ��z#U^��\֏�u����7��$�_�Xo:v@}��'�D�x�x��2�e�9�YL����B
�Ce�H��	�{��]����qY�v�y:q��'�\���:8:d���#/x!f��i�Ӹ��l������1��O��1�J�9���9��`���t�3���ο'</NR>*�P)���U��Z�4�i��C�d'bqD���'c%��+���v���ར<Q(����_����A�s	�;�e��鉸%�%Y���O
9������?ż��7�I|�O��>4�M�hG�7�`���v�$��l���3q�B�sQ��|~I�3tX�~�t��a���pc�(�z�x��x��5	!���wR%k�A�% ���o���j��v?	u.{����L��1,��&�(�Osk�|-.�����䐟�O��˱^����%a��B�1��F�#�W5%}d��412r��Y��p��T�L������D��r�Y������C� ;4�Xh��� ��M�z����&���p�O
R-��Jb7����t;�eJ�X%fk��4vk�?'֡�!����&����JG]]���"O�z��� ���p�
+���t��t��Xm���e��/���gU��<����w�G0;T.ca�[`	����䂧�>i�k�f�H�1�a��B�Ro(�ܺ�H�秉 +?.�0c�c��0�Y��Մd��
2���"%\)��	������U�-�[����}��/��cޚ�̼�),�!�I��0���Q��s����f#�a���A{�5?v����w~��(Xꉚs��^ �k$��� �쐣5f�$/�V9.x�V�r��f�$0���'Mz$!b�%ܠ!2  �c#&��G��q(k1�:�`.z�u�Zf���kȀ��c�s�så k�F��ŏ���sQd�"̎.6m�\�ͷ1{���!�L�uw5{Y�_o�^l�r�9�~?�9���U"�NQ��}��3V�o+�]K���E�"�\2������ہ+'ɺ�;�t�M	���ĺc����[r)ŷ'�_�H���]���&��d7���7�>�B��$���"17���RFN��X�sP#���_�yJ@�������x� �~:K���%A�i6�;H��@3^u#<'}���b ȩ�{�9�|�J&չ���fS%��)�(�	��t۔e��<�_��s�1.�6/�=�I0)�8,�>�o�����a�+	VH��ɣ	�g 5C�����l \��-�37���ۺ�k�e��k�e����=d�0�؜�ʹ���9-T�w5��s�Űۣ���0[�s�s=��~.3~.~�e��6e�`Z�G�����vХt��v�2��º1��ՠ���^c
ʋ0+�[�yOLP;�QB��F^D۲�09l��1�ce��`��Y�	�k>7��S��	~�9�\���s�̍L�aC�d0���H�&��.s��P��Ŕ^��bJf?~1%��S2�VL�LZS!��
I�mq��m�X�`ښH
�o�q�	R� ��Qml�h�����Շ��vۿ�}���5`��f�_�<L�����8V��f���o�cl4sa36��Z7��n{��	��n`*��n`��06c����h��c.��63�4vŏ�6�(8>-Ӕ��McWd�\"���i�Y���us}��!�7���^5�bS�M�u����aC��:��f�5)���I��]����&۲����_�Sg�}��*�Li�z�M�^~���J �
�٭%����Wp��9�Eox�;�Yp�+��J�L�}
�����]��cs�dE!�3vT���n�50�4�Ǹ�}}a��O��� = ��
��iނ�ūl��XЇ�Hu�cV��g�I���Q�uq�e�c,x��,%�D2�չ�Kr:)��[_V-#��2K�)e�P���>�$&�<�ڹ�<����,4�1z��<�`�И��c�x��c�ms7W�$��îg�A��\��s*�񳩘�s�i�sf-�=ʞan�Ed��1��4�A{�˾�=�s}Խ��i�fJ���XQ��Mu�����L��Q�TI�&b���$gV�ᯋ�+����dTxGjskm���՜}�1�S��猴�__3�[+�I�5U~��uh了�$ࡉ�WgX�%�+p=P��k����tO�b����
�o�t*�d���2�׈F������eKSm@P��4>�ꌌLB�^g��&����c�1O1D�B�IMl>w�d0�mo�⸴�IM�����\s��i��s���s�.>�g31�m3暤&~�e���ۣ�IZ� 樏��'�\5��&�������`.e`�\|ʾ12`�\|Ұ��K�9���ű&��sM�4���s���Ė7��]�ű��M©yz��)f%�Mׇ>i��eX[Ds��R�e��vx��m}S��h��؋n[O�w�oQ��NM��ܔ$o{��q�����E��2�͎O�4�.�T���i�̓�P�[�g��s�cnd0E�3�b����0�.6y��6�k��뚖��a�55>�i)�����?��a�bW72��s#��8\]̠�M�7��bF]l򰙮�O;Ϟ=�?�L�         	  x��W�n�8�N��	�2t��\l5��5VBB8@ǘ�m�V�����m��jr�b������hsZt��J��]+�쉰�ʕ�fE&��͕��V��"������
e˷ٶ�Q��>�T*[�d!�KF�2\{�$V0㤡1�q�62��ުP<�;�6���7QQmf$C����lH�{ZQP�_?B�������Х���H�5Kz�8�&J��¿nA�I)�no��I�1%�8���I�!k�X�ۚ�J�'�2cU�}m��h�_�{�.R~�������6)�н����2��3���L�0�?UoU���ji(W2������^`�j��=:E�N����
̠�����pZ(�2òp	�J9 �	{�X�"�*��A�ˣ��O-n>�����Un�p^�fZX��B-���A5���O�n���1���_N$<���bx(d���	��<�#�q�t#�0] �(1��?n�u�R��W	c�xA�1f�c���;����%׹s�����,G�yI3�2�&��ZH,���۫�H�L@�'܈b+��*�xAd�m�(pm2�N���l��\aѴ��{�G�9��q�cNf������;k�^Z��ć]SB?UZ��t�oʺ���U��L���,JCe�����8��d84ːCA�i0V7��os�,��쏍�2f���֪���Qr�]\(������a�Zk�T�����9������1;�����
�k�������d��	���D&��yi����S�Y��A���>���%�q;e�X�y;�	hډ��I�]%=��n[�8�z�n5P��� �-,��| �j�N�-��#U�U�+G��[���i6+Ƿc���W&�ǘ~ �	#�,6���v"����?��M��/f���I��2NpHL��oj10���Sx����Y��fG�μ�6܋�	<[>Qd�&�n�Ɜ�)"�J�=��Ҕ4��fc�m�O`��\	�(�2#�V/x��ȫ����6_�!
�y����|W떳:�y��ڕPU��� In�x7�7#�$�j��C g�^_�J��/���}���ȴ�wU@��(�_?WuA�m\q�t�4x�
c����^���)�CF��DN/tpN��!�ϳ�;����(/U�=��Z^v�x�C�`S���!eɶ+J�.�v���?�!B�G9��qy~:�H��M[}�>��t�g�?��o'����:�"���s���>�����*q��%����6����}o�7@�Mb�?4)�����L�֨�of�ZO��e[�,�&WWW�lʪH         g  x��\�n����<�"?�8I.���?K����X�|1��?#q%mEq�%iG)�;�
�G��orO�o��DR�%;A���Yr�;��7��~�����ͣ�J"�>J�I�S2bk�&�J&���{
3��Op)
��J�Փo����Ic���sII*^�e��[�����_�D�����?^G�����j���L�o?at]���q	?�(���H�P���Mw���(����,
\�︭�Rqb�H�2b��*�z��s�ň҅C�B�*����@�.�`u��83���)��z��O�_~�X���_b��*���㩑2j^��7��&��R�H~��I"��������m\�X�K_LA�����cY=+:�(�D��\�+)C1̢�E~z���꒏���҄���z�c142�.�_22�4�.4H)��)���^�;� ^����X����J��[3*>w���+qj��i�$4�YHbjJ�Y&�i��C��ڬ]C���>���~�M��ѧU<S����MB�#q=��T��t��Vf��;X�9&V\d��
�k��ct��Tf<L��������L�DjE��t���<WiBoiV�Qǟ\C��i�µg*�	����ޗ{�U��wr����&�00:��Y����K~�aH���Φ��	S�3�����E^�ס��x��5��ev��c	LJ�5�j�> ������J��������x��K��ea��\��:ɡ��sL�MWY�$�	'�D�*�9��R�X���|&Zg�O�:N��4�w:�G44x�e�(���c=�Ţ/�43��~.��=3�}Q�Dh �������F2���j}������>ڇ5�8���Gs�Cm�x��DX�����[���wdZ����y~Yl��,���/b��Rϫ���FGh<��[�\bO��7:u
�����Oj�g��d:����^��,�0oA�)M(\�(l�D`�3��ɝ��P"��W�qŷY���>�E�mef�cvB�i-=fO�ړ,aHX��\���(�T���}�Iq�>8T2���)����XM�ȅ��&��f$�����.����:wy�����P9���xa�؉44�񂑟�o�Ǌ>ġ6�u@�7�
��װ��J�L��j�Co>xX�G�����2q�!Nc9'8I@�LRB�ˇ�m���fz0�	��Sơ����J(�hS}ĕ^�N3��>�7h��B�@E����簆/�9
O�9}�"�u1�Nf�N�v�b��Тc�D�	�5��t&��<~���
�^�<~qЀo_��o@�iA�P�]���.����kX/M�yڅ�T��ㅾ��A�pIK@{����2<b!�&�$������kѾ*��3B����DGܩej=I��6k ��C	g�70�ą.�ޣ�e�u.oe�Hv�w��E'�*VS�*�+�pc7=y@���
K.���������b�k����L[2gXp5e:�("��}!+�1x���@�t�����Ŋ�m�o����AI&���JK<��p����K��y��L����x�f�Bh�z�.L�f� "#��Ě1pz�<c�h���054Kˀ G��#�x��¥xE{N�ŷ+I|ݙ.m6���.��������'�?�f�'�!�����(��!�>�~J�%�<�[��p����|�!������h�Qb+�VK,<���9�6'���(��;_�y�mE�C�aEX�>��g��[��M�㉭7���?��QQ��"\��ǧ���kp_xb?1�2�v#YklܹB�r�����
i/|�C&�F�=s�����=�V�6�Z�.H���q.Eכ"��&����l�q�R��M��d���W/��8&���S��GnW`%�7	�V|��e��$�gW�cGs�H��[��7/�dj���Y��u��Ĥ*�dhD�LS'�1yL�L��艹�*f�3@�!t�%��S'`�v#
�x��ō�����΅��%��ܺ� B��w�}����n���@�����-OL���U�����<_ص.�k�j�ͨ�+m��:֜�[ B���`�\�e��g�ݓ��e"���&��Vh��F6���5���KŞzӥ*3���TT��e�&W��)��N2+��M$s'~\K6��_t�|�,�!9��d��F�ג������W��.|.R�6�``���I�Nj��l�����b���w�pJILƆ����Ӯ��z�>F��������I"��"��4�O�I8Aw�n"���ԣ5E�	t@輆�xT^2���PNy�����oDsI����^�z2)į�Y��멒�����85��^���Z@
�]y����(ΐS��\���Z���
q������r��l�����O�m���/Xz,zY�,��S��bW>�,4��t�\'v���A��
���v���(������ P���~ʅJbiۧh�K���	j�d��]��Db!Ǐ8�.�GN��	v��� ���y^tO���zP~h�a� j�.Zw��7{s��z�~�ԫZ����߭���p{����|���q���۪��P�F1(NA-1�j�K6��"Y쿝��d�'���$��'�J�ї��je�.i�����_;V�q��ԳZ�b�d�+���[���ڹ�{|�u���P߿��޼bU�˷*^�i�
$4�`�-A�[�9ô���~��J�$����=�do[��P��4�m%��f��p��nש��<�&p� `}���6u��p&xf���-�q�C'�F�Q$-R�7O�٩:�9B_#ث�����P����>�dޖ�+��6��3����kf?�"֐����k�1�;���R٪��0Cq�������5��)�]��Xg@e��kÊ��
�Hy<�:oyF����3��p�;1�h���Յ���6&�l�����!;z��k��VP�.%~w�-��|�{�2�!�M����g :n7���E ��4��-]6\�G�� �me~_�}�6R;����zZG���z�j�g$D�x�<4����	W��Q%#g�Ʃgv��?��f���G���F\)��e���y��	ۿ5F+z�M�£Z�n�ywj��s*^p�Bq����}ǒ�,��� �q_�i���� ���r]f��'�|�_?�'��m\���-w�ls���jm��+��n �����s�W��χ����E��{�{zE�����9 f��X�Ps;�]T��Wo����ު����������M�����9���I�@������a���G�m�|H\�j�8�O�W�l�i�\�]�&�Z�.��g��N�J��ANx�br5�-�1�@���?�Խ@3d#�1�S���Q�����D����}�n�Sp~��B�g���7��E#K,���Q����tF��Bj�����a�-�����a��MҢ�u�&P��|�Mu�9�B5�ck����������0eo(���Zos-��t+D/v�� �e���w�����>�~bO
׶s�ީ�y�Pʹ���HM]��t��3�I����W����!kd�Q�����q��;�:
׮��.�Z��>0����;F �(�3��E�jU��}fޮK��ۿl�\Iۈ�~Ԛ�7����lm��O� ���ȁY�m����=t�3M��A�`�Z��b��9-f^G���[��A��� �6ۘy�0^��R>�� l��z^?����y��v�p�W6�ʵ=�v̽�`���i3��y��K�|��2r�u���Gq�'�~������igK���w�8$�3�,�����t�#>�\��Oѡxj�����'�����wS.�(�h��v*�d��BZM���ib_�e��1=�i���_����rbx���a8��~�Z�Gҡ$|j����F����$-�	�_������c"�
         �   x�5��
�0���S�BY�&�G�"� x�RfѺ��ԋ��n&�����'�Zm�m����)ȉ��B�2Kc��k�I���n�����L�9g���ɸ�C�k�άg�w��?>K+Z��Ņ��* YSN'��N���d���S���w��E@� )ˋ�R� (�:�            x��}[o�V��s�W0����j�+�`R�t:�TU�t��`0�0h�e3�I]�q78�a���_2���;%�{Y��1ʖ6�ͽ���o�����̻�Յ��������g�
/�������>���A����d�������_�^��|r9�|�J����t��n5��a�ɗ.�ɋ����ѓ?1[���n���x~���S��N>�0��"�2�`��=�c\o��v�{�鞘ǳ7o��=q�n�p.D��|O\nߤS�0�Pn>��#�%Zq��sL��/��m��%�{��R�_�ez����m$�	��0��o�0�_�9��$�{y�'���Q�<�b�/�?���W������d5]���������|��z,�o}���0J>:��
���O�����V�+/ᓫ鎏�~w����$��7a۶ua�����ǃE<O��}����������^͗V��z���2�#��O%����kǫE:7��*Z��	��Q�&�����^߆��<��O�ߤ�Lg%{�p���_���+�G:�<�fQ�_,�����������0�3#��j�`��p���_]M�k�y�9}��'x��)o���0J����/�~4�W�.��q��x�,}8}�t�no<
���.�tiÓd͟ Z�_&O�H�{:L8/|r�h�?,��;�	���v�;��x6���W�"��g���v��x�xy������k��f��Lw6�Oփ--�Z��͢�їA� �[���Z��b{��˙�X��ˋ`Y����|��_�6�u���l�ZX���Y����:�_��<-�~�����U�>?�NX�ֵ?��g?��O|
���WQ����rF�^?��7�����y�F���=��ˇx>�d���y3��ʇ+,�`r���x��7ӹ]&��`	�b{��,��b���������~���y ��H�x� ��Ѻ��[Ql]ñg�W��,?z\ކ���M��?O~,o�
�H��:��O�V<�n}��<�?���~f[�D��G�.�,�EW����wD�t��woখpS�l6O�N�/����(~�0�f	��a�_X��4� ���80<p�h����_�����r�z?SxW�L���l�8Z�װ���� ���!�|,�G�_N�Ezd�^�f%���L�扒��`K�w-`YX�6��tn��K�{��~}��?�k��|aq$��wp�?h2�ߒ���t+��'O^E�ڒa��?]n_�$�ms��`�J�L����<���42�s�q���a��ˤ�t�ݓ'̑�WFvQ��Ӫ\>��o��V�vX[IАb�)^�V��a�`��`�?�V�;��WCZ%l�Ο?���$E�Ϥ'<�=<�ʷ�FMV�o��w�@��#�d���E��}�Cއ��4���.�Y�^��b����C�����=`j��o��Ȁߧ���|�Ua�tz37��şC0;Q�v�o�w�uX,}�ǈW�u�엟��M��B(�����mt["�۲Z���Km�z$x�����)��5 <x�`��M��x>y\��������F��.ևQ%S��(Y0	�eNV'_7��yvԿ��5h�j�a���܉���\��*�L f�ԏNm�cʖ.�l��0J@�V�T0���,S�Ͽϒ�`���_믰�&�y8�^���) W�Ss �sX��̓�[?	�II����
���?�{��W���I��m5�y���{��N֋�5��_�iX/ِ��~3���xy;���d���Wa"���☭��ŉBye}����;y�����W��Y�W������|ջ�	J�� R���Y<���t��?��]OS�93�Б%o� S+�ZyZI]eB�׻hV��1/6�"�Eċ�ӴӴ/"^D���y��͋�1/�v�u�'��Ir�ʒ:�tnLi��;��ϳ��E�JiL9�4�H��R�����!�CH�����"8�Mp��Mp�ì53v	{�H��Jd���v�(c����M|�#�f��g�v����s���1�y�v; ������Z�p�;���6�%�A�cD�c}�Y.����E��,貐��D��$�x<X���s�"gEh�	f��?�G��zIς�����ֲkY��u��z���4��dx��S�qr���Uq�d��-Rŏ��*n��H?��=JD���p"Rŉ+z
Uܫ���j�w��UA��G<Ib?w`s&�����dv��$090��ͱ%q�X-���س�Ԫ�]�e�. B�e�|��ҡ�� {7��ѿ��z��xٹ�k0�U��ۍ��~|�4��]v��S�RJ{��z};�0��|������]E��u� x;هE3/c�W�v��k�Ѕ����x�:L�f(�2ԟak<F�h�\���<��i�O��S��g�����|���s�v�﮳]~����ӕ�d�Yc������9i��} s�Q�{3�?��X��MR��C<c�<�A�eDI)��rl+Gǳu���SRu{�5�'�?]Xqd}LW���.���V��)R><DR�;����}<	�I���/^M'��D�^��}Kig��HFI���i��j�̆��x�Ke���6	);s���e��_9��3d�����ֲ�LӟsG/'Go'�9f���&���'��G ̑��e���K��Yis����ܪ_ִ�$/�ѣF�Ҟ;*9PB�NX0;�	���
d�*�T�"�w� ��S� �X�ǹQ4����!�`ߑ��6�/�|D�$@��y
���8�4V@!�\s�+ �c��k�����#��ln+��ڽ�R����ޟݮ��<&r �4s��I~W����٣WS�ʿ�K��/X��R��8P`'Z Z�Q��[��W��>����ο�@Xl����*��d����t�8;�@n�ys��-+[8�G�h�9،#J����.�~���h��a ������)|m2���		ԍj�`(�����`f�êffw�A�O�?2]CƸ�~��̻�ͩ=�PHk6]-ֶ��������:���k���~d�� f�bN�����������n����d���G�.nE�u��_�����qy���͛��'��H��`�dʮ�E��$1��I��<�?���~�,�$��.�,�EW���y�gc�����M-� ϓ{�s�K�'�.���YB�y�T����gG=\"�l/7�W7����lC�b$��և��p�� �dz�����l�$�h��!m�F7�:���h-���
�J���l;^��"�L^E����&a��-�H�j��'٦X��	�<y�h}��#�G �@���y�g\VNI��Z���U���KV��Z��k�����
9%�d��Bv�z�qF��Di�Ҝ>�"JC��(Q�4Di΍Ҁ�A��V
��Ԋ>�'8�9�Q�cN�S�Q.�ɋƎ9u���l@f��lH"6t�0���!bCĆ�:;6�46y����u��@LS@�\M~����<�d[vW�im-��o��	�� ����%k*/�nO׊���0����א{�9�����W:��yj?�;�L5���s�J��/m��N�r|�t�#� �!���~��u��<H�3���X��W�@�Nx��0d�;W�J�������mf<D��6l���(�m�;����µ؊��R�C�{l�����C��
�,��hpm�Y���hpq�f��h,�Б4�Q��+���T*)�rASvP-�@�����b,s�`.Q�\�=B(U[?wۙ��h�ɳ��w��$���5{y,�WU�L�7]lh- �/�T��Q�~K���*dY�;�Z��,3��Fl*N	s�٭���c6u��t^ˢqsز*:��P�.oX�P�ʡ�R�S�g��x7oc��q@yu&X~l�~&�N�(Q�v
5�s��8���}�^ٷ�9ʘ�q�����v�cŃ�.��Av�M��4 �1��+�WG�N�A-���(,����e�쫫�z5mt6~]���Mo��� թ~�\���;�<��r�o�p�R�{mKX��8W���Q���    �����MM��������>?���7�م��pX�}��'r�&U�M\�0������v�-�y8�Z��%���!��9|�&H�~�Z�6���Kr�&��?&ظ��7�$��>�P�w��� pH���j?��i]�?����j��C�H��Ò��*�E�2�����T��O�E��ń^�h*i.Xy悕S�z�C����`DH�u�R�n}^v���%Kkd�������ǵ���E�S�q�Ƥ�RG�k�y\ǟ��<uz^�z�ı��q	�ז�9n���6��8齅%զ,m�wum��_Yz�rӅ�UV2i��l��ΞZ���r�0D����<E�(e��6v�A-�w�(�.�qC�d+�[���$���a34��`R`+�!�]%y��p.v���nPÈ ]�0m�]k!F��+k�mmopC�p.���r����e�Z{ۂoW�7��ʟ���e;l{GQpxa��2��%#[���0��.s9 ��j0�me(g��O�Dys��%���������!��tjl©u�'��,B���5�A�p_��J��nM^b4O����w��������9��A�ݘl��=�;���ն^���U������z�b���:�4��qukO�v��űQVM7�k��M���cF#��tx� ]+sk��j�Q7'E�u�O�'�W���y���{���픷��Dg��O���v������G>O�ֽU��O�kV).zd�T��e�T����"���G�����}�&>�h�*��ɲ�{��1�66�r�%g)�|�Tî����d�CH�J]�p��qO�""#������MTk?�{��[��(���(���_5�u�)���F��(����*��3�
?jQ-T�d��H��r�,���N��]���$�3��L�}l�*N�:ɝp��$�`��e���!D;Ӏ�B���Y�g���-���"�u�XK�Z�[��iQ�6q�b�p[�n�V�N�׭7�������n��iU��,n�0���ڪ��n�=O�B��(ԃۺ���H�O�?�Sv\��ewv\�{s�ro<���Zq�t�(�m3��y:wM�P�^�'���m(��0�z@������v���sLSz4n
�'p[3�X� 'Ω�����7#ּz�;Q���`���v��$��v����8�2p���ؐ�{�5ދ�Q�����{Q��E�l�#̷�nӰj�"NS��	����k^] x���[���L�;G��ٽ��AJv��BJ6)�ł��X��n�v�r�Y����〜�M�57�}\E�C�*���Yc��8�	܆�@pl����2�ZK���IV�!�a�̟(�L�·x
�p��5�Nw�����i�υd�!�sd�o��}�q7,�M�W����ף�}=<~�j$�m�����x�1!�銧��
|����P������M�����
V�
��ZHq�*�T�b|�~���U0̃4�V��*�H�6F�)~5~sD5���iݢ+�?̮�������&)+�{���fo%b��G:c�]Tv��
ץ�	܆dp�63c�̎#3#fF�l|�Ň�13bf��j�L생��4�t;i74�Y�:+Ua',� r�:+��<uV��W�Dq>��C��ivV�Ո��9����
��m��C�\c�^�m��˪��Q~g��C\qd�7\�����]̋��9��G/7>�ȯH���L"?��$�,�G˓H�?Y�_��$
#��$��O"?��$��O"�ߩ������,�SY�3-+C�q���	x�i'̜�w�QS0D|�Hee�>q�M��@��`�2����ჳ���v*�G��T1�������ڹ��$�Ii�K�T*��*�*��Qq�Dx�ÎGe���?��j�m곮����z��������R�[jzKQ{���V��q�dU���6B)�p��"%2���B򤍍"96��^z��������Qn0;��O�Mc�w�mN�(��r��%���Ż2��8�,� J�S-KKs�ر�2sj�w�:�'�����"T�|��I��.dYM�t��	 ��̸�|�×�s-D�}W��$�^�[l��<jnu���ȩ��34G��o&a�����9\�h����m��f�A�X�F���-�ac)d����n�y�Z����U�dZM�7�RP/��[�s<��R
�՞�w�KA�'�+x�Q� �R� �R� 9�N-|P�r�n�n�PƵ��@��U9Y�Õ�=)�U9���9�*�*`��%5R�H#�5�bh��Gx$��oNT�y�%!�#�99a��3���mLM<dj�����¦&.5������9����Z�Ӹ�Z�O�]��w?�.c;wY�W]�F�]�Dݓ���`w�Ȼ��7,,�9
[;���-��v@$���L����H;8�vP)�E��0a2��񁃳���v�d��N�	Q�2��f�h��f�h��f�h>��f�ܝ)���A�͐ݚ�N~O��gv�( �[��0G�����?�U�C�x50����h�e�SM�\����*��@�-κ��ϋp��{�(G�ڸg���&R&u�I/#����e� 5��6����K��P��<p�uM	��bp�&G�3�a���m��ln�������ɵVMs��6m=9� �s�g��iډ�d�"<� <�A�n�X�ib�Cq@q@q��Tyāg.�ɪ`ֹk��um1XFS�2�ߓ�r�����-^�*� �j�"y�M^y�O�u�@�"~�̓�����Ã�2JU>z���&�K�@�;؆a���(C��V;�5�k��k��m���`��=����z=]]Yo�d���oB�����m�ݪ���Y��N�n/gfs���z��=�'�����J{�{ؓTږ�'��P�Y��gQi�yZ�Gш�Hш�Hш�8ЄG4���-]V�
��~�U;��@rm�,��z
9��慞L=��zQ�^J�#�ֶ�0D�2K����|I;�K��_>N�6iUk�U��ʰ�BVa�b�9�"���I���K��.*��E6�g2�c[���MD�����h􊷐��S(/��
呫�����IyncR���2/ؼ ��*�(9y�@� ��'�<{�ё{�1��v+����L�����Y�qd&�q���av1�8��4�S;��6��)ÓO7�[���,��g�}���I�N��&ݐ�N�$eȐ�Ǝ�H�8��C��:�,jĶ����z��5�-r�*�kf�M�<�yOYO�I���t��x���+٩+��l����y�a}�,:��ȣ�MW�I~ѵ�<6E��*j�����ԣ�kLTj/�UmeδX����5�%�Yݝ��H�<d�%����&Z6��pdn޳d�̡�J�C�9���Pp�x�(8�e�)8�$�;� �H
�[pw]�e����"XF���;�2�e'�<�e����"XF���;�2�e'˄��N]u���1����D{��o1��������������_,��s�{v�K"!DB��(#B$��;�"!�LB<�<lX�3���-�D���ZC��+��Zeɔ₋!s�2��b2�q�Yrб],T2�Ű,�?�[6���y-Y�D�]�R�o��-G��yk�U�"�bQ�Φ��Ny	�>c"M�mN�a��i?��4��1���h&�՚	��;�,@ju(/[/t�J7�������1�v�@�/2}��K�3��paN�]l.Z|�D�΋N�_��<�%�ϓ_���D��H�G�攦��~9�v����Ю�2�LB\\�ml±}(^�A�g4�ܕ����l����e��]�f�����1ZS�\�Wћ"gѶ����P�R����� �{(q�}Ws�]����Cn�;
�掞q؄P݈��Pj�BM\���.>�&.���0o'�:T�<��l�����y���4v�<��?�vk������K.��H��}v���.�餑k�y\K{�6������n!� 9�9"�`+�(Z�~�â�~��C�|W�f��    r#*sO�����.��79Af?�4�Ãܸ�Cn\��W
�ƕܫy�M}+C�5�5����Jh���B(�YȮM�!w���h��>=�n-��?�}Cȵ)���N-�;6,�*a�����W����¹�_�t�S�ƴ=�0���#��c����n�dfv|�l26í_h�;e��
�l������v�4��ݾ�Ҍ�s���{
n���9S�!�h��6 >��s8/�M����� �-��,q��[�]�U�La�{���dGMC\<³
삻�a�]��Ved
�!�'%s��� ��|�}����e,Kv�\;_Y���rQ�������q��3�\�Jlʴ��X;L$Xן�{��5�|�h��d�k���p9}���!�8Վ��ϰ�'0���^��?n�qɫ����Oc8����w.Xw;�zڱ|n���%4��A�'�d�[t���wh�s�lU���cKn���s�g�m������A6�ulBb�����I�L�"	D���m�t��J\p>�D�̦��(�YR�����'4�r?_hX� �+3#� �*+� 1
� 1
;� 1ao�'��,�~���W�~��-+Z�7pf.ֺJf���b����:bf?Q�x�®����֫��z5m�������ھ3������c�(v��=6�mN�]3R�P��f~�ܷ��QG��n�NF/�{=�����Y����m�`)��Hu0z0����ê���M�9R+y�䘉"8��S7A����9g�%1M�!�1�����տޜ��\i�+�D�E���((u`�3�+��%џ��8Dq��RB���^ey����Ui����Dl�+z�lN�S���6�x:s6����Α;Vy��4r�*���ɸ�]��C�t0�h���`�J���	e=��LЋ�A/�^O�����'w"�t��;�܉��~:�c ց��	��z/�.�x��!X�x!8T��S�18t.��l�����e�ZG��.��o��?�E�����8��k8sV�NQU�&�z�_��owY�S��Y���:������O�ī���dZ$��ģ��Z�f�J�J7�)��w����^���k=�W�`;Ǔ��1���d�T<��%��!V���rw-��m��>g7����J�A��$ڵ/(k2u������-I��X�r��t�$bIĒ��'�R�C1�RfE�܌�CnF���Q�f�����E(}��[�(�R� ��2}��T��aQN���{�5� �Aփ�Y��a=�~R���'�qJ�k�J��!��9�����4��R�ҺJ:�g7�g8|�������*�f��h�b6��ݱL�c���-_RR���um�����"KV��m\���]���Y~����q�����l�����^s�&��i���Z�-���$�$����,76X���?$����w8>�kh�n`����֟O��2��̛�d�x����)(]W�O�yRZϟt�����]��uI�[~����t�4X���t��~^�k��?��d��Mbb>ē�MtR�a>$�*��g�9�ظy}���G8n8H/t��\8�r�����^=٫g�X�M�k���Y�_d�X�%E��F�d�ѱ���O'�B���_)lL��d=*�JdQ)8y�X(A�N��6ԓ���R��cW��syPM	�u١�T6��})ؗ�}O3�WJUrׅ��ajQ��4ˢ��H���y������6eM�r2ed�Ȕ�)s�pE���J��.k��s��s��]9���b���I.&����㖋�W�ZU�U�8^n6���l�6&��:	�E��z��krmet�h���3�%1-bZ�gZTz�J�u+�Z���«d��eF֏�Y���~�\��(qC���5R� e�$��i&P#�X�=����M5em�v �Y��r�AҨOA�&9��h��OS���6�w��X)*�����E^�O"������ m���](�x���aYGx�Oë���Na;�D��u{;/�q�u���" �?&�2���,�Oҟ���U�z�
st�Ū(�~C�x>y� 
 -Y��9̤'<�=l��o���Cu��C�)����fd�=\/��xj���d�#1�����­)�<���g�(�4��Rp)���{��/�;�K�SU�F[��h�]��iѾ���aE��V���H��F��Q}>���M�R���rj����~�yCY"�P��piP�"�=��`EuII��c�X��L�&��Ҩ��`��S��b
�1|�Rܮ���qƹ���Ru�n@�Z�ډ��"kW��`�4v��F��x�Q(�dt��BOvr��%���iѓA�^��#JuY/��,׼9�Q�k��hX�����B�N�/��:� �vqu}3���iͲ�l��8��k�_�ݵ��F�V�����n�j~�6���gF�-lg��3-�U�.���F�V�)���*�MA�NV>�W�-��^�����0� ����&(��,A爋1� ����er���G�f5�.�?<{@5;J٦rl!~X���Q�l��deH/�G��H6;fٌ2)ñ���nAR'+g�?'�5�$
L��v��C���n���*'����X�'Q������||Xvz�QI�B�j˕4�ա�Zƽ���3�Qv�=���B�����gi�L�>d��sP�]����4�()��W����1q6�_���n�+�S�O�'�OX�bQ�	�׮;X?jT�<�1�\QU���ќB;�A�d�Xt��C�mt���edBɄ�	%z�&T��0O� [��t�뢚d��K*S8瓅sR�&�lR�&e:?a���	�=�H	m#ߟ��.G{t�N
8�7�s��P;!��	{�*\s1g����>��%�~�j6�r��0�Y����|���M�d��$�%9,*��#S)�0����|�lI����H�R{}uN�����%%�Q�%�Q�%�C�ck\�3MFS6���� ��D����c���%p�Fv�xȮ��ꑌ�~������@�u�<�	�3閙ų�!���"��׷���by�Yg��d�I�#�|LvYz���h�C%
�ne��������
5�f��L�����=�f�RhL%�w�<��)�<�T��Q�w;lx*es�n�!�L�C�b�h�|p'�fL�PoOq�(�S�����Θ��_F���X�|n��EmH�(Z��KZ,��L�+����OO�p�$���
���+��q7/�I�d����!s���+�Oz'��A�gݘm@	kTL��MS+�Q1�n1�����ω�rL9����	��'��O<�`u�D�;"D�18b��ƍ,&�a��u��ٜ�ٜa����="{DE��;�9�u�m#'�q�D6^Md�8 gMͩ����Ӧ�q�Y"	�T4�&�L��h4A��ZJ8{�u���-��]���kt�;E��,Y�[")Q3Ѹ*���H>-�IC<�L�BG
2�a�Um�9��J>�(Uw��NT�i�wϡ����$��,`�E����;��F����.�tym�����o'��v����k�q˞��%y�O�%��$�O
>��$.(�PX*�/Lۍ9Y�K��b���3ie�L�V@�o���)Ť�RLJ1)Ż����bQ�L>�Уp�֜|���<�Z�xM�k+m�b���<�p��m���A���0��Q������AJ[TY�����Z�YY�\���g�O�f�BPE��#��7�Vq6Й��&���j`Um�r`2�} �2�"4ǭS�X��p�_��Ƴ9��Eb�X�N��_�@�
�|sԴ���P�jZr��snZ�9nm�*C��Q��q65>�^�l���u�����\��Β���ZoA�z�k��f�����7��a/83���iS��Ӹ�.1%Y��L�k
UJ��]l��5�#-+�����T4l���'��}#	 
�=$ I�N��%��k8	-�
V��G��� �nޔ��>����3�*	7�)�l=�=	�y�M��<�?���~��X݅�����
p}8�nZ����%ܔ?��� j  �O�]?�f��f�����%g�\"�l/��6��C0����*��I �a#(��7�78��)��6��D {K��DU�%�ɹ�f9F�}(N�C����kͥQ����!�'%��s '�|�}�N�eM��#��W���B�\�����@�|Ӱ����2����=�sro{�&�/���,-�����{C4��M������(oc�z�eA��hX���~�1��;rr.Xw	|�뉜���I^nz�@خC������^M>������ `G?��u��W
�|�y��Pm���^xK�(ޑ8=q����Dcw���<�ư=�/�W��1���qu``��k�����ȺRo2�dHɐ�!�f!O��6�y$絞�$瑜Gr��<�֒�L|jyV����Qe�]F�E���P��sC�Jd�����װw;����O�p*�5��E0�`��!C�
C��P	�#�*��񝕾)P�"o��n8�%U~��oT���,Х3����9��9�bzm";�EvM 1�љb@�f�΃9�4}V�<�O�r
��v
���pIԊ�Q+�VD�ΆZ�"�+h��V�>4��Cs�}h�NZ�KK	]��~Iu(4�B3�94��P݂Nq�J�d�����#�G֏�ߙY?�*C��a�m�5㨁9�����<L���)���A��dwXC�P�q���"��I]|��H�Sq8��cQii�⊼�g��m�I��t�]��@פ�s�P
�!�JV����YU�Tw��b�X]�vQ1j#v�!��Fldm�$c���������\��3l���әa8�mZqFd}����r���Npix�a�+��g2�����MsU�!�` Jx<��G�mA����#���a�^���I��L�Pc)m��p�P���mS�m"�D��(��(�B"{�d������z���$�'.�鹍֓\��:$��L:���z���P�"?��3\�=.r�fs��&ݐtC�I7�n�=��&Pr%wQrWgK@�]��5��<���q�a����KHz�ΠXa����͘<��1C��m�drɔ�)�GQQ�*0C@����*0Cf:�.�W�Mq9\����R�IT���j�@%�%���<�cҠ�CI�N�#%�����?�`��de�ʐ�!+CV�T�����`t�W�)���O�UG0�F��>J�#�����c��Ff��(�Q2��mF�Sp#����k���{2�����G.>�%z¦A��m�;�H���B����B�O��C���CI:�����O�Y��M�a�J��Ff��ɶ�m?f���CF����1�y-����țbODA�D���r?%B=6�
Ѽ�b���Q�Б�����p�E`����EĚ`3�!L�g���H��-S��f�R���oJ�mO�����~���ǟ�h�$��N
�(�޳��ZH���|��0	��Y�a2Hd�� �A��#4<��lN��/y�B����"[B��ll�஡��5�˲zl�4nl	�V�8J�+K(v���%�?�e��;^��v
��m,��w���%��x����,�#8a�G����y���}x}�	���x���v�ů+N��j�F����l�GlZ��S()������V��6�fm����Fm�N{X�Ҍ�58�E�`r�Sd|�����܈Gbs:�?�	Y��p���f����iXP�C��./fxC�vz��醄�|MB�rqX�rT��Qo�����s�mHq%<�+ʫ�(��O�cޝ����<ӖڒR[R��u[3�>�n+ZⶡT|h�ƨ,G�q���p=��BJ�h�k!�c"0&��\7gX��N�;��$���>V�]� � �B��A�H�(�@I�*t^CI�b�x8IU�tr��U�d*��&ZM��h5����j�
U9�-�2�����Nj���)�N��'�*�6�YݮI*�i�=�
�Uj�FE�hM��	뿝G��6K=T"�J�~C%R��֡�T"�ϐJc�$�����ԋB�H?�+\/���@��wz�:��s�z�\A� A�N"h�Zda#��6��goc�!mLOI�y'�C�����=�xt�#�Khb���˪c��r-�vU5F��~d�Dk��kM|ʩ�0�exp���1y��n3M�C��簛�0	/	���`��$�'5�Ql]�Ih�W�� �<.o�yS����ϓ`���N��]�E[�X��2>�&Ft�I�H?3��.��p��1\��!@��EO�{7����g`���\���ɺ����l��l�_,�ܨ'g�\0��rus���6pB���/�\��1ُ�&�9|x��F��..�����^߀%��l)��b��������5ͮtGů�p�}+ٷ"�}+�ܷ�}+p3`�R�5�g54���"��׷����(Wɨ����&�}�����Je�*�WG�����>�ߟ����'��_N���U!�KЙNg:��t�ә~�g�rrɚ��%q�ġ�C�%�l���Y���U�]����Tl)�Zp,z�����D�.�5G�ҭs?nO�cS}�:��֍/�ը/Աke�\�Z���w�����wnD�*q�2Le8�h~�Hz8)�O�,cI�K�,���xN��e�q-w�����(����)ܲ�Ө�_�B˟�qpy�FW$fچ�a����5*hӅ�Q(��nƤ�mL��>T�N���0���k�5���;12W\�K�l5�6u^s�ж$-yH�xGr���,�bҩI�&��tjҩI�>y�Z1=.�M��Ⱥ��������z	Gރr*&c�;u�AaڭQǾw��!�悀����1˭u��]@�YM����&�D�/�j�H��z.5�W"��cw<7��H�c��Ƕ��Ӧ�q7��ߎ���"�u�̋�F;�p�)��Z���
/�jLM��	05�&���X��0�����w��R���c�	b�Vƫo�uSY�IS\)Sܭ�k���(0,�E0i�s��w��&;�1�V�Z�M;��x�X;�&o�.�F��wtm�͜J
7�C��`8�\A�� #F��0rM���J�j�P���+�gP%F
�8rcFo��n��1��"��8�Ƭvϴڹ�P-��G��9r2�d�OŐ��L�Bȵ�X��O*gW����ܧ8T�pH)�H�w
i�����O�
�)6e6����D������o:K[C^�o���d�߹����yR��v�ᩇYp��:�Q$!���Q`"q���
�Z�*��. �������"lM�Vpa�q�rp�/���n��[�͕�5�DVX�X���X���v�'�T�X�iZ����yI�\�A��0p��ӂZ�)�,����<��z'DnG� ��A���y��_�	h]�     