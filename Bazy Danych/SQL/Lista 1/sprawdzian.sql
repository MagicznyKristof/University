-- Krzysztof Łyskawa, pga
-- Zadanie 1
SELECT city.* FROM city 
JOIN airport ON city.name = airport.city 
WHERE city.country = 'PL' AND city.elevation < 100 
ORDER BY city.name ASC;

-- Zadanie 2
SELECT DISTINCT sea.name, sea.area FROM sea
JOIN river ON river.sea = sea.name
JOIN geo_river ON geo_river.river = river.name
JOIN country ON country.code = geo_river.country
WHERE river.length > 800 AND country.name = 'France'
ORDER BY sea.area DESC;
