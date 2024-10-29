DROP DATABASE IF EXISTS energy_consumption_dw;
CREATE DATABASE energy_consumption_dw;

USE energy_consumption_dw;

DROP TABLE IF EXISTS dim_time;
CREATE TABLE dim_time (
    id_time INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    season ENUM('summer', 'autumn', 'winter', 'spring') NOT NULL,
    month INT NOT NULL
);


DROP TABLE IF EXISTS dim_location;
CREATE TABLE dim_location (
    id_location INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(255) NOT NULL,
    municipality VARCHAR(255) NOT NULL,
    parish VARCHAR(255) NOT NULL
);


DROP TABLE IF EXISTS fact_energy_consumption;
CREATE TABLE fact_energy_consumption (
    id_fact INT AUTO_INCREMENT PRIMARY KEY,
    id_time INT,
    id_location INT,
    energy_consumption DECIMAL(10, 2) NOT NULL,
    smart_meter_percentage DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (id_time) REFERENCES dim_time(id_time),
    FOREIGN KEY (id_location) REFERENCES dim_location(id_location)
);
