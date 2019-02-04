--drop table dgmain.payments;

create table dgmain.payments (
  payment_id              int primary key,
  payment_date            int,
  vacation_id             int,
  payment_type            text,
  payment_amnt            int,
  card_id                 int
);
