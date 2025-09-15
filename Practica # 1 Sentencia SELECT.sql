-- PRACTICA SQL 1TUP1 2025

-- Practica en Clase: 1 – 3 – 4 – 6 – 7 – 11
-- Práctica Complementaria: 2 – 5 – 8 – 9 – 10 – 12 – 14


-- 1) Mostrar la estructura de la tabla Empresas. Seleccionar toda la información de la misma.
USE `agencia_personal`;
DESCRIBE `agencia_personal`.`empresas`;
SELECT * FROM `agencia_personal`.`empresas`;

-- 2) Mostrar la estructura de la tabla Personas. Mostrar el apellido y nombre y la fecha de
-- registro en la agencia.

DESCRIBE `agencia_personal`.`personas`;

-- 3) Guardar el siguiente query en un archivo de extensión .sql, para luego correrlo.
-- Mostrar los títulos con el formato de columna: Código Descripción y Tipo ordenarlo
-- alfabéticamente por descripción.

SELECT cod_titulo "Código", desc_titulo "Descripción", tipo_titulo "Tipo" 
FROM titulos order by desc_titulo;

SELECT * FROM `agencia_personal`.`titulos`
INTO OUTFILE '/home/ezequiel-hansen/Descargas/titulos.sql'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

-- Error Code: 1290. The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
-- indica que MySQL está configurado para permitir la exportación de archivos solo a un directorio específico por 
-- razones de seguridad. Este comportamiento está controlado por la opción --secure-file-priv, que restringe las 
-- operaciones de importación y exportación a una carpeta definida en la configuración de MySQL.
-- veamos donde se pueden escribir estos archivos...
SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM titulos 
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\titulos.txt'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';


-- 4) Mostrar de la persona con DNI nro. 28675888, nombre y apellido, fecha de
-- nacimiento, teléfono y su dirección.
-- Las cabeceras de las columnas serán:
-- |Apellido y Nombre (concatenados)  |Fecha Nac.|Teléfono  |Dirección               |
SELECT concat(apellido , ",", nombre)"Apellido y Nombre",DATE_FORMAT(fecha_nacimiento, "%d/%m/%Y")"Fecha Nac",Telefono"Telefono",direccion"Direccion" FROM `agencia_personal`.`personas` WHERE dni="28675888";

-- 5) Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y
-- 31345778. Ordenadas por fecha de Nacimiento

SELECT concat(apellido , ",", nombre)"Apellido y Nombre",DATE_FORMAT(fecha_nacimiento, "%d/%m/%Y")"Fecha Nac",Telefono"Telefono",direccion"Direccion" FROM `agencia_personal`.`personas` WHERE (dni="27890765" OR dni="29345777" OR dni="31345778");
-- 6) Mostrar las personas cuyo apellido empiece con la letra ‘G’.
SELECT * FROM `agencia_personal`.`personas` WHERE apellido LIKE 'G%';

-- 7) Mostrar el nombre, apellido y fecha de nacimiento de las personas nacidas entre 1980 y 2000
SELECT nombre, apellido, fecha_nacimiento FROM `agencia_personal`.`personas` WHERE `fecha_nacimiento` BETWEEN '1980-01-01' AND '2000-12-31';

-- 8) Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente
-- por fecha de solicitud.
SELECT * FROM `agencia_personal`.`antecedentes` WHERE fecha_hasta IS NULL;

-- 9) Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral
-- ordenados por fecha desde.
SELECT * FROM `agencia_personal`.`antecedentes` ORDER BY fecha_desde;
-- 10) Mostrar aquellos antecedentes laborales que finalizaron y cuya fecha hasta no esté entre
-- junio del 2013 a diciembre de 2013, ordenados por número de DNI del empleado.
SELECT * FROM `agencia_personal`.`antecedentes` WHERE fecha_hasta IS NOT NULL AND fecha_hasta NOT BETWEEN '2013-06-01' AND '2013-12-31' ORDER BY dni;		

-- 11) Mostrar los contratos cuyo salario sea mayor que 2000 y trabajen en las empresas 30-10504876-5 o 30-21098732-4.
-- Rotule el encabezado:
-- |Nro Contrato                |DNI             |Salario           |CUIL               |
SELECT nro_contrato, dni, sueldo, cuit FROM `agencia_personal`.`contratos` WHERE sueldo > 2000 AND (cuit= '30-10504876-5' OR cuit= '30-21098732-4');

-- 12) Mostrar los títulos técnicos
SELECT * FROM `agencia_personal`.`titulos` WHERE desc_titulo LIKE 'Tecnico%';

-- 13) Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ y el código de cargo
-- sea 6; o hayan solicitado aspirantes de sexo femenino
SELECT * FROM `agencia_personal`.`solicitudes_empresas` WHERE fecha_solicitud > '2013-09-21' AND (cod_cargo LIKE 6 OR sexo= 'Femenino');

-- 14) Seleccionar los contratos con un salario pactado mayor que 2000 y que no hayan sido
-- terminado.
SELECT * FROM `agencia_personal`.`contratos` WHERE sueldo > 2000 AND fecha_caducidad IS NULL;
