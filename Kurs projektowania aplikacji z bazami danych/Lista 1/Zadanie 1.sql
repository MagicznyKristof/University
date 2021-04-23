SELECT DISTINCT City FROM 
	(SalesLT.SalesOrderHeader JOIN SalesLT.Address 
	ON SalesLT.SalesOrderHeader.ShipToAddressID = SalesLT.Address.AddressID)
	ORDER BY City