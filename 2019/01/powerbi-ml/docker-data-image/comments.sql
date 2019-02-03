USE WideWorldImporters
GO 

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP Table #tmp
CREATE TABLE #tmp (OrderID BIGINT, Comments NVARCHAR(MAX))

INSERT INTO #tmp (OrderID, Comments) 
VALUES (73595,'This is the best product I ever purchased! I would highly recommend this to anyone!'),
(73594,'Absolutely awful, you should never ever buy this crap !!1'),
(73593,'It was exactly what I was looking for, fair price for good quality product'),
(73592,'Overall build quality is satisfactory but price should be lower. Unfortunately, delivery was not on time.'),
(73591,'Think twice before you decide to purchase this product. Poor quality for twice the price.'),
(73590,'I was waiting for this product for a long time. When I that it was available in the WideWorldImporters, I decided I need to purchase it. I never looked back.'),
(73589,'Kupiłem ten produkt w zeszłym miesiącu w waszym sklepie internetowym, czekałem na niego ponad dwa tygodnie a kiedy w końcu przyszedł to okazuje się że jest kompletnie zniszczony! Jeżeli nie dostane pieniędzy spowrotem to zgłaszam to na policje!'),
(73587,'La carretera estaba atascada. Había mucho tráfico el día de ayer.'),
(73586,'Los caminos que llevan hasta Monte Rainier son espectaculares y hermosos.')

UPDATE o
SET  Comments = t.Comments
FROM [WideWorldImporters].[Sales].[Orders] o
JOIN #tmp t ON t.OrderID = o.OrderID