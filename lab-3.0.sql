
select * from system.data_type_families;

select * from system.data_type_families where alias_to='String';

CREATE TABLE users (
    id UInt32,
    name String,
    is_active BOOL
)
primary key id

describe users

create database rich;

create table rich.friends(
    name String,
    birthday Date,
    age Int8
)
ENGINE= MergeTree
PRIMARY KEY name

alter table rich.friends
    add column meetings Array(DateTime)

alter table rich.friends
    add column meetings_2 Array(datetime)

alter table rich.friends
    drop column meetings_2

show create table rich.friends

insert into rich.friends values 
    ('Tomas', '1970-12-02', 54, ['2024-01-05 09:00:00', '1706500542'])
    ('Claire', '1998-12-02', 25, [now(), now() - interval 1 week])

select * from rich.friends

select name, meetings[1], meetings[2] from rich.friends;

alter table rich.friends
    add column size UInt64,
    add column metrics Nullable(UInt64)

insert into rich.friends (size, metrics) values 
    (100, 453343),
    (NULL, 574434),
    (200, NULL);

select * from rich.friends 

create table enum_demo
(
    device_id UInt32,
    device_type Enum('server'=1, 'container'=2, 'router'=3)
)
ENGINE = MergeTree
primary KEY device_id

insert into enum_demo values (123, 'router')
insert into enum_demo values (456, 'container')
insert into enum_demo values (123, 'server')
select * from enum_demo

insert into enum_demo values (789, 'pod')

create table my_table4
(
    user_id UInt32,
    message String,
    timestamp DateTime,
    metrics Decimal(30,2),
)
ENGINE = MergeTree
PRIMARY KEY (user_id, timestamp)
order by (user_id, timestamp, message)

create table my_table5
(
    user_id UInt32,
    message String,
    timestamp DateTime,
    metrics Decimal(30,2),
)
ENGINE = MergeTree
PRIMARY KEY (user_id, timestamp, message)
order by (user_id, timestamp)
