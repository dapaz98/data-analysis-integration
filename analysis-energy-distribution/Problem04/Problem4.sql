--
-- Análise e Integração de Dados
--  Prof. Paulo Carreira
--  Prof. Luís Sousa
--  Student Ygor Acacio Maria
--  Student Eduardo
---

DROP TABLE IF EXISTS Time_Dimension;
CREATE TABLE Time_Dimension (
    time_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    season ENUM('summer', 'autumn', 'winter', 'spring') NOT NULL,
    month INT NOT NULL
);


DROP TABLE IF EXISTS Location_Dimension;
CREATE TABLE Location_Dimension (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(255) NOT NULL,
    municipality VARCHAR(255) NOT NULL,
    parish VARCHAR(255) NOT NULL
);


DROP TABLE IF EXISTS Energy_Fact;
CREATE TABLE Energy_Fact (
    fact_id INT AUTO_INCREMENT PRIMARY KEY,
    time_id INT,
    location_id INT,
    energy_consumption DECIMAL(10, 2) NOT NULL,
    smart_meter_percentage DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (time_id) REFERENCES Time_Dimension(time_id),
    FOREIGN KEY (location_id) REFERENCES Location_Dimension(location_id)
);
