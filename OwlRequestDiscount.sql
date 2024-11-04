SELECT
    Item.Price * OrderLine.Quantity *
    (CASE
        WHEN Discount.Discount IS NULL THEN 0
        ELSE Discount.Discount
     END) AS TotalPrice,
    Item.Price * OrderLine.Quantity AS PriceBeforePromo,
    Discount.Discount
FROM
    owl.dbo.Order1
INNER JOIN
    owl.dbo.OrderLine ON Order1.Id = OrderLine.OrderId
INNER JOIN
    owl.dbo.Item ON OrderLine.ItemId = Item.Id
INNER JOIN
    owl.dbo.Period ON Period.Date = Order1.Date
LEFT JOIN
    owl.dbo.Discount ON Discount.PeriodId = Period.Id
