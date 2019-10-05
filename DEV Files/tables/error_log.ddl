-- Table: dgmain.error_log

-- DROP TABLE dgmain.error_log;

CREATE TABLE dgmain.error_log
(
    trans_id integer,
    err_msg text COLLATE pg_catalog."default",
    err_time timestamp
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE dgmain.error_log
    OWNER to dgadmin;

GRANT ALL ON TABLE dgmain.error_log TO dgadmin WITH GRANT OPTION;
