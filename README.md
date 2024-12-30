# sql-project-on-ecommerce-sales-

## Q1 What is the total revenue generated per month? 
```sql
SELECT  DATE_FORMAT(order_date, '%Y-%m') AS Month,  
    ROUND(SUM(total_price),0) AS Total_Revenue  
FROM orders  
GROUP BY DATE_FORMAT(order_date, '%Y-%m')  
ORDER BY Month;
```
