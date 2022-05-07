ALTER TABLE south
DROP COLUMN Hou;
ALTER TABLE south
DROP COLUMN Dat;
ALTER TABLE south
DROP COLUMN id;
select * from south;
DELETE FROM south WHERE (PRECIPITATION=-9999 AND 
    Atmospheric_pressure_station=-9999 AND
    Maximum_air_pressure=-9999 AND
    Minimum_air_pressure=-9999 AND
    Solar_radiation=-9999 AND
    Air_temperature=-9999 AND
    Dew_poin_temperature=-9999 AND
    Maximum_temperature_las_hou=-9999 AND
    Minimum_temperature_las_hou=-9999 AND
    Maximum_dew_poin_temperature=-9999 AND
    Minimum_dew_poin_temperature=-9999 AND
    Maximum_relative_humid_temp_las_hou=-9999 AND
    Minimum_relative_humid_temp_las_hou=-9999 AND
    Relative_humid=-9999 AND
    Wind_direction=-9999 AND
    Wind_gust=-9999 AND
    Wind_speed=-9999 );
select count(*) from south;
UPDATE south set  PRECIPITATION=(Select avg(PRECIPITATION) from south where  PRECIPITATION!=-9999)  where  PRECIPITATION=-9999;
UPDATE south set  Solar_radiation=(Select avg(Solar_radiation) from south where  Solar_radiation!=-9999)  where  Solar_radiation=-9999;
UPDATE south set  Dew_poin_temperature=(Select avg(Dew_poin_temperature) from south where  Dew_poin_temperature!=-9999)  where  Dew_poin_temperature=-9999;
UPDATE south set  Relative_humid=(Select avg(Relative_humid) from south where  Relative_humid!=-9999)  where  Relative_humid=-9999;
UPDATE south set  Maximum_air_pressure=(Select avg(Maximum_air_pressure) from south where  Maximum_air_pressure!=-9999)  where  Maximum_air_pressure=-9999;
UPDATE south set  Minimum_air_pressure=(Select avg(Minimum_air_pressure)  from south where  Minimum_air_pressure!=-9999)  where  Minimum_air_pressure=-9999;
UPDATE south set Maximum_temperature_las_hou=(Select avg( Maximum_temperature_las_hou) as val from south where  Maximum_temperature_las_hou!=-9999)  where  Maximum_temperature_las_hou=-9999;
UPDATE south set Minimum_temperature_las_hou=(Select avg(Minimum_temperature_las_hou) as val from south where Minimum_temperature_las_hou!=-9999)  where Minimum_temperature_las_hou=-9999;
UPDATE south set Maximum_dew_poin_temperature=(Select avg( Maximum_dew_poin_temperature) as val from south where Maximum_dew_poin_temperature!=-9999)  where  Maximum_dew_poin_temperature=-9999;
UPDATE south set  Minimum_dew_poin_temperature=(Select avg(  Minimum_dew_poin_temperature) as val from south where   Minimum_dew_poin_temperature!=-9999)  where   Minimum_dew_poin_temperature=-9999;
UPDATE south set  Maximum_relative_humid_temp_las_hou=(Select avg(  Maximum_relative_humid_temp_las_hou) as val from south where   Maximum_relative_humid_temp_las_hou!=-9999)  where   Maximum_relative_humid_temp_las_hou=-9999;
UPDATE south set  Minimum_relative_humid_temp_las_hou=(Select avg(  Minimum_relative_humid_temp_las_hou) as val from south where   Minimum_relative_humid_temp_las_hou!=-9999)  where   Minimum_relative_humid_temp_las_hou=-9999;
UPDATE south set  Wind_direction=(Select avg(  Wind_direction) as val from south where   Wind_direction!=-9999)  where   Wind_direction=-9999;
UPDATE south set  Wind_gust=(Select avg( Wind_gust) as val from south where   Wind_gust!=-9999)  where  Wind_gust=-9999;
