--drop table dgmain.travel_groups;

create table dgmain.travel_groups (
group_name                      text,
lead_guest_guid                 int,
travel_guest_guids              int[]
);
