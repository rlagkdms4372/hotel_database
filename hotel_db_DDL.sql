-- DDL
DROP DATABASE IF EXISTS HOTEL;
CREATE DATABASE HOTEL;
USE HOTEL;

-- Create CONTACT table
DROP TABLE IF EXISTS CONTACT;
CREATE TABLE CONTACT (
    H_code        VARCHAR(30) NOT NULL,
    Address            TEXT NOT NULL,
    Hotel_phone         VARCHAR(15) NOT NULL,
    CONSTRAINT pk_hotel_code PRIMARY KEY (H_code)
);

-- Create DEPARTMENT table
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

-- Create EVENT table
DROP TABLE IF EXISTS EVENT;
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

-- Create EMPLOYEE table
DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE EMPLOYEE (
  Employee_ID        VARCHAR(9) NOT NULL,
  EF_Name       VARCHAR(15) NOT NULL,
  EL_Name        VARCHAR(15) NOT NULL,
  Hire_Date         DATE NOT NULL,
  Salary            DECIMAL(10,2) NOT NULL,
  Weekly_Work_Time  SMALLINT NOT NULL,
  Shift_In          TIME NOT NULL,
  Shift_Out         TIME NOT NULL,
  Dno        VARCHAR(20) NOT NULL,
  CONSTRAINT pk_employee PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_employee_department FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);

-- Create CONCIERGE table
DROP TABLE IF EXISTS CONCIERGE;
CREATE TABLE CONCIERGE (
  Employee_ID        VARCHAR(9) NOT NULL,
  Lang_spoken       VARCHAR(15) NOT NULL,
  Hotel_Code        VARCHAR(30) NOT NULL,
  CONSTRAINT pk_concierge PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_concierge_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_concierge_contact FOREIGN KEY (Hotel_Code) references CONTACT(H_Code)
);

-- Create HOUSEKEEPING table
DROP TABLE IF EXISTS HOUSEKEEPING;
CREATE TABLE HOUSEKEEPING (
  Employee_ID        VARCHAR(9) NOT NULL,
  Cleaning_skill       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_housekeeping PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_housekeeping_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);

-- Create MASSAGE_THERAPIST table
DROP TABLE IF EXISTS MASSAGE_THERAPIST;
CREATE TABLE MASSAGE_THERAPIST (
  Employee_ID        VARCHAR(9) NOT NULL,
  Massage_type       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_massage_therapist PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_massage_therapist_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);

-- Create VALET_DRIVER table
DROP TABLE IF EXISTS VALET_DRIVER;
CREATE TABLE VALET_DRIVER (
  Employee_ID        VARCHAR(9) NOT NULL,
  DLicense_type       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_valet_driver PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_valet_driver_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);

-- Create COOK table
DROP TABLE IF EXISTS COOK;
CREATE TABLE COOK (
  Employee_ID        VARCHAR(9) NOT NULL,
  Cuisine       VARCHAR(30) NOT NULL,
  CONSTRAINT pk_cook PRIMARY KEY(Employee_ID),
  CONSTRAINT fk_cook_employee FOREIGN KEY (Employee_ID) references EMPLOYEE(Employee_ID)
);

-- Create GUEST table
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

-- Create PAYMENT table
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

-- Create FEEDBACK table
DROP TABLE IF EXISTS FEEDBACK;
CREATE TABLE FEEDBACK (
    Feedback_ID        VARCHAR(20) NOT NULL,
    Feed_Comment    TEXT NOT NULL,
	Guest_ID        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_feedback_id PRIMARY KEY (Feedback_ID),
    CONSTRAINT fk_G_id_fd FOREIGN KEY (Guest_ID) references GUEST(Guest_ID)
);

-- Create ROOM table
DROP TABLE IF EXISTS ROOM;
CREATE TABLE ROOM (
  Room_no       SMALLINT NOT NULL,
  Daily_price   DOUBLE NOT NULL,
  CONSTRAINT pk_Room PRIMARY KEY (Room_no)
);

-- Create CAR table
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

-- Create DELIVERS table
DROP TABLE IF EXISTS DELIVERS;
CREATE TABLE DELIVERS (
  Emp_ID            VARCHAR(9) NOT NULL,
  Room_no       SMALLINT NOT NULL,
  CONSTRAINT pk_delivers PRIMARY KEY (Emp_ID,Room_no),
  CONSTRAINT fk_delivers_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_delivers_room FOREIGN KEY (Room_no) references ROOM(Room_no)
);

-- Create ORDERS table
DROP TABLE IF EXISTS ORDERS;
CREATE TABLE ORDERS (
  Emp_ID            VARCHAR(9) NOT NULL,
  G_no       VARCHAR(20) NOT NULL,
  CONSTRAINT pk_orders PRIMARY KEY (Emp_ID, G_no),
  CONSTRAINT fk_orders_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_orders_guests FOREIGN KEY (G_no) references GUEST(Guest_ID)
);

-- Create CLEANS table
DROP TABLE IF EXISTS CLEANS;
CREATE TABLE CLEANS (
  Emp_ID            VARCHAR(9) NOT NULL,
  Room_number       SMALLINT NOT NULL,
  CONSTRAINT pk_cleans PRIMARY KEY (Emp_ID, Room_number),
  CONSTRAINT fk_cleans_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_cleans_rooms FOREIGN KEY (Room_number) references ROOM(Room_no)
);

-- Create CONVEY_REQUEST table
DROP TABLE IF EXISTS CONVEY_REQUEST;
CREATE TABLE CONVEY_REQUEST (
  Emp_ID            VARCHAR(9) NOT NULL,
  Dno       VARCHAR(20) NOT NULL,
  CONSTRAINT pk_convey_request PRIMARY KEY (Emp_ID, Dno),
  CONSTRAINT fk_convey_request_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
  CONSTRAINT fk_convey_request_department FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);

-- Create REQUEST table
DROP TABLE IF EXISTS REQUEST;
CREATE TABLE REQUEST (
  G_no            VARCHAR(20) NOT NULL,
  Dno       VARCHAR(20) NOT NULL,
  CONSTRAINT pk_request PRIMARY KEY (G_no, Dno),
  CONSTRAINT fk_request_employee FOREIGN KEY (G_no) references GUEST(GUEST_ID),
  CONSTRAINT fk_request_department FOREIGN KEY (Dno) references DEPARTMENT(D_no)
);

-- Create SOCIALS table
DROP TABLE IF EXISTS SOCIALS;
CREATE TABLE SOCIALS (
Hotel_Code		VARCHAR(15)		NOT NULL,
Handle			VARCHAR(15)		NOT NULL,
Social_Media_Name	VARCHAR(15)		NOT NULL,
CONSTRAINT pk_handle PRIMARY KEY(Handle),
CONSTRAINT fk_socials_contact FOREIGN KEY (Hotel_Code) references CONTACT(H_code)
);

-- Create INTERACT table
DROP TABLE IF EXISTS INTERACTS;
CREATE TABLE INTERACTS(
	Emp_ID	VARCHAR(9) NOT NULL,
	G_no		VARCHAR(20) NOT NULL,
	CONSTRAINT pk_interacts PRIMARY KEY (Emp_ID, G_no),
	CONSTRAINT fk_interacts_employee FOREIGN KEY (Emp_ID) references EMPLOYEE(Employee_ID),
    CONSTRAINT fk_interacts_guest FOREIGN KEY(G_no) references GUEST(Guest_ID)
);

-- Create TAKE_ACTION table
DROP TABLE IF EXISTS TAKE_ACTION;
CREATE TABLE TAKE_ACTION (
	Dno	VARCHAR(20) NOT NULL,
	F_id	VARCHAR(20) NOT NULL,
	CONSTRAINT fk_take_action_department FOREIGN KEY (Dno) references DEPARTMENT(D_no),
	CONSTRAINT fk_take_action_Fid FOREIGN KEY (F_id) references FEEDBACK(Feedback_ID)
);

-- Create BOOK table
DROP TABLE IF EXISTS BOOK;
CREATE TABLE BOOK (
  Booking_ID        VARCHAR(20) NOT NULL,
  G_no              VARCHAR(20) NOT NULL,
  Room_no           SMALLINT NOT NULL,
  Plate_no          VARCHAR(10) NULL,
  Start_date        DATE NOT NULL,
  End_date          DATE NOT NULL,
  Check_in_time     DATETIME NULL,
  Check_out_time    DATETIME NULL,
  Booking_Status    ENUM('Reserved','CheckedIn','CheckedOut','Cancelled') NOT NULL DEFAULT 'Reserved',
  CONSTRAINT pk_book PRIMARY KEY (Booking_ID),
  CONSTRAINT fk_book_room FOREIGN KEY (Room_no) references ROOM(Room_no),
  CONSTRAINT fk_book_guest FOREIGN KEY (G_no) references GUEST(Guest_ID),
  CONSTRAINT fk_book_car FOREIGN KEY (Plate_no) references CAR(License_Plate)
);

-- Create INVENTORY table
DROP TABLE IF EXISTS INVENTORY;
CREATE TABLE INVENTORY (
    Purchase_ID     VARCHAR(12) NOT NULL,
    Booking_ID      VARCHAR(20) NOT NULL,
    Quantity        INT NOT NULL,
    Price           DECIMAL(8,2) NOT NULL,
    Purchase_date   DATETIME NOT NULL,
    CONSTRAINT pk_inventory PRIMARY KEY (Purchase_ID),
    CONSTRAINT fk_inventory_booking FOREIGN KEY (Booking_ID) references BOOK(Booking_ID)
);

-- Create MAKE_PAYMENT table
DROP TABLE IF EXISTS MAKE_PAYMENT;
CREATE TABLE MAKE_PAYMENT(
  I_id     VARCHAR(20) NOT NULL,
  Pay_id   VARCHAR(20) NOT NULL,
  CONSTRAINT fk_make_payment_inventory FOREIGN KEY (I_id) references INVENTORY(Purchase_ID),
  CONSTRAINT fk_make_payment_payment FOREIGN KEY (Pay_id) references PAYMENT(Payment_ID)
);

-- Create CAR_PALTE table
DROP TABLE IF EXISTS CAR_PLATE;
CREATE TABLE CAR_PLATE (
  G_no        VARCHAR(20) NOT NULL,
  Plate_no	VARCHAR(10) NOT NULL,
  CONSTRAINT pk_carplate PRIMARY KEY (Plate_no),
  CONSTRAINT fk_carplate_guest FOREIGN KEY (G_no) references GUEST(Guest_ID)
);
