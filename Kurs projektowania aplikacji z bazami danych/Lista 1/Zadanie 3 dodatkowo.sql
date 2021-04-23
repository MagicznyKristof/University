SELECT FirstName, LastName, Customer.CustomerID, CA1.AddressID, Ad1.City, Ad2.City, CA1.AddressType
	FROM	SalesLT.Customer JOIN
			SalesLT.CustomerAddress CA1 ON CA1.CustomerID = Customer.CustomerID JOIN
			SalesLT.CustomerAddress CA2 ON CA1.CustomerID = CA2.CustomerID AND CA1.AddressID != CA2.AddressID JOIN
			SalesLT.Address Ad1 ON CA1.AddressID = Ad1.AddressID JOIN
			SalesLT.Address Ad2 ON CA1.AddressID = Ad2.AddressID AND Ad1.City != Ad2.City
	ORDER BY LastName, AddressType
