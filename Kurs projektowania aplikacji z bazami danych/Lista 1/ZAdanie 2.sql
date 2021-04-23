SELECT ProductModel.Name, COUNT(Product.ProductID)--, ProductModel.ProductModelID--, 
	FROM SalesLT.Product JOIN SalesLT.ProductModel
		ON Product.ProductModelID = ProductModel.ProductModelID
	GROUP BY ProductModel.Name
	HAVING Count (*) > 1
/*without GROUP BY Name we get an error 
"ProductModel.Name is invalid for the select list because it is not contained in either an aggregate function or the GROUP BY clause*/