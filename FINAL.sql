create table centralwest like northeast;
create table south like northeast;
create table southeast like northeast;
LOAD DATA INFILE 'central_west.csv' 
INTO TABLE centralwest
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
SET session wait_timeout=300;
select * from centralwest union select * from south union select * from north;