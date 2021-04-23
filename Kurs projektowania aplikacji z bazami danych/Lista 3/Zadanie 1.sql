DROP TABLE IF EXISTS Prices
DROP TABLE IF EXISTS Products
DROP TABLE IF EXISTS Rates
GO

CREATE TABLE Products(ID INT PRIMARY KEY, ProductName VARCHAR (20))
INSERT INTO Products VALUES (1, 'apples')
INSERT INTO Products VALUES (2, 'oranges')
INSERT INTO Products VALUES (3, 'pears')
INSERT INTO Products VALUES (4, 'plums')
INSERT INTO Products VALUES (5, 'peaches')
GO

CREATE TABLE Rates(Currency Varchar(3) PRIMARY KEY, PricePLN MONEY)
INSERT INTO Rates VALUES ('PLN', 1.00)
INSERT INTO Rates VALUES ('EUR', 4.63)
INSERT INTO Rates VALUES ('GBP', 5.42)
INSERT INTO Rates VALUES ('JPY', 0.036)
INSERT INTO Rates VALUES ('CNY', 0.60)
GO

CREATE TABLE Prices(ProductID INT REFERENCES Products(ID), Currency VARCHAR(3) REFERENCES Rates(Currency), Price MONEY) 
INSERT INTO Prices VALUES (1, 'PLN', 2.45)
INSERT INTO Prices VALUES (2, 'PLN', 3.21)
INSERT INTO Prices VALUES (3, 'PLN', 0.91)
INSERT INTO Prices VALUES (4, 'PLN', 7.99)
INSERT INTO Prices VALUES (5, 'PLN', 23.00)
INSERT INTO Prices VALUES (1, 'EUR', 3.34)
INSERT INTO Prices VALUES (1, 'GBP', 5.12)
INSERT INTO Prices VALUES (1, 'JPY', 6.43)
INSERT INTO Prices VALUES (2, 'EUR', 0.01)
INSERT INTO Prices VALUES (3, 'GBP', 5.12)
INSERT INTO Prices VALUES (3, 'JPY', 45.24)
INSERT INTO Prices VALUES (4, 'EUR', 134.21)
INSERT INTO Prices VALUES (4, 'GBP', 0.65)
INSERT INTO Prices VALUES (4, 'JPY', 12345678.90)
INSERT INTO Prices VALUES (5, 'CNY', 1.00)
GO

SELECT * FROM Prices
GO

DELETE FROM Rates WHERE Currency = 'CNY'
GO

DECLARE z1Products CURSOR FOR SELECT ProductID, Currency, Price FROM Prices ORDER BY ProductID
DECLARE z1Rates CURSOR FOR SELECT Currency, PricePLN FROM Rates

DECLARE @ProductID INT, @Currency VARCHAR(3), @Price MONEY
DECLARE @CurrentProduct INT, @CurrentPricePLN MONEY
DECLARE @CCurrency VARCHAR(3), @Rate MONEY

OPEN z1Products
FETCH NEXT FROM z1Products INTO @ProductID, @Currency, @Price
SET @CurrentProduct = @ProductID
SET @CurrentPricePLN = (SELECT Price FROM Prices WHERE Currency = 'PLN' AND ProductID = @CurrentProduct)
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @Price = -1
	OPEN z1Rates
	FETCH NEXT FROM z1Rates INTO @CCurrency, @Rate
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF @Currency = @CCurrency
		BEGIN
			SET @Price = @CurrentPricePLN / @Rate
			UPDATE Prices SET Price = @Price WHERE ProductID = @ProductID AND Currency = @Currency
		END
		FETCH NEXT FROM z1Rates INTO @CCurrency, @Rate
	END
	IF @Price = -1
		DELETE FROM Prices WHERE ProductID = @ProductID AND Currency = @Currency
	CLOSE z1Rates
	FETCH NEXT FROM z1Products INTO @ProductID, @Currency, @Price
	IF @ProductID != @CurrentProduct
	BEGIN
		SET @CurrentProduct = @ProductID
		SET @CurrentPricePLN = (SELECT Price FROM Prices WHERE Currency = 'PLN' AND ProductID = @CurrentProduct)
	END
END
CLOSE z1Products
DEALLOCATE z1Products
DEALLOCATE z1Rates
GO

SELECT * FROM Prices
GO




