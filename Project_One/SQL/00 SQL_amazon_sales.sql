-- *****Data cleaning*****
-- Find columns with NULL 
SELECT * 
FROM amazon 
WHERE category IS NULL OR product_name IS NULL OR category IS NULL OR discounted_price IS NULL
OR actual_price IS NULL OR discount_percentage IS NULL OR rating IS NULL OR rating_count IS NULL 
OR about_product IS NULL OR user_id IS NULL OR user_name IS NULL OR review_id IS NULL
OR review_title IS NULL OR review_content IS NULL OR img_link IS NULL OR product_link IS NULL 
OR category = '' OR product_name = '' OR category = '' OR discounted_price = ''
OR actual_price = '' OR discount_percentage = '' OR rating = '' OR rating_count = '' 
OR about_product = '' OR user_id = '' OR user_name = '' OR review_id = ''
OR review_title = '' OR review_content = '' OR img_link = '' OR product_link = '';

-- Since only two null values are at "rating count" column, replace NULL values to 1
UPDATE amazon
SET rating_count = 1
WHERE rating_count IS NULL OR rating_count = '';

-- Find possible invalid information in critical columns
SELECT category FROM amazon ORDER BY category;
SELECT discounted_price FROM amazon ORDER BY discounted_price;
SELECT actual_price FROM amazon ORDER BY actual_price;
SELECT discount_percentage FROM amazon ORDER BY discount_percentage;
SELECT rating FROM amazon ORDER BY rating;
SELECT rating_count FROM amazon ORDER BY rating_count;

-- Since only one invalid informaiton and it is at "rating", delete the row with "rating" as "|"
DELETE FROM amazon WHERE rating = '|';

-- Clear data in "discounted_price", "actual_price", "discount_percentage" , 'rating' and 'rating_count' columns so they can be used correclty as number comparing later
UPDATE amazon
SET discounted_price  = CAST(REPLACE(REPLACE(discounted_price,'₹',''),',','') AS DECIMAL(10,2)),
actual_price  = CAST(REPLACE(REPLACE(actual_price,'₹',''),',','') AS DECIMAL(10,2)),
discount_percentage  = CAST(REPLACE(discount_percentage,'%','')/100 AS DECIMAL(10,2)),
rating = CAST(rating AS DECIMAL(10,1)),
rating_count = REPLACE(rating_count,',','');

-- Clear data in 'category' columns to keep only main categorires and its sub catergories
ALTER TABLE amazon
ADD COLUMN category_main VARCHAR(255) AFTER category,
ADD COLUMN category_sub VARCHAR(255) AFTER category_main;

UPDATE amazon, (SELECT category, SUBSTRING_INDEX(category,'|',1) AS 'category_temp1', SUBSTRING_INDEX(SUBSTRING_INDEX(category,'|',2),'|',-1) AS 'category_temp2'FROM amazon) temp
SET amazon.category_main  = temp.category_temp1, amazon.category_sub  = temp.category_temp2
WHERE amazon.category = temp.category;


-- *****Data analyzing*****
-- General categories distribution as per main category 
SELECT category_main, COUNT(category_main) AS 'count_main_category', CONCAT(ROUND((COUNT(category_main)/(SELECT COUNT(*) FROM amazon))*100,2),'%') AS 'count_main_category(%)'
FROM amazon
GROUP BY category_main
ORDER BY category_main;

-- General categories distribution as per sub category
SELECT category_main, category_sub, COUNT(category_sub) AS 'count_sub_category', CONCAT(ROUND((COUNT(category_sub)/(SELECT COUNT(*) FROM amazon))*100,2),'%') AS 'count_sub_category(%)'
FROM amazon
GROUP BY category_main, category_sub
ORDER BY category_main, category_sub;

-- Most popular main category 
SELECT category_main, FORMAT(SUM(rating_count),0) AS 'most_popular_main_category'
FROM amazon 
GROUP BY category_main
ORDER BY SUM(rating_count) DESC;

-- Most popular sub category 
SELECT category_sub, category_main,  FORMAT(SUM(rating_count),0) AS 'most_popular_sub_category'
FROM amazon 
GROUP BY category_sub, category_main
ORDER BY SUM(rating_count) DESC, category_sub, category_main;

-- Price distribution in general
SELECT FORMAT(COUNT((CASE WHEN discounted_price <=10000 THEN 1 END)),0) AS '(0,10000]',
			FORMAT(COUNT((CASE WHEN discounted_price >10000 AND discounted_price <=20000 THEN 1 END)),0) AS '(10000,20000]',
			FORMAT(COUNT((CASE WHEN discounted_price >20000 AND discounted_price <=30000 THEN 1 END)),0) AS '(20000,30000]',
			FORMAT(COUNT((CASE WHEN discounted_price >30000 AND discounted_price <=40000 THEN 1 END)),0) AS '(30000,40000]',
			FORMAT(COUNT((CASE WHEN discounted_price >40000 AND discounted_price <=50000 THEN 1 END)),0) AS '(40000,50000]',
			FORMAT(COUNT((CASE WHEN discounted_price >50000 AND discounted_price <=60000 THEN 1 END)),0) AS '(50000,60000]',
			FORMAT(COUNT((CASE WHEN discounted_price >60000 AND discounted_price <=70000 THEN 1 END)),0) AS '(60000,70000]',
			FORMAT(COUNT((CASE WHEN discounted_price >70000 AND discounted_price <=80000 THEN 1 END)),0) AS '(70000,80000]',
			FORMAT(COUNT(discounted_price),0) AS 'total'
FROM amazon;

-- Price distribution with main category
SELECT category_main, FORMAT(COUNT((CASE WHEN discounted_price <=10000 THEN 1 END)),0) AS '(0,10000]',
			FORMAT(COUNT((CASE WHEN discounted_price >10000 AND discounted_price <=20000 THEN 1 END)),0) AS '(10000,20000]',
			FORMAT(COUNT((CASE WHEN discounted_price >20000 AND discounted_price <=30000 THEN 1 END)),0) AS '(20000,30000]',
			FORMAT(COUNT((CASE WHEN discounted_price >30000 AND discounted_price <=40000 THEN 1 END)),0) AS '(30000,40000]',
			FORMAT(COUNT((CASE WHEN discounted_price >40000 AND discounted_price <=50000 THEN 1 END)),0) AS '(40000,50000]',
			FORMAT(COUNT((CASE WHEN discounted_price >50000 AND discounted_price <=60000 THEN 1 END)),0) AS '(50000,60000]',
			FORMAT(COUNT((CASE WHEN discounted_price >60000 AND discounted_price <=70000 THEN 1 END)),0) AS '(60000,70000]',
			FORMAT(COUNT((CASE WHEN discounted_price >70000 AND discounted_price <=80000 THEN 1 END)),0) AS '(70000,80000]',
			FORMAT(COUNT(discounted_price),0) AS 'total'
FROM amazon
GROUP BY category_main
ORDER BY category_main;

-- Top 5 most expensive products after discount 
SELECT product_name, category_main, discounted_price AS 'most_expensive_products'
FROM amazon
ORDER BY (discounted_price+0) DESC
LIMIT 5;

-- Top 5 cheapest products after discount 
SELECT product_name, category_main, discounted_price AS 'cheapest_products'
FROM amazon
ORDER BY (discounted_price+0)
LIMIT 5;

-- Discount rate distribution
SELECT CONCAT(ROUND(discount_percentage*100,2),'%') AS 'discount_percentage(%)', COUNT(discount_percentage) AS 'discount_rate_distribution(total_amount)', CONCAT(ROUND((COUNT(discount_percentage)/(SELECT COUNT(discount_percentage) FROM amazon)*100),2),'%') AS 'discount_rate_distribution(%)'
FROM amazon
GROUP BY discount_percentage
ORDER BY discount_percentage;

-- Top 5 higest discount products based on amounts
SELECT product_id, product_name AS 'higest_discount_products(amounts)', FORMAT((actual_price-discounted_price),0) AS 'discount_amount', FORMAT(actual_price,0) AS 'actual_price', FORMAT(discounted_price,0) AS 'discounted_price', CONCAT(discount_percentage*100,'%') AS 'discount_rate'
FROM amazon
ORDER BY (actual_price-discounted_price) DESC
LIMIT 5;

-- Top 5 higest discount products based on discount rate
SELECT product_id, product_name  AS 'higest_discount_products(discount_rate)', CONCAT(discount_percentage*100,'%') AS 'discount_rate(%)', FORMAT(actual_price,2) AS 'actual_price', FORMAT(discounted_price,2) AS 'discounted_price'
FROM amazon
ORDER BY discount_percentage DESC
LIMIT 5;

-- Rating distribution
SELECT rating, COUNT(rating) AS 'rating_distribution(total_amount)', CONCAT(ROUND((COUNT(rating)/(SELECT COUNT(rating) AS 'temp' FROM amazon)*100),2),'%') AS 'rating_distribution(%)'
FROM amazon
GROUP BY rating
ORDER BY rating;

-- Rating distribution, seperate by main category 
SELECT category_main,
			COUNT((CASE WHEN rating <=1 THEN 1 END)) AS '(0,1]',
			COUNT((CASE WHEN rating >1 AND rating <=2 THEN 1 END)) AS '(1,2]',
			COUNT((CASE WHEN rating >2 AND rating <=3 THEN 1 END)) AS '(2,3]',
			COUNT((CASE WHEN rating >3 AND rating <=4 THEN 1 END)) AS '(3,4]',
			COUNT((CASE WHEN rating >4 THEN 1 END)) AS '(4,5]',
			COUNT(category_main) AS 'sum',
			CONCAT(ROUND((COUNT((CASE WHEN rating >4 THEN 1 END))/COUNT(category_main))*100,2),'%') AS '(4,5](%)'
FROM amazon
GROUP BY category_main
ORDER BY category_main;

-- Rating distribution, seperate by sub category 
SELECT category_main, category_sub,
			COUNT((CASE WHEN rating <=1 THEN 1 END)) AS '(0,1]',
			COUNT((CASE WHEN rating >1 AND rating <=2 THEN 1 END)) AS '(1,2]',
			COUNT((CASE WHEN rating >2 AND rating <=3 THEN 1 END)) AS '(2,3]',
			COUNT((CASE WHEN rating >3 AND rating <=4 THEN 1 END)) AS '(3,4]',
			COUNT((CASE WHEN rating >4 THEN 1 END)) AS '(4,5]',
			COUNT(category_main) AS 'sum',
			CONCAT(ROUND((COUNT((CASE WHEN rating >4 THEN 1 END))/COUNT(category_main))*100,2),'%') AS '(4,5](%)'
FROM amazon
GROUP BY category_main, category_sub
ORDER BY category_main, sum desc, category_sub;

-- Average rating of each main category with its highest rating and rating total amounts
SELECT category_main, FORMAT(AVG(rating),2) AS 'avg_rating', FORMAT(MAX(rating),2) AS 'higest_rating'
FROM amazon
GROUP BY category_main
ORDER BY category_main;

-- Higest rating product in each category main
SELECT category_main, FORMAT(rating,2) AS 'higest_rating', FORMAT(rating_count,0) AS 'total_rating', product_name, FORMAT(discounted_price,2) AS 'discounted_price'
FROM (SELECT category_main, product_name, rating, rating_count, DENSE_RANK() OVER (PARTITION BY category_main ORDER BY rating DESC) AS 'rank', discounted_price FROM amazon) AS temp
WHERE temp.rank = 1
ORDER BY category_main, rating_count+0 DESC;

-- Lowest rating product in each category main
SELECT category_main, FORMAT(rating,2) AS 'lowest_rating', FORMAT(rating_count,0) AS 'total_rating', product_name, FORMAT(discounted_price,2) AS 'discounted_price'
FROM (SELECT category_main, product_name, rating, rating_count, DENSE_RANK() OVER (PARTITION BY category_main ORDER BY rating) AS 'rank', discounted_price FROM amazon) AS temp
WHERE temp.rank = 1
ORDER BY category_main, rating_count+0 DESC;