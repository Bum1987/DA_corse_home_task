--Task 1: Display NAME, CLASS on ships released after 1920
--
select s."name",s."class" from ships s
where s.launched > '1920'

-- Task 2: Display Name, Class on ships released after 1920, but no later than 1942.
--
select s."name",s."class" from ships s
where s.launched between '1920' and '1942'

-- Task 3: How many ships in each class. Display the quantity and class.
--
select count(s."name") as ship_count,s."class" 
from ships s
group by s."class" 


-- Task 4: For the classes of ships, the caliber of the guns of which is at least 16, indicate the class and the country. (Classes table)
--
select c."class", c.country from classes c
where c.numguns >= 16

-- Task 5: Indicate the ships sunk in battles in the North Atlantic (Outcomes, North Atlantic). Output: Ship.
--
select ship from outcomes o
where battle = 'North Atlantic'and "result" = 'sunk'

-- Task 6: Display the name (SHIP) of the last sunk ship
--
-- Subqueries 
select x.ship from (select * from outcomes o join battles b on o.battle=b."name"  
where o."result" = 'sunk') x
where x."date" = (select max(x2."date")from (select * from outcomes o join battles b on o.battle=b."name"  
where o."result" = 'sunk') x2)
-- CTE
with x as (select * from outcomes o join battles b on o.battle=b."name"  
where o."result" = 'sunk')
select x.ship from x
where x."date" = (select max(x."date") from x) 

-- Task 7: Display the name of the ship (ship) and class (class) of the last sunk ship
--
-- If class will be 0 
select x.ship, x."class" from (select * from outcomes o join battles b on o.battle=b."name" left join ships s on o.ship = s."name"  
where o."result" = 'sunk') x 
where x."date" = (select max(x2."date")from (select * from outcomes o join battles b on o.battle=b."name" left join ships s on o.ship = s."name"  
where o."result" = 'sunk') x2)
-- If class will not be 0
select x.ship, x."class" from (select * from outcomes o join battles b on o.battle=b."name" left join ships s on o.ship = s."name"  
where o."result" = 'sunk'
and s."class" is not null) x 
where x."date" = (select max(x2."date")from (select * from outcomes o join battles b on o.battle=b."name" left join ships s on o.ship = s."name"  
where o."result" = 'sunk'
and s."class" is not null) x2)

-- Task 8: Display all the sunk ships, which have a caliber of guns at least 16 and which are sunk. Output: ship, class
--
select s."name", s."class"  from outcomes o left join ships s on o.ship = s."name" join classes c on s."class" = c."class"  
where o."result" = 'sunk'
and c.numguns >= '16'
-- Task 9: Display out all the classes of ships released by the United States (Classes, Country = 'Usa' table). Output: Class
--
select c."class" from classes c
where country = 'USA'

-- Task 10: Display all the ships released by the United States (the Classes & Ships, Country = 'Usa' table). Output: name, class
select s."name", c."class" from classes c join ships s on c."class" = s."class" 
where c.country = 'USA'