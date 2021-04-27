CREATE ROLE 'ce_user','ce_admin'  ;

CREATE USER 'haps_user'@'localhost' IDENTIFIED BY 'pa55word';
CREATE USER 'jay_admin'@'localhost' IDENTIFIED BY 'pa55word';

GRANT 'ce_user' TO 'haps_user'@'localhost';
GRANT 'ce_admin' TO 'jay_admin'@'localhost';

Grant all on campus_eats_fall2020 to ce_admin;
grant  select on campus_eats_fall2020.* to ce_user;

CREATE VIEW view_haps AS
    SELECT 
        *
    FROM
        restaurant
    WHERE
        restaurant_id = 1;

GRANT SELECT, UPDATE
ON view_haps
to haps_user@localhost