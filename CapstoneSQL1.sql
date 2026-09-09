create database tracking_prescriptions;

CREATE TABLE pharmacy (
	pharmacy_id				VARCHAR(5),
	name					VARCHAR(50) NOT NULL,
	contact_phone_number	VARCHAR(15),
	address					TEXT,
	days_of_week			VARCHAR(50),
	hours					VARCHAR(50),
	CONSTRAINT pharmacy_pk PRIMARY KEY (pharmacy_id)
);

CREATE TABLE insurance_plan (
	member_id		VARCHAR(15),
	provider_name	VARCHAR(50) NOT NULL, --user input
	plan_name		VARCHAR(50) NOT NULL, --user input
	plan_type		VARCHAR(20) CHECK ( plan_type in ('PPO','HMO','EPO','POS','','Medicare')), --Auto-filled based on user input 
    group_number	VARCHAR(20) NOT NULL, --user input
    converage_detail TEXT, --Auto filled based on user input
	CONSTRAINT insurance_plan_pkey PRIMARY KEY (member_id)
);


CREATE TABLE accepted_insurance_plan (
	pharmacy_id			VARCHAR(5),
	member_id		 	VARCHAR(15),
	CONSTRAINT accepted_insurance_plan_pk PRIMARY KEY (pharmacy_id, member_id),
	CONSTRAINT accepted_insurance_plan_pharmacy_fk FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT accepted_insurance_plan_member_fk FOREIGN KEY (member_id) REFERENCES insurance_plan (member_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE notifications (
	notifications_id 	VARCHAR(5),
	message				VARCHAR(20)	CHECK( message in ('Received','In Progress','Completed')),
	timestamp			VARCHAR (11),
	prescription_id 	VARCHAR(36),
	CONSTRAINT notifications_pkey PRIMARY KEY (notifications_id),
	CONSTRAINT notifications_fkey FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


CREATE TABLE users(
	users_id			VARCHAR(6),
	first_name			VARCHAR(25)	NOT NULL,
	last_name			VARCHAR(30)	NOT NULL,
	date_of_birth		DATE 		CHECK (date_of_birth <= CURRENT_DATE), --ensuring no one is born in future
	member_id			VARCHAR(15),
	notification_id 	VARCHAR(5), 
	CONSTRAINT user_pk PRIMARY KEY (user_id),
	CONSTRAINT user_fk FOREIGN KEY (member_id) REFERENCES insurance_plan (member_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT user_notificaton_fk FOREIGN KEY (notifications_id) REFERENCES notifications (notifications_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

ALTER TABLE users ALTER COLUMN member_id DROP NOT NULL;


CREATE TABLE phone_number (
	user_id		 VARCHAR(6),
	phone_number VARCHAR(15),
	CONSTRAINT phone_number_pkey PRIMARY KEY (users_id, phone_number),
	CONSTRAINT phone_number_fkey (users_id) REFERENCES users (users_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE email (
	user_id 	VARCHAR(6),
	email 		VARCHAR(30) CHECK (email LIKE '%@%.%'),
	CONSTRAINT email_pkey PRIMARY KEY (users_id, email),
	CONSTRAINT email_fkey FOREIGN KEY (users_id) REFERENCES users (users_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE chosen_pharmacy (
	pharmacy_id 	VARCHAR(5),
	users_id		VARCHAR(6),
	CONSTRAINT chosen_pharmacy_pkey PRIMARY KEY (pharmacy_id, users_id),
	CONSTRAINT chosen_pharmacy_fkey FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT chosen_pharmacy_user_fkey FOREIGN KEY (users_id) REFERENCES user (users_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE prescription (
	prescription_id					VARCHAR(15),
	name							VARCHAR(30) NOT NULL,
	dosage							VARCHAR(20) NOT NULL,
	prescribing_doc_last_name		VARCHAR(30),
	date_prescribed					DATE CHECK (date_prescribed <= CURRENT_DATE),
	alternative_selected			TEXT CHECK (alternative_selected IN ('YES','NO')),			
	date_filled						DATE CHECK (date_filled <= CURRENT_DATE),
	picked_up						TEXT CHECK (picked_up IN('YES','NO')),
	medication_id					INT NOT NULL,
	user_id							VARCHAR(6),
	pharmacy_id						VARCHAR(5),
	notification_id					VARCHAR(4),
	CONSTRAINT prescription_pkey PRIMARY KEY (prescription_id),
	CONSTRAINT prescription_medication_fkey FOREIGN KEY (medication_id) REFERENCES medication (medication_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT prescription_user_fkey FOREIGN KEY (users_id) REFERENCES users (users_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT prescription_pharmacy_fkey FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	CONSTRAINT prescription_notification_fkey FOREIGN KEY (notification_id) REFERENCES notification (notification_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);	


CREATE TABLE medication (
    medication_id        VARCHAR(5),
    name                VARCHAR(50) NOT NULL,
    manufacturer        VARCHAR(50),
    used_for           TEXT,
	prescription_id		VARCHAR(15),
	CONSTRAINT medication_pkey PRIMARY KEY (medication_id),
	CONSTRAINT medication_fkey FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE covered_prescriptions (
	member_id		VARCHAR(15),
	prescription_id	VARCHAR(10),
	copay			NUMERIC(8,2) NOT NULL,
	CONSTRAINT covered_prescriptions_pkey PRIMARY KEY (member_id, prescription_id),
	CONSTRAINT covered_prescriptions_fkey FOREIGN KEY (member_id) REFERENCES insurance_plan (member_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT covered_prescriptions_id_fkey FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	);


CREATE TABLE prescription_sold_pharmacy (
	pharmacy_id			VARCHAR(5),
	prescription_id		VARCHAR(15),
	price				NUMERIC(10,2) NOT NULL,
	CONSTRAINT prescription_sold_pharmacy_pkey PRIMARY KEY (pharmacy_id, prescription_id),
	CONSTRAINT prescription_sold_pharmacy_fkey FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	CONSTRAINT prescription_sold_pharmacy_prescription_fkey FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE alternative_medication (
	alternative_id		VARCHAR(15),
	name				VARCHAR(50)	NOT NULL,
	manufacturer		VARCHAR(50)	NOT NULL,
	used_for			TEXT,
	prescription_id		VARCHAR(15),
	CONSTRAINT	alternative_medication_pkey PRIMARY KEY (alternative_id),
	CONSTRAINT alternative_medication_fkey	FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE covered_alternative (
	alternative_id		VARCHAR(15),
	member_id			VARCHAR(15),
	copay				NUMERIC (8,2) NOT NULL,
	CONSTRAINT covered_alternative_pk PRIMARY KEY (alternative_id, member_id),
	CONSTRAINT covered_alternative_fk FOREIGN KEY (alternative_id) REFERENCES alternatvie_medications (alternative_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT covered_alternative_member_fk FOREIGN KEY (member_id) REFERENCES insurance_plan (member_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE alternative_sold_pharmacy (
	alternative_id		VARCHAR(15),
	pharmacy_id			VARCHAR(5),
	price				NUMERIC (10,2) NOT NULL,
	CONSTRAINT alternative_sold_pharmacy_pkey PRIMARY KEY (alternative_id, pharmacy_id),
	CONSTRAINT alternative_sold_pharmacy_fkey FOREIGN KEY (alternative_id) REFERENCES alternative_medication (alternavite_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT alternative_sold_pharmacy_fkey1 FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

INSERT INTO pharmacy (pharmacy_id, name, contact_phone_number, address, days_of_week, hours)
Values ('0000', 'Rite Aid', '610-384-2011', '128 Airport Rd, Coatesville PA 19320', 'Mon-Sun', '8AM-10PM'), /*entered this one in early so had to re put in insert statement*/
INSERT INTO pharmacy (pharmacy_id, name, contact_phone_number, address, days_of_week, hours)
Values	('0001', 'CVS', '727-784-5771', '900 Lake Rd Palm Harbor Fl 34685', 'Mon-Sat', '8AM-9PM'),
		('0002', 'Acme Pharmacy', '303-633-0008', '600 South Ave Tallmadge OH 44278', 'Mon-Sun', '9AM-6PM'),
		('0003','Giant Pharmacy', '610-383-5461', '3477 Lincoln Highway Thorndale Pa 19372', 'Mon-Fri','10AM-7PM'),
		('0004', 'Wegmans Pharmacy', '984-960-5585','11051 Ligon Mill Rd Wake Forest NC 27587', 'Mon-Sun', '8AM-11PM'),
		('0005', 'Walgreens Pharmacy', '662-335-1429', '747 Highway 1 S Greenville MS 38701', 'Tue-Sun', '10AM-11PM'),
		('0006', 'Shoprite Pharmacy', '907-694-9786', '37 Aylesbury Ave Timonium MD 21093', 'Mon-Fri', '8AM-10PM'),
		('0007', 'Walmart Pharmacy', '931-552-3535', '2315 Madison St Clarksville TN 37043', 'Mon-Thur', '6AM-5PM'),
		('0008', 'Costco Pharmacy','504-484-5220','3900 Dubin St New Orleans LA 70118', 'Mon-Sun', '10AM-6PM')
		
INSERT INTO  accepted_insurance_plan (pharmacy_id, member_id)
VALUES ('0000', '908765554'),
		('0006', '34368011'),
		('0002', '0922345'),
		('0003', '33422768'),
		('0004', '0922345'),
		('0005', '14624M006')

INSERT INTO accepted_insurance_plan (pharmacy_id, member_id)
VALUES ('0000', '5587465')
		
INSERT INTO accepted_insurance_plan (pharmacy_id, member_id)
VALUES ('0008', '666547635'),
		('0007','99260033'),
		('0008', '605360023'),
		('0008', '4409876'),
		('0002', '5587465'),
		('0000', '887649')


INSERT INTO insurance_plan (member_id, provider_name, plan_name, plan_type, group_number, coverage_details)
Values ( '908765554','Aetna CVS Health', 'Bronze 2 HSA', 'HMO', 'KHG998', 'Deductible 500.00; Generic drugs - In network: no charge after deductible, Out of network: Benefit not covered; Preferred brand drugs - In network: No charge after deductible, Out of network: Benefit not covered; Specialilty Drugs - Benefit not covered')
INSERT INTO insurance_plan (member_id, provider_name, plan_name, plan_type, group_number, coverage_details)
VALUES ('0922345','Anthem Blue Cross Blue Sheild', 'Heart Healthy Bronze Pathway X', 'HMO', 'HGT456', 'Deductible 6000.00 individual total (health and drug combined; Generic drugs - In network: 30.00 copay, Out of network: Benefit not covered; Preferred brand drugs - In network: 80.00 copay after deductible, Out of netowrk: Benifit not covered; Specialty Drugs - In network: 40% coinsurance after deductible, Out of network: Benefit not covered')
INSERT INTO insurance_plan (member_id, provider_name, plan_name, plan_type, group_number, coverage_details)
VALUES ('33422768','United HeathCare', 'Community Plan', 'Medicaid','YNB4509', 'Deductible 0.00; Generic drugs - In network: 0.00 copay, Out of network: Benefit not covered; Preferred brand drugs: In network: Covered up to 2000.00, Out of network: Benefit not covered'),
		('666547635','Ambetter From Louisiana Healthcare Connections', 'Everyday Bronze', 'EPO', 'PUO8876', 'Deductible 8450.00; Generic drugs - In network: 3.00, Out of network: Benefit not covered; Preferred brand drugs: In network: 45% coinsurance after deductible, Out of network: Benefit not covered'),
		('115100071','Blue Cross and Blue Sheild of NC', 'Blue Value Bronze Basic', 'POS', 'RGH34902', 'Deductible 14000.00; Generic drugs - In network: 20.00, Out of network - 20.00; Preferred brand drugs - In network: 50% coinsurance after deductible, Out of Network: 50% coinsurance after deductible; Non-preferred brand drugs - In Network: 50% coinsurance after deductible, Out of Network: 50% coinsurance after deductible'),
		('99260033', 'Cigna Healthcare', 'Connect Bronze 7500', 'EPO', 'EVN32556', 'Deductible 7500.00 (health & drug combined); Generic drugs - In Network: 50% coinsurance after deductible, Out of Network: Benefit not covered; Preferred brand drugs - In Network: 50% coinsurance after deductible, Out of Network: Benefit not covered; Non-preferred brand drugs - In Network: 50% coinsurance after deductible, Out of Network: Benefit not covered'),
		('14624M006', 'Primewell Health Services of Mississippi', 'Savings Bronze 7700', 'POS', 'QSD3456', 'Deductible 15400.00 (health & drug combined); Generic drugs - In Network: No charge after deductible, Out of Network: Benefit not covered; Preferred brand drugs - In Network: No charge after deductible, Out of Network: Benefit not covered'),
		('605360023', 'Avera Health Plans', 'Avera $6000', 'PPO', 'KSR88754', 'Deductible 12000.00; Generic drugs - In Network: 30.00, Out of Network: Benefit not covered; Preferred brand drugs - In Network: 40% coinsurance after deductible, Out of Network: Benefit not covered'),
		('34368011', 'Ambetter from Sunflower Health Plan', 'Elite Bronze', 'EPO', 'YW22965', 'Deductible $3,800 (individual total); Generic drugs - In Network: $3, Out of Network: Benefit not covered; Preferred brand drugs - In Network: 195.00, Out of Network: Benefit not covered')

INSERT INTO insurance_plan (member_id, provider_name, plan_name, plan_type, group_number, coverage_details)
VALUES ('4409876', 'United HealthCare', 'Community Plan', 'Medicaid', 'UYT2254', 'Deductible 0.00; Generic Drugs - In network: 0.00, Out of network: Benefit not covered; Preferred brand drugs - In network: Benefit not covered, Out of network, benefit not covered'),
		('5587465', 'Blue Cross and Blue Sheild', 'Healthy Path Bronze', 'PPO', 'NGH4456', 'Deductible 100.00; Generic Drugs - In network: 15.00 copay, Out of network: 50.00 copay; Preferred brand drugs - In network: 50.00 copay, Out of network: 100.00 copay'),
		('887649', 'Cigna', 'Gold Plan', 'POS', 'HYT3345', 'Deductible 400.00; Generic Drugs - In network: 40.00 copay, Out of network: 1000.00 copay; Preferred brand drugs - In network: Benefit not covered, Out of network: Benefit not covered')

-- Purpose: To update the coverage details for a given insurance plan provider, reflecting a change in coverage information.
UPDATE insurance_plan
SET coverage_details = 'Updated coverage with additional prescription discounts for generic medications.'
WHERE member_id = '908765554';


INSERT INTO notifications (notifications_id , message, timestamp, prescription_id)
VALUES ('1000', 'Received', '2025-02-20', 'QQ12355')
INSERT INTO notifications (notifications_id , message, timestamp, prescription_id)
VALUES ('2000', 'Received', '2025-03-03', 'QQ56778'),
		('3000', 'Completed', '2023-11-11', 'QQ28709'),
		('4000', 'Completed', '2024-12-15', 'QQ4537'),
		('5000', 'Completed', '2025-03-25', 'QQ6621'),
		('6000', 'In Progress', '2025-01-03', 'QQ9077'),
		('7000', 'Completed', '2024-08-09', 'QQ3329'),
		('8000', 'Completed', '2024-10-09', 'QQ4028'),
		('9000', 'Completed', '2025-02-28', 'QQ9463')

INSERT INTO notifications (notifications_id , message, timestamp, prescription_id)
VALUES ('1010', 'Completed', '2024-09-05', 'QQ12998'),
		('1011', 'Completed', '2025-02-15', 'QQ50000'),
		('1012', 'Completed', '2023-05-22', 'QQ09876')
INSERT INTO notifications (notifications_id , message, timestamp, prescription_id)
VALUES ( '1013', 'Completed', '2025-01-22', 'QQ90765'),
		('1014', 'Completed', '2024-05-16', 'QQ8886'),
		('1015', 'Completed', '2025-02-21', 'QQ1122')


INSERT INTO users (users_id, first_name, last_name, date_of_birth, member_id, notifications_id )
VALUES ('U1111', 'Laura', 'Dampman', '1987-01-22', '908765554', '2000')
INSERT INTO users(users_id, first_name, last_name, date_of_birth, member_id, notifications_id)
VALUES ('U2222', 'Noah', 'Creedon', '2002-10-05', '666547635', '3000'),
		('U3333', 'Sabrina', 'Carpenter', '1980-06-13', '0922345', '4000'),
		('U4444', 'Chappel', 'Bright', '1992-11-01', '33422768', '5000'),
		('U5555', 'Christine', 'Roan', '1996-07-11', '115100071', '6000'),
		('U6666', 'Landon', 'Smith', '1984-04-25', '887649', '7000'),
		('U7777', 'Megan', 'Fox', '1986-05-16', '14624M006', '8000'),
		('U8888', 'Colson', 'Baker', '1990-04-22', '99260033', '9000'),
		('U9999', 'Pete', 'Davidson', '1993-11-16', '34368011', '1000')

INSERT INTO users (users_id, first_name, last_name, date_of_birth, member_id, notifications_id)
VALUES ('U1010', 'Brad', 'Pitt', '1978-04-22', '4409876', '1010'),
		('U1011', 'Molly', 'Shannon', '1970-03-29', '5587465', '1011'),
		('U1012', 'Kate', 'McKinnon', '1980-12-24', '887649', '1012')
INSERT INTO users (users_id, first_name, last_name, date_of_birth, member_id, notifications_id)
VALUES ('U1013', 'Jen', 'Lopez', '1977-09-13', NULL, '1013'),
		('U1014', 'Jim', 'Carey', '1965-10-10', NULL, '1014'),
		('U1015', 'Taylor', 'Swift', '1989-03-26', NULL, '1015')

-- Purpose: To delete a user from the system when they are no longer active or have been removed from the system.
DELETE FROM users
WHERE user_id = 'U1013';


INSERT INTO phone_number( users_id, phone_number)
VAlUES ('U1111', '610-765-0987'),
	    ('U2222', '435-987-3456'),
		('U3333', '786-999-2345'),
		('U4444', '567-098-4567'),
		('U5555', '234-765-3876'),
		('U6666', '876-666-9821'),
		('U9999', '254-718-1936')

INSERT INTO phone_number (users_id, phone_number)
VALUES ('U1010', '484-908-1567'),
	    ('U1011', '610-309-5549'),
		('U1012', '243-777-0387')
INSERT INTO phone_number (users_id, phone_number)
VALUES( 'U1013', '484-990-6543'),
		('U1014', '345-9987'),
		('U1015', '484-997-3345')

INSERT INTO chosen_pharmacy(pharmacy_id, users_id)
VALUES ('0004','U3333'),
		('0004', 'U5555'),
		('0005', 'U7777'),
		('0000', 'U1111'),
		('0007', 'U8888'),
		('0002', 'U4444'),
		('0000', 'U6666'),
		('0008', 'U2222')

INSERT INTO chosen_pharmacy(pharmacy_id, users_id)
VALUES ('0002', 'U1010'),
		('0000', 'U1011'),
		('0000', 'U1012')
INSERT INTO chosen_pharmacy (pharmacy_id, users_id)
VALUES('0001', 'U1013'),
		('0006', 'U1014'),
		('0003', 'U1015')
INSERT INTO chosen_pharmacy (pharmacy_id, users_id)
VALUES ('0006', 'U9999')

INSERT INTO prescription ( prescription_id, name, dosage, prescribing_doc_last_name, date_prescribed, alternative_selected, date_filled, picked_up, medication_id, users_id, pharmacy_id, notifications_id )
VALUES('QQ12355', 'Atorvastatin', '40mg, 30 tablets', 'Cooper', '2025-02-20', 'YES', NULL, 'NO', '12345', 'U1111', '0000', '1000' )
INSERT INTO prescription ( prescription_id, name, dosage, prescribing_doc_last_name, date_prescribed, alternative_selected, date_filled, picked_up, medication_id, users_id, pharmacy_id, notifications_id )
VALUES   ('QQ56778', 'Losartan', '50mg, 30 tablets', 'Gallagher', '2025-03-01', 'YES','2025-03-03', 'YES', '13345', 'U2222', '0001', '2000'),
	     ('QQ28709', 'Myalept', '10mg, 10 injections', 'Creedon', '2023-11-11', 'NO', '2023-11-11', 'YES',  '14445', 'U3333', '0002', '3000'),
		 ('QQ4537', 'Escitalopram', '10mg, 15 tablets', 'Smith', '2024-12-15', 'YES', '2024-12-15', 'NO', '15545', 'U4444', '0003', '4000'),
		 ('QQ6621', 'Amoxicillin', '500mg, 21 capsules', 'Dampman', '2025-03-20', 'YES', '2025-03-25', 'YES', '16665', 'U5555', '0004', '5000'),
		 ('QQ9077', 'Mavenclad', '10mg, 7 tablets', 'Huddell', '2025-01-03', 'NO', NULL, 'NO', '17745' , 'U6666', '0005', '6000'),
		 ('QQ3329', 'Amrix', '15mg, 60 tablets', 'Longo', '2024-08-05', 'YES', '2024-08-09', 'YES', '18823', 'U7777', '0006', '7000'),
		 ('QQ4028', 'Adasuve', '75mg, 30 tablets', 'Brawny', '2024-10-09', 'NO', '2024-10-09', 'YES', '19923', 'U8888', '0007', '8000'),
		 ('QQ9463', 'lorazepam', '1mg, 30 tablets', 'Howard', '2025-02-28', 'YES', '2025-02-28', 'YES', '10345', 'U9999', '0008', '9000')

INSERT INTO prescription (prescription_id, name, dosage, prescribing_doc_last_name, date_prescribed, alternative_selected, date_filled, picked_up, medication_id, users_id, pharmacy_id, notifications_id)
VALUES ('QQ12998', 'Trazodone', '50mg, 20 tablets', 'Buckman', '2024-09-04', 'NO', '2024-09-05', 'YES', '00044', 'U1010', '0002', '1010'),
		('QQ50000', 'Zolpidem Tartrate', '10mg, 30 tablets', 'Steffy', '2025-02-15', 'YES', '2025-02-15', 'YES', '00055', 'U1011', '0000', '1011'),
		('QQ09876', 'Alprazolam', '0.5mg, 30 tablets', 'Hill', '2023-05-19)', 'YES', '2023-05-22', 'YES', '00066', 'U1012', '0007', '1012')

INSERT INTO prescription (prescription_id, name, dosage, prescribing_doc_last_name, date_prescribed, alternative_selected, date_filled, picked_up, medication_id, users_id, pharmacy_id, notifications_id)
VALUES ('QQ90765', 'Lisinopril', '20mg, 30 tablets', 'Miller', '2025-01-22', 'NO', '2025-01-22', 'YES', '33209', 'U1013', '0001', '1013' ),
		('QQ8886', 'Metformin', '500mg, 60m tablets', 'Snider', '2024-05-15', 'NO', '2024-05-16', 'YES', '86654', 'U1014', '0006', '1014' ),
		('QQ1122', 'Fluticasone', '50mg, inhaler', 'Brooks', '2025-02-21', 'YES', '2025-02-21', 'YES', '40665', 'U1015', '0003', '1015')

-- Purpose: To update the dosage of an existing prescription for a user, ensuring that prescription data is accurate and up-to-date.
UPDATE prescription
SET dosage = '500mg, 30 capsules'
WHERE prescription_id = 'QQ50001';


INSERT INTO medication (medication_id, name, manufacturer, used_for)
VALUES ('12345', 'Atorvastatin', 'LGMPharma', 'Lowers cholesterol and triglyceride levels to prevent heart disease, angina, strokes, and heart attacks'),
		('13345', 'Losartan', 'Hetero Labs Ltd', 'Treats high blood pressure in adults and children at least 6 years old'),
		('14445', 'Myalept', 'Amylin Pharmaceuticals', 'Treats Congenital or acquired generalized lipodystrophy'),
		('15545', 'Escitalopram', 'AbbVie', 'Treats depression and generalized anxiety disorder (GAD)'),
		('16665', 'Amoxicillin', 'USAntibiotics', 'Treats bacterial infections such as tonsillitis, bronchitis, sinusitis, pneumonia, and infections of the ear, nose, throat, skin, or urinary tract'),
		('17745', 'Mavenclad', 'EMD Serono, Inc', 'Treats relapsing forms of multiple sclerosis (MS) in adults'),
		('18823','Amrix', 'ECR Pharmaceuticals', 'Treats muscle spasms in adults.'),
		('19923', 'Adasuve', 'Teva Pharmaceutical Industries Ltd', 'Treats acute agitation related to schizophrenia or bipolar disorder in adults'),
		('10345', 'lorazepam', 'Aurolife Pharma LLC', 'Treats anxiety disorders'),
		('33209', 'Lisinopril', 'Gedeon', 'Treats High blood pressure'),
		('86654', 'Metformin', 'EMD Serono Inc', 'Treats type 2 diabetes'),
		('40665', 'Fluticasone', 'GHE Pharma', 'Treats a range of conditions including inflammatory skin conditions, allergies, asthma, Nasal symptoms, allergy eye symptoms, difficulty breathing caused by asthma, nasal polyps')

INSERT INTO medication (medication_id, name, manufacturer, used_for)
VALUES ('00044', 'Trazodone', 'Watson Labs', 'Treats depression, insomnia and anxiety'),
		('00055', 'Zolpidem Tartrate', 'Teva', 'Treats and manages insomnia'),
		('00066', 'Alprazolam', 'Rising Pharmaceuticals, Inc', 'Treats anxiety disorders, panic disorders and anxiey caused by depression')

		
INSERT INTO  alternative_medication (alternative_id, name, manufacturer, used_for, prescription_id)
VALUES ('A0001', 'Lipitor', 'Pfizer', 'Lowers cholesterol and triglyceride levels to prevent heart disease, angina, strokes and heart attacks', 'QQ12355'),
		('A0002', ' Cozaar', 'Merck', 'Treats high blood pressure in adults and children at least 6 years old', 'QQ56778'),
		('A0003', 'Lexapro', 'Forest Laboratories Inc', 'Treats depression and generalized anxiety disorder (GAD)', 'QQ4537'),
		('A0004', 'Amozil', 'USAntibiotics', 'Treats bacterial infections such as tonsillitis, bronchitis, sinusitis, pneumonia, and infections of the ear, nose, throat, skin, or urinary tract', 'QQ6621'),
		('A0005', 'Cyclobenzaprine', 'Patriot Pharmaceuticals LLC', 'Treats muscle spasms in adults', 'QQ3329'),
		('A0006', 'Ativan', 'Bausch Health', 'Treats anxiety disorders','QQ9463'),
		('A0007', 'Desyrel', 'Merck', 'Treats depression, insomnia and anxiety', NULL),
		('A0008', 'Ambien', 'Cosette Pharmaceuticals, Inc', 'Treats and manages insomnia', 'QQ50000'),
		('A0009', 'Xanax', 'Pfizer Pharmaceuticals', 'Treats anxiety disorders, panic disorders and anxiey caused by depression', 'QQ09876')

INSERT INTO alternative_medication (alternative_id, name, manufacturer, used_for, prescription_id)
VALUES ('A0010', 'Flonase', 'GSK Consumer Healthcare', 'Treats a range of conditions including inflammatory skin conditions, allergies, asthma, Nasal symptoms, allergy eye symptoms, difficulty breathing caused by asthma, nasal polyps', 'QQ1122')


INSERT INTO covered_prescriptions (member_id, prescription_id, copay)
VALUES ('605360023', 'QQ4028', '50.00'),
		('4409876', 'QQ12998', '15.30')

INSERT INTO  covered_alternative (alternative_id, member_id, copay)
VALUES ('A0009', '5587465', '15.00'), 
		('A0006', '34368011', '3.00'),
		('A0005', '14624M006', '12.00'),
		('A0004', '115100071', '20.00'),
		('A0003', '33422768', '0.00')

INSERT INTO prescription_sold_pharmacy (pharmacy_id, prescription_id, price)
VALUES ('0004', 'QQ28709', '77000.00'),
		('0007', 'QQ9077', '83563.00'),
		('0006', 'QQ8886', '14.49'),
		('0001', 'QQ90765', '8.66')
		
INSERT INTO alternative_sold_pharmacy (alternative_id, pharmacy_id, price)
VALUES ('A0010', '0003', '18.99'),
		('A0002', '0008', '22.99'),
		('A0001', '0000', '21.66')
INSERT INTO alternative_sold_pharmacy (alternative_id, pharmacy_id, price)
VALUES ('A0008', '0000', '19.20')


-- Purpose: To retrieve all prescriptions associated with a specific user, which is necessary for displaying their prescription history.
SELECT prescription_id, name, dosage, date_prescribed, alternative_selected
FROM prescription
WHERE users_id = 'U1111';

-- Purpose: To retrieve the pharmacies along with the insurance plans they accept, helping users find pharmacies that work with their insurance.
SELECT ph.name AS pharmacy_name, ip.provider_name, ip.plan_name
FROM pharmacy ph
JOIN accepted_insurance_plan aip ON ph.pharmacy_id = aip.pharmacy_id
JOIN insurance_plan ip ON aip.member_id = ip.member_id;

-- Purpose: To list all medications and the prescriptions they are associated with, showing how medications are tracked.
SELECT m.name AS medication_name, p.prescription_id
FROM medication m
JOIN prescription p ON m.medication_id = p.medication_id;


/* Queries*/

--1. Purpose: To retrieve a list of all pharmacies with their contact phone number, address, and days of operation.
SELECT name, contact_phone_number, address, days_of_week
FROM pharmacy
ORDER BY name;

--2. Purpose: To count the number of users who have selected a particular pharmacy.
SELECT p.name AS pharmacy_name, COUNT(up.users_id) AS user_count
FROM chosen_pharmacy up
JOIN pharmacy p ON up.pharmacy_id = p.pharmacy_id
GROUP BY p.name;

--3. Purpose: To find the copays from both prescriptions and alternatives per user from highest to lowest.
SELECT u.first_name, u.last_name, MAX(copay) AS max_copay
FROM users u
JOIN (SELECT member_id, copay
      FROM covered_prescriptions
      UNION ALL
      SELECT member_id, copay
      FROM covered_alternative) AS combined_copays ON u.member_id = combined_copays.member_id
GROUP BY u.first_name, u.last_name
ORDER BY max_copay DESC;

--4. Purpose: To retrieve all prescriptions with their details and whether they have alternatives.
SELECT p.prescription_id, p.name, p.dosage, p.date_prescribed, p.alternative_selected
FROM prescription p;

--5. Purpose: Find out what the average cost for both covered alternatives and non covered alternatives
SELECT ROUND((SELECT AVG(copay) 
FROM covered_alternative), 2) AS avg_covered_cost,
ROUND((SELECT AVG(price) 
FROM alternative_sold_pharmacy), 2) AS avg_non_covered_cost

--6. Purpose: Find out what the average cost for both covered prescriptions and non-covered prescrptions
SELECT ROUND((SELECT AVG(copay) 
FROM covered_prescriptions), 2) AS avg_covered_cost,
ROUND((SELECT AVG(price) 
FROM prescription_sold_pharmacy), 2) AS avg_non_covered_cost

--7. Purpose: What users chose a pharmacy that does not take their insurance
SELECT u.users_id, u.first_name, u.last_name, cp.pharmacy_id, p.name AS pharmacy_name, ip.provider_name AS insurance_provider
FROM users u
JOIN chosen_pharmacy cp ON u.users_id = cp.users_id
JOIN pharmacy p ON cp.pharmacy_id = p.pharmacy_id
LEFT JOIN  accepted_insurance_plan aip ON cp.pharmacy_id = aip.pharmacy_id AND u.member_id = aip.member_id
JOIN insurance_plan ip ON u.member_id = ip.member_id
WHERE aip.pharmacy_id IS NULL;

--8. Purpose: Shows me the price of all covered prescriptions and covered alternatives at each pharmacy
SELECT p.pharmacy_id, p.name AS pharmacy_name, SUM(cp.copay) AS total_covered_cost
FROM covered_prescriptions cp
JOIN prescription pr ON cp.prescription_id = pr.prescription_id
JOIN chosen_pharmacy chp ON pr.users_id = chp.users_id
JOIN pharmacy p ON chp.pharmacy_id = p.pharmacy_id
GROUP BY p.pharmacy_id, p.name

UNION ALL

SELECT p.pharmacy_id,p.name AS pharmacy_name, SUM(ca.copay) AS total_covered_cost
FROM covered_alternative ca
JOIN alternative_medication am ON ca.alternative_id = am.alternative_id
JOIN prescription pr ON am.prescription_id = pr.prescription_id
JOIN chosen_pharmacy chp ON pr.users_id = chp.users_id
JOIN pharmacy p ON chp.pharmacy_id = p.pharmacy_id
GROUP BY p.pharmacy_id, p.name
ORDER BY total_covered_cost DESC;


--9. Purpose: To get the total cost of all non-covered prescriptions and non covered alternatives from each pharmacy
SELECT p.pharmacy_id, p.name AS pharmacy_name, SUM(psp.price) AS total_non_covered_cost
FROM prescription_sold_pharmacy psp
JOIN prescription pr ON psp.prescription_id = pr.prescription_id
JOIN pharmacy p ON psp.pharmacy_id = p.pharmacy_id
GROUP BY p.pharmacy_id, p.name

UNION ALL

SELECT p.pharmacy_id, p.name AS pharmacy_name, SUM(asp.price) AS total_non_covered_cost
FROM alternative_sold_pharmacy asp
JOIN pharmacy p ON asp.pharmacy_id = p.pharmacy_id
GROUP BY p.pharmacy_id, p.name
ORDER BY total_non_covered_cost DESC;


--10.  Purpose: To calculate the maximum copay by insurance provider, for both covered_prescriptions and covered_alternatives.
SELECT ip.provider_name, MAX(cp.max_copay) AS max_copay
FROM insurance_plan ip
JOIN (SELECT member_id, copay AS max_copay
       FROM covered_prescriptions
       UNION ALL
       SELECT member_id, copay AS max_copay
       FROM covered_alternative) cp 
	   ON ip.member_id = cp.member_id
GROUP BY ip.provider_name;

--11 Purpose: To find users who do not have an insurance plan.
SELECT u.first_name, u.last_name
FROM users u
WHERE u.member_id IS NULL;

--12. Purpose: To calculate the total number of prescriptions filled by each user.
SELECT u.first_name, u.last_name, COUNT(p.prescription_id) AS total_prescriptions
FROM users u
LEFT JOIN prescription p ON u.users_id = p.users_id
GROUP BY u.first_name, u.last_name;

--13. Purpose: Gives top 5 pharmacies that accept the most insurance plans.
SELECT ph.name AS pharmacy_name, COUNT(aip.member_id) AS insurance_count
FROM pharmacy ph
JOIN accepted_insurance_plan aip ON ph.pharmacy_id = aip.pharmacy_id
GROUP BY ph.name
ORDER BY insurance_count DESC
LIMIT 5;

-- 14. Purpose: To find the pharmacy with the highest number of prescription sales and the total sales value.
SELECT ph.name AS pharmacy_name, 
       COUNT(psp.prescription_id) AS total_sales,
       SUM(psp.price) AS total_sales_value
FROM pharmacy ph
JOIN prescription_sold_pharmacy psp ON ph.pharmacy_id = psp.pharmacy_id
JOIN prescription p ON psp.prescription_id = p.prescription_id  -- Ensure we join prescription to get the correct prices
GROUP BY ph.name
ORDER BY total_sales DESC
LIMIT 1;

--15. Purpose: To calculate the total cost of alternative medications sold at each pharmacy.
SELECT ph.name AS pharmacy_name, SUM(asp.price) AS total_alternative_sales
FROM pharmacy ph
JOIN alternative_sold_pharmacy asp ON ph.pharmacy_id = asp.pharmacy_id
GROUP BY ph.name;

--16. Purpose: To retrieve users with prescriptions filled in the last 30 days.
SELECT u.first_name, u.last_name, p.prescription_id, p.date_filled
FROM users u
JOIN prescription p ON u.users_id = p.users_id
WHERE p.date_filled > CURRENT_DATE - INTERVAL '30 days';

--17. Procedure that inserts a new row into the notifications table
CREATE OR REPLACE PROCEDURE add_notification(
    p_notification_id VARCHAR,
    p_message VARCHAR,
    p_timestamp VARCHAR,
    p_prescription_id VARCHAR )
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO notifications (
    notifications_id,
    message,
    timestamp,
    prescription_id )
  VALUES (
    p_notification_id,
    p_message,
    p_timestamp,
    p_prescription_id);
END;
$$;

CALL add_notification('1000', 'In Progress', '2025-04-01', 'QQ112223');
-- will work when I add this new prescription into my prescription table

