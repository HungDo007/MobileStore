--Create Database
create database MobileStore;
go
use MobileStore;
--Create some initial tables
go
create table Products(
	ProductID int not null identity(1,1),
	Name nvarchar(50),
	Quantity int,
	Description nvarchar(max),
	Status bit,
	Price int,
	Image nvarchar(max),
);
go
create table Producers(
	ProducerID int identity(1,1) not null,
	Name nvarchar(50),
);
go
create table Categories(
	CategoryID int identity(1,1) not null,
	Name nvarchar(50),
);
go
create table ProductSpecifications(
	SpecificationID int identity(1,1) not null,
	Name nvarchar(50),
	Description nvarchar(max),
);
go
create table Customers(
	CustomerID int identity(1,1) not null,
	Name nvarchar(50),
	PhoneNumber nvarchar(20),
	Email nvarchar(50),
	Password nvarchar(30)
);
--create primary key and foreign relationships between initial tables
go
alter table Products add ProducerID int;
alter table Products add CategoryID int;
go
alter table Producers add constraint ProducersPK primary key(ProducerID);
alter table Categories add constraint CategoriesPK primary key(CategoryID);
alter table Products add constraint ProductsPK primary key(ProductID);
alter table Customers add constraint CustomerPK primary key(CustomerID);
alter table ProductSpecifications add constraint ProductSpecificationsPK primary key(SpecificationID);
go
alter table Products add constraint ProductsProdcerIDFK foreign key(ProducerID) references Producers(ProducerID);
alter table Products add constraint ProductsCategoryIDFK foreign key(CategoryID) references Categories(CategoryID);
--create weak entity tables
go
create table Comments(
	CustomerID int not null,
	ProductID int not null,
	CommentTime datetime not null,
	Content nvarchar(max),

	constraint CommentsPK primary key(CustomerID, ProductID, CommentTime),
	constraint CommentsCustomerIDFk foreign key (CustomerID) references Customers (CustomerID),
	constraint CommentsProductIDFk foreign key (ProductID) references Products (ProductID), 
);
go
create table Orders(
	CustomerID int not null,
	ProductID int not null,
	OrderTime datetime not null,
	amount int,

	constraint OrdersPK primary key (ProductID, CustomerID, OrderTime),
	constraint OrdersCustomerIDFK foreign key(CustomerID) references Customers(CustomerID),
	constraint OrdersProductIDFK foreign key(ProductID) references Products(ProductID),
);
go
create table SpecificationValues(
	SpecificationID int not null,
	Value nvarchar(50) not null,

	constraint SpecificationValuesPK primary key (SpecificationID, Value),
	constraint SpecificationValuesSpecificationIDFK foreign key(SpecificationID) references ProductSpecifications(SpecificationID),
);
--create many to many relationship tables
go
create table HasSpecification(
	ProductID int not null,
	SpecificationID int not null,
	Value nvarchar(50) not null,

	constraint HasSpecificationPK primary key(ProductID, SpecificationID, Value),
	constraint HasSpecificationProductIDFK foreign key(ProductID) references Products(ProductID),
	constraint HasSpecidicationSpecificationIDAndValueFK foreign key(SpecificationID, Value) references SpecificationValues(SpecificationID, Value),
);
go
create table Carts(
	ProductID int not null,
	CustomerID int not null,
	amount int
	
	constraint CartsPK primary key(ProductID, CustomerID),
	constraint CartsProductIDFK foreign key(ProductID) references Products(ProductID),
	constraint CartsCustomerIDFK foreign key(CustomerID) references Customers(CustomerID),
);
go
create table Rates(
	ProductID int not null,
	CustomerID int not null,
	starts int,
	constraint RatesPK primary key(ProductID, CustomerID),
	constraint RatesCustomerIDFK foreign key(CustomerID) references Customers(CustomerID),
	constraint RatesProductIDFK foreign key(ProductID) references Products(ProductID),
);
go
--add constraint
	--Product tables
	alter table Products add constraint defaultQuantity default 0 for quantity;
go
--inserting some initial values
insert into Categories(Name) values ('Tablet');
insert into Categories(Name) values ('Android');
insert into Categories(Name) values ('IOS');
insert into Categories(Name) values ('Window Phone');

insert into Producers(Name) values ('SamSung');
insert into Producers(Name) values ('Sony');
insert into Producers(Name) values ('Apple');
insert into Producers(Name) values ('Xiaomi');
insert into Producers(Name) values ('LG');
insert into Producers(Name) values ('Motorola');
insert into Producers(Name) values ('Oppo');
insert into Producers(Name) values ('Lenovo');
insert into Producers(Name) values ('Nokia');

insert into ProductSpecifications(Name, Description) values ('Ram','Ramdom access memory');
insert into ProductSpecifications(Name, Description) values ('Rom','Read-only memory');
insert into ProductSpecifications(Name, Description) values ('Number of SIMs','no decription');
insert into ProductSpecifications(Name, Description) values ('OS','Operation System');

insert into SpecificationValues(SpecificationID, Value) values (1,'4GB');
insert into SpecificationValues(SpecificationID, Value) values (1,'8GB');
insert into SpecificationValues(SpecificationID, Value) values (1,'16GB');
insert into SpecificationValues(SpecificationID, Value) values (2,'32GB');
insert into SpecificationValues(SpecificationID, Value) values (2,'128GB');
insert into SpecificationValues(SpecificationID, Value) values (3,'2 Sims');
insert into SpecificationValues(SpecificationID, Value) values (3,'1 Sims');
insert into SpecificationValues(SpecificationID, Value) values (4,'Android');
insert into SpecificationValues(SpecificationID, Value) values (4,'IOS');

insert into Products(Name,Price,Description) values ('j3 Pro',4,'ProVip');
insert into Products(Name,Price,Description) values ('j7 Pro',7,'Max Pro');
insert into Products(Name,Price,Description) values ('iphone 7',10,'IOSPro');

insert into HasSpecification(ProductID, SpecificationID, Value) values(1,1,'4GB');
insert into HasSpecification(ProductID, SpecificationID, Value) values(1,2,'32GB');
insert into HasSpecification(ProductID, SpecificationID, Value) values(1,3,'2 Sims');
insert into HasSpecification(ProductID, SpecificationID, Value) values(1,4,'IOS');

select p.Name, p1.Name as specification, h.Value as value
from Products p inner join HasSpecification h on p.ProductID = h.ProductID
				inner join ProductSpecifications p1 on h.SpecificationID = p1.SpecificationID
where p.Name='j3 pro';













