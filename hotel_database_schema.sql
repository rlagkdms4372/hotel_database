DROP DATABASE IF EXISTS HOTEL;
CREATE DATABASE HOTEL;
USE HOTEL;

DROP TABLE IF EXISTS CONTACT;
CREATE TABLE CONTACT (
    H_code        VARCHAR(30) NOT NULL,
    Address            TEXT NOT NULL,
    Hotel_phone         VARCHAR(15) NOT NULL,
    CONSTRAINT pk_hotel_code PRIMARY KEY (H_code)
);
DROP TABLE IF EXISTS DEPARTMENT;
CREATE TABLE DEPARTMENT (
  D_name        TEXT NOT NULL,
  Main_Office       TEXT NOT NULL,
  D_phone       VARCHAR(15) NOT NULL, 
  D_head		TEXT NOT NULL,
  Budget       MEDIUMINT NOT NULL, 
  D_no		VARCHAR(20) NOT NULL,
  CONSTRAINT pk_Department PRIMARY KEY (D_no)
);



DROP TABLE IF EXISTS _EVENT;
CREATE TABLE EVENT (
    Event_Name        VARCHAR(15) NOT NULL,
    Event_ID        VARCHAR(20) NOT NULL,
    Event_date        DATE NOT NULL,
    Event_time        TIME NOT NULL,
    Event_Loc        VARCHAR(20) NOT NULL,
    Dno        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_event_id PRIMARY KEY (Event_ID),
    CONSTRAINT fk_dependent_Dno FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);
DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE EMPLOYEE (
  Employee_ID        VARCHAR(9) NOT NULL,
  EF_Name       VARCHAR(15) NOT NULL,
  EL_Name        VARCHAR(15) NOT NULL,
  Shift        DATETIME NOT NULL,
  Dno        VARCHAR(20) NOT NULL,
  CONSTRAINT pk_employee PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_employee_department FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);
DROP TABLE IF EXISTS CONCIERGE;
CREATE TABLE CONCIERGE (
  Employee_ID        VARCHAR(9) NOT NULL,
  Lang_spoken       VARCHAR(15) NOT NULL,
  Hotel_Code        VARCHAR(30) NOT NULL,
  CONSTRAINT pk_concierge PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_concierge_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_concierge_contact FOREIGN KEY (Hotel_Code) references CONTACT(H_Code)
);
DROP TABLE IF EXISTS HOUSEKEEPING;
CREATE TABLE HOUSEKEEPING (
  Employee_ID        VARCHAR(9) NOT NULL,
  Cleaning_skill       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_housekeeping PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_housekeeping_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);
DROP TABLE IF EXISTS MASSAGE_THERAPIST;
CREATE TABLE MASSAGE_THERAPIST (
  Employee_ID        VARCHAR(9) NOT NULL,
  Massage_type       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_massage_therapist PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_massage_therapist_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);
DROP TABLE IF EXISTS VALET_DRIVER;
CREATE TABLE VALET_DRIVER (
  Employee_ID        VARCHAR(9) NOT NULL,
  DLicense_type       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_valet_driver PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_valet_driver_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);
DROP TABLE IF EXISTS COOK;
CREATE TABLE COOK (
  Employee_ID        VARCHAR(9) NOT NULL,
  Cuisine       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_cook PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_cook_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);



DROP TABLE IF EXISTS GUEST;
CREATE TABLE GUEST (
    Guest_ID        VARCHAR(20) NOT NULL,
    F_name            VARCHAR(15) NOT NULL,
    L_name            VARCHAR(15) NOT NULL,
    Room_no            SMALLINT NOT NULL,
    Phone            BIGINT NOT NULL,
    Credit_card        VARCHAR(16) NOT NULL,
    Address            VARCHAR(200) NOT NULL,
    Loyalty_pts        MEDIUMINT NOT NULL,
    Emp_ID            VARCHAR(9) NOT NULL,
    CONSTRAINT pk_guest_id PRIMARY KEY (Guest_ID),
    CONSTRAINT fk_emp_id FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID)
);


DROP TABLE IF EXISTS PAYMENT;
CREATE TABLE PAYMENT (
    Payment_ID        VARCHAR(20) NOT NULL,
    Payer_ID        VARCHAR(20) NOT NULL,
    Payment_method    VARCHAR(10) NOT NULL,
    Payment_date    DATE NOT NULL,
    Payment_amt        DECIMAL(19,4) NOT NULL,
    Emp_ID            VARCHAR(9) NOT NULL,
    CONSTRAINT pk_payment_id PRIMARY KEY (Payment_ID),
    CONSTRAINT fk_payment_payer_id FOREIGN KEY (Payer_ID) references GUEST(Guest_ID),
    CONSTRAINT fk_payment_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID)
);

DROP TABLE IF EXISTS FEEDBACK;
CREATE TABLE FEEDBACK (
    Feedback_ID        VARCHAR(20) NOT NULL,
    Feed_Comment    TEXT NOT NULL,
	Guest_ID        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_feedback_id PRIMARY KEY (Feedback_ID),
    CONSTRAINT fk_G_id_fd FOREIGN KEY (Guest_ID) references GUEST(Guest_ID)
);


DROP TABLE IF EXISTS ROOM;
CREATE TABLE ROOM (
  Daily_price        DOUBLE NOT NULL,
  Room_no       SMALLINT NOT NULL,
  Start_date       DATE NOT NULL, 
  End_date		DATE NOT NULL,
  Guest_ID        VARCHAR(20) NOT NULL,
  CONSTRAINT pk_Room PRIMARY KEY (Room_no),
  CONSTRAINT fk_G_id FOREIGN KEY (Guest_ID) references GUEST(Guest_ID)
);

DROP TABLE IF EXISTS CAR;
CREATE TABLE CAR (
  Guest_ID        VARCHAR(20) NOT NULL,
  Employee_ID        VARCHAR(9) NOT NULL,
  Model       VARCHAR(30) NOT NULL,
  Parking_ID        VARCHAR(20) NOT NULL,
  Color       VARCHAR(15) NOT NULL,
  License_Plate        VARCHAR(10) NOT NULL,
  CONSTRAINT pk_car PRIMARY KEY(License_Plate),
  CONSTRAINT fk_G_id_car FOREIGN KEY (Guest_ID) references GUEST(Guest_ID),
  CONSTRAINT fk_Emp_id_car FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);

DROP TABLE IF EXISTS DELIVERS;
CREATE TABLE DELIVERS (
  Emp_ID            VARCHAR(9) NOT NULL,
  Room_no       SMALLINT NOT NULL,
  CONSTRAINT pk_delivers PRIMARY KEY (Emp_ID,Room_no),
  CONSTRAINT fk_delivers_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_delivers_room FOREIGN KEY (Room_no) references ROOM(Room_no)
);

DROP TABLE IF EXISTS ORDERS;
CREATE TABLE ORDERS (
  Emp_ID            VARCHAR(9) NOT NULL,
  G_no       VARCHAR(20) NOT NULL,
  CONSTRAINT pk_orders PRIMARY KEY (Emp_ID, G_no),
  CONSTRAINT fk_orders_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_orders_guests FOREIGN KEY (G_no) references GUEST(Guest_ID)
);

DROP TABLE IF EXISTS CLEANS;
CREATE TABLE CLEANS (
  Emp_ID            VARCHAR(9) NOT NULL,
  Room_number       SMALLINT NOT NULL,
  CONSTRAINT pk_cleans PRIMARY KEY (Emp_ID, Room_number),
  CONSTRAINT fk_cleans_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_cleans_rooms FOREIGN KEY (Room_number) references ROOM(Room_no)
);

DROP TABLE IF EXISTS CONVEY_REQUEST;
CREATE TABLE CONVEY_REQUEST (
  Emp_ID            VARCHAR(9) NOT NULL,
  Dno       VARCHAR(20) NOT NULL,
  CONSTRAINT pk_convey_request PRIMARY KEY (Emp_ID, Dno),
  CONSTRAINT fk_convey_request_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_convey_request_department FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);

DROP TABLE IF EXISTS REQUEST;
CREATE TABLE REQUEST (
  G_no            VARCHAR(20) NOT NULL,
  Dno       VARCHAR(20) NOT NULL,
  CONSTRAINT pk_request PRIMARY KEY (G_no, Dno),
  CONSTRAINT fk_request_employee FOREIGN KEY (G_no) references GUEST(GUEST_ID),
  CONSTRAINT fk_request_department FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);

DROP TABLE IF EXISTS CLEANS;
CREATE TABLE CLEANS (
  Emp_ID            VARCHAR(9) NOT NULL,
  Room_number       SMALLINT NOT NULL,
  CONSTRAINT pk_cleans PRIMARY KEY (Emp_ID, Room_number),
  CONSTRAINT fk_cleans_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_cleans_rooms FOREIGN KEY (Room_number) references ROOM(Room_no)
);

DROP TABLE IF EXISTS SOCIALS;
CREATE TABLE SOCIALS (
Hotel_Code		VARCHAR(15)		NOT NULL,
Handle			VARCHAR(15)		NOT NULL,
Social_Media_Name	VARCHAR(15)		NOT NULL,
CONSTRAINT pk_handle PRIMARY KEY(Handle),
CONSTRAINT fk_socials_contact FOREIGN KEY (Hotel_Code) references CONTACT(H_code)
);

DROP TABLE IF EXISTS INTERACTS;
CREATE TABLE INTERACTS(
	Emp_ID	VARCHAR(9) NOT NULL,
	G_no		VARCHAR(20) NOT NULL,
	CONSTRAINT pk_interacts PRIMARY KEY (Emp_ID, G_no),
	CONSTRAINT fk_interacts_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
    CONSTRAINT fk_interacts_guest FOREIGN KEY(G_no) references GUEST(Guest_ID)
);


DROP TABLE IF EXISTS TAKE_ACTION;
CREATE TABLE TAKE_ACTION (
	Dno	VARCHAR(20) NOT NULL,
	F_id	VARCHAR(20) NOT NULL,
	CONSTRAINT fk_take_action_department FOREIGN KEY (Dno) references DEPARTMENT(D_no),
	CONSTRAINT fk_take_action_Fid FOREIGN KEY (F_id) references FEEDBACK(Feedback_ID)
);

DROP TABLE IF EXISTS INVENTORY;
CREATE TABLE INVENTORY (
    Item_id        VARCHAR(12) NOT NULL,
    Quantity        VARCHAR(20) NOT NULL,
    Price    ENUM("text", "Cash", "Credit", "Debit"),
    Guest_ID        VARCHAR(20) NOT NULL,
    CONSTRAINT pr_inventory PRIMARY KEY (Item_id),
    CONSTRAINT fk_G_id_inventory FOREIGN KEY (Guest_ID) references GUEST(Guest_ID)
);

DROP TABLE IF EXISTS MAKE_PAYMENT;
CREATE TABLE  MAKE_PAYMENT(
	I_id	VARCHAR(20)	NOT NULL,
	Pay_id	 VARCHAR(20)	NOT NULL,
CONSTRAINT fk_make_payment_inventory FOREIGN KEY (I_id) references INVENTORY(Item_id),
CONSTRAINT fk_make_payment_payment FOREIGN KEY(Pay_id) references PAYMENT(Payment_ID)
);


DROP TABLE IF EXISTS CAR_PLATE;
CREATE TABLE CAR_PLATE (
  G_no        VARCHAR(20) NOT NULL,
  Plate_no	VARCHAR(10) NOT NULL,
  CONSTRAINT pk_carplate PRIMARY KEY (Plate_no),
  CONSTRAINT fk_carplate_guest FOREIGN KEY (G_no) references GUEST(Guest_ID)
);

DROP TABLE IF EXISTS BOOK;
CREATE TABLE BOOK (
  G_no        VARCHAR(20) NOT NULL,
  Room_no	SMALLINT NOT NULL,
  Plate_no	VARCHAR(10) NOT NULL,
  CONSTRAINT pk_book PRIMARY KEY (Plate_no),
  CONSTRAINT fk_book_room FOREIGN KEY (Room_no) references ROOM(Room_no),
  CONSTRAINT fk_book_guest FOREIGN KEY (G_no) references Guest(Guest_ID)
);



INSERT INTO CONTACT (H_code, Address, Hotel_phone) VALUES
('SOLAR997754356', '1348 Formula Lane, Dallas, TX 75204', '9897773012');

INSERT INTO DEPARTMENT (D_name, Main_Office, D_phone, D_head, Budget, D_no) VALUES
('Housekeeping', 101, '9894345656', 'Veda Charthad', 400000, '1'),
('Management', 102, '9894346767', 'Haeun Kim', 345000, '2'),
('Valet', 103, '9894342323', 'Jihyung Park', 200000, '3'),
('Massage', 104, '9894341212', 'Aditi Mungale', 175000, '4'),
('Cook', 105, '9894345650088', 'Pushpa Kumar', 260000, '5');

INSERT INTO EMPLOYEE (Employee_ID, EF_Name, EL_Name, Shift, Dno) VALUES
('86559', 'Ignacio', 'Jennaway', '2023-01-18 23:24:13', '1'),
('35617', 'Ardys', 'Ducarne', '2022-12-23 09:15:47', '2'),
('58039', 'Gaylor', 'Cudihy', '2022-07-17 16:40:28', '3'),
('29771', 'Alessandra', 'Boor', '2022-06-07 10:55:39', '1'),
('12893', 'Clarence', 'McPartland', '2022-04-27 14:10:50', '2'),
('46957', 'Lilian', 'McLoughlin', '2022-03-17 17:26:01', '3'),
('73095', 'Giuseppe', 'Bladon', '2022-02-07 20:41:12', '1'),
('99231', 'Aidan', 'McGuiness', '2022-01-07 23:56:23', '2'),
('65173', 'Eleanor', 'Kinsella', '2021-12-27 06:11:34', '3'),
('82319', 'Elijah', 'Duggan', '2021-11-27 09:26:45', '1'),
('49559', 'Amelia', 'Fitzgerald', '2021-11-27 09:26:45', '1'),
('26799', 'Dorian', 'O''Shea', '2021-09-27 15:57:07', '3'),
('13939', 'John', 'Smith', '2023-03-08 12:00:00', '1'),
('50177', 'Mary', 'Jones', '2023-03-08 14:00:00', '2'),
('76315', 'Peter', 'Brown', '2023-03-08 16:00:00', '3'),
('25678', 'Clara', 'O''Brien', '2023-03-08 18:00:00', '1'),
('14526', 'David', 'Williams', '2023-03-08 20:00:00', '2'),
('98754', 'Emily', 'Anderson', '2023-03-08 22:00:00', '3'),
('32100', 'Robert', 'Jones', '2023-03-09 00:00:00', '1'),
('65432', 'Susan', 'Smith', '2023-03-09 02:00:00', '2'),
('97856', 'Michael', 'Brown', '2023-03-09 04:00:00', '3'),
('43219', 'Jessica', 'O''Neil', '2023-03-09 06:00:00', '1'),
('76548', 'William', 'Davis', '2023-03-09 08:00:00', '2'),
('12365', 'Sarah', 'Taylor', '2023-03-09 10:00:00', '3'),
('87654', 'John', 'Doe', '2023-03-09 12:00:00', '1'),
('54321', 'Jane', 'Smith', '2023-03-09 14:00:00', '2'),
('98765', 'Peter', 'Jones', '2023-03-09 16:00:00', '3'),
('45678', 'Mary', 'Brown', '2023-03-09 18:00:00', '1'),
('23456', 'David', 'Williams', '2023-03-09 20:00:00', '2'),
('12345', 'Emily', 'Anderson', '2023-03-09 22:00:00', '3');


INSERT INTO CONCIERGE (Employee_ID, Lang_spoken, Hotel_Code) VALUES
('86559', 'English', 'SOLAR997754356'),
('35617', 'Spanish', 'SOLAR997754356'),
('58039', 'French', 'SOLAR997754356'),
('29771', 'English', 'SOLAR997754356'),
('12893', 'Spanish', 'SOLAR997754356');

INSERT INTO HOUSEKEEPING (Employee_ID, Cleaning_skill) VALUES
('29771', 'Dusting'),
('12893', 'Mopping'),
('46957', 'Vacuuming'),
('25678', 'Dusting'),
('14526', 'Mopping'),
('98754', 'Vacuuming'),
('32100', 'Dusting'),
('65432', 'Mopping'),
('97856', 'Vacuuming'),
('43219', 'Dusting'),
('76548', 'Mopping'),
('12365', 'Vacuuming'),
('87654', 'Dusting'),
('54321', 'Mopping'),
('98765', 'Vacuuming'),
('45678', 'Dusting'),
('23456', 'Mopping'),
('12345', 'Vacuuming');

INSERT INTO MASSAGE_THERAPIST (Employee_ID, Massage_type) VALUES
('73095', 'Swedish'),
('99231', 'Deep Tissue'),
('65173', 'Hot Stone'),
('12345', 'Shiatsu'),
('23456', 'Prenatal');

INSERT INTO VALET_DRIVER (Employee_ID, DLicense_type) VALUES
('82319', 'Class C'),
('49559', 'Class C'),
('26799', 'Class C'),
('45678', 'Class C'),
('98765', 'Class C'),
('54321', 'Class C');


INSERT INTO COOK (Employee_ID, Cuisine) VALUES
('13939', 'American'),
('50177', 'Italian'),
('76315', 'Chinese'),
('25678', 'Japanese'),
('14526', 'Indian'),
('98754', 'Thai'),
('32100', 'Vietnamese'),
('65432', 'Korean'),
('97856', 'Middle Eastern'),
('43219', 'Mediterranean');

INSERT INTO GUEST (Guest_ID, F_name, L_name, Room_no, Phone, Credit_card, Address, Loyalty_pts, Emp_ID) VALUES
#Guest_ID        VARCHAR(20) NOT NULL,
#F_name            VARCHAR(15) NOT NULL,
#L_name            VARCHAR(15) NOT NULL,
#Room_no            SMALLINT NOT NULL,
#Phone            BIGINT NOT NULL,
#Credit_card        TINYINT(16) NOT NULL,
#Address            VARCHAR(200) NOT NULL,
#License_plate    VARCHAR(10) NOT NULL,
#Loyalty_pts        MEDIUMINT NOT NULL,
#Emp_ID            VARCHAR(9) NOT NULL,
('12345678', "JAMES", "SMITH", 201, '1234567890', '1234567890123456', "2947 BAKSU ST", 604, '86559'),
('23456789', "JOHN", "JOHNSON", 202, 1345678901, 1345678901234567, "2957 SITN ST",  1005, '35617'),
('13456789', "ROBERT", "WILLIAMS", 203, 1456789012, 1456789012345678, "0748 DALLAS ST", 205, '58039'),
('14567890', "MICHAEL", "BROWN", 204, 1567890123, 1567890123456789, "2485 PLANO ST",  680, '29771'),
('10234566', "WILLIAM", "JONES", 205, 1678901234, 1678901234567890, "3768 RICHARDSON ST", 1027, '12893'),
('34567890', "DAVID", "GARCIA", 206, 1789012345, 1789012345678901, "78462 ARLINGTON ST",  285, '46957'),
('45678901', "RICHARD", "MILLER", 207, 1890123456, 1890123456789012, "7702 DALLAS ST",  3948, '73095'),
('56789012', "CHARLES", "DAVIS", 208, 1901234567, 1901234567890123, "6883 NEWYORK ST",  2345, '99231'),
('67890123', "JOSEPH", "RODRIGUEZ", 209, 2345678901, 2123456789012345, "6843 CHICAGO ST",  3847, '65173'),
('78901234', "THOMAS", "MARTINEZ", 301, 2456789012, 2234567890123456, "9272 AUSTIN ST",  8937, '82319'),
('89012345', "MARY", "HERNANDEZ", 302, 2567890123, 2345678901234567, "58746 SEATTLE ST",  293, '49559'),
('90123456', "PATRICIA", "LOPEZ", 303, 2678901234, 2456789012345678, "4372 SANDIEGO ST",  897, '26799'),
('15678901', "LINDA", "GONZALES", 304, 2789012345, 2567890123456789, "3998 GALVESTON ST",  380, '13939'),
('87654321', "BARBARA", "WILSON", 305, 2890123456, 2678901234567890, "6543 IRVING ST",  9038, '50177'),
('17890123', "ELIZABETH", "ANDERSON", 306, 2901234567, 2789012345678901, "3946 COPPELL ST",  3843, '76315'),
('25678901', "JENNIFER", "THOMAS", 307, 3456789012, 2890123456789012, "0192 RENNER ST",  897, '25678'),
('19012345', "MARIA", "TAYLOR", 308, 3567890123, 2901234567890123, "9346 DENTON ST",  784, '14526'),
('38459281', "SUSAN", "MOORE", 309, 3678901234, 2012345678901234, "87654 FRISCO ST",  4937, '98754'),
('25678902', "MARGARET", "JACKSON", 401, 3789012345, 3123456789012345, "90123 ALLEN ST",  28, '32100'),
('28901234', "DOROTHY", "MARTIN", 402, 3890123456, 3234567890123456, "12345 GARLAND ST", 9, '65432'),
('29012345', "CHRISTOPHER", "LEE", 403, 3901234567, '3345678901234567', "2947 PILS ST",  587, '97856'),
('31234567', "DANIEL", "PEREZ", 404, 3012345678, 3456789012345678, "2957 QUIO ST",  498, '43219'),
('32345678', "MATTHEW", "THOMPSON", 405, 4567890123, 3567890123456789, "0748 PLANO ST",  2006, '76548'),
('33456789', "ANTHONY", "WHITE", 406, 4678901234, 3678901234567890, "2485 DALLAS ST",  382, '12365'),
('35678901', "MARK", "HARRIS", 407, 4789012341, 3789012345678901, "3768 ARLINGTON ST",  6819, '87654'),
('36789012', "DONALD", "SANCHEZ", 408, 4789012342, 3890123456789012, "78462 RICHARDSON ST",  57, '54321'),
('37890123', "STEVEN", "CLARK", 409, 4789012343, 3901234567890123, "7702 NEWYORK ST",  27, '98765'),
('38901234', "PAUL", "RAMIREZ", 501, 4789012344, 3012345678901234, "6883 OHIO ST",  209, '45678'),
('39012345', "ANDREW", "LEWIS", 502, 4789012345, 4123456789012345, "6843 AUSTIN ST",  589, '23456'),
('41234567', "JOSHUA", "ROBINSON", 503, 4890123456, 4234567890123456, "9272 CHICAGO ST",  88, '12345'),
('42345678', "LISA", "WALKER", 504, 4901234567, 4345678901234567, "58746 SANDIEGO ST",  587, '86559'),
('43456789', "NANCY", "YOUNG", 505, 5678901234, 4456789012345678, "4372 SEATTLE ST",  598, '35617'),
('44567890', "BETTY", "ALLEN", 506, 5789012345, 4567890123456789, "3998 IRVING ST",  1234, '58039'),
('46789012', "MARGARET", "KING", 507, 5890123456, 4678901234567890, "6543 COPPELL ST",  243, '29771'),
('47890123', "SANDRA", "WRIGHT", 508, 5901234567, 4789012345678901, "3946 RENNER ST",  298, '12893'),
('48901234', "ASHLEY", "SCOTT", 509, 6789012345, 4890123456789012, "0192 DENTON ST",  8, '46957'),
('49012345', "KIMBERLY", "TORRES", 601, 6890123456, 4901234567890123, "9346 FRISCO ST",  573, '73095'),
('51234567', "EMILY", "NGUYEN", 602, 6901234567, 4012345678901234, "87654 ALLEN ST",  234, '99231'),
('52345678', "DONNA", "HILL", 603, 7890123456, 5123456789012345, "90123 GARLAND ST",  19, '65173'),
('53456789', "MICHELLE", "FLORES", 604, 7901234567, 5234567890123456, "12345 DALLAS ST",  75, '82319'),
('54678901', "JOSHUA", "GREEN", 605, 7012345678, 5345678901234567, "9272 SEATTLE ST",  976, '49559'),
('55789012', "LISA", "ADAMS", 606, 8901234567, 5456789012345678, "58746 SANDIEGO ST",  276, '26799'),
('57890123', "NANCY", "NELSON", 607, 8012345678, 5567890123456789, "4372 GALVESTON ST",  190, '13939'),
('58901234', "BETTY", "BAKER", 608, 8123456789, 5678901234567890, "3998 IRVING ST", 803, '50177'),
('59012334', "MARGARET", "HALL", 609, 8234567890, 5789012345678901, "6543 COPPELL ST",  238, '76315'),
('60123456', "SANDRA", "RIVERA", 701, 8345678901, 5890123456789012, "3946 RENNER ST",  590, '25678'),
('61234567', "ASHLEY", "CAMPBELL", 702, 8456789012, 5901234567890123, "0192 DENTON ST",  290, '14526'),
('62345678', "KIMBERLY", "MITCHELL", 703, 8567890123, 5012345678901234, "9346 FRISCO ST",  385, '98754'),
('63456789', "EMILY", "CARTER", 704, 8678901234, 6123456789012345, "87654 OHIO ST",  298, '32100'),
('64567890', "DONNA", "ROBERTS", 705, 8789012345, 6234567890123456, "90123 DALLAS ST",  281, '65432');

INSERT INTO PAYMENT(Payment_ID, Payer_ID, Payment_method, Payment_date, Payment_amt, Emp_ID) VALUES
('00001','12345678' ,'Card', '2023-05-20', '300.00', '86559' ),
('00002','23456789' ,'Cash', '2023-05-01', '250.00','86559' ),
('00003', '13456789','Card', '2023-05-09', '500.00','86559' ),
('00004','14567890' ,'Card', '2023-05-21', '300.00','86559' ),
('00005','10234566' ,'Card', '2023-05-14', '300.00','86559' ),
('00006','34567890' ,'Card', '2023-05-02', '250.00','86559' ),
('00007','45678901' ,'Card', '2023-05-18', '250.00','86559' ),
('00008','56789012' ,'Card', '2023-05-30', '300.00','86559' ),
('00009', '67890123' ,'Card', '2023-05-03', '300.00','86559' ),
('00010','78901234' ,'Card', '2023-05-07', '300.00','86559' ),
('00011','89012345' ,'Card', '2023-05-02', '500.00','86559' ),
('00012','90123456' ,'Card', '2023-05-08', '300.00','86559'),
('00013','15678901' ,'Card', '2023-05-27', '300.00','86559' ),
('00014','87654321' ,'Card', '2023-05-10', '300.00', '35617' ),
('00015','17890123' ,'Card', '2023-05-13', '1000.00','35617' ),
('00016','25678901' ,'Card', '2023-05-03', '300.00', '35617'),
('00017','19012345' ,'Card', '2023-05-29', '300.00', '35617'),
('00018','38459281' ,'Card', '2023-05-05', '300.00', '35617'),
('00019','25678902' ,'Card', '2023-05-29', '300.00', '35617'),
('00020','28901234' ,'Card', '2023-05-22', '500.00', '35617'),
('00021','29012345' ,'Card', '2023-05-13', '300.00', '35617'),
('00022','31234567' ,'Card', '2023-05-21', '500.00', '58039'),
('00023','32345678' ,'Card', '2023-05-30', '300.00', '58039'),
('00024 ','33456789' ,'Card', '2023-05-20', '300.00', '58039'),
('00025','35678901' ,'Card', '2023-05-13', '300.00','58039' ),
('00026','36789012' ,'Card', '2023-05-15', '300.00','58039' ),
('00027','37890123' ,'Debit', '2023-05-08', '300.00', '58039'),
('00028','38901234' ,'Card', '2023-05-01', '300.00', '58039'),
('00029','39012345' ,'Card', '2023-05-15', '300.00','29771'),
('00030','41234567' ,'Card', '2023-05-29', '250.00','29771' ),
('00031','42345678','Debit', '2023-05-07', '300.00', '29771'),
('00032', '43456789','Card', '2023-05-24', '300.00','29771' ),
('00033','44567890' ,'Card', '2023-05-04', '300.00','29771' ),
('00034',46789012 ,'Card', '2023-05-22', '300.00', '29771'),
('00035','47890123' ,'Card', '2023-05-10', '300.00', '29771'),
('00036','48901234' ,'Card', '2023-05-19', '250.00', '29771'),
('00037','49012345' ,'Card', '2023-05-11', '300.00', '29771'),
('00038','51234567' ,'Card', '2023-05-28', '300.00', '29771'),
('00039','52345678','Card', '2023-05-20', '300.00','29771' ),
('00040','53456789','Card', '2023-05-02', '1000.00', '29771'),
('00041','54678901' ,'Card', '2023-05-14', '300.00', '29771'),
('00042','55789012' ,'Card', '2023-05-15', '500.00', '29771'),
('00043','57890123' ,'Card', '2023-05-17', '300.00','29771' ),
('00044','58901234','Card', '2023-05-05', '300.00', '29771'),
('00045','59012334' ,'Card', '2023-05-05', '250.00', '12893'),
('00046','60123456' ,'Card', '2023-05-06', '300.00', '12893'),
('00047','61234567' ,'Card', '2023-05-21', '300.00', '12893'),
('00048','62345678' ,'Card', '2023-05-11', '300.00', '12893'),
('00049','63456789' ,'Debit', '2023-05-08', '75.00', '12893'),
('00050','64567890' ,'Card', '2023-05-28', '300.00', '12893');

INSERT INTO FEEDBACK (Feedback_ID, Feed_Comment, Guest_ID ) VALUES
('111', 'The hotel was ok but it could be better. I wish there were more employees.','57890123' ),
('112', 'I loved my stay at the hotel. All of the services were so nice and all of the employees were very courteous. Will definitely come again', '54678901' ),
('113', 'The hotel needs more towels. Other than that I enjoyed my stay here at the hotel, and my masseuse did a good job with their service ','37890123');


INSERT INTO ROOM (Daily_price, Room_no, Start_Date, End_date, Guest_ID) VALUES
('163.51', 369, '2023-04-18', '2023-05-20', '12345678'),
('326.14', 206, '2023-04-17', '2023-05-01', '23456789'),
('106.96', 492, '2023-04-28', '2023-05-09', '13456789'),
('342.85', 271, '2023-04-27', '2023-05-21', '14567890'),
('329.35', 484, '2023-04-17', '2023-05-14', '10234566'),
('115.65', 348, '2023-04-01', '2023-05-02', '34567890'),
 ('241.45', 195, '2023-04-22', '2023-05-18', '45678901'),
 ('151.34', 372, '2023-04-13', '2023-05-30', '56789012'),
 ('108.09', 488, '2023-04-03', '2023-05-03', '67890123'),
 ('286.83', 345, '2023-04-18', '2023-05-07', '78901234'),
 ('341.96', 315, '2023-04-08', '2023-05-02', '89012345'),
 ('256.36', 470, '2023-04-19', '2023-05-08', '90123456'),
 ('147.08', 308, '2023-04-27', '2023-05-27', '15678901'),
 ('166.67', 486, '2023-04-14', '2023-05-10', '87654321'),
 ('151.49', 246, '2023-04-01', '2023-05-13', '17890123'),
 ('219.31', 476, '2023-04-07', '2023-05-03', '25678901'),
 ('263.56', 118, '2023-04-10', '2023-05-29', '19012345'),
 ('290.79', 323, '2023-04-22', '2023-05-05', '38459281'),
 ('292.62', 265, '2023-04-08', '2023-05-29', '25678902'),
 ('149.18', 183, '2023-04-18', '2023-05-22', '28901234'),
 ('108.38', 207, '2023-04-20', '2023-05-13', '29012345'),
 ('223.96', 396, '2023-04-29', '2023-05-21', '31234567'),
 ('266.07', 219, '2023-04-14', '2023-05-30', '32345678'),
 ('146.27', 381, '2023-04-06', '2023-05-20', '33456789'),
 ('180.74', 277, '2023-04-29', '2023-05-13', '35678901'),
 ('102.63', 110, '2023-04-29', '2023-05-15', '36789012'),
 ('119.15', 314, '2023-04-20', '2023-05-08', '37890123'),
 ('145.62', 287, '2023-04-10', '2023-05-01', '38901234'),
 ('198.69', 442, '2023-04-10', '2023-05-15', '39012345'),
 ('115.99', 306, '2023-04-25', '2023-05-29', '41234567'),
 ('337.56', 373, '2023-04-10', '2023-05-07', '42345678'),
 ('150.23', 461, '2023-04-10', '2023-05-24', '43456789'),
 ('288.81', 147, '2023-04-03', '2023-05-04', '44567890'),
 ('243.89', 151, '2023-04-21', '2023-05-22', '46789012'),
 ('173.10', 295, '2023-04-28', '2023-05-10', '47890123'),
 ('229.31', 210, '2023-04-24', '2023-05-19', '48901234'),
 ('344.69', 212, '2023-04-18', '2023-05-11', '49012345'),
 ('267.95', 186, '2023-04-29', '2023-05-28', '51234567'),
 ('174.09', 218, '2023-04-27', '2023-05-20', '52345678'),
 ('347.79', 197, '2023-04-07', '2023-05-02', '53456789'),
 ('186.00', 103, '2023-04-27', '2023-05-14', '54678901'),
 ('238.48', 262, '2023-04-29', '2023-05-15', '55789012'),
 ('195.54', 282, '2023-04-03', '2023-05-17', '57890123'),
 ('285.09', 258, '2023-04-02', '2023-05-05', '58901234'),
 ('140.82', 411, '2023-04-08', '2023-05-05', '59012334'),
 ('297.14', 352, '2023-04-27', '2023-05-06', '60123456'),
 ('346.75', 253, '2023-04-28', '2023-05-21', '61234567'),
 ('261.18', 344, '2023-04-29', '2023-05-11', '62345678'),
 ('344.02', 417, '2023-04-27', '2023-05-08', '63456789'),
 ('244.92', 161, '2023-04-19', '2023-05-28', '64567890');




INSERT INTO CAR ( Guest_ID, Employee_ID, Model, Parking_ID, Color, License_Plate) value
('38901234', '82319' , 'Honda Odessy', '1', 'Black','YBG5626'),
('39012345', '82319' , 'Honda Civic', '2', 'Red', 'QYB9239'),
('41234567', '82319' , 'Honda Odessy', '3', 'Black', 'DUB495'),
('42345678', '82319' , 'Lamborghini', '4', 'Blue', 'WEJ2938'),
('43456789', '82319' , 'Bugatti', '5', 'Blue', 'WUE5489'),
('44567890', '82319' , 'Toyota Corolla', '6', 'Black', 'TIN9458'),
('46789012', '82319' , 'Honda Odessy', '7', 'Blue', 'DIE0584'),
('46789012', '82319' , 'Acura 2023', '8', 'Blue', 'IHN2345'),
('47890123', '82319' , 'Honda Odessy', '9', 'Red', 'EHB5894'),
('47890123', '49559' , 'Honda Civic', '10', 'Red', 'BNM6789'),
('48901234', '49559' , 'Honda Odessy', '11', 'Green', 'AYW3847'),
('48901234', '49559' , 'lamborghini', '12', 'Blue', 'QUG5643'),
('49012345', '49559' , 'Honda Odessy', '13', 'Green', 'OUN9086'),
('51234567', '49559' , 'Honda Odessy', '14', 'Grey', 'CTB2735'),
('51234567', '49559' , 'Audi A5', '15', 'Blue', 'MOP8630'),
('52345678', '49559' , 'Honda Odessy', '16', 'Blue', 'QBZ4372'),
('52345678', '49559' , 'Toyota Corolla', '17', 'Green', 'PIL3636'),
('53456789', '26799' , 'Honda Odessy', '18', 'Red', 'ZBU7230'),
('53456789', '26799' , 'Chevrolet', '19', 'Red', 'INU2716'),
('54678901', '26799', 'Honda Odessy', '20', 'Black', 'WWZ2674'),
('54678901', '26799', 'Chevrolet', '21', 'Blue', 'IJN9236'),
('58901234', '26799', 'Honda Odessy', '22', 'Blue', 'YGB7236'),
('58901234', '26799', 'Toyota Corolla', '23', 'Black', 'EBY9081'),
('59012334', '26799', 'Toyota Tacoma', '24', 'Red', 'SUN2732'),
('59012334', '26799', 'Honda Odessy', '25', 'Red', 'PIJ8633'),
('60123456', '45678', 'BMW Series 2', '26', 'Grey', 'ZYR4374'),
('61234567', '54321', 'Honda Odessy', '27', 'Blue', 'MYV3635'),
('61234567', '98765', 'Ford Maveric', '28', 'Black', 'MVY5626'),
('62345678', '49559', 'BMW 2018', '29', 'Green', 'UYT2717'),
('62345678','49559', 'Bugatti', '30', 'Red', 'POI2678');

INSERT INTO EVENT (Event_Name, Event_ID, Event_date, Event_time, Event_loc, Dno) VALUES
('Hotel Party', '11', '2023-03-28', '09:40:28', 'Apple Blvrd', '1'),
('Easter egg hunt', '22', '2023-03-30', '07:25:28', 'Bird Lane', '2');






INSERT INTO INVENTORY (Item_id, Quantity, Price, Guest_ID) VALUES
#Item_id        VARCHAR(12) NOT NULL,
#Quantity        VARCHAR(20) NOT NULL,
#Price    ENUM("text", "Cash", "Credit", "Debit"),
#Guest_ID        VARCHAR(20) NOT NULL,
('1', '1', "text", '12345678'),
('2', '1', "CASH", '23456789'),
('3', '2', "Credit", '13456789'),
('4', '7', "Credit", '14567890'),
('5', '5', "Credit", '10234566'),
('6', '1', "Credit", '34567890'),
('7', '2', "CASH", '45678901'),
('8', '9', "CASH", '56789012'),
('9', '7', "Debit", '67890123'),
('10', '8', "Debit", '78901234'),
('11', '5', "CASH", '64567890'),
('12', '3', "Credit", '64567890'),
('13', '6', "Credit", '63456789'),
('14', '5', "CASH", '63456789'),
('15', '7', "text", '62345678'),
('16', '3', "CASH", '61234567'),
('17', '9', "Debit", '60123456'),
('18', '10', "Debit", '59012334'),
('19', '2', "Debit", '59012334'),
('20', '3', "Credit", '58901234'),
('21', '6', "Debit", '58901234'),
('22', '3', "Credit", '57890123'),
('23', '1', "Credit", '55789012'),
('24', '1', "Cash", '54678901'),
('25', '1', "Credit", '53456789'),
('26', '4', "Cash", '52345678'),
('27', '5', "Credit", '51234567'),
('28', '3', "Credit", '49012345'),
('29', '2', "Text", '48901234'),
('30', '4', "Credit", '47890123'),
('31', '3', "Credit", '46789012'),
('32', '5', "Cash", '44567890'),
('33', '2', "Credit", '43456789'),
('34', '1', "Debit", '43456789'),
('35', '2', "Debit", '42345678'),
('36', '2', "Debit", '41234567'),
('37', '2', "Debit", '39012345'),
('38', '1', "Credit", '38901234'),
('39', '1', "Cash", '37890123'),
('40', '15', "Cash", '36789012'),
('41', '4', "Cash", '35678901'),
('42', '8', "Credit", '35678901'),
('43', '7', "Text", '33456789'),
('44', '9', "Credit", '32345678'),
('45', '5', "Credit", '31234567'),
('46', '1', "Credit", '31234567'),
('47', '1', "Credit", '29012345'),
('48', '2', "Text", '29012345'),
('49', '1', "Credit", '28901234'),
('50', '1', "Cash", '28901234'),
('51', '2', "Cash", '25678901'),
('52', '2', "Cash", '25678901'),
('53', '2', "Credit", '38459281'),
('54', '3', "Debit", '19012345'),
('55', '3', "Cash", '25678901'),
('56', '1', "Debit", '17890123'),
('57', '5', "Debit", '87654321'),
('58', '7', "Debit", '15678901'),
('59', '4', "Credit", '90123456'),
('60', '1', "Cash", '89012345');

