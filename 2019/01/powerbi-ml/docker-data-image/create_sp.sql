USE WideWorldImporters
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