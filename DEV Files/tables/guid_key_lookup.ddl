--drop table dgmain.guid_key_lookup;

create table dgmain.guid_key_lookup (
key_name             text,
key_value            text,
guid                 int,
primary key (key_name, key_value, guid)
);
