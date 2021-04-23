--/*
SELECT		City, 
			COUNT(DISTINCT Customer.CustomerID) AS "Number of Clients", 
			COUNT(DISTINCT SalesPerson) AS "Number Of Sales People"
	FROM	SalesLT.Customer 
			JOIN SalesLT.CustomerAddress ON Customer.CustomerID = CustomerAddress.CustomerID 
			JOIN SalesLT.Address ON CustomerAddress.AddressID = Address.AddressID
	GROUP BY City
	--*/
	/*
SELECT		City, 
			Customer.FirstName,
			Customer.LastName,
			Customer.CustomerID,
			CustomerAddress.AddressID,
			CustomerAddress.AddressType
			--COUNT(Customer.CustomerID) AS "Number of Clients", 
			--COUNT(DISTINCT SalesPerson) AS "Number Of Sales People"
	FROM	SalesLT.Customer 
			JOIN SalesLT.CustomerAddress ON Customer.CustomerID = CustomerAddress.CustomerID 
			JOIN SalesLT.Address ON CustomerAddress.AddressID = Address.AddressID
	WHERE	City = 'Austin'
	--GROUP BY City, FirstName, LastName
	*/