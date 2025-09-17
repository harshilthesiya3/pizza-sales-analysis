select * from pizza_sales;

select sum(total_price) as Total_Revenue from pizza_sales;

select sum(total_price)/count(distinct(order_id)) as Avg_Order_Value from pizza_sales;

select sum(quantity) as Total_Pizza_Sold from pizza_sales;

select count(distinct(order_id)) as Total_Orders from pizza_sales;

select cast(cast(sum(quantity) as decimal(10,2))/cast(count(distinct(order_id))as decimal(10,2))as decimal(10,2)) as AVg_Pizza_Per_Order from pizza_sales;

select DATENAME(DW,order_date) as order_day, count(distinct order_id) as total_orders from pizza_sales
group by DATENAME(DW,order_date);

DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = STRING_AGG(
    QUOTENAME(c.name) + ' IS NULL',
    ' OR '
)
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('pizza_sales');

SET @sql = 'SELECT * FROM pizza_sales WHERE ' + @sql + ';';

EXEC sp_executesql @sql;


UPDATE ps
SET ps.order_date = TRY_CAST(pst.order_date AS DATE)
FROM pizza_sales ps
JOIN pizza_sales_staging pst 
    ON ps.order_id = pst.order_id
WHERE ps.order_date IS NULL
  AND TRY_CAST(pst.order_date AS DATE) IS NOT NULL;


  SELECT COUNT(*) AS remaining_null_dates
FROM pizza_sales
WHERE order_date IS NULL;


select DATENAME(MONTH,order_date) as Month_Name,Count(distinct order_id) as Total_Orders
from pizza_sales
group by DATENAME(MONTH,order_date)
order by Total_Orders desc;

select pizza_category,(sum(total_price)*100)/(select sum(total_price) from pizza_sales) as Percentage_Total_Sales
from pizza_sales
group by pizza_category;

select * from pizza_sales;
/*Percentage by pizza size*/

select pizza_size,cast((sum(total_price)*100)/(select sum(total_price) from pizza_sales)as decimal(10,2)) as Percentage_Pizza_Size
from pizza_sales
group by pizza_size
order by Percentage_Pizza_Size desc;

/*total pizza sold by pizza category*/
select pizza_category,cast(sum(total_price) as decimal(10,2)) as Total_Sales from pizza_sales 
group by pizza_category;

/*Top 5 Best Sellers by Revenue, Total Quantity and Total Orders*/
select TOP 5 pizza_name,count(distinct order_id) as Total_Orders from pizza_sales 
group by pizza_name
order by Total_Orders desc;

select TOP 5 pizza_name,sum(total_price) as Total_Revenue from pizza_sales 
group by pizza_name
order by Total_Revenue asc;

select TOP 5 pizza_name,sum(quantity) as Total_Pizza_Sold from pizza_sales 
group by pizza_name
order by Total_Pizza_Sold asc;

select TOP 5 pizza_name,count(distinct order_id) as Total_Orders from pizza_sales 
group by pizza_name
order by Total_Orders asc;


