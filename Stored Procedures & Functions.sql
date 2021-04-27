-- Q1: Create a stored procedure that inserts a new row into the Restaurant table. Test with good and bad data. 
USE campus_eats_fall2020;

DROP PROCEDURE IF EXISTS insert_restaurant;

DELIMITER //

CREATE PROCEDURE insert_restaurant
(
  restaurant_id_param        INT,
  location_param   VARCHAR(75),
  restaurant_name_param     VARCHAR(75),
  schedule_param    VARCHAR(75),
  website_param         VARCHAR(75)
)
BEGIN
  INSERT INTO restaurant
         (restaurant_id, location, restaurant_name, 
          schedule, website)
  VALUES (restaurant_id_param, location_param, restaurant_name_param, 
          schedule_param, website_param);
END//

DELIMITER ;

-- test
CALL insert_restaurant(600, 'Charlotte', 'Cookout', 'Monday', 
                     'www.cookout.com');
                     

-- this statement raises an error
CALL insert_restaurant('Burger', 'Charlotte', 'Cookout', 'Monday', 
                     'www.cookout.com');
                     
                     -- clean up
SELECT * FROM restaurant WHERE restaurant_id >= 600;

DELETE FROM restaurant WHERE restaurant_id >= 600;

-- Q2: Create a function that returns the Driver_ID given the Driver_Name.  Test the function.
USE campus_eats_fall2020;

DROP FUNCTION IF EXISTS get_person_id;

DELIMITER //

CREATE FUNCTION get_person_id
(
   person_name_param VARCHAR(50)
)
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
  DECLARE person_id_var INT;
  
  SELECT person_id
  INTO person_id_var
  FROM person
  WHERE person_name = person_name_param;
  
  RETURN(person_id_var);
END//

DELIMITER ;

SELECT d.driver_id
FROM driver AS d
JOIN student AS s
ON d.student_id = s.student_id
JOIN person AS p
ON s.person_id = p.person_id
WHERE p.person_id = get_person_id('Keith Turner');

-- test 
select Campus_Eats_Fall2020.get_person_id('Keith Turner');

-- Q3: Create a function that returns the Restaurant_ID given the Restaurant_Name. Test the function.
USE campus_eats_fall2020;

DROP FUNCTION IF EXISTS get_restaurant_id;

DELIMITER //

CREATE FUNCTION get_restaurant_id
(
   restaurant_name_param VARCHAR(50)
)
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
  DECLARE restaurant_id_var INT;
  
  SELECT restaurant_id
  INTO restaurant_id_var
  FROM restaurant
  WHERE restaurant_name = restaurant_name_param;
  
  RETURN(restaurant_id_var);
END//

DELIMITER ;

SELECT restaurant_id
FROM restaurant
WHERE restaurant_id = get_restaurant_id('Rath LTD');

-- Q4: Create a stored procedure or a function that returns the average ratings for Restaurants.  Test the function.
USE campus_eats_fall2020;

DROP FUNCTION IF EXISTS get_avg_rating;

DELIMITER //
CREATE FUNCTION get_avg_rating
() 
RETURNS DECIMAL(9,2) 
DETERMINISTIC READS SQL DATA
BEGIN 
	DECLARE avg_rating_var DECIMAL(9,2);
	
    SELECT round(avg(Rating),2)
	INTO avg_rating_var
    from OverallRating;
   
  RETURN avg_rating_var; 
END
//
DELIMITER ;

select Campus_Eats_Fall2020.get_avg_rating();

-- Q5: Create a Stored Procedure or a function that returns the average ratings for a Restaurant given a Restaurant _ID.  Do the same for Driver_Ratings. 
DROP FUNCTION IF EXISTS avg_restaurant_rating;
DELIMITER //
  
CREATE FUNCTION avg_restaurant_rating(p_restaurant_id INT) 
RETURNS DECIMAL(3,2) DETERMINISTIC
BEGIN 
	DECLARE avg_rating DECIMAL(3,2);
	SELECT round(avg(Rating_Rest_Qstn_1 + Rating_Rest_Qstn_2 + Rating_Rest_Qstn_3 + Rating_Rest_Qstn_4)/4,2) AS AvgRating
	FROM restaurantrating RR 
    LEFT JOIN overallrating OVR ON RR.Rating_id=OVR.Rating_id
    LEFT JOIN `Order` O ON O.order_id = OVR.order_id
    WHERE O.restaurant_id = p_restaurant_id
	GROUP BY restaurant_id INTO avg_rating;
  RETURN avg_rating; 
END
//


SELECT restaurant_id, coalesce(avg_restaurant_rating(restaurant_id),'No Rating for this resturant') AS Rating
from campus_eats_fall2020.order;

DROP FUNCTION IF EXISTS avg_Driver_rating;
DELIMITER //
  
CREATE FUNCTION avg_Driver_rating(p_driver_id INT) 
RETURNS DECIMAL(3,2) DETERMINISTIC
BEGIN 
	DECLARE avg_rating DECIMAL(3,2);
	SELECT ROUND(AVG(Rating_Driver_Qstn_1+Rating_Driver_Qstn_2+Rating_Driver_Qstn_3+Rating_Driver_Qstn_4)/4, 2) as driver_avg_rating
	FROM driverrating DR 
    LEFT JOIN overallrating OVR ON DR.Rating_id=OVR.Rating_id
    LEFT JOIN `Order` O ON O.order_id = OVR.order_id
    WHERE O.driver_id = p_driver_id
	GROUP BY driver_id INTO avg_rating;
  RETURN avg_rating; 
END
//


SELECT distinct driver_id, coalesce(avg_Driver_rating(driver_id),'No Rating for this driver') AS Rating
from campus_eats_fall2020.order;