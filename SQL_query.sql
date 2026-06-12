use outlet;
select * from order_details limit 10;
select * from pizza_types limit 10;
select * from pizzas limit 10;
select * from orders limit 10;

select count(order_id) Total_count from orders;

-- Total Revenue
SELECT 
    ROUND(SUM(pd.quantity * p.price), 2) AS Total_revenue
FROM
    order_details pd
        JOIN
    pizzas p USING (pizza_id);
    
-- Highest prize pizza 
SELECT 
    pt.name, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt USING (pizza_type_id)
ORDER BY price DESC;

-- common pizza size ordered
SELECT 
    SUM(od.quantity) Total_Quantity, p.size Size
FROM
    order_details od
        JOIN
    pizzas p USING (pizza_id)
GROUP BY Size
ORDER BY Total_Quantity DESC;

-- most repeated order quantity counts 
SELECT 
    od.quantity Qty, COUNT(order_details_id) Counts
FROM
    order_details od
GROUP BY Qty
ORDER BY Counts DESC;

-- maximum count of pizza type with there quantity 
SELECT 
    pt.name, SUM(od.quantity) Qty
FROM
    pizza_types pt
        JOIN
    pizzas p USING (pizza_type_id)
        JOIN
    order_details od USING (pizza_id)
GROUP BY pt.name
ORDER BY Qty DESC;



-- Total count of each pizza category 

SELECT 
    pt.category Category, SUM(od.quantity) Qty
FROM
    pizza_types pt
        JOIN
    pizzas p USING (pizza_type_id)
        JOIN
    order_details od USING (pizza_id)
GROUP BY Category
ORDER BY Qty DESC;

-- order counts on Hours 
SELECT 
    HOUR(time) Order_time, COUNT(order_id) order_count
FROM
    orders
GROUP BY Order_time
ORDER BY Order_count DESC;


-- category wize pizza count
SELECT 
    category, COUNT(pizza_type_id) Counts
FROM
    pizza_types
GROUP BY category
ORDER BY Counts DESC;

-- Count the Avg no of Pizzas ordered per day 
select avg(QTY) from 
(SELECT 
    o.date odr_date, SUM(od.quantity) QTY
FROM
    orders o
        JOIN
    order_details od USING (order_id)
GROUP BY odr_date) as Total_Quantity;


-- Month wise total orders  
SELECT 
    AVG(QTY)
FROM
    (SELECT 
        MONTH(o.date) odr_Month, SUM(od.quantity) QTY
    FROM
        orders o
    JOIN order_details od USING (order_id)
    GROUP BY odr_Month) AS Total_QTY_Monthly;



-- Calculate the percentage contribution of each pizza type to Total revenue 

with Total_revenue as (SELECT 
            SUM(od.quantity * p.price) revenue
        FROM
            order_details od
                JOIN
            pizzas p USING (pizza_id))
SELECT 
    pt.category category,
    SUM(od.quantity * p.price) / max(tr.revenue) * 100 AS Total_per
FROM
    pizza_types pt
        JOIN
    pizzas p USING (pizza_type_id)
        JOIN
    order_details od USING (pizza_id)
    cross join Total_revenue tr 
GROUP BY pt.category
ORDER BY Total_per DESC;


