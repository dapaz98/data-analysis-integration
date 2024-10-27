--
-- Análise e Integração de Dados
--  Prof. Paulo Carreira
--  Prof. Luís Sousa
---

DROP TABLE IF EXISTS date_dimension;
CREATE TABLE date_dimension (
    date_id INT NOT NULL,
    date_value CHAR(10) NOT NULL,
    calendar_date DATE NOT NULL,
    year_number INT NOT NULL,
    is_leap_year BOOLEAN NOT NULL,
    quarter_number INT NOT NULL,
    month_name VARCHAR(9) NOT NULL,
    month_number INT NOT NULL,
    month_start_date DATE NOT NULL,
    month_end_date DATE NOT NULL,
    month_days INT NOT NULL,
    month_days_number INT NOT NULL,
    week_number INT NOT NULL,
    week_day_number INT NOT NULL,
    week_day_name VARCHAR(9) NOT NULL,
    week_day_type VARCHAR(7) NOT NULL,
    week_start_date DATE NOT NULL,
    week_end_date DATE NOT NULL
);

DROP PROCEDURE IF EXISTS populate_date_dimension;
DELIMITER $$

CREATE PROCEDURE populate_date_dimension()
BEGIN
    DECLARE todays_date DATE;
    DECLARE end_date DATE;

    -- Initialize the start and end dates
    SET todays_date = '2018-01-01';
    SET end_date = '2030-12-31';

    -- Loop through each date
    WHILE todays_date <= end_date DO
        INSERT INTO date_dimension (
            date_id,
            date_value,
            calendar_date,
            year_number,
            is_leap_year,
            quarter_number,
            month_name,
            month_number,
            month_start_date,
            month_end_date,
            month_days,
            month_days_number,
            week_number,
            week_day_number,
            week_day_name,
            week_day_type,
            week_start_date,
            week_end_date
        )
        VALUES (
            -- Date ID format: YYYYMMDD
            YEAR(todays_date) * 10000 + MONTH(todays_date) * 100 + DAY(todays_date),
            -- Date as a string
            DATE_FORMAT(todays_date, '%Y-%m-%d'),
            -- Calendar date
            todays_date,
            -- Year number
            YEAR(todays_date),
            -- Leap year check
            IF(YEAR(todays_date) % 4 = 0 AND (YEAR(todays_date) % 100 != 0 OR YEAR(todays_date) % 400 = 0), 1, 0),
            -- Quarter number
            QUARTER(todays_date),
            -- Month name
            MONTHNAME(todays_date),
            -- Month number
            MONTH(todays_date),
            -- Month start date
            DATE_FORMAT(todays_date, '%Y-%m-01'),
            -- Month end date
            LAST_DAY(todays_date),
            -- Days in the month
            DAY(LAST_DAY(todays_date)),
            -- Day number in the month
            DAY(todays_date),
            -- Week number (Monday as the first day of the week)
            WEEK(todays_date, 1),
            -- Day of the week number (1 = Sunday, 7 = Saturday)
            DAYOFWEEK(todays_date),
            -- Day name
            DAYNAME(todays_date),
            -- Weekday or Weekend
            CASE 
                WHEN DAYOFWEEK(todays_date) IN (1, 7) THEN 'Weekend'
                ELSE 'Weekday'
            END,
            -- Start of the week
            DATE_SUB(todays_date, INTERVAL DAYOFWEEK(todays_date) - 1 DAY),
            -- End of the week
            DATE_ADD(todays_date, INTERVAL 7 - DAYOFWEEK(todays_date) DAY)
        );

        -- Increment the date by one day
        SET todays_date = DATE_ADD(todays_date, INTERVAL 1 DAY);
    END WHILE;
END$$

DELIMITER ;


-- Execute the procedure to populate the table
CALL populate_date_dimension();


DROP TABLE IF EXISTS time_dimension;
CREATE TABLE time_dimension (
    time_id INT NOT NULL,
    time_of_day TIME NOT NULL,
    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL,
    day_time_name VARCHAR(10) NOT NULL,
    day_night VARCHAR(10) NOT NULL
);

-- Populate the Time Dimension table for every minute of the day

DROP PROCEDURE IF EXISTS populate_time_dimension;

DELIMITER $$
CREATE PROCEDURE populate_time_dimension()
BEGIN
    DECLARE current_second TIME;

    -- Initialize the time and time_id
    SET current_second = '00:00:00';

    -- Loop until we reach the last second of the day
    WHILE current_second <= '23:59:59' DO
        INSERT INTO time_dimension (
            time_id,
            time_of_day,
            hour,
            minute,
            second,
            day_time_name,
            day_night
        )
        VALUES (
            -- time_id as a numeric representation of the time (HHMMSS)
            CAST(DATE_FORMAT(current_second, '%H%i%S') AS UNSIGNED),
            -- The actual time of the day
            current_second,
            -- Extract the hour part
            HOUR(current_second),
            -- Minute of the day
            HOUR(current_second) * 60 + MINUTE(current_second),
            -- Second of the current time
            SECOND(current_second),
            -- Day period based on time
            CASE
                WHEN current_second BETWEEN '06:00:00' AND '08:29:59' THEN 'Morning'
                WHEN current_second BETWEEN '08:30:00' AND '11:59:59' THEN 'AM'
                WHEN current_second BETWEEN '12:00:00' AND '17:59:59' THEN 'PM'
                WHEN current_second BETWEEN '18:00:00' AND '22:29:59' THEN 'Evening'
                ELSE 'Night'
            END,
            -- Day or Night based on time
            CASE
                WHEN current_second BETWEEN '07:00:00' AND '19:59:59' THEN 'Day'
                ELSE 'Night'
            END
        );

        -- Increment the time by 1 second
        SET current_second = ADDTIME(current_second, '00:00:01');
        SET time_id = time_id + 1;

    END WHILE;
END$$
DELIMITER ;

-- Call the procedure to populate the time_dimension table
CALL populate_time_dimension();
