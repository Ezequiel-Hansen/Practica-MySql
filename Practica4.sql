use `agencia_personal`;

select E.razon_social "Razon social", sum(importe_comision) "Importe" from `empresas` E
	INNER JOIN `solicitudes_empresas` SE ON E.cuit=SE.cuit
    INNER JOIN `contratos` C ON C.cuit=SE.cuit and SE.cod_cargo=C.cod_cargo and SE.fecha_solicitud= C.fecha_solicitud
    INNER JOIN `comisiones` COM ON COM.nro_contrato=C.nro_contrato
    WHERE E.razon_social= "Traigame eso" and fecha_pago is not null;
    
    
select E.razon_social "Razon social", sum(importe_comision) "Importe" from `empresas` E
	INNER JOIN `solicitudes_empresas` SE ON E.cuit=SE.cuit
    INNER JOIN `contratos` C ON C.cuit=SE.cuit and SE.cod_cargo=C.cod_cargo and SE.fecha_solicitud= C.fecha_solicitud
    INNER JOIN `comisiones` COM ON COM.nro_contrato=C.nro_contrato
    WHERE fecha_pago is not null group by E.cuit, E.razon_social;
    
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
