create database amazon;
use amazon;

select * from amazon;

ALTER TABLE amazon 
CHANGE COLUMN `Product line` product_line VARCHAR(255);

ALTER TABLE amazon 
CHANGE COLUMN `gross income` gross_income VARCHAR(255);

ALTER TABLE amazon 
CHANGE COLUMN `Customer type` Customer_type VARCHAR(255);

ALTER TABLE amazon 
CHANGE COLUMN `Tax 5%` tax VARCHAR(255);

-- Feature Engineering 

-- creating New columns 
ALTER TABLE amazon 
ADD COLUMN timeofday VARCHAR(20);

UPDATE amazon
SET timeofday = 
    CASE 
        WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(time) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'  
    END;


ALTER TABLE amazon ADD dayname VARCHAR(15);

UPDATE amazon
SET dayname = DATENAME(DAY);


ALTER TABLE amazon ADD COLUMN weekday VARCHAR(10);

UPDATE amazon
SET weekday = DAYNAME(date);

ALTER TABLE amazon DROP COLUMN dayname;





-- 1. What is the count of distinct cities in the dataset?
select count(distinct(city)) from amazon;

-- 2. For each branch, what is the corresponding city?
SELECT branch, city FROM amazon
GROUP BY branch, city;

-- 3. What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT `Product line`) FROM amazon;

-- 4. Which payment method occurs most frequently?
SELECT payment, COUNT(*) AS frequency FROM amazon
GROUP BY payment
ORDER BY frequency DESC
LIMIT 1;

-- 5. Which product line has the highest sales?
SELECT product_line, round(SUM(total),2) AS total_sales
FROM amazon
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

-- 6. How much revenue is generated each month?
select monthname, round(sum(total),2) as total_revenue  from amazon
group by monthname;

-- 7. In which month did the cost of goods sold reach its peak?
select monthname, round(sum(total),2) as total_revenue  from amazon
group by monthname
limit 1;

-- 8. Which product line generated the highest revenue?
select product_line, round(sum(total),2) as highest_revenue from amazon
group by product_line 
limit 1;

-- 9. In which city was the highest revenue recorded?
select city, round(sum(total),2) as highest_revenue from amazon
group by city 
limit 1;

-- 10. Which product line incurred the highest Value Added Tax?
select product_line, round(sum(gross_income), 2) as value_added from amazon
group by product_line 
limit 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT product_line, SUM(total) AS total_sales,
    CASE 
        WHEN SUM(total) > 
        (SELECT AVG(total_sales) FROM (SELECT SUM(total) AS total_sales FROM amazon 
        GROUP BY product_line) AS avg_sales)
        THEN 'Good'
        ELSE 'Bad'
    END AS performance
FROM amazon
GROUP BY product_line;

-- 12. Identify the branch that exceeded the average number of products sold.
SELECT product_line, SUM(total) AS total_products_sold FROM amazon
GROUP BY product_line
HAVING SUM(total) > (
    SELECT AVG(total_products_sold) 
    FROM (
        SELECT product_line, SUM(total) AS total_products_sold 
        FROM amazon 
        GROUP BY product_line
    ) AS avg_table
);

-- 13. Which product line is most frequently associated with each gender?
SELECT gender, product_line, purchase_count
FROM (
    SELECT gender, product_line, COUNT(*) AS purchase_count,
           RANK() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rnk
    FROM amazon
    GROUP BY gender, product_line
) AS ranked_data
WHERE rnk = 1;

-- 14. Calculate the average rating for each product line.
select product_line, round(avg(rating),2) from amazon
group by product_line;

-- 15. Count the sales occurrences for each time of day on every weekday.
SELECT weekday, timeofday, COUNT(total) AS sales_count FROM amazon
GROUP BY weekday, timeofday
ORDER BY weekday, timeofday;



-- 16. Identify the customer type contributing the highest revenue.
select customer_type, round(sum(total),2) from amazon 
group by customer_type 
limit 1;

-- 17. Determine the city with the highest VAT percentage.
SELECT city, MAX(tax) AS highest_vat FROM amazon
GROUP BY city
ORDER BY highest_vat DESC
LIMIT 1;

-- 18. Identify the customer type with the highest VAT payments.
select customer_type, max(tax) as highest_vat_payments from amazon 
group by customer_type
order by highest_vat_payments desc 
limit 1;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct(customer_type)) from amazon;

-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct(payment)) from amazon;

-- 21. Which customer type occurs most frequently?
SELECT customer_type, COUNT(*) AS occurrence_count FROM amazon
GROUP BY customer_type
ORDER BY occurrence_count DESC
LIMIT 1;

-- 22. Identify the customer type with the highest purchase frequency.
SELECT customer_type, COUNT(*) AS purchase_frequency FROM amazon
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;

-- 23. Determine the predominant gender among customers.
select gender, count(gender) as predominant_gender from amazon
group by gender
order by predominant_gender desc 
limit 1;

-- 24. Examine the distribution of genders within each branch.
SELECT branch, gender, COUNT(*) AS gender_count FROM amazon
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;

-- 25. Identify the time of day when customers provide the most ratings.
SELECT timeofday, COUNT(rating) AS rating_count FROM amazon
GROUP BY timeofday
ORDER BY rating_count DESC
LIMIT 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.
select branch, timeofday, count(rating) as highest_customer_rating from amazon 
group by branch, timeofday 
order by highest_customer_rating Desc;

-- 27. Identify the day of the week with the highest average ratings.
SELECT weekday, AVG(rating) AS avg_rating FROM amazon
GROUP BY weekday
ORDER BY avg_rating DESC
LIMIT 1;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select weekday, branch, avg(rating) as avg_rating from amazon 
group by weekday, branch
order by avg_rating;




select * from amazon;








