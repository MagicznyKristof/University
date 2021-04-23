/*INSERT INTO SalesLT.Product (Name, ProductCategoryID, ProductNumber, StandardCost, ListPrice, ProductModelID, SellStartDate, SellEndDate)
VALUES	('Example Bad Product', 1, 'FR-R92B-21', 1234, 1234, 6, '2002-06-01 00:00:00.000', '2002-06-01 00:00:00.000'),
		('Example Bad Product_1', 2, 'FR-R92B-22', 1234, 1234, 6, '2002-06-01 00:00:00.000', '2002-06-01 00:00:00.000'),
		('Example Bad Product_2', 3, 'FR-R92B-23', 1234, 1234, 6, '2002-06-01 00:00:00.000', '2002-06-01 00:00:00.000'),
		('Example Bad Product_3', 4, 'FR-R92B-24', 1234, 1234, 6, '2002-06-01 00:00:00.000', '2002-06-01 00:00:00.000');*/
--INSERT INTO SalesLT.Product (Name, ProductCategoryID, ProductNumber, StandardCost, ListPrice, ProductModelID, SellStartDate, SellEndDate)
	--VALUES	('Example Bad Product_5', 1, 'FR-R92B-25', 1234, 1234, 6, '2002-06-01 00:00:00.000', '2002-06-01 00:00:00.000')
--SELECT * FROM SalesLT.ProductCategory

/*
SELECT ProductCategory.Name AS "Category", Product.Name AS "Product", ProductCategory.ProductCategoryID AS "ID"
	FROM	SalesLT.Product JOIN 
			SalesLT.ProductCategory ON Product.ProductCategoryID = ProductCategory.ProductCategoryID
	ORDER BY ProductCategory.ProductCategoryID
*/
/*
--version 1 (worse)
SELECT ProductCategory.Name AS "Category", Product.Name AS "Product"
	FROM	SalesLT.Product JOIN 
			SalesLT.ProductCategory ON Product.ProductCategoryID = ProductCategory.ProductCategoryID
	WHERE EXISTS 
		(SELECT ProductCategoryID 
			FROM SalesLT.ProductCategory AS Categories 
			WHERE Categories.ParentProductCategoryID = Product.ProductCategoryID)
*/

--version 2 (better)
SELECT DISTINCT PC2.Name AS "Category", Product.Name AS "Product"
	FROM	SalesLT.ProductCategory PC1 JOIN
			SalesLT.ProductCategory PC2 ON PC1.ParentProductCategoryID = PC2.ProductCategoryID JOIN
			SalesLT.Product ON Product.ProductCategoryID = PC2.ProductCategoryID

