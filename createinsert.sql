USE master
GO
IF EXISTS(SELECT * FROM SYS.sysdatabases WHERE name = 'BouquetStore') 
BEGIN
	DROP DATABASE BouquetStore
END
GO
create database BouquetStore
go
use BouquetStore
go
create table Bouquet(
	BouquetID char(5) not null primary key,
	BouquetName varchar(30) not null,
	BouquetFlower varchar(30) not null,
	BouquetAccessory varchar(30) not null,
	BouquetPrice int not null	
)
go
create table Customer(
	CustomerID char(5) not null primary key,
	CustomerName varchar(30) not null,
	CustomerGender varchar (10) not null,
	CustomerPhone varchar(15) not null unique,
	CustomerEmail varchar(30) not null unique,
	CustomerAddress varchar(100) not null
)
go
create table HeaderTransaction(
	TransactionID char(5) not null primary key, 
	CustomerID char(5) not null references Customer(CustomerID) on delete cascade on update cascade,
	TransactionDate date
)
go
create table DetailTransaction(
	TransactionID char(5) not null references HeaderTransaction(TransactionID) on delete cascade on update cascade,
	BouquetID char(5) not null references Bouquet(BouquetID) on delete cascade on update cascade,
	Quantity int not null,
	primary key(TransactionID, BouquetID)
)
go
insert into Bouquet values
('BQ001','Red Kiss','Red Rose','Ruby Broach', 3500000),
('BQ002','Blue Flame','Red Rose','Blue Sapphire Broach', 3250000),
('BQ003','Snow White','White Tulip','White Diamond Broach', 5000000),
('BQ004','Pinky Fairy','Amaryllis','Pink Sapphire Broach', 4500000),
('BQ005','Bright Future','Blanket Flower','Gold Ribbon', 2500000),
('BQ006','Royal Purple','Lavender','Amethyst Broach', 3900000),
('BQ007','Morning Sunshine','Pot Marigold','Light Blue Ribbon', 2750000),
('BQ008','Sincerely Smile','Shasta Daisy','Yellow Ribbon', 1800000),
('BQ009','Wind''s Hug','Windflower','White Ribbon', 2200000),
('BQ010','Queen''s Perfume','Iris','Diamond Broach', 6000000)
go
insert into Customer values
('CU001','Sandi Balabala', 'Male', '0851234567890', 'sandibalabala@gmail.com', 'Subaru Street Num. 23'),
('CU002','Just Haku', 'Male', '087123123526', 'justhaku@gmail.com', 'Rem Street Num. 46'),
('CU003','Yose Armadillo', 'Male', '086126126526', 'yosearmadillo@gmail.com', 'Armadodo Street Num. 96'),
('CU004','Priscillia Karee', 'Female', '086726423576', 'priscilliakaree@gmail.com', 'Curry Street Num. 107'),
('CU005','Sebastian Reynald', 'Male', '081721421571', 'sebastianreynald@gmail.com', 'Fantasy Street Num. 123'),
('CU006','Angel Pretty', 'Female', '081221421272', 'angelpretty@gmail.com', 'Sky Street Num. 10'),
('CU007','Vince Vincy', 'Male', '082312568972', 'vincevincy@gmail.com', 'Cyber Street Num. 99'),
('CU008','Audy Mariposa', 'Female', '082523561971', 'audymariposa@gmail.com', 'Malificient Street Num. 77'),
('CU009','Devy Lunaria', 'Female', '082727571773', 'devylunaria@gmail.com', 'Moon Street Num. 100'),
('CU010','Caith Rachel', 'Female', '082127172371', 'caithrachel@gmail.com', 'Cat Street Num. 33')
GO
insert into HeaderTransaction values
('HT001','CU001','1 January 2019'),
('HT002','CU007','3 January 2019'),
('HT003','CU003','5 February 2019'),
('HT004','CU009','10 March 2019'),
('HT005','CU005','16 March 2019'),
('HT006','CU006','13 April 2020'),
('HT007','CU010','17 May 2020'),
('HT008','CU004','18 June 2020'),
('HT009','CU008','25 September 2020'),
('HT010','CU002','30 December 2020')
GO
insert into DetailTransaction values
('HT001','BQ001',2),
('HT001','BQ002',1),
('HT002','BQ001',1),
('HT002','BQ004',3),
('HT002','BQ005',2),
('HT003','BQ002',1),
('HT003','BQ003',1),
('HT004','BQ001',5),
('HT005','BQ001',4),
('HT005','BQ002',1),
('HT005','BQ003',3),
('HT006','BQ005',1),
('HT007','BQ003',1),
('HT007','BQ006',2),
('HT008','BQ002',3),
('HT008','BQ004',2),
('HT008','BQ006',2),
('HT009','BQ003',4),
('HT009','BQ005',3),
('HT010','BQ006',6)
go
exec sp_msforeachtable 'select * from ?'