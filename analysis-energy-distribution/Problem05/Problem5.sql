--
-- Análise e Integração de Dados
--  Prof. Paulo Carreira
--  Prof. Luís Sousa
--  Student Ygor Acacio Maria
--  Student Eduardo
---

DROP TABLE IF EXISTS time_Dimension;
CREATE TABLE time_Dimension (
    time_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    season ENUM('summer', 'autumn', 'winter', 'spring') NOT NULL,
    month INT NOT NULL
);

DROP PROCEDURE IF EXISTS populate_time_dimension;
DELIMITER $$

CREATE PROCEDURE populate_time_dimension()
BEGIN
    DECLARE current_date DATE;
    DECLARE end_date DATE;

    -- Initialize the start date and end date
    SET current_date = '2018-01-01';
    SET end_date = '2023-12-31';

    -- Loop through each month in the date range
    WHILE current_date <= end_date DO
        INSERT INTO time_dimension (
            time_id,
            year,
            season,
            month
        )
        VALUES (
            
            -- Time ID format: YYYYMM
            YEAR(current_date) * 100000000 + MONTH(current_date) * 1000000
           
            -- Year
            YEAR(current_date),
            
            -- Season based on month
            CASE
                WHEN MONTH(current_date) IN (12, 1, 2) THEN 'winter'
                WHEN MONTH(current_date) IN (3, 4, 5) THEN 'spring'
                WHEN MONTH(current_date) IN (6, 7, 8) THEN 'summer'
                WHEN MONTH(current_date) IN (9, 10, 11) THEN 'autumn'
            END,
            
            -- Month
            MONTH(current_date),
        );

        SET current_date = DATE_ADD(current_date, INTERVAL 1 MONTH);
    END WHILE;
END$$

DELIMITER ;

CALL populate_time_dimension();




DROP TABLE IF EXISTS location_Dimension;
CREATE TABLE location_Dimension (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(255) NOT NULL,
    municipality VARCHAR(255) NOT NULL,
    parish VARCHAR(255) NOT NULL
);

DROP PROCEDURE IF EXISTS populate_location_dimension;
DELIMITER $$

CREATE PROCEDURE populate_location_dimension()
BEGIN
    
    INSERT INTO location_dimension (region, municipality, parish)
    VALUES 
        ('SANTAREM', 'Santarém', 'MOCARRIA'),
        ('VISEU', 'Armamar', 'SAO MARTINHO DAS CHAS'),
        ('VISEU', 'Vouzela', 'VENTOSA'),
        ('AVEIRO', 'Espinho', 'UF ANTA E GUETIM'),
        ('BRAGA', 'Barcelos', 'UF TAMEL E VILAR DO MONTE'),
        ('BRAGA', 'Fafe', 'UF AGRELA E SERAFAO'),
        ('COIMBRA', 'Coimbra', 'CEIRA'),
        ('GUARDA', 'Gouveia', 'SAO PAIO'),
        ('PORTO', 'Felgueiras', 'JUGUEIROS'),
        ('SANTAREM', 'Abrantes', 'MOURISCAS'),
        ('SANTAREM', 'Torres Novas', 'UF BROGUEIRA P IGREJA ALCOROCH'),
        ('VIANA DO CASTELO', 'Arcos de Valdevez', 'AZERE'),
        ('VISEU', 'Tarouca', 'VARZEA DA SERRA'),
        ('AVEIRO', 'Aveiro', 'ESGUEIRA'),
        ('CASTELO BRANCO', 'Vila de Rei', 'FUNDADA'),
        ('COIMBRA', 'Condeixa-a-Nova', 'UF CONDEIXA-A-VELHA E C-A-NOVA'),
        ('GUARDA', 'Gouveia', 'RIBAMONDEGO'),
        ('SANTAREM', 'Vila Nova da Barquinha', 'PRAIA DO RIBATEJO'),
        ('SETUBAL', 'Almada', 'UF CHARNECA CAPARICA SOBREDA'),
        ('BRAGA', 'Cabeceiras de Basto', 'CAVEZ'),
        ('EVORA', 'Évora', 'CANAVIAIS'),
        ('GUARDA', 'Pinhel', 'AF SUL DE PINHEL'),
        ('GUARDA', 'Vila Nova de Foz Côa', 'MUXAGATA'),
        ('LISBOA', 'Lourinhã', 'MOITA DOS FERREIROS'),
        ('LISBOA', 'Sintra', 'CASAL DE CAMBRA'),
        ('PORTO', 'Baião', 'UF CAMPELO E OVIL'),
        ('PORTO', 'Penafiel', 'EJA'),
        ('SETUBAL', 'Setúbal', 'UF SETUBAL'),
        ('VIANA DO CASTELO', 'Melgaço', 'FIAES');
END$$

DELIMITER ;

CALL populate_location_dimension();



DROP TABLE IF EXISTS energy_Fact;
CREATE TABLE energy_Fact (
    fact_id INT AUTO_INCREMENT PRIMARY KEY,
    time_id INT,
    location_id INT,
    energy_consumption DECIMAL(10, 2) NOT NULL,
    smart_meter_percentage DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (time_id) REFERENCES Time_Dimension(time_id),
    FOREIGN KEY (location_id) REFERENCES Location_Dimension(location_id)
);
