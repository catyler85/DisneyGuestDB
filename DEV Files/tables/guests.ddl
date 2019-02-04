--drop table dgmain.guests;

create table dgmain.guests (
guid                   int primary key,
name_prefix            text,
first_name             text,
middle_name            text,
last_name              text,
name_suffix            text,
address1               text,
address2               text,
address3               text,
city                   text,
state                  text,
zip                    text,
email                  text,
phone                  text,
cell                   text,
fax                    text,
last_updated           date
);
