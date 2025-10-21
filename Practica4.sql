use `agencia_personal`;
-- 1) Mostrar las comisiones pagadas por la empresa Tráigame eso
SELECT E.razon_social "Razon social", sum(importe_comision) "Importe" FROM `empresas` E
	INNER JOIN `solicitudes_empresas` SE ON E.cuit=SE.cuit
    INNER JOIN `contratos` C ON C.cuit=SE.cuit AND SE.cod_cargo=C.cod_cargo AND SE.fecha_solicitud= C.fecha_solicitud
    INNER JOIN `comisiones` COM ON COM.nro_contrato=C.nro_contrato
    WHERE E.razon_social= "Traigame eso" AND fecha_pago IS NOT NULL;
    
-- 2) Ídem 1) pero para todas las empresas.
SELECT E.razon_social "Razon social", sum(importe_comision) "Importe" FROM `empresas` E
	INNER JOIN `solicitudes_empresas` SE ON E.cuit=SE.cuit
    INNER JOIN `contratos` C ON C.cuit=SE.cuit AND SE.cod_cargo=C.cod_cargo AND SE.fecha_solicitud= C.fecha_solicitud
    INNER JOIN `comisiones` COM ON COM.nro_contrato=C.nro_contrato
    WHERE fecha_pago is not null group by E.cuit, E.razon_social;

-- 3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
-- evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
-- en forma ascendente y luego por desviación estándar en forma descendente.
SELECT 
	ENT.nombre_entrevistador "Entrevistador", 
	EE.desc_evaluacion "Tipo", 
	AVG(EVA.resultado) "Promedio",
    STD(EVA.resultado) "Desvio estandar",
    VARIANCE(EVA.resultado) "Varianza"
    FROM `entrevistas` ENT
	INNER JOIN `entrevistas_evaluaciones` EVA ON ENT.nro_entrevista=EVA.nro_entrevista
    INNER JOIN `evaluaciones` EE ON EVA.cod_evaluacion=EE.cod_evaluacion
	GROUP BY ENT.nombre_entrevistador, EVA.cod_evaluacion
    ORDER BY AVG(EVA.resultado)ASC, STD(EVA.resultado) DESC;
-- 4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
-- de evaluación.
SELECT 
	ENT.nombre_entrevistador "Entrevistador", 
	EE.desc_evaluacion "Tipo", 
	AVG(EVA.resultado) "Promedio",
    STD(EVA.resultado) "Desvio estandar",
    VARIANCE(EVA.resultado) "Varianza"
    FROM `entrevistas` ENT
	INNER JOIN `entrevistas_evaluaciones` EVA ON ENT.nro_entrevista=EVA.nro_entrevista
    INNER JOIN `evaluaciones` EE ON EVA.cod_evaluacion=EE.cod_evaluacion
	WHERE nombre_entrevistador= "Angelica Doria"
	GROUP BY ENT.nombre_entrevistador, EVA.cod_evaluacion
    HAVING AVG(EVA.resultado) > 71
    ORDER BY AVG(EVA.resultado)ASC, STD(EVA.resultado) DESC;
    
-- 5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014.

SELECT ENT.nombre_entrevistador,COUNT(ENT.fecha_entrevista)
    FROM `entrevistas` ENT;

-- 6) Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad.
-- Ordenado por cantidad de entrevistas.
SELECT 
	ENT.nombre_entrevistador "Entrevistador", COUNT(*) "Cantidad",
	EE.desc_evaluacion "Tipo", 
	AVG(EVA.resultado) "Promedio",
    STD(EVA.resultado) "Desvio estandar",
    VARIANCE(EVA.resultado) "Varianza"
    FROM `entrevistas` ENT
	INNER JOIN `entrevistas_evaluaciones` EVA ON ENT.nro_entrevista=EVA.nro_entrevista
    INNER JOIN `evaluaciones` EE ON EVA.cod_evaluacion=EE.cod_evaluacion
	GROUP BY ENT.nombre_entrevistador, EVA.cod_evaluacion
    HAVING AVG(EVA.resultado) > 71
    ORDER BY COUNT(*);
    
    
-- 7) Ídem 6) para aquellos cuya cantidad de entrevistas por c'okdigo de evalucaicpon
-- sea myor mayor que 1. Ordenado por nombre en forma descendente y por codigo de
-- evalucacion en forma ascendente
SELECT 
	ENT.nombre_entrevistador "Entrevistador", COUNT(*) "Cantidad", EE.cod_evaluacion "Cod Evaluacion",
	EE.desc_evaluacion "Tipo", 
	AVG(EVA.resultado) "Promedio",
    STD(EVA.resultado) "Desvio estandar",
    VARIANCE(EVA.resultado) "Varianza"
    FROM `entrevistas` ENT
	INNER JOIN `entrevistas_evaluaciones` EVA ON ENT.nro_entrevista=EVA.nro_entrevista
    INNER JOIN `evaluaciones` EE ON EVA.cod_evaluacion=EE.cod_evaluacion
    GROUP BY EE.cod_evaluacion, ENT.nombre_entrevistador
    HAVING COUNT(EE.cod_evaluacion) > 1
    ORDER BY EE.cod_evaluacion ASC;

    -- 8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar,
-- cantidad a pagadas.
SELECT C.nro_contrato "Contrato", COUNT(*) "Total", COUNT(IFNULL(COM.fecha_pago, NULL)) "Pagadas", COUNT(*) - COUNT(IFNULL(COM.fecha_pago, NULL)) "A pagar" 
    FROM `contratos` C 
    INNER JOIN `comisiones` COM ON COM.nro_contrato=C.nro_contrato
	GROUP BY C.nro_contrato;
    
-- 9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
-- el % de impagas.
SELECT C.nro_contrato, 
COUNT(*) "Cant Comisiones", 
ROUND(COUNT(fecha_pago)/COUNT(*),2)*100 "% de comisiones pagas",
100 - ROUND(COUNT(fecha_pago)/COUNT(*),2)*100 "% de comisiones a pagar"
FROM `agencia_personal`.`contratos` C 
INNER JOIN `agencia_personal`.`comisiones` COM ON C.nro_contrato=COM.nro_contrato
GROUP BY C.nro_contrato;
    
-- 10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
-- diferencia respecto al total de solicitudes.

SELECT COUNT(DISTINCT E.cuit) "Cantidad", COUNT(*)-COUNT(DISTINCT E.cuit) "Diferencia" FROM `agencia_personal`.`empresas` E 
INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit;

-- 11) Cantidad de solicitudes por empresas.
SELECT E.cuit, E.razon_social, COUNT(*) FROM `agencia_personal`.`empresas` E 
INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
GROUP BY E.cuit
ORDER BY COUNT(*) DESC;

-- 12) Cantidad de solicitudes por empresas y cargos.
SELECT E.cuit, E.razon_social, C.desc_cargo "Desc. Cargo", COUNT(*) from `agencia_personal`.`empresas` E 
INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
INNER JOIN `agencia_personal`.`cargos`C ON SE.cod_cargo=C.cod_cargo
GROUP BY E.cuit, C.cod_cargo
ORDER BY COUNT(*);

-- 13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
-- que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
-- mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.
SELECT EM.cuit, razon_social, count(DISTINCT AN.dni) "Cant de Personas" FROM `agencia_personal`.`empresas` EM
LEFT JOIN `agencia_personal`.`antecedentes` AN ON EM.cuit=AN.cuit
GROUP BY EM.cuit;

-- 14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
-- forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
-- 0. Agregar algún cargo que nunca haya sido solicitado.
SELECT C.cod_cargo, desc_cargo, count(cuit) FROM `agencia_personal`.`cargos` C
LEFT JOIN `agencia_personal`.`solicitudes_empresas` SE ON C.cod_cargo=SE.cod_cargo
GROUP BY C.cod_cargo
ORDER BY count(cuit) DESC;

-- 15) Indicar los cargos que hayan sido solicitados menos de 2 veces.
SELECT C.cod_cargo, desc_cargo, count(cuit) FROM `agencia_personal`.`cargos` C
LEFT JOIN `agencia_personal`.`solicitudes_empresas` SE ON C.cod_cargo=SE.cod_cargo
GROUP BY C.cod_cargo
HAVING count(cuit)<2;
