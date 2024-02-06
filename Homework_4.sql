--DB scheme: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
--Computer company: make View (Pages_all_products)
-- there will be a page breakdown of all products (no more than two product on one page).
-- Conclusion: All data from Laptop, page number, list of all pages
create view pages_all_products as
select code, model, speed, ram, hd, price, screen, 
    case when num % 2 = 0 
      	then num/2 
      	else num/2 + 1 
	end as page_num, 
    case when total % 2 = 0 
    	then total/2 
    	else total/2 + 1 
    end as num_of_pages
from (
      select *, row_number(*) over(order by model desc) as num, 
             count(*) over() as total 
      from Laptop
) a

select * from pages_all_products


sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
--Complete company: make View (Distribution_by_type), in which there will be
--Processive ratio of all products according to the type of device. Conclusion: manufacturer, type, percentage (%)
create view distribution_by_type as (select a.maker, a."type", a.c1
from (
with x as (
select distinct maker,"type", 
(row_number(*) over(partition by maker, "type"))::float as y,
(row_number(*) over(partition by maker))::float as z from product p
)
select round((y/z)*100) as c1 , x.* from x
)a )


--task3 (lesson5)
-- Computer firm: make the previous priest View Graph - a circular diagram. Example https://plotly.com/python/histograms/

request = """
with x as (select distinct (maker ||' '|| "type") as z, count(*) over (partition by maker ||' '|| "type") from distribution_by_type)
select z, count/(select sum(count) from x)*100 as y from x
"""
df = pd.read_sql_query(request, conn)
fig = px.pie(df, names = 'z', values = 'y') 
fig.show()

--task4 (lesson5)
-- Ships: make a copy of the SHIPS table (ships_two_words), but the name of the ship should consist of two words
select * into ships_two_words from ships 
where "name" like '% %' 

select * from ships_two_words

--task5 (lesson5)
-- Ships: Bring a list of ships in which Class is absent (is null) and the name begins with the letter "S"
with x as (select distinct x."name", s."class" from (select "name" from ships
union 
select ship as "name" from outcomes) x left join ships s on s."name" = x."name")
select x."name" from x 
where x."class" is null and x."name" like 'S%' 



