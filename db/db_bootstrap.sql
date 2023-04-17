-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database traintrack_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- This is a security risk, but it's a development environment.
grant all privileges on traintrack_db.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
use traintrack_db;

-- Put your DDL 
CREATE TABLE commuters
(
	email  	VARCHAR(50) PRIMARY KEY,
	password   VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name  VARCHAR(50) NOT NULL
);


CREATE TABLE transit_cards
(
	id        	INT PRIMARY KEY AUTO_INCREMENT,
	balance   	DECIMAL 	NOT NULL,
	email     	VARCHAR(50) NOT NULL,
	purchase_date DATETIME NOT NULL default CURRENT_TIMESTAMP,
	CONSTRAINT
    	transit_cards_fk1 FOREIGN KEY (email)
    	REFERENCES commuters (email)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT
);


CREATE TABLE routes
(
	id        	INT PRIMARY KEY,
	name      	VARCHAR(50),
	time_period   INT
);


CREATE TABLE locations
(
	name            	VARCHAR(50) PRIMARY KEY,
	latitude        	DOUBLE NOT NULL,
	longitude       	DOUBLE NOT NULL,
	handicap_accessible BOOL
);


CREATE TABLE stops
(
	id        	INT PRIMARY KEY AUTO_INCREMENT,
	sequence_num  INT UNIQUE,
	time_to_next  INT,
	location_name VARCHAR(50) NOT NULL,
	route_id  	INT     	NOT NULL,
	open      	BOOL default 0 NOT NULL,
	CONSTRAINT
    	stops_fk1 FOREIGN KEY (location_name)
    	REFERENCES locations (name)
    	ON UPDATE CASCADE
    	ON DELETE CASCADE,
	CONSTRAINT
    	stops_fk2 FOREIGN KEY (route_id)
    	REFERENCES routes (id)
    	ON UPDATE CASCADE
    	ON DELETE CASCADE
);


CREATE TABLE favorites
(
	com_email VARCHAR(50),
	stop_id   INT,
	nickname  VARCHAR(50),
	CONSTRAINT
    	favorites_fk1 FOREIGN KEY (com_email)
    	REFERENCES commuters (email)
    	ON UPDATE CASCADE
    	ON DELETE CASCADE,
	CONSTRAINT
    	favorites_fk2 FOREIGN KEY (stop_id)
    	REFERENCES stops (id)
    	ON UPDATE CASCADE
    	ON DELETE CASCADE,
	PRIMARY KEY (com_email, stop_id)
);


CREATE TABLE alerts
(
	id     	INT PRIMARY KEY,
	message	VARCHAR(50) NOT NULL,
	start_date DATE,
	end_date   DATE,
	severity   VARCHAR(50),
	stop_id	INT     	NOT NULL,
	CONSTRAINT
    	alerts_fk1 FOREIGN KEY (stop_id)
    	REFERENCES stops (id)
    	ON UPDATE CASCADE
    	ON DELETE CASCADE
);


CREATE TABLE vehicles
(
	id          	INT PRIMARY KEY,
	type        	VARCHAR(50) NOT NULL,
	route_id   INT,
	commission_date DATE,
  daily_start_time TIME,
	CONSTRAINT
    	vehicles_fk1 FOREIGN KEY (route_id)
    	REFERENCES routes (id)
    	ON UPDATE CASCADE
    	ON DELETE SET NULL
);


CREATE TABLE operators
(
	id         	INT PRIMARY KEY,
	vehicle_id 	INT,
	phone_num  	VARCHAR(25),
	email      	VARCHAR(50) UNIQUE,
	address_line_1 VARCHAR(50),
	address_line_2 VARCHAR(50),
	city       	VARCHAR(50),
	state      	VARCHAR(25),
	zip_code   	VARCHAR(25),
	ssn        	VARCHAR(25) UNIQUE,
	birth_date 	DATE,
	shift_start	TIME,
	shift_end  	TIME,
	CONSTRAINT
    	operators_fk1 FOREIGN KEY (vehicle_id)
    	REFERENCES vehicles (id)
    	ON UPDATE CASCADE
    	ON DELETE SET NULL
);


CREATE TABLE reports
(
	id         	INT PRIMARY KEY AUTO_INCREMENT,
	message    	VARCHAR(200) NOT NULL default 'No message',
	timestamp  	DATETIME   	NOT NULL default CURRENT_TIMESTAMP,
	commuter_email VARCHAR(50) default NULL,
	operator_id	INT default NULL,
	CONSTRAINT
    	reports_fk1 FOREIGN KEY (commuter_email)
    	REFERENCES commuters (email)
    	ON UPDATE CASCADE
    	ON DELETE SET NULL,
	CONSTRAINT
    	reports_fk2 FOREIGN KEY (operator_id)
    	REFERENCES operators (id)
    	ON UPDATE CASCADE
    	ON DELETE SET NULL
);

-- Add sample data. 
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ktresvina0@icio.us','YvPIio4kRh','Kiersten','Tresvina');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dhickinbottom1@eventbrite.com','b5TBgZO8i','Dewain','Hickinbottom');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ewoodnutt2@twitpic.com','euys0HpOgF','Ethelin','Woodnutt');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('landrzejak3@mit.edu','HGPUdhex','Loni','Andrzejak');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dolin4@drupal.org','roF6AZ','Dianne','Olin');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jmerner5@hc360.com','30Fb5ox4U','Jason','Merner');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('fmissington6@ca.gov','hjp7XbPwP','Fenelia','Missington');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mdodsworth7@patch.com','KHAkX40j','Marcel','Dodsworth');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ldulling8@infoseek.co.jp','SzrlqB','Lilah','Dulling');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('tlaight9@ucsd.edu','SHEUUuAkc6','Terrel','Laight');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dbroadwooda@unblog.fr','eW59BS','Dickie','Broadwood');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rgrzelakb@facebook.com','5qfqbSiae0Q','Raff','Grzelak');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('cewinsc@mashable.com','Q86qOv2C1','Clemmy','Ewins');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rpaulmannd@usgs.gov','wvpOB20j','Ruprecht','Paulmann');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mcinnamonde@telegraph.co.uk','amNLUr6Xd','Marcela','Cinnamond');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mcorzorf@reverbnation.com','YhL2q2qV','Melisandra','Corzor');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('hlongeag@stanford.edu','ABp36inU','Hannis','Longea');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rbenzih@ibm.com','tag5PZU','Rriocard','Benzi');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('gflorioi@tumblr.com','r6QiJ4','Gherardo','Florio');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('pyetmanj@biglobe.ne.jp','s5fWsi','Pinchas','Yetman');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('josherrink@twitter.com','mzrMfJh1qj','Jacquenette','O''Sherrin');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('qhurlll@spotify.com','Poyxr5uAlnf','Quintina','Hurll');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ckillingbackm@home.pl','uAA0dtiP','Cordi','Killingback');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('bfinchamn@goo.gl','4biuLCPNm0T','Benedick','Fincham');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ecampagneo@wunderground.com','aAGeclbK','Ellery','Campagne');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jrussenp@gravatar.com','PRld9YwpprHA','Jackquelin','Russen');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('kcribbottq@cafepress.com','waXjKoGdan','Kristyn','Cribbott');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('avanoortr@edublogs.org','9DDpWe','Arvy','Van Oort');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('llanghorns@cbslocal.com','YUFKgXY','Lucas','Langhorn');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mbattiet@jalbum.net','yHrw8yp9z4U','Meara','Battie');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('grickerdu@so-net.ne.jp','7UxSW91EbQjb','Grady','Rickerd');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jbrandiv@geocities.jp','ljt4FZa92E','Jennie','Brandi');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('eallsuppw@chronoengine.com','o12lu20tw0Z','Erastus','Allsupp');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('pwornerx@bigcartel.com','20aHq562G','Petrina','Worner');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('cfaggy@google.co.jp','ny4wy3r','Chico','Fagg');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('slikelyz@cargocollective.com','QtVXpVnMdxL','Sean','Likely');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('drawdales10@yolasite.com','IDScnx8l','Donalt','Rawdales');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('wridsdole11@google.com','PadaYXTO','Werner','Ridsdole');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rlamp12@wisc.edu','xKGqBKsmJFDd','Rupert','Lamp');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dtimlett13@ycombinator.com','r6IUA1','Dayle','Timlett');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('scullington14@nih.gov','pryDKwyaj','Starlene','Cullington');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('kupston15@unicef.org','DZ2j0Yi','Kippy','Upston');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ogoodlip16@behance.net','4kqIhyamnJ','Orly','Goodlip');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('drau17@webs.com','YrC5OfeTdUAP','Demetra','Rau');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('sriccioppo18@webmd.com','zyyLVr','Sloane','Riccioppo');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dmirams19@nifty.com','4yikxkDuTV','Dew','Mirams');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('twherton1a@census.gov','1MrMjDT','Trixy','Wherton');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jdevita1b@cargocollective.com','oERfcnlG8','Janean','Devita');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ksimmins1c@gravatar.com','wMevCOs1E','Kelsey','Simmins');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mpatrie1d@illinois.edu','OJmSLtt','Meggi','Patrie');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('eobradden1e@flickr.com','c2Uz4m54','Eula','O''Bradden');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('eedson1f@issuu.com','dDFtbv5t60Z','Elvis','Edson');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('aswayte1g@marketwatch.com','NchsYYUyPBYi','Angelo','Swayte');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ftomblings1h@shop-pro.jp','aYDMzWE9tE4Q','Fields','Tomblings');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('vchampkins1i@dropbox.com','1leVH5UtT','Vergil','Champkins');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('tjozef1j@dot.gov','U6Ppn3k','Tami','Jozef');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('gtice1k@cpanel.net','8gOyETj','Gibbie','Tice');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rkonke1l@jiathis.com','BQsrbn7','Roberto','Konke');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('gnapoleone1m@privacy.gov.au','NoNtjFPC','Gunter','Napoleone');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('pgullan1n@blogspot.com','vJpIWEYSPH3','Perren','Gullan');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jmanneville1o@virginia.edu','qF9tNFo6z8','Janice','Manneville');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ktremelling1p@cyberchimps.com','1AgXCyc5','Katerine','Tremelling');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('zjahner1q@facebook.com','KHjRbCh','Zachariah','Jahner');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('cmayhou1r@sfgate.com','XgqkedfE','Cherilynn','Mayhou');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mbirkenshaw1s@altervista.org','pC4fR4jnkX','Mile','Birkenshaw');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('pcrooke1t@i2i.jp','q2KhRcHYZEBr','Panchito','Crooke');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('atierny1u@hostgator.com','k9ICYLhXx','Anna','Tierny');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('smcginn1v@prweb.com','x6G12ej2DG','Sharyl','McGinn');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rtroucher1w@illinois.edu','H9urPhAnXpV','Reagen','Troucher');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dbangs1x@loc.gov','0rmhC0','Dwain','Bangs');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('fcharteris1y@howstuffworks.com','Bd63T9dDaVt6','Feliks','Charteris');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('kmacanespie1z@illinois.edu','laGYEI65sW3','Kingston','MacAnespie');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mnoweak20@gnu.org','EAKSioGPWqqy','Morty','Noweak');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dwaith21@dmoz.org','cZpmHi1Lj7U','Deane','Waith');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('spentlow22@webs.com','ehb2JhPT2k','Shanan','Pentlow');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('gspinke23@java.com','nhvJYmVBA','Gwendolyn','Spinke');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('cdomanek24@1688.com','L2orI7P','Carmita','Domanek');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('twickes25@theglobeandmail.com','2CMlSPa','Tim','Wickes');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('lthoumasson26@facebook.com','DZxe5z7vj','Lyle','Thoumasson');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mhardan27@icio.us','Aqgb2qFk4zDt','Missy','Hardan');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('imcgibbon28@shop-pro.jp','hWOh8ao','Isacco','McGibbon');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('ktonner29@time.com','uYAvIvH','Kendell','Tonner');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('wworks2a@cnet.com','S3bUNcJce0Uq','Windham','Works');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('sshingler2b@bluehost.com','vW0lDWpcTVA','Stafani','Shingler');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('aspyvye2c@mit.edu','qsH8TBbTVdVx','Avril','Spyvye');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jordish2d@wisc.edu','aM3pvHx','Jolyn','Ordish');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('elightwood2e@statcounter.com','ZeavV27gU','Etienne','Lightwood');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('mmandrake2f@last.fm','yd2aSh','Monica','Mandrake');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('abofield2g@europa.eu','V88Y6xIkf','Alphonse','Bofield');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('dcaston2h@house.gov','XsMU41e','Dom','Caston');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rbohden2i@dropbox.com','1t6Xn0aGmyP','Rosette','Bohden');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('nhardman2j@quantcast.com','tj1dNtbkWJ','Noellyn','Hardman');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('imundow2k@multiply.com','F20lp7aOJHn','Irita','Mundow');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('fyesinov2l@twitter.com','SLSGxj5J9ZC','Francois','Yesinov');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rmatyasik2m@vkontakte.ru','MeukRiAFo','Regine','Matyasik');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('jateggart2n@list-manage.com','SMBrhwqp','Joelie','Ateggart');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('kminty2o@yahoo.com','zu2y5OC','Kareem','Minty');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('fbristow2p@europa.eu','QAEYShozXYeb','Fanya','Bristow');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('pworlidge2q@cmu.edu','hA9PAb','Piper','Worlidge');
INSERT INTO commuters(email,password,first_name,last_name) VALUES ('rhuygen2r@cdbaby.com','hazVar4ZIOT','Reynard','Huygen');


INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (1,44.02,'tlaight9@ucsd.edu','2023-01-20');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (2,87.96,'mcinnamonde@telegraph.co.uk','2023-01-07');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (3,83.24,'kupston15@unicef.org','2022-11-26');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (4,78.89,'ckillingbackm@home.pl','2022-06-07');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (5,40.94,'jordish2d@wisc.edu','2022-08-23');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (6,81.6,'dcaston2h@house.gov','2023-01-30');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (7,30.49,'mcinnamonde@telegraph.co.uk','2023-01-16');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (8,50.31,'wridsdole11@google.com','2022-10-03');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (9,61.13,'twherton1a@census.gov','2022-12-14');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (10,15.03,'dtimlett13@ycombinator.com','2022-10-13');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (11,65.44,'sshingler2b@bluehost.com','2022-06-21');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (12,66.44,'tlaight9@ucsd.edu','2022-04-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (13,86.15,'ldulling8@infoseek.co.jp','2023-01-06');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (14,53.01,'dmirams19@nifty.com','2022-10-19');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (15,70.06,'llanghorns@cbslocal.com','2023-03-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (16,0.68,'cfaggy@google.co.jp','2023-04-10');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (17,69.1,'rmatyasik2m@vkontakte.ru','2023-04-10');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (18,34.87,'rbenzih@ibm.com','2022-07-01');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (19,57.47,'fyesinov2l@twitter.com','2022-07-02');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (20,59.55,'fbristow2p@europa.eu','2022-10-11');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (21,16.98,'atierny1u@hostgator.com','2022-10-30');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (22,53.32,'nhardman2j@quantcast.com','2022-07-31');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (23,88.49,'cewinsc@mashable.com','2022-07-17');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (24,8.4,'ktonner29@time.com','2022-07-27');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (25,32.24,'mdodsworth7@patch.com','2022-12-17');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (26,54.97,'kmacanespie1z@illinois.edu','2022-07-02');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (27,30.65,'ewoodnutt2@twitpic.com','2022-12-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (28,69.8,'dbroadwooda@unblog.fr','2023-01-15');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (29,59.8,'fcharteris1y@howstuffworks.com','2022-06-24');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (30,95.83,'ogoodlip16@behance.net','2023-01-14');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (31,64.15,'rbenzih@ibm.com','2022-12-29');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (32,63.97,'imundow2k@multiply.com','2023-03-19');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (33,47.13,'zjahner1q@facebook.com','2022-09-21');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (34,0.18,'drawdales10@yolasite.com','2022-05-08');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (35,65.54,'dbangs1x@loc.gov','2022-12-24');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (36,45.44,'mhardan27@icio.us','2022-06-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (37,83.5,'sshingler2b@bluehost.com','2022-06-25');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (38,34.89,'ftomblings1h@shop-pro.jp','2022-06-03');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (39,53.65,'jmanneville1o@virginia.edu','2022-04-30');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (40,97.48,'ksimmins1c@gravatar.com','2022-12-23');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (41,63.15,'grickerdu@so-net.ne.jp','2023-02-05');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (42,32.8,'dolin4@drupal.org','2022-09-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (43,35.74,'kupston15@unicef.org','2022-08-12');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (44,23.53,'fbristow2p@europa.eu','2022-12-11');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (45,33.37,'gnapoleone1m@privacy.gov.au','2022-11-03');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (46,32.6,'avanoortr@edublogs.org','2022-04-23');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (47,16.5,'grickerdu@so-net.ne.jp','2022-11-01');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (48,45.2,'dwaith21@dmoz.org','2022-09-30');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (49,96.35,'jmanneville1o@virginia.edu','2022-11-03');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (50,26.72,'jordish2d@wisc.edu','2023-04-04');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (51,26.22,'gnapoleone1m@privacy.gov.au','2022-07-20');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (52,44.94,'dtimlett13@ycombinator.com','2022-12-28');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (53,11.05,'jrussenp@gravatar.com','2022-06-30');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (54,95.85,'lthoumasson26@facebook.com','2023-02-06');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (55,91.54,'ktresvina0@icio.us','2022-12-07');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (56,70.06,'ogoodlip16@behance.net','2022-12-11');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (57,71.58,'twickes25@theglobeandmail.com','2022-06-27');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (58,89.06,'gnapoleone1m@privacy.gov.au','2022-08-01');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (59,87.08,'spentlow22@webs.com','2022-06-16');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (60,74.72,'rtroucher1w@illinois.edu','2023-01-07');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (61,19.54,'rtroucher1w@illinois.edu','2022-10-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (62,4.48,'ecampagneo@wunderground.com','2022-12-28');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (63,0.34,'drawdales10@yolasite.com','2022-10-27');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (64,57.0,'kminty2o@yahoo.com','2022-09-25');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (65,34.94,'slikelyz@cargocollective.com','2022-12-20');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (66,50.46,'rhuygen2r@cdbaby.com','2023-04-08');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (67,69.98,'dtimlett13@ycombinator.com','2022-07-05');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (68,56.79,'gflorioi@tumblr.com','2022-07-31');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (69,86.11,'fyesinov2l@twitter.com','2022-07-18');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (70,16.06,'mbirkenshaw1s@altervista.org','2022-10-23');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (71,40.04,'aswayte1g@marketwatch.com','2022-06-27');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (72,43.75,'spentlow22@webs.com','2022-06-04');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (73,53.43,'rpaulmannd@usgs.gov','2022-05-15');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (74,41.48,'ewoodnutt2@twitpic.com','2023-01-22');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (75,84.44,'tjozef1j@dot.gov','2022-09-25');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (76,19.77,'jateggart2n@list-manage.com','2022-04-19');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (77,43.94,'imcgibbon28@shop-pro.jp','2023-04-12');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (78,55.84,'smcginn1v@prweb.com','2023-03-07');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (79,59.29,'pcrooke1t@i2i.jp','2022-10-29');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (80,46.11,'ewoodnutt2@twitpic.com','2022-05-29');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (81,74.45,'fbristow2p@europa.eu','2022-05-31');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (82,80.39,'jateggart2n@list-manage.com','2022-10-13');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (83,58.22,'vchampkins1i@dropbox.com','2022-05-31');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (84,76.1,'pyetmanj@biglobe.ne.jp','2022-11-30');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (85,95.59,'pworlidge2q@cmu.edu','2022-06-21');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (86,53.37,'nhardman2j@quantcast.com','2023-04-04');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (87,52.65,'dbangs1x@loc.gov','2023-02-20');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (88,35.36,'lthoumasson26@facebook.com','2022-05-14');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (89,4.03,'fmissington6@ca.gov','2022-07-27');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (90,22.07,'rlamp12@wisc.edu','2022-07-10');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (91,61.98,'atierny1u@hostgator.com','2022-05-28');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (92,19.57,'dmirams19@nifty.com','2022-04-16');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (93,29.07,'drawdales10@yolasite.com','2023-02-10');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (94,44.55,'cfaggy@google.co.jp','2023-02-21');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (95,17.61,'aspyvye2c@mit.edu','2022-05-19');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (96,87.1,'mbattiet@jalbum.net','2022-04-18');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (97,80.74,'tlaight9@ucsd.edu','2023-01-28');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (98,62.37,'aswayte1g@marketwatch.com','2023-01-13');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (99,39.66,'josherrink@twitter.com','2023-03-19');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (100,16.94,'pwornerx@bigcartel.com','2022-11-23');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (101,36.29,'sriccioppo18@webmd.com','2023-01-14');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (102,98.24,'ktremelling1p@cyberchimps.com','2022-07-29');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (103,89.5,'ktonner29@time.com','2022-12-01');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (104,27.84,'kupston15@unicef.org','2023-02-28');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (105,17.97,'gflorioi@tumblr.com','2022-06-25');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (106,54.07,'dolin4@drupal.org','2022-04-29');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (107,78.82,'jordish2d@wisc.edu','2022-08-24');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (108,10.7,'mbirkenshaw1s@altervista.org','2022-07-10');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (109,42.47,'dtimlett13@ycombinator.com','2023-03-08');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (110,9.95,'dmirams19@nifty.com','2022-10-10');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (111,3.65,'jordish2d@wisc.edu','2023-01-21');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (112,41.49,'landrzejak3@mit.edu','2022-12-02');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (113,1.48,'sriccioppo18@webmd.com','2023-01-17');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (114,62.77,'pyetmanj@biglobe.ne.jp','2022-04-24');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (115,22.96,'nhardman2j@quantcast.com','2022-11-17');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (116,34.51,'mbattiet@jalbum.net','2023-03-20');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (117,51.86,'tjozef1j@dot.gov','2022-10-18');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (118,67.14,'sshingler2b@bluehost.com','2022-10-01');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (119,89.56,'josherrink@twitter.com','2022-07-27');
INSERT INTO transit_cards(id,balance,email,purchase_date) VALUES (120,86.02,'drau17@webs.com','2022-06-02');


INSERT INTO routes(id,name,time_period) VALUES (1,'Puce',48);
INSERT INTO routes(id,name,time_period) VALUES (2,'Crimson',25);
INSERT INTO routes(id,name,time_period) VALUES (3,'Khaki',52);
INSERT INTO routes(id,name,time_period) VALUES (4,'Yellow',53);
INSERT INTO routes(id,name,time_period) VALUES (5,'Teal',22);
INSERT INTO routes(id,name,time_period) VALUES (6,'Aquamarine',35);
INSERT INTO routes(id,name,time_period) VALUES (7,'Orange',39);
INSERT INTO routes(id,name,time_period) VALUES (8,'Red',96);

INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Moshi Airport',44.2441908,15.2513162,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Wasua Airport',24.4752847,101.3431058,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('London City Airport',44.724837,17.3220709,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Mirny Airport',37.738098,127.0336819,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Greenbrier Valley Airport',14.6055216,121.1174129,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Pierre Van Ryneveld Airport',14.5257818,20.9238397,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Decorah Municipal Airport',28.391349,115.299029,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Horta Airport',-12.1538726,-76.9717368,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Malmö Sturup Airport',61.2559503,73.3845471,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Moises R. Espinosa Airport',-23.2140719,-46.8238911,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Griffiss International Airport',-2.9765098,33.5140043,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Decatur HI-Way Airfield',9.7907348,-13.5147735,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Phu Quoc International Airport',-7.4289773,109.1434108,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Nowata Airport',54.36667,24.33333,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Breiðdalsvík Airport',-8.3027766,113.5222556,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Dulkaninna Airport',24.8735859,-99.5758769,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Melchor de Mencos Airport',-8.1807254,113.6055854,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Tenerife Norte Airport',8.6093813,-70.1024147,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Curuzu Cuatia Airport',37.4056028,139.7874841,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Asahikawa Airport',46.7523145,33.2473218,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Stephenville Airport',21.850061,111.197459,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Allegheny County Airport',-7.740099,-40.2884386,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Fukue Airport',52.959496,21.0954627,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Okha Airport',3.5951956,98.6722227,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Nakhchivan Airport',43.8507498,131.8648449,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Spencer Municipal Airport',37.7621762,-25.5651478,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Luzamba Airport',7.2188798,2.3394209,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Boca Raton Airport',49.7549498,21.8253619,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Ørsta-Volda Airport, Hovden',33.5668566,-83.477106,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Ileg Airport',9.6522451,124.3690673,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Hamadan Airport',-37.9361202,-57.5552203,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Toncontín International Airport',46.0845,-71.9782415,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Jacobina Airport',-7.40772,112.5349392,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Qasigiannguit Heliport',14.4050979,100.464947,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Kuri Airport',35.4709893,-5.4057358,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Xingtai Dalian Airport',50.8269051,5.7198625,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Cape Eleuthera Airport',41.2791209,-8.6487108,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Tezu Airport',-15.6921494,46.3336857,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Wuhai Airport',-8.3243906,122.9846079,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Gemena Airport',56.5092219,25.7635891,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Gaylord Regional Airport',50.1597084,21.955679,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Hill City Municipal Airport',66.5583101,67.7877623,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('May River Airstrip',32.654079,-5.9213829,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Sepulot Airport',10.2019084,122.911283,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Burns Lake Airport',37.510549,118.325556,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Inishmore Aerodrome',-8.2824,125.0434,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Aghajari Airport',-37.5407812,-60.7891909,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Heydar Aliyev International Airport',14.347522,120.9245309,true);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Fernando de Noronha Airport',37.7423068,-25.6594762,false);
INSERT INTO locations(name,latitude,longitude,handicap_accessible) VALUES ('Sirjan Airport',-6.7919,111.9161,false);


INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (1,10,3,'Pierre Van Ryneveld Airport',7,false);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (2,20,17,'May River Airstrip',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (3,30,10,'Cape Eleuthera Airport',5,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (4,40,12,'Malmö Sturup Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (5,50,9,'Hamadan Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (6,60,19,'Okha Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (7,70,3,'Moshi Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (8,80,7,'Wasua Airport',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (9,90,4,'Heydar Aliyev International Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (10,100,2,'Malmö Sturup Airport',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (11,110,4,'Breiðdalsvík Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (12,120,7,'Tenerife Norte Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (13,130,20,'Decorah Municipal Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (14,140,6,'Wasua Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (15,150,12,'Breiðdalsvík Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (16,160,18,'Xingtai Dalian Airport',5,false);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (17,170,15,'Inishmore Aerodrome',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (18,180,5,'Decatur HI-Way Airfield',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (19,190,4,'Tezu Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (20,200,17,'Xingtai Dalian Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (21,210,17,'Fernando de Noronha Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (22,220,6,'Fukue Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (23,230,18,'Kuri Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (24,240,14,'Cape Eleuthera Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (25,250,12,'Fukue Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (26,260,8,'Sepulot Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (27,270,10,'Curuzu Cuatia Airport',2,false);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (28,280,8,'Ørsta-Volda Airport, Hovden',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (29,290,9,'London City Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (30,300,1,'Mirny Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (31,310,13,'Hamadan Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (32,320,9,'Greenbrier Valley Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (33,330,9,'Breiðdalsvík Airport',8,false);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (34,340,19,'May River Airstrip',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (35,350,20,'Tezu Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (36,360,6,'Malmö Sturup Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (37,370,9,'Moises R. Espinosa Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (38,380,5,'Inishmore Aerodrome',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (39,390,17,'Hill City Municipal Airport',2,false);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (40,400,18,'Hamadan Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (41,410,20,'Gaylord Regional Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (42,420,1,'Malmö Sturup Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (43,430,2,'London City Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (44,440,4,'Sepulot Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (45,450,8,'Fukue Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (46,460,11,'Nakhchivan Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (47,470,19,'Burns Lake Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (48,480,9,'Hamadan Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (49,490,7,'London City Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (50,500,19,'Hill City Municipal Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (51,510,19,'Griffiss International Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (52,520,3,'Curuzu Cuatia Airport',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (53,530,3,'Decatur HI-Way Airfield',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (54,540,2,'Nakhchivan Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (55,550,3,'London City Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (56,560,16,'Phu Quoc International Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (57,570,9,'Jacobina Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (58,580,17,'Xingtai Dalian Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (59,590,4,'Okha Airport',2,false);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (60,600,6,'Mirny Airport',5,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (61,610,8,'Ørsta-Volda Airport, Hovden',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (62,620,16,'Curuzu Cuatia Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (63,630,9,'Gaylord Regional Airport',5,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (64,640,9,'Aghajari Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (65,650,11,'Decorah Municipal Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (66,660,14,'Luzamba Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (67,670,8,'Horta Airport',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (68,680,9,'Griffiss International Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (69,690,1,'Sepulot Airport',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (70,700,15,'Luzamba Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (71,710,8,'Burns Lake Airport',6,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (72,720,6,'Allegheny County Airport',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (73,730,2,'Phu Quoc International Airport',3,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (74,740,3,'Nakhchivan Airport',8,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (75,750,7,'Hill City Municipal Airport',1,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (76,760,5,'Tenerife Norte Airport',5,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (77,770,11,'Boca Raton Airport',4,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (78,780,17,'Cape Eleuthera Airport',2,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (79,790,19,'May River Airstrip',7,true);
INSERT INTO stops(id,sequence_num,time_to_next,location_name,route_id,open) VALUES (80,800,2,'Sepulot Airport',5,true);


INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('twherton1a@census.gov',3,'Hovde');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('cmayhou1r@sfgate.com',49,'Farmco');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mbirkenshaw1s@altervista.org',72,'Farwell');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mcorzorf@reverbnation.com',73,'Lukken');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rbenzih@ibm.com',11,'Menomonie');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ecampagneo@wunderground.com',26,'Bultman');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('eallsuppw@chronoengine.com',1,'Ilene');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('wworks2a@cnet.com',43,'Kingsford');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('landrzejak3@mit.edu',21,'Village');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('cfaggy@google.co.jp',60,'3rd');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('jdevita1b@cargocollective.com',29,'Prairieview');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('fmissington6@ca.gov',23,'Graceland');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('pwornerx@bigcartel.com',7,'Summerview');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('gflorioi@tumblr.com',53,'Schiller');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('pgullan1n@blogspot.com',46,'Arrowood');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('eallsuppw@chronoengine.com',13,'Independence');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mbattiet@jalbum.net',33,'Shoshone');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('cmayhou1r@sfgate.com',63,'Dunning');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mbirkenshaw1s@altervista.org',69,'Kingsford');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mmandrake2f@last.fm',56,'Eagan');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('sshingler2b@bluehost.com',8,'Westport');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mpatrie1d@illinois.edu',40,'Sachtjen');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rkonke1l@jiathis.com',65,'Lakeland');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('kmacanespie1z@illinois.edu',20,'Coleman');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('fcharteris1y@howstuffworks.com',10,'Forest');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('twickes25@theglobeandmail.com',64,'Saint Paul');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('abofield2g@europa.eu',11,'Alpine');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ckillingbackm@home.pl',37,'Marquette');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('scullington14@nih.gov',76,'Crescent Oaks');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('jmerner5@hc360.com',2,'Carpenter');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('aspyvye2c@mit.edu',29,'Bowman');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('gflorioi@tumblr.com',45,'Schiller');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('fcharteris1y@howstuffworks.com',54,'Melrose');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('spentlow22@webs.com',25,'Waubesa');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('landrzejak3@mit.edu',47,'Corry');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('fmissington6@ca.gov',42,'Lien');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('pcrooke1t@i2i.jp',55,'Northwestern');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('jdevita1b@cargocollective.com',78,'Bellgrove');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ktremelling1p@cyberchimps.com',4,'Basil');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('aswayte1g@marketwatch.com',22,'Bunting');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rbenzih@ibm.com',27,'Johnson');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('gnapoleone1m@privacy.gov.au',12,'Kings');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ewoodnutt2@twitpic.com',8,'Meadow Valley');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('scullington14@nih.gov',20,'Elmside');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rmatyasik2m@vkontakte.ru',28,'Johnson');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('twherton1a@census.gov',67,'Hanson');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('elightwood2e@statcounter.com',52,'Ilene');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('grickerdu@so-net.ne.jp',26,'Morrow');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('drau17@webs.com',65,'Meadow Valley');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('jmerner5@hc360.com',46,'Ridge Oak');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('lthoumasson26@facebook.com',8,'Merrick');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('pworlidge2q@cmu.edu',78,'Eagan');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('landrzejak3@mit.edu',16,'Lotheville');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('kmacanespie1z@illinois.edu',60,'Hudson');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('twickes25@theglobeandmail.com',43,'Maple Wood');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('dbroadwooda@unblog.fr',30,'Center');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rbohden2i@dropbox.com',37,'Nevada');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('dhickinbottom1@eventbrite.com',65,'Canary');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('wridsdole11@google.com',39,'Pennsylvania');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rbohden2i@dropbox.com',12,'Karstens');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('gflorioi@tumblr.com',56,'Corscot');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('lthoumasson26@facebook.com',33,'Lien');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ckillingbackm@home.pl',26,'Redwing');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ktremelling1p@cyberchimps.com',28,'Summer Ridge');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('elightwood2e@statcounter.com',14,'Sloan');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('zjahner1q@facebook.com',54,'Atwood');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ckillingbackm@home.pl',12,'Northwestern');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rgrzelakb@facebook.com',2,'Straubel');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('avanoortr@edublogs.org',65,'Declaration');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('dcaston2h@house.gov',15,'Elgar');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('aswayte1g@marketwatch.com',67,'Claremont');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mnoweak20@gnu.org',63,'Maple');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('scullington14@nih.gov',6,'Huxley');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ckillingbackm@home.pl',25,'Gulseth');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('cdomanek24@1688.com',12,'Kingsford');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('dwaith21@dmoz.org',32,'Kropf');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ckillingbackm@home.pl',68,'Ramsey');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('spentlow22@webs.com',79,'Bellgrove');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mcorzorf@reverbnation.com',38,'Coolidge');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('jordish2d@wisc.edu',60,'Michigan');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('dbangs1x@loc.gov',78,'Northridge');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mcorzorf@reverbnation.com',45,'Scoville');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('fmissington6@ca.gov',77,'Debs');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ktresvina0@icio.us',35,'Union');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('jdevita1b@cargocollective.com',28,'Messerschmidt');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ksimmins1c@gravatar.com',65,'Sullivan');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mhardan27@icio.us',10,'Sherman');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('qhurlll@spotify.com',54,'Darwin');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('aswayte1g@marketwatch.com',66,'Stang');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('drau17@webs.com',78,'Nelson');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('cfaggy@google.co.jp',58,'Montana');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('drawdales10@yolasite.com',35,'Hollow Ridge');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('cmayhou1r@sfgate.com',17,'Kinsman');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('mmandrake2f@last.fm',65,'Rieder');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('kcribbottq@cafepress.com',55,'Grayhawk');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('kupston15@unicef.org',15,'Petterle');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('rkonke1l@jiathis.com',79,'Comanche');
INSERT INTO favorites(com_email,stop_id,nickname) VALUES ('ktremelling1p@cyberchimps.com',77,'La Follette');


INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (1,'Stand-alone 6th generation collaboration','2022-08-25','2022-08-30',5,57);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (2,'Fundamental object-oriented support','2023-01-16','2023-01-20',2,70);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (3,'Persevering modular knowledge user','2022-09-10','2022-09-14',2,13);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (4,'Customizable background methodology','2022-09-19','2022-09-22',1,34);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (5,'Universal neutral time-frame','2022-10-21','2022-10-25',1,45);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (6,'Visionary web-enabled website','2022-10-12','2022-10-12',2,30);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (7,'Horizontal context-sensitive open system','2022-05-27','2022-06-03',4,44);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (8,'Vision-oriented disintermediate application','2022-12-25','2022-12-27',1,66);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (9,'Implemented exuding framework','2022-04-16','2022-04-17',3,8);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (10,'Face to face dynamic architecture','2022-07-27','2022-07-29',4,35);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (11,'Sharable methodical workforce','2022-10-19','2022-10-26',1,37);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (12,'Ameliorated bottom-line synergy','2022-07-21','2022-07-24',3,1);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (13,'Upgradable intermediate collaboration','2022-10-17','2022-10-24',2,5);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (14,'Enhanced secondary challenge','2022-06-27','2022-06-29',4,68);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (15,'Synergistic exuding strategy','2022-08-17','2022-08-20',1,76);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (16,'Ameliorated modular intranet','2022-09-05','2022-09-11',2,45);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (17,'Visionary zero tolerance matrices','2022-08-03','2022-08-03',5,37);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (18,'Proactive client-driven solution','2023-03-06','2023-03-09',3,37);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (19,'Persistent composite hardware','2022-06-21','2022-06-21',3,71);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (20,'Vision-oriented holistic workforce','2022-10-28','2022-10-31',1,27);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (21,'Assimilated well-modulated project','2022-11-27','2022-11-29',3,12);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (22,'Compatible grid-enabled firmware','2023-01-28','2023-01-31',5,78);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (23,'Synchronised coherent neural-net','2022-09-30','2022-10-04',2,79);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (24,'Programmable national instruction set','2023-02-01','2023-02-06',2,56);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (25,'Optional bottom-line methodology','2022-09-12','2022-09-15',5,70);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (26,'Synchronised mobile hardware','2023-04-12','2023-04-15',4,60);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (27,'Balanced didactic support','2022-06-18','2022-06-19',1,30);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (28,'Multi-layered regional contingency','2023-02-17','2023-02-24',2,63);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (29,'Re-contextualized 3rd generation website','2022-11-20','2022-11-23',1,65);
INSERT INTO alerts(id,message,start_date,end_date,severity,stop_id) VALUES (30,'Team-oriented intangible framework','2022-09-21','2022-09-21',5,64);


INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (1,'train',5,'2022-07-31','16:02');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (2,'bus',8,'2023-03-10','17:50');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (3,'ferry',2,'2022-06-01','7:58');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (4,'train',1,'2023-03-02','15:50');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (5,'ferry',3,'2022-09-09','14:59');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (6,'bus',7,'2022-05-12','7:45');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (7,'ferry',6,'2022-11-30','14:24');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (8,'bus',4,'2022-04-28','13:14');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (9,'train',7,'2022-10-09','10:04');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (10,'ferry',4,'2022-07-24','9:17');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (11,'ferry',2,'2023-03-29','13:52');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (12,'ferry',1,'2022-11-03','16:32');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (13,'bus',8,'2023-02-27','10:52');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (14,'bus',5,'2023-01-18','17:50');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (15,'ferry',6,'2022-07-26','7:36');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (16,'ferry',3,'2023-01-01','17:47');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (17,'train',1,'2022-04-27','6:02');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (18,'bus',2,'2022-12-17','14:47');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (19,'train',7,'2022-06-19','12:39');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (20,'bus',4,'2022-05-06','14:19');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (21,'ferry',5,'2022-06-27','13:12');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (22,'bus',8,'2023-01-05','12:12');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (23,'train',6,'2022-04-14','12:37');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (24,'bus',3,'2023-01-06','14:43');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (25,'ferry',4,'2022-11-17','18:00');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (26,'train',2,'2022-10-14','6:22');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (27,'ferry',5,'2022-04-16','12:32');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (28,'bus',6,'2023-02-19','9:52');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (29,'bus',8,'2022-12-28','15:40');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (30,'ferry',7,'2023-02-02','6:39');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (31,'ferry',3,'2022-11-15','16:58');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (32,'ferry',1,'2022-05-08','11:44');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (33,'ferry',2,'2022-08-15','15:53');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (34,'train',4,'2022-08-27','12:29');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (35,'bus',7,'2023-02-09','16:04');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (36,'ferry',8,'2022-11-08','8:13');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (37,'bus',5,'2023-01-11','15:56');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (38,'ferry',1,'2023-02-24','6:11');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (39,'train',6,'2022-10-27','15:04');
INSERT INTO vehicles(id,type,route_id,commission_date,daily_start_time) VALUES (40,'ferry',3,'2022-10-19','15:14');

INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (1,1,'812-320-2833','gantham0@mit.edu','1927 Service Street','Room 1813','Evansville','Indiana',66302,'559-62-0316','2023-04-09','23:56','14:39');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (2,2,'703-524-4199','jchace1@privacy.gov.au','8028 Service Trail','Apt 358','Reston','Virginia',87569,'292-72-0214','2022-07-16','22:35','13:52');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (3,3,'818-182-8652','acourtier2@1und1.de','153 Manitowish Parkway','6th Floor','Santa Monica','California',60808,'819-23-2740','2022-12-23','10:14','21:38');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (4,4,'303-856-3824','sfawdery3@nasa.gov','5178 Pine View Place','Apt 464','Denver','Colorado',64863,'440-26-7730','2022-08-19','5:33','16:14');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (5,5,'317-683-3934','jpeile4@bravesites.com','6759 Luster Center','11th Floor','Indianapolis','Indiana',99206,'533-20-6289','2022-12-27','22:52','14:03');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (6,6,'909-945-0018','srogier5@sphinn.com','097 Macpherson Parkway','1st Floor','San Bernardino','California',56217,'118-10-1883','2022-08-27','18:55','17:23');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (7,7,'202-913-0379','ssandlin6@spiegel.de','4345 Kedzie Drive','12th Floor','Washington','District of Columbia',98115,'515-26-7841','2022-06-19','14:02','9:40');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (8,8,'714-753-6307','oballefant7@liveinternet.ru','3 Dakota Parkway','Apt 1673','Santa Ana','California',32372,'272-45-4216','2022-10-29','10:09','14:13');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (9,9,'325-709-4842','isimonot8@barnesandnoble.com','68 Prairie Rose Alley','Room 240','Abilene','Texas',70913,'483-07-7759','2022-11-21','23:05','1:57');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (10,10,'520-216-0207','mkorting9@photobucket.com','577 Bay Terrace','Suite 78','Tucson','Arizona',88283,'447-98-9813','2022-05-31','19:38','0:26');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (11,11,'713-598-3012','jharteleya@time.com','973 Stone Corner Drive','Room 49','Houston','Texas',33746,'474-51-1112','2023-02-19','21:47','2:41');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (12,12,'231-277-0110','bprattb@economist.com','03971 Delaware Terrace','Room 336','Muskegon','Michigan',49795,'514-08-0178','2023-01-25','1:56','15:23');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (13,13,'205-240-1832','focuddiec@quantcast.com','96 Mesta Junction','PO Box 78758','Birmingham','Alabama',17541,'612-53-4409','2022-10-31','19:33','14:51');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (14,14,'316-713-2123','ajedrzejd@biblegateway.com','98590 Briar Crest Avenue','Room 1697','Wichita','Kansas',50057,'365-32-7912','2023-02-07','3:29','22:00');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (15,15,'757-961-6164','dbaffine@yolasite.com','8 Moland Street','4th Floor','Norfolk','Virginia',33954,'742-72-0911','2022-08-12','15:55','15:52');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (16,16,'615-525-0299','ajanaszkiewiczf@1und1.de','139 Ryan Plaza','PO Box 61163','Nashville','Tennessee',55794,'143-71-0415','2022-11-05','7:03','18:05');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (17,17,'903-160-6138','kellingfordg@ucsd.edu','6843 Di Loreto Street','Room 1450','Tyler','Texas',35552,'405-69-2673','2022-07-13','11:26','3:01');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (18,18,'323-156-9987','rroufh@dell.com','55 Spaight Lane','Apt 90','Los Angeles','California',52856,'620-47-4579','2022-05-10','7:54','15:35');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (19,19,'970-587-8427','gfurberi@illinois.edu','4403 Doe Crossing Junction','20th Floor','Fort Collins','Colorado',31054,'619-56-7920','2022-10-22','22:47','22:45');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (20,20,'714-453-2269','mrosellinij@usnews.com','469 Elgar Lane','Suite 31','Garden Grove','California',96809,'654-76-4560','2022-06-24','0:16','10:52');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (21,1,'407-750-9493','lmackimmiek@gnu.org','66984 Garrison Parkway','3rd Floor','Orlando','Florida',33655,'454-61-4139','2022-11-23','12:09','20:06');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (22,2,'317-805-9448','jkaygilll@amazon.de','3 Katie Junction','Room 1376','Indianapolis','Indiana',48701,'868-25-6570','2023-04-09','18:26','12:19');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (23,3,'917-102-4098','cgillanm@ustream.tv','9340 Waywood Hill','Suite 39','New York City','New York',53115,'223-89-1194','2023-02-02','11:19','20:42');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (24,4,'954-232-2239','kkeohanen@vk.com','1295 Dryden Terrace','Room 969','Miami','Florida',41014,'584-24-7444','2022-10-25','16:10','7:45');
INSERT INTO operators(id,vehicle_id,phone_num,email,address_line_1,address_line_2,city,state,zip_code,ssn,birth_date,shift_start,shift_end) VALUES (25,5,'817-725-7944','rplayleo@photobucket.com','05295 Parkside Point','7th Floor','Fort Worth','Texas',45702,'313-65-7898','2022-07-12','9:39','23:08');


INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (1,'vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin','2022-09-12','mbattiet@jalbum.net',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (2,'nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin','2022-05-18','gnapoleone1m@privacy.gov.au',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (3,'felis donec semper sapien a libero nam dui proin leo odio porttitor id','2023-02-07',NULL,12);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (4,'sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in','2022-06-13',NULL,2);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (5,'parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum','2023-03-18',NULL,10);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (6,'ac leo pellentesque ultrices mattis odio donec vitae nisi nam','2022-05-07','mcorzorf@reverbnation.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (7,'duis mattis egestas metus aenean fermentum donec ut mauris eget','2023-02-13',NULL,3);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (8,'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit','2022-10-26',NULL,11);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (9,'hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci','2023-02-09','dtimlett13@ycombinator.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (10,'turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed','2022-09-08','gspinke23@java.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (11,'adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum','2022-10-03',NULL,9);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (12,'vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper','2022-08-12',NULL,21);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (13,'habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante','2023-04-03','jateggart2n@list-manage.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (14,'augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere','2022-05-05',NULL,10);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (15,'eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis','2023-01-21',NULL,22);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (16,'elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus','2022-04-17',NULL,23);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (17,'id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum','2022-09-02',NULL,15);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (18,'leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam','2023-01-27','pworlidge2q@cmu.edu',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (19,'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio','2022-10-29',NULL,14);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (20,'semper sapien a libero nam dui proin leo odio porttitor id consequat in','2022-08-15',NULL,21);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (21,'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan','2022-07-17',NULL,24);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (22,'pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque','2022-11-22',NULL,10);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (23,'convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam','2022-05-04',NULL,15);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (24,'convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget','2022-04-29','ecampagneo@wunderground.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (25,'eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam','2022-07-16','jordish2d@wisc.edu',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (26,'nunc proin at turpis a pede posuere nonummy integer non velit donec diam','2023-03-17','bfinchamn@goo.gl',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (27,'sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum','2022-09-23','gspinke23@java.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (28,'consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam','2023-01-29',NULL,12);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (29,'sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque','2023-01-06','avanoortr@edublogs.org',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (30,'sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus','2022-06-22',NULL,4);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (31,'dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum','2022-10-16','atierny1u@hostgator.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (32,'proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut','2022-12-30','ewoodnutt2@twitpic.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (33,'consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id','2022-12-30',NULL,17);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (34,'dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida','2022-12-29','ktremelling1p@cyberchimps.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (35,'luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci','2023-03-22',NULL,6);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (36,'ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet','2022-12-21',NULL,12);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (37,'in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus','2022-05-25',NULL,3);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (38,'nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec','2023-02-16','twickes25@theglobeandmail.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (39,'orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin','2023-01-05','ogoodlip16@behance.net',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (40,'felis fusce posuere felis sed lacus morbi sem mauris laoreet ut','2022-09-13','rgrzelakb@facebook.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (41,'mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec','2023-01-23',NULL,25);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (42,'pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus','2023-02-01',NULL,23);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (43,'lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat','2022-08-19','atierny1u@hostgator.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (44,'ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi','2022-08-26',NULL,14);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (45,'quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis','2022-09-20','jordish2d@wisc.edu',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (46,'dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet','2022-10-26','gspinke23@java.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (47,'lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin','2022-08-11',NULL,16);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (48,'platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis','2022-06-07','ldulling8@infoseek.co.jp',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (49,'sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget','2023-03-12','cewinsc@mashable.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (50,'cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue','2022-11-03','fyesinov2l@twitter.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (51,'in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum','2022-09-09','aspyvye2c@mit.edu',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (52,'elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit','2022-08-31',NULL,19);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (53,'quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia','2022-08-24','mhardan27@icio.us',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (54,'consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac','2022-07-03','cewinsc@mashable.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (55,'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio','2022-06-21',NULL,6);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (56,'in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse','2023-03-07','tjozef1j@dot.gov',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (57,'nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo','2022-11-27',NULL,16);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (58,'eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit','2023-02-25','mcorzorf@reverbnation.com',NULL);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (59,'orci luctus et ultrices posuere cubilia curae donec pharetra magna','2022-05-17',NULL,5);
INSERT INTO reports(id,message,timestamp,commuter_email,operator_id) VALUES (60,'dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat','2023-02-16',NULL,12);