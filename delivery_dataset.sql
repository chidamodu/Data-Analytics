To extract hour from column containing timestamp values:
select extract(hour from column_name) FROM table_name LIMIT 5;

To prettify the displaying of a table with many fields
\x auto; (Expanded display is used automatically)

To add a column to an existing table with query results:
ALTER TABLE table_name ADD COLUMN column_name time; (here time specifies the type of the column: column_name)
UPDATE table_name SET column_name =pg_catalog.time(column_name); (to extract only the time from timestamp column values)

To check out column names and type
\d+ table_name; (can also use just \d; \d+ gives more info about storage and other details)

To alter the type of column to 'timestamp'(note: there is no special mention about which column type has to changed to timestamp)
ALTER TABLE table_name ALTER column_name type timestamp USING column_name::timestamp;

To select Day-of_week from a column containing timestamp values:(the below query qorks even if the ::DATE is not mentioned)
SELECT EXTRACT(DOW FROM column_name::DATE) FROM table_name;

To delete a column in a table:
ALTER TABLE table_name DROP COLUMN column_name;


To extract Day-of_week(DOW) from timestamp and store the results of the query as a separate column in the table:
ALTER TABLE table_name ADD COLUMN column_name integer;
UPDATE table_name SET column_name = EXTRACT(DOW FROM column_name::DATE);


SET TIME ZONE 'PST8PDT'; (California Time Zone)#to set the timezone to California Time Zone

ALTER TABLE table_name ADD COLUMN date_det date;
UPDATE table_name SET date_det=customer_placed_order_time::DATE;#customer_placed_order is a column with timestamp values


ALTER TABLE table_name ADD COLUMN month_det integer;
UPDATE table_name SET month_det=EXTRACT(MONTH FROM customer_placed_order_time);


For timestamp with time zone, the internally stored value is always in UTC (Universal Coordinated Time). So i think it is quite important to mention the time zone 'PST' part as appears in the
current query. For example: SELECT '2012-03-25 01:00:00-07'::DATE;
In the specific case shown below both the queries give same output but this doesn have to be necessarily true for every value. So the bottomline is mention time zone PST wherever it is necessary
SELECT '2012-03-25 01:00:00-07'::DATE;
    date
------------
 2012-03-25
(1 row)

SELECT '2012-03-25 00:00:00'::DATE;
    date
------------
 2012-03-25
(1 row)

ALTER TABLE table_name ADD COLUMN day_week varchar(15);
UPDATE table_name SET day_week=to_char(date_det,'Day');#to_char is used to get the day in verbal format like Monday, Tuesday, etc,.


ALTER TABLE table_name ADD COLUMN confirmed_time time;
UPDATE table_name SET confirmed_time = pg_catalog.time(restaurant_confirmed_time);#restaurant_confirmed_time is a column with timestamp values


ALTER TABLE table_name ADD COLUMN pickup_t time;
UPDATE table_name SET pickup_t = pg_catalog.time(pickup_time);#pg_catalog.time gets just the time from timestamp, which contains both date and time

ALTER TABLE table_name ADD COLUMN deliver_t time;
UPDATE table_name SET deliver_t = pg_catalog.time(delivered_time);


SELECT COUNT(DISTINCT refund_amount) FROM table_name;#to get the count of distinct values of refund_amount

SELECT COUNT(driver_at_restaurant_time) FROM table_name
WHERE driver_at_restaurant_time is not null;#to get the non_null values of a column

To find the time difference between customer_placed_order_time and delivered_time in minutes (note here: first use epoch to find the difference in seconds and divide that by 60 to get minutes)
select extract (epoch from (deliver_t - order_time))::integer/60 AS diff_minutes FROM table_name LIMIT 15;

To add the difference between the customer_placed_order_time and delivered_time in minutes as a separate column in the table:
ALTER TABLE table_name ADD COLUMN deliver_order_diff integer;
UPDATE table_name SET deliver_order_diff=extract (epoch from (deliver_t - order_time))::integer/60;

Select extract (epoch from (pg_catalog.time(driver_at_restaurant_time)-confirmed_time))::integer/60 AS diff_time FROM table_name LIMIT 5;

To convert the postgres table into a csv file
COPY table_name TO '/path/to/file/file_name' DELIMITER ',' CSV HEADER;

To subtract two time values:
SELECT pg_catalog.time(timestamp '3/10/12 19:27') - pg_catalog.time(timestamp '3/10/12 19:21');


ALTER TABLE table_name ADD COLUMN deliver_order_diff time with timezone= extract (epoch from (deliver_t - order_time))::integer/60;


SELECT '3/10/12 7:21 PM PST'::timestamp;
      timestamp
---------------------
 2012-03-10 19:21:00


SELECT res_confirm_pickup_diff FROM table_name
WHERE SIGN(res_confirm_pickup_diff) < 0;#to get the negative values from a column
