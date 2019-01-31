--drop table dgmain.guests_trans;

create table dgmain.guests_trans (
trans_id                     int,
load_date                    date,
status                       text,
guid                         int,
name_prefix                  text,
first_name                   text,
middle_name                  text,
last_name                    text,
name_suffix                  text,
address1                     text,
address2                     text,
address3                     text,
city                         text,
state                        text,
zip                          text,
country                      text,
email                        text,
phone                        text,
cell                         text,
fax                          text,
preferred_contact_method     text
);
