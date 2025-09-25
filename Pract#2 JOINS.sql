-- Práctica Nº 2: JOINS
-- Practica en Clase: 1 – 2 – 6 – 7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 – 9 – 13
-- BASE DE DATOS: AGENCIA_PERSONAL
USE `agencia_personal`;
-- 1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
-- sueldo acordado en el contrato
-- |nombre |apellido |sueldo |dni|
SELECT nombre "nombre", apellido "apellido", sueldo "sueldo",P.dni "DNI" 
FROM `agencia_personal`.`personas` P INNER JOIN `agencia_personal`.`contratos`C ON P.dni=C.dni 
WHERE C.nro_contrato=5;

-- 2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
-- Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
-- agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
-- ‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa
-- | Dni |nro_contrato|fecha_incorporacion|fecha_solicitud|fecha_caducidad|
SELECT dni "DNI", nro_contrato "nro_contrato", fecha_incorporacion "FECHA INCORPORACION", fecha_solicitud "FECHA SOLICITUD", IFnull(fecha_caducidad, "Sin Fecha") "FECHA CADUCIDAD" 
FROM `agencia_personal`.`empresas` E 
INNER JOIN `agencia_personal`.`contratos`C ON E.cuit=C.cuit 
WHERE E.razon_social IN ("Viejos Amigos", "Tráigame Eso") ORDER BY fecha_solicitud, razon_social;

 -- 3) Listado de las solicitudes consignando razón social, dirección y e_mail de la
-- empresa, descripción del cargo solicitado y años de experiencia solicitados, ordenado por
-- fecha d solicitud y descripción de cargo.
SELECT E.razon_social, E.direccion, E.e_mail, C.desc_cargo, ifnull(SE.anios_experiencia ,"Sin experiencia") FROM `agencia_personal`.`empresas` E
INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit= SE.cuit
INNER JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo
ORDER BY fecha_solicitud;

-- 4) Listar todos los candidatos con título de bachiller o un título de educación no
-- formal. Mostrar nombre y apellido, descripción del título y DNI
SELECT P.dni, P.nombre, P.apellido, T.desc_titulo FROM `agencia_personal`.`personas` P
INNER JOIN `agencia_personal`.`personas_titulos`PT ON P.dni= PT.dni
INNER JOIN `agencia_personal`.`titulos` T ON PT.cod_titulo= T.cod_titulo
WHERE desc_titulo= "Bachiller" OR tipo_titulo="Educacion no formal";

-- 5) Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.
SELECT P.nombre, P.apellido, T.desc_titulo FROM `agencia_personal`.`personas` P
INNER JOIN `agencia_personal`.`personas_titulos`PT ON P.dni= PT.dni
INNER JOIN `agencia_personal`.`titulos` T ON PT.cod_titulo= T.cod_titulo;

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
SELECT razon_social "Empresa", date_format(fecha_solicitud ,"%d-%m-%Y")"Fecha-Solicitud", desc_cargo "Cargo", ifnull(edad_minima, "Sin especificar") "Edad min", ifnull(edad_maxima, "Sin especificar") "Edad max" 
FROM `agencia_personal`.`empresas` E RIGHT JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
LEFT JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo
WHERE razon_social= "Viejos Amigos";

-- 8) Mostrar los antecedentes de cada postulante: 
SELECT concat(P.nombre, ' ', P.apellido) AS "Nombre Apellido", desc_cargo "Cargo" FROM `agencia_personal`.`personas` P LEFT JOIN `agencia_personal`.`antecedentes` A ON P.dni=A.dni
RIGHT JOIN `agencia_personal`.`cargos` C ON A.cod_cargo=C.cod_cargo WHERE nombre or apellido is not null ;

-- 9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
-- ascendente por empresa y descendente por cargo:
SELECT E.razon_social "Empresa", C.desc_cargo "Cargo", EV.desc_evaluacion, EE.resultado 
FROM `agencia_personal`.`empresas` E inner join `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
inner join `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo
inner join `agencia_personal`.`entrevistas`EN ON SE.cuit=EN.cuit and SE.cod_cargo=EN.cod_cargo and SE.fecha_solicitud=EN.fecha_solicitud
inner join `agencia_personal`.`entrevistas_evaluaciones` EE ON EN.nro_entrevista=EE.nro_entrevista
inner JOIN `agencia_personal`.`evaluaciones` EV ON EE.cod_evaluacion=EV.cod_evaluacion 
ORDER BY E.razon_social ASC, C.desc_cargo DESC;

-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
-- y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
-- leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.
SELECT E.cuit, E.razon_social, ifnull(date_format( SE.fecha_solicitud , "%d-%m-%Y"), 'Sin solicitud') "Fecha Solicitud", ifnull(C.desc_cargo, 'Sin solicitud') "Cargo"
FROM `agencia_personal`.`empresas` E LEFT JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
LEFT JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo;

-- 11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
-- y si se hubiese realizado un contrato los datos de la(s) persona(s).
SELECT E.cuit, E.razon_social, C.desc_cargo, ifnull(P.dni, 'sin contrato') "dni", ifnull(P.apellido, 'sin contrato') "Apellido", ifnull(P.nombre, 'sin contrato') "Nombre" FROM `agencia_personal`.`empresas` E 
inner join `agencia_personal`.`solicitudes_empresas` SE ON SE.cuit=E.cuit
inner join `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo
left join `agencia_personal`.`contratos` CO ON C.cod_cargo=CO.cod_cargo and SE.cuit= CO.cuit and SE.fecha_solicitud=CO.fecha_solicitud
left join `agencia_personal`.`personas` P ON P.dni=CO.dni;

-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
-- las solicitudes para las cuales no se haya realizado un contrato.
SELECT E.cuit, E.razon_social, C.desc_cargo FROM `agencia_personal`.`empresas` E
INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON SE.cuit= E.cuit
INNER JOIN `agencia_personal`.`cargos` C ON C.cod_cargo= SE.cod_cargo 
LEFT JOIN `agencia_personal`.`contratos` CO ON CO.cuit= SE.cuit and CO.cod_cargo= SE.cod_cargo and CO.fecha_solicitud= SE.fecha_solicitud
WHERE nro_contrato IS NULL ;

-- 13) Listar todos los cargos y para aquellos que hayan sido realizados (como
-- antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
-- lo ocupó.
SELECT * FROM `agencia_personal`.`cargos` C
LEFT JOIN `agencia_personal`.`antecedentes` A ON E.cuit= A.cuit and C.cod_cargo=A.cod_cargo
LEFT JOIN `agencia_personal`.`personas` P ON P.dni= A.dni
LEFT JOIN `agencia_personal`.`empresa` E ON A.cuit=E.cuit;

-- BD: aftse
-- 14) Indicar todos los instructores que tengan un supervisor.
USE `afatse`;

SELECT 	INS.cuil "Cuil Instructor", INS.nombre "Nombre Instructor", INS.apellido "Apellido Instructor",
SUP.cuil "Cuil Supervisor", SUP.nombre "Nombre Supervisor", SUP.apellido "Apellido Supervisor" 
FROM `afatse`.`instructores` INS
INNER JOIN `afatse`.`instructores` SUP ON INS.cuil_supervisor= SUP.cuil
WHERE INS.cuil_supervisor IS NOT NULL;

-- 15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
-- campos en blanco
SELECT 	INS.cuil "Cuil Instructor", INS.nombre "Nombre Instructor", INS.apellido "Apellido Instructor",
ifnull(SUP.cuil, "") "Cuil Supervisor", ifnull(SUP.nombre , "")"Nombre Supervisor", ifnull(SUP.apellido, "") "Apellido Supervisor" 
FROM `afatse`.`instructores` INS
LEFT JOIN `afatse`.`instructores` SUP ON INS.cuil_supervisor= SUP.cuil;

-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.
