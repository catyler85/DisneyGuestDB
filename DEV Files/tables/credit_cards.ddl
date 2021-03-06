--drop table dgmain.credit_cards;

create table dgmain.credit_cards (
  card_id                  int primary key,
  card_added_date          date,
  guid                     int,
  card_type                text,
  card_num                 int,
  card_security_cd         int,
  card_exp_date            date,
  disney_visa              boolean
);
