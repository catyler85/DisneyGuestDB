create table dgmain.resorts (
resort_id    int primary key,
location     text,
resort_name  text,
	resort_type text,
	rooms       jsonb[],
	dining      jsonb[],
	entertainment jsonb[]
);
