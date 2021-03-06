--drop table dgmain.call_log;

create table dgmain.call_log (
call_log_id                    int primary key,
call_date                      date,
lead_ids                       int[],
vacation_ids                   int[],
guid                           int,
cast_member_name               text,
notes                          text[]
);
