-- DROP TABLE dgmain.lov_table;

CREATE TABLE dgmain.lov_table
(
    lookup_type text,
    lookup_key text,
    lookup_value text,
    lookup_seq integer
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE dgmain.lov_table
    OWNER to dgadmin;

GRANT ALL ON TABLE dgmain.lov_table TO dgadmin WITH GRANT OPTION;
