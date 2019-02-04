--drop table dgmain.travel_groups;

create table dgmain.travel_groups (
group_id                        int,
group_name                      text,
lead_guest_guid                 int,
travel_guest_guids              int[],
primary key (group_id, group_name)
);
