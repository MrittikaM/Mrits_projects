-- 1st view
    SELECT 
        o.order_id,
        re.restaurant_name,
        r.Rating_Rest_Qstn_4,
        p.person_name,
        d.Rating_Driver_Qstn_4
    FROM
        OverallRating o
            JOIN
        RestaurantRating r ON o.Rating_id = r.Rating_id
            JOIN
        DriverRating d ON o.Rating_id = d.Rating_id
            JOIN
        Campus_Eats_Fall2020.order co USING (order_id)
            JOIN
        restaurant re ON co.restaurant_id = re.restaurant_id
            JOIN
        person p ON co.person_id = p.person_id
    WHERE
        Rating_Rest_Qstn_4 > 3
            AND Rating_Driver_Qstn_4 > 3
    ORDER BY order_id; 
    
    SELECT * FROM Campus_Eats_Fall2020.recommendation_ratings;

-- 2nd view 
CREATE VIEW Restaurant_With_Best_Food_Quality AS    
    SELECT 
        o.order_id,
        re.restaurant_name,
        r.Rating_Rest_Qstn_1 AS "Food Quality 1-5"
    FROM
        OverallRating o
            JOIN
        RestaurantRating r ON o.Rating_id = r.Rating_id
            JOIN
        Campus_Eats_Fall2020.order co USING (order_id)
            JOIN
        restaurant re ON co.restaurant_id = re.restaurant_id
	WHERE r.Rating_Rest_Qstn_1 >= 4
    ORDER BY r.Rating_Rest_Qstn_1 DESC;
    
    SELECT * FROM Campus_Eats_Fall2020.Restaurant_With_Best_Food_Quality;
     
	-- 3rd view
    CREATE OR REPLACE VIEW Good_Delivery_Drivers AS
    SELECT 
		p.person_name as driver_name,
		ROUND(AVG(ovr.rating), 2) as driver_avg_rating,
		COUNT(ovr.order_id) as No_Of_Orders
	FROM
		driverrating dr
	INNER JOIN 
		overallrating ovr 
		ON ovr.Rating_id = dr.Rating_id
	INNER JOIN 
		campus_eats_fall2020.order o 
		ON ovr.order_id = o.order_id
	INNER JOIN
		driver d
		ON d.driver_id = o.driver_id
	INNER JOIN
		student s
		ON s.student_id = d.student_id
	INNER JOIN
		person p
		ON p.person_id = o.person_id
	GROUP BY s.student_id
	HAVING AVG(ovr.rating) >= 3.5
	ORDER BY driver_avg_rating DESC, No_Of_Orders DESC;
    
SELECT * FROM Campus_Eats_Fall2020.Good_Delivery_Drivers;
    
    
    
    
