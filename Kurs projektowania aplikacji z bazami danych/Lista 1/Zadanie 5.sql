SELECT FirstName, LastName, SUM(UnitPriceDiscount * OrderQty) AS "Discount"
	FROM 
		SalesLT.Customer JOIN 
		SalesLT.SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID JOIN 
		SalesLT.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
	GROUP BY FirstName, LastName
	ORDER By Discount DESC