-- DROP TABLE dgmain.webservice_trans;

CREATE TABLE dgmain.webservice_trans
(
    trans_id integer primary key,
    trans_date date,
    params jsonb,
    trans_name text COLLATE pg_catalog."default",
    results text
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE dgmain.webservice_trans
    OWNER to dgadmin;

GRANT ALL ON TABLE dgmain.webservice_trans TO dgadmin WITH GRANT OPTION;
