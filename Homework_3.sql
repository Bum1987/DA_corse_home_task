--Homework 3
--task1  (lesson4)
--Computer company: make View (name all_products_flag_300) for all products (PC, Printer, Laptop) with flag, if the cost is more> 300. View three columns: Model, Price, Flag
create view all_products_flag_300 as (
with x as (select model, price from pc
union all
select model, price from printer
union all
select model, price from laptop
) 
select *, case when price > 300 then 1 else 0 end flag
from x)

select * from all_products_flag_300  

--task2  (lesson4)
--Computer company: make View (name all_products_flag_avg_price) for all products (PC, Printer, Laptop) with a flag, if the cost is greater than the cost. There are three columns in View: Model, Price, Flag
create view all_products_flag_avg_price as (
with x as (select model, price from pc
union all
select model, price from printer
union all
select model, price from laptop
)
select *, case when price > (select avg(price) from x) then 1 else 0 end flag 
from x)

select * from all_products_flag_avg_price

--task3  (lesson4)
-- Computer company: Bring all the manufacturer's printers = 'a' with a cost of higher than the manufacturer’s average = 'D' and 'C'. Bring Model
with x as (select printer.*, p.maker, p."type" from printer join product p on printer.model  = p.model)
select x.model from x
where x.price > (select avg(price) from x where maker in ('D','C'))
and x.maker = 'A' 

--task11 (lesson4)
create view sunk_ships_by_classes as
with all_ships as
(
		select name, class
		from ships
	union all
		select distinct ship, NULL as class
		from Outcomes
		where ship not in (select name from ships) 
)
select class, count(*) from all_ships where name in --Cekered in the condition of the filter by the names of the sunk ships
	(
	select ship
	from outcomes
	where result = 'sunk'
	) group by class

select *
from sunk_ships_by_classes

-- Ships: according to the previous View (sunk_ships_by_classes) to make a graph in Colab (x: class, y: count)
 
import psycopg2
import pandas as pd
#Áèáëèîòåêà æäÿ âèçóàëèçàöèè
from IPython.display import HTML
import plotly.express as px



DB_HOST = '178.170.196.15'
DB_USER = 'student12'
DB_USER_PASSWORD = 'student12_password'
DB_NAME = 'sql_ex_for_student12'

conn = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)
c = conn.cursor()

request = """
select class, count
from sunk_ships_by_classes
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(df, x="class", y="count") 
fig.show()

--task12 (lesson4)
-- ships: make a copy of the Classes table (name class_with_flag) and add Flag to it: if the number of guns is larger or equal to 9 - then 1, otherwise 0
select *, case when c.numguns >= '9' then 1 else 0 end flag into classes_with_flag from classes c 
select * from classes_with_flag

--task13 (lesson4)
-- Ships: make a schedule in Colab according to the Classes table with the number of classes by countries (X: Country, Y: Count)

request = """
select count(*) as c,country from classes c 
group by country
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(df, x="country", y="c") 
fig.show()