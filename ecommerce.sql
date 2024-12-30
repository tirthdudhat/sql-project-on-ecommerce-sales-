use ecommerce;

-- Q1 What is the total revenue generated per month? 

SELECT  DATE_FORMAT(order_date, '%Y-%m') AS Month,  
    ROUND(SUM(total_price),0) AS Total_Revenue  
FROM orders  
GROUP BY DATE_FORMAT(order_date, '%Y-%m')  
ORDER BY Month;

-- Q2 Which product categories contribute the most to overall sales?
SELECT p.category, o.product_id, SUM(o.quantity) total_quantity, ROUND(SUM(o.price_at_purchase),0) AS total_sales
FROM order_items AS o
JOIN  products AS p ON 
		o.product_id = p.product_id
GROUP BY category
ORDER BY 4 DESC;

-- Q4 How many orders are placed by customers each month?

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS Month,  
    COUNT(order_id) AS Total_Orders             
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')           
ORDER BY Month;        

-- Q5 What are the most reviewed products and their average ratings?                       
SELECT 
    p.product_id, 
    p.product_name, 
    COUNT(r.review_id) AS Total_Reviews, 
    AVG(r.rating) AS Average_Rating      
FROM products p
JOIN reviews r ON p.product_id = r.product_id 
GROUP BY p.product_id, p.product_name             
ORDER BY Total_Reviews DESC,                      
    Average_Rating DESC;   

-- Q6. Identify customers who made more than 1 purchases in the last 6 months and calculate their total spending.
SELECT c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name, 
    COUNT(o.order_id) AS Total_Purchases, 
    SUM(o.total_price) AS Total_Spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)  
GROUP BY c.customer_id, Customer_Name
HAVING Total_Purchases > 1  
ORDER BY Total_Spending DESC;

-- Q 7 Which supplier provides the highest-rated products on average, and what is their average delivery time?
SELECT s.supplier_id, 
    s.supplier_name, 
    AVG(r.rating) AS Average_Product_Rating,          
    AVG(DATEDIFF(sh.delivery_date, sh.shipment_date)) AS Average_Delivery_Time 
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id      
JOIN reviews r ON p.product_id = r.product_id       
JOIN shipments sh ON sh.order_id = (                 
        SELECT oi.order_id 
        FROM order_items oi 
        WHERE oi.product_id = p.product_id
        LIMIT 1
    )
WHERE sh.delivery_date IS NOT NULL                    
GROUP BY s.supplier_id, s.supplier_name                
ORDER BY Average_Product_Rating DESC                     
LIMIT 1;         

                                   


  
