-- Práctica Nº 2: JOINS
-- Practica en Clase: 1 – 2 – 6 – 7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 – 9 – 13
-- BASE DE DATOS: AGENCIA_PERSONAL
USE `agencia_personal`;
-- 1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
-- sueldo acordado en el contrato
-- |nombre |apellido |sueldo |dni|
SELECT nombre "nombre", apellido "apellido", sueldo "sueldo",P.dni "DNI" FROM `agencia_personal`.`personas` P INNER JOIN `agencia_personal`.`contratos`C ON P.dni=C.dni WHERE C.nro_contrato=5;


-- 2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
-- Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
-- agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
-- ‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa
-- | Dni |nro_contrato|fecha_incorporacion|fecha_solicitud|fecha_caducidad|
SELECT dni "DNI", nro_contrato "nro_contrato", fecha_incorporacion "FECHA INCORPORACION", fecha_solicitud "FECHA SOLICITUD", IFnull(fecha_caducidad, "Sin Fecha") "FECHA CADUCIDAD" 
FROM `agencia_personal`.`empresas` E 
INNER JOIN `agencia_personal`.`contratos`C ON E.cuit=C.cuit 
WHERE E.razon_social IN ("Viejos Amigos", "Tráigame Eso") ORDER BY fecha_solicitud, razon_social;

-- 6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
-- Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
-- Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia
-- S.A

SELECT DISTINCT concat(apellido, ", " , nombre,  IFnull(concat(" tiene como referencia a ", persona_contacto), " no tiene contacto"), " cuando trabajo en ",  razon_social) "mensaje" 
FROM `agencia_personal`.`personas` P LEFT JOIN `agencia_personal`.`antecedentes` A ON P.dni=A.dni
LEFT JOIN `agencia_personal`.`empresas` E ON A.cuit=E.cuit
WHERE persona_contacto IS NULL OR persona_contacto IN ("Armando Esteban Quito", "Felipe Rojas");

SELECT A.*, concat(apellido, ", " , nombre,  IFnull(concat(" tiene como referencia a ", persona_contacto), " no tiene contacto"), " cuando trabajo en ",  razon_social) "mensaje" 
FROM `agencia_personal`.`personas` P LEFT JOIN `agencia_personal`.`antecedentes` A ON P.dni=A.dni
LEFT JOIN `agencia_personal`.`empresas` E ON A.cuit=E.cuit
WHERE persona_contacto IS NULL OR persona_contacto IN ("Armando Esteban Quito", "Felipe Rojas");

-- 7) Seleccionar para la empresa Viejos amigos, fechas de solicitudes, descripción del
-- cargo solicitado y edad máxima y mínima . Encabezado:
-- |Empresa Fecha  |Solicitud    |Cargo Edad Mín    |Edad Máx    |

-- 8) Mostrar los antecedentes de cada postulante: 

-- 9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
-- ascendente por empresa y descendente por cargo:

-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
-- y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
-- leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.

-- 11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
-- y si se hubiese realizado un contrato los datos de la(s) persona(s).

-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
-- las solicitudes para las cuales no se haya realizado un contrato.


-- 13) Listar todos los cargos y para aquellos que hayan sido realizados (como
-- antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
-- lo ocupó.

-- 14) Indicar todos los instructores que tengan un supervisor.

-- 15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
-- campos en blanco

-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.
-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.
