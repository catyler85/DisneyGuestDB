--drop table dgmain.guid_key_lookup_trans;

create table dgmain.guid_key_lookup_trans (
trans_id             int,
load_date            date,
status               text,
key_name             text,
key_value            text,
guid                 int,
dg_id                int
);
