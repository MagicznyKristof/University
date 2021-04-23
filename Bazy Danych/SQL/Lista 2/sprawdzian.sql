-- Krzysztof £yskawa, pga
-- Zadanie 1
SELECT country.name, COUNT(DISTINCT islandin.island) island_number FROM country
LEFT JOIN geo_sea ON geo_sea.country = country.code
LEFT JOIN islandin ON islandin.sea = geo_sea.sea
GROUP BY country.code, country.name
ORDER BY island_number DESC, country.name ASC;

-- Zadanie 2
SELECT Country.name, e2.percentage FROM Country
JOIN EthnicGroup e1 ON e1.country = Country.code
JOIN EthnicGroup e2 ON e2.country = Country.code
WHERE e2.name = 'Polish'
GROUP BY e2.name, Country.code, Country.name, e2.percentage
HAVING Count(e1.name) >= 10;

-- Zadanie 4
SELECT Country.name, ROUND(SUM(City.population) / Country.population * 100, 0) FROM Country
JOIN City ON City.country = Country.code
GROUP BY Country.name, Country.code, Country.population
HAVING SUM(City.population) > Country.population * 0.75;
