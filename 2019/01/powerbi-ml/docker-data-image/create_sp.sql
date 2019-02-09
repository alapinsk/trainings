USE WideWorldImporters
GO 

CREATE OR ALTER VIEW [PowerBI].[CustomerTransactions]
AS
SELECT CAST(AVG([AmountExcludingTax]) AS int) AS AverageAmountPaid
      ,COUNT(InvoiceID) AS InvoiceCnt
	  ,CustomerID
FROM [WideWorldImporters].[Sales].[CustomerTransactions]
GROUP BY CustomerID
GO

CREATE OR ALTER VIEW [PowerBI].[ItemGroups]
AS
SELECT [StockGroupID] [ItemGroupID]
      ,[StockGroupName] [ItemGroupName]
FROM [Warehouse].[StockGroups]
GO

CREATE OR ALTER VIEW [PowerBI].[ItemItemGroups]
AS
SELECT [StockItemID] [ItemID]
      ,[StockGroupID] [ItemGroupID]
FROM [Warehouse].[StockItemStockGroups]
GO

CREATE OR ALTER VIEW [PowerBI].[Items]
AS
SELECT si.[StockItemID] [ItemID]
      ,si.[StockItemName] [ItemName]
      ,sih.[LastCostPrice] [CostPrice]
      ,si.[RecommendedRetailPrice]
      ,c.[ColorName]
FROM [Warehouse].[StockItems] si
JOIN [Warehouse].[StockItemHoldings] sih ON sih.StockItemID = si.StockItemID
LEFT JOIN [Warehouse].[Colors] c ON c.ColorID = si.ColorID
GO

CREATE OR ALTER VIEW [PowerBI].[Orders]
AS 
SELECT	o.OrderID, ol.StockItemID ItemID, o.CustomerID, o.SalespersonPersonID, o.OrderDate, OrderNumber = o.CustomerPurchaseOrderNumber,
		o.ExpectedDeliveryDate, ol.Quantity, ol.UnitPrice,
        o.Comments
FROM [Sales].[Orders] o
JOIN [Sales].[OrderLines] ol ON o.OrderID = ol.OrderID
GO

CREATE OR ALTER VIEW [PowerBI].[Customers]
AS 
SELECT [CustomerID]
      ,[CustomerName]
      ,ci.[CityName] [DeliveryCityName]
      ,st.[StateProvinceName] [DeliveryStateProvinceName]
      ,co.[CountryName] [DeliveryCountryName]
      ,ci.[Location].Lat [DeliveryCityLat]
      ,ci.[Location].Long [DeliveryCityLong]
FROM [Sales].[Customers] c
JOIN [Application].[Cities] ci ON ci.CityID = c.DeliveryCityID
JOIN [Application].[StateProvinces] st ON st.StateProvinceID = ci.StateProvinceID
JOIN [Application].[Countries] co ON co.CountryID = st.CountryID
GO

CREATE OR ALTER VIEW Website.SalesOrders
AS
SELECT	o.OrderID, o.OrderDate, OrderNumber = o.CustomerPurchaseOrderNumber,
		o.ExpectedDeliveryDate, o.PickingCompletedWhen,
		o.CustomerID, c.CustomerName, c.PhoneNumber, c.FaxNumber, c.WebsiteURL, 
		DeliveryLocation = JSON_QUERY((SELECT 
				[type] = 'Feature',
				[geometry.type] = 'Point',
				[geometry.coordinates] = JSON_QUERY(CONCAT('[',c.DeliveryLocation.Long,',',c.DeliveryLocation.Lat ,']')),
				[properties.DeliveryMethod] = dm.DeliveryMethodName,
				[properties.AddressLine1] = c.DeliveryAddressLine1,
				[properties.AddressLine2] = c.DeliveryAddressLine2,
				[properties.PostalCode] = c.DeliveryPostalCode,
				[properties.Instructions] = o.DeliveryInstructions
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
		SalesPerson = sp.FullName, SalesPersonPhone = sp.PhoneNumber, SalesPersonEmail = sp.EmailAddress
FROM	Sales.Orders o
		INNER JOIN Sales.Customers c
			ON o.CustomerID = c.CustomerID
			LEFT OUTER JOIN [Application].DeliveryMethods AS dm
				ON c.DeliveryMethodID = dm.DeliveryMethodID
		INNER JOIN Application.People sp
			ON o.SalespersonPersonID = sp.PersonID
GO

CREATE OR ALTER VIEW Website.SalesOrderLines
AS
SELECT	ol.OrderLineID, ol.OrderID, ol.Description, ol.Quantity, ol.UnitPrice, ol.TaxRate,
		ProductName = si.StockItemName, si.Brand, si.Size, c.ColorName, pt.PackageTypeName
FROM	Sales.OrderLines ol
		INNER JOIN Warehouse.StockItems si
			ON ol.StockItemID = si.StockItemID
			INNER JOIN Warehouse.Colors c
				ON c.ColorID = si.ColorID
		INNER JOIN Warehouse.PackageTypes pt
			ON ol.PackageTypeID = pt.PackageTypeID
GO