--task1
--Ships: For each class, determine the number of ships of this class sunk in battles. Bring: class and number of sunk ships.
select s."class", count(s."class")  from ships s join outcomes o on s."name" = o.ship  
where o."result"  = 'sunk'
group by s."class" 

--task2
--Ships: For each class, determine the year when the first ship of this class was launched. If the year of launching the head ship is unknown, determine the minimum year of launching ships of this class. Bring out: class, year.Ships: For each class, determine the year when the first ship of this class was launched. If the year of launching the head ship is unknown, determine the minimum year of launching ships of this class. Bring out: class, year.
with x as (select "class", MIN(launched) AS min_lunch
FROM ships group by "class")
select c."class", x.min_lunch from classes c
left join x on c."class" = x."class"  

--task3
--Ships: For classes that have losses in the form of sunk ships and at least 3 ships in the database, derive the name of the class and the number of sunk ships.select c."class", x.sunk_count--, y.ship_count 
from classes c left join (select s."class", count(s."class") as sunk_count from outcomes o 
left join ships s 
on o.ship = s."name" 
where o."result"  = 'sunk'
group by s."class") x on c."class"  = x."class" left join (select s2."class",count(s2."name") as ship_count from ships s2
group by s2."class") y on c."class" = y."class"
where sunk_count != 0
and ship_count >= 3

--task4
--ships: Find the names of ships with the greatest number of guns among all ships
--such displacements (take into account ships from the Outcomes table).
select x.ship from (select cl.displacement, x.ship, cl.numguns 
from (select o.ship, s2."class" from outcomes o join ships s2 on o.ship = s2."name" 
union 
select s."name" as ship, s."class"  from ships s) x join classes cl on x."class" = cl."class"
order by cl.displacement) x left join (select c.displacement, max(c.numguns) max_numguns 
from classes c group by c.displacement) y on x.displacement = y.displacement 
where x.numguns = y.max_numguns 

--task5
--Computer company: Find producers of printers who produce a PC with the least RAM volume
--And with the fastest processor among all PCs having the lowest volume of RAM. Bring: Maker

select maker from (with x as (select * from product p join pc p3 on p.model = p3.model 
where maker in (select distinct product.maker from product join printer p2 on product.model = p2.model 
order by product.maker)
and p."type" = 'PC')
select * from x
where x.ram = (select min(x.ram) from x)) as y2
where y2.speed = (select max(y.speed) from (with x as (select * from product p join pc p3 on p.model = p3.model 
where maker in (select distinct product.maker from product join printer p2 on product.model = p2.model 
order by product.maker)
and p."type" = 'PC')
select * from x
where x.ram = (select min(x.ram) from x))as y)