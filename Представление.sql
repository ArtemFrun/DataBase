use [master];
go

if db_id('MusicCollection') is not null
begin
  ALTER DATABASE [MusicCollection] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  drop database [MusicCollection];
end
go

create database [MusicCollection];
go

use [MusicCollection];
go

create table [Discs]
(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null unique check ([Name] <> N''),
  [ArtistId] int not null,
  [StyleId] int not null,
  [PublisherId] int not null,
  [ReleaseDate] date not null,
);
go

create table [Artists]
(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Publishers]
(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null unique check ([Name] <> N''),
  [Country] nvarchar(100) not null
);
go

create table [Styles]
(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Songs]
(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null unique check ([Name] <> N''),
  [DiscId] int not null,
  [StyleId] int not null,
  [ArtistId] int not null,
  [Duration] int not null
);
go

alter table [Discs] 
add foreign key ([ArtistId]) references [Artists]([Id])
go

alter table [Discs] 
add foreign key ([StyleId]) references [Styles]([Id])
go

alter table [Discs] 
add foreign key ([PublisherId]) references [Publishers]([Id])
go

alter table [Songs] 
add foreign key ([ArtistId]) references [Artists]([Id])
go

alter table [Songs] 
add foreign key ([StyleId]) references [Styles]([Id])
go

alter table [Songs] 
add foreign key ([DiscId]) references [Discs]([Id])
go

alter table [Discs] 
add Review nvarchar(max) not null check (Review <> N'')
go

--alter table [Publishers] 
--add Adress nvarchar(255) not null check (Adress <> N'')
--go

--alter table [Songs] 
--alter column [Name] nvarchar(255)

--alter table [Publishers] 
--drop column Adress 

--alter table [Discs] 
--drop constraint  FK__Discs__ArtistId__48CFD27E

--alter table [Discs] 
--add constraint  FK__Discs__ArtistId foreign key ([ArtistId]) references [Artists]([Id])

INSERT into [Artists]([Name]) values
(N'Artist1'),
(N'The Beatles'),
(N'Artist3'),
(N'MockArtist')

insert into [Styles]([Name]) values
(N'Style1'),
(N'Style2'),
(N'Style3')

insert into [Publishers]([Name], [Country]) values
(N'Publisher1', N'USA'),
(N'Publisher2', N'France'),
(N'Publisher3', N'Spain')

insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate]) values
(N'DiscA1S1', 1, 1, N'Review1', 1, SYSDATETIME()),
(N'DiscA1S2', 1, 2, N'Review2', 1, SYSDATETIME()),
(N'DiscA1S3', 1, 3, N'Review3', 1, SYSDATETIME()),
(N'DiscA2S1', 2, 1, N'Review4', 2, SYSDATETIME()),
(N'DiscA2S2', 2, 2, N'Review5', 2, SYSDATETIME()),
(N'DiscA2S3', 2, 3, N'Review6', 2, SYSDATETIME()),
(N'DiscA3S1', 3, 1, N'Review7', 3, SYSDATETIME()),
(N'DiscA3S2', 3, 2, N'Review8', 3, SYSDATETIME()),
(N'DiscA3S3', 3, 3, N'Review9', 3, SYSDATETIME()),
(N'DiscA1S4', 1, 3, N'Review10', 3, SYSDATETIME())

insert into [Songs]([Name], [ArtistId], [DiscId], [StyleId], [Duration]) values
(N'Song1A1', 1, 1, 1, 1),
(N'Song2A1', 1, 2, 2, 2),
(N'Song3A1', 1, 3, 3, 3),
(N'Song4A1', 1, 10, 3, 4),
(N'Song1A2', 2, 4, 1, 5),
(N'Song2A2', 2, 5, 2, 6),
(N'Song3A2', 2, 6, 3, 5),
(N'Song1A3', 3, 7, 1, 4),
(N'Song2A3', 3, 8, 2, 3),
(N'Song3A3', 3, 9, 3, 2)
go

--1. ѕредставление отображает названи€ всех исполнителей
Create view ArtistsView as
select Artists.Name as [Artist Name]
From Artists

select * from ArtistsView

--2. ѕредставление отображает полную информацию о всех песн€х: название песни, название диска, длительность песни, музыкальный стиль песни, исполнитель
Create view FullInformation as
select Songs.Name  as [Songs Name], Discs.Name as [Disc Name],
Songs.Duration as Duraton, Styles.Name as Styles, Artists.Name as Artist
From Songs
Inner join Discs on Discs.Id = Songs.DiscId
Inner join Styles on Styles.Id = Discs.StyleId
Inner join Artists on Artists.Id = Discs.ArtistId

Select * from FullInformation

--3. ѕредставление отображает информацию о музыкальных дисках конкретной группы. Ќапример, The Beatles
Create view GrupsDiscs as
select Songs.Name  as [Songs Name], Discs.Name as [Disc Name],
Songs.Duration as Duraton, Styles.Name as Styles, Artists.Name as Artist
From Songs
Inner join Discs on Discs.Id = Songs.DiscId
Inner join Styles on Styles.Id = Discs.StyleId
Inner join Artists on Artists.Id = Discs.ArtistId
Where Artists.Name = 'The Beatles'

Select * from GrupsDiscs

--4. ѕредставление отображает название самого попул€рного в коллекции исполнител€. ѕопул€рность определ€етс€ по
--количеству дисков в коллекции
Create view Popular as
select top 1 Artists.Name as [Popular Artist Name]
From Artists
join Songs on Songs.ArtistId = Artists.Id
group by Artists.Name
Order by COUNT(Songs.DiscId) desc

select * from Popular
--5. ѕредставление отображает топ-3 самых попул€рных в коллекции исполнителей. ѕопул€рность определ€етс€ по количеству дисков в коллекции
Create view [Top 3 Popular] as
select top 3 Artists.Name as [Popular Artist Name]
From Artists
join Songs on Songs.ArtistId = Artists.Id
group by Artists.Name
Order by COUNT(Songs.DiscId) desc

select * from [Top 3 Popular]

--6. ѕредставление отображает самый долгий по длительности музыкальный альбом.
create view [Duration Song] as
select top 1 Songs.Name as [Song Name], MAX(Songs.Duration) as Duration
from Songs
group by Songs.Name
Order by MAX(Songs.Duration) desc

select * from [Duration Song]


--«адание 2. ¬се задани€ необходимо выполнить по отношению к базе данных Ђћузыкальна€ коллекци€ї, описанной
--в практическом задании дл€ этого модул€:

--1. —оздайте обновл€емое представление, которое позволит вставл€ть новые стили
Create view StyleView as
select Styles.Id as Id, Name
from Styles

select * from StyleView

Insert into StyleView (Name) Values ('Style4')

--2. —оздайте обновл€емое представление, которое позволит вставл€ть новые песни
Create view SongsView as
select Songs.Id as Id, Name, DiscId, StyleId, ArtistId, Duration
from Songs

select * from SongsView

Insert into SongsView (Name, DiscId, StyleId, ArtistId, Duration)
values ('NewSong', 10, 1, 3, 5)

--3. —оздайте обновл€емое представление, которое позволит обновл€ть информацию об издателе
Create view PublishersView as
select Publishers.Id as Id, Name, Country
from Publishers

Select * from PublishersView

Update PublishersView
Set Name = 'Pablisher4' Where Country = 'USA'

--4. —оздайте обновл€емое представление, которое позволит удал€ть исполнителей
Create view ArtistsViewDel as
select Artists.Id, Name
from Artists

select * from ArtistsViewDel

Delete from ArtistsViewDel
where Name = 'MockArtist'

--5. —оздайте обновл€емое представление, которое позволит обновл€ть информацию о конкретном исполнителе. Ќапример, Muse.
Create view ArtistsView2 as
select Artists.Id, Name
from Artists

select * from ArtistsView2

Update ArtistsView2
Set Name = 'Muse2' Where Name = 'Muse'

create view ArtistsView3 as
select Artists.Id as [Artists Id], Artists.Name as [Artists Name],
Discs.Id as [Discs Id], Discs.Name as [Discs Name], Discs.ArtistId as [Discs.ArtistId],
Discs.PublisherId as [Discs PublisherId], Discs.ReleaseDate as [Discs ReleaseDate],
Discs.Review as [Discs Review], Discs.StyleId as [Discs StyleId], Publishers.Id as [Publishers Id], 
Publishers.Country as [Publishers Country], Publishers.Name as [Publishers Name] 
from Artists
INNER join Discs on Discs.ArtistId = Artists.Id
INNER join Publishers on Discs.PublisherId = Publishers.Id

Update ArtistsView3
Set [Discs Name] = 'DiscA1S11' Where [Discs Name] = 'DiscA1S1'

select * from ArtistsView3