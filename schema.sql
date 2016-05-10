-- Drop tables with no FK first
-- Control Shift R to run in IntelliJ
DROP TABLE room;
DROP TABLE hotel;
DROP TABLE room_type;
DROP TABLE customer;
DROP TABLE booking;
DROP TABLE staff;
DROP TABLE discount;


CREATE TABLE hotel (
  id 						INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
  name					VARCHAR(40) NOT NULL,
  location			VARCHAR(40) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE room_type (
  id 						INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
  price					INTEGER NOT NULL,
  CONSTRAINT valid_price CHECK (price>=0),
  PRIMARY KEY (id)
);

CREATE TABLE room (
  id						INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
  room_type_fk	INTEGER NOT NULL,
  hotel_fk			INTEGER NOT NULL,
  status 				VARCHAR(20) NOT NULL,
  -- 	booking_fk
  CONSTRAINT check_status CHECK (status='BOOKED' OR status='OCCUPIED' OR  status='AVAILABLE'),
  PRIMARY KEY (id),
  CONSTRAINT room_ROOM_TYPE_ID_FK FOREIGN KEY (room_type_fk) REFERENCES room_type (id),
  CONSTRAINT room_HOTEL_ID_FK FOREIGN KEY (hotel_fk) REFERENCES hotel (id)
);


CREATE TABLE customer (
  id 						INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
  user_name 		VARCHAR(40) NOT NULL,
  first_name		VARCHAR(20) NOT NULL,
  last_name			VARCHAR(20) NOT NULL,
  email					VARCHAR(100) NOT NULL,
  address				VARCHAR(200) NOT NULL,
  cc_number   	INTEGER,
  cc_name				VARCHAR(40),
  cc_expiry			VARCHAR(40),
  PRIMARY KEY (id)
);

CREATE TABLE booking
(
  id              INTEGER PRIMARY KEY NOT NULL,
  start_date      DATE NOT NULL,
  end_date        DATE NOT NULL,
  hotel_fk        INTEGER NOT NULL,
  customer_fk     INTEGER,
  CONSTRAINT valid_dates CHECK (start_date <= booking.end_date),
  CONSTRAINT booking_CUSTOMER_ID_fk FOREIGN KEY (customer_fk) REFERENCES CUSTOMER (ID),
  CONSTRAINT booking_HOTEL_ID_fk FOREIGN KEY (hotel_fk) REFERENCES HOTEL (ID)
);

CREATE TABLE staff
(
  id              INTEGER PRIMARY KEY NOT NULL,
  first_name      VARCHAR(20),
  last_name       VARCHAR(20),
  username        VARCHAR(50) NOT NULL UNIQUE,
  password        VARCHAR(100) NOT NULL,
  staff_class     VARCHAR(20) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE discount (
  id              INT NOT NULL,
  room_type_fk    INTEGER NOT NULL,
  discount_price  INTEGER NOT NULL,
  hotel_fk        INTEGER NOT NULL,
  start_date      DATE NOT NULL,
  end_date        DATE NOT NULL,
  CONSTRAINT valid_dates CHECK (start_date <= booking.end_date),
  CONSTRAINT discount_ROOM_TYPE_FK FOREIGN KEY (room_type_fk) REFERENCES room_type (id),
  CONSTRAINT discount_HOTEL_ID_FK FOREIGN KEY (hotel_fk) REFERENCES hotel(id),
  PRIMARY KEY (id)
);