use `agencia_personal`;
-- 1) Para aquellos contratos que no hayan terminado calcular la fecha de caducidad
-- como la fecha de solicitud más 30 días (no actualizar la base de datos).
select nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato, date_add(fecha_solicitud, interval 1 MONTH) 
from `agencia_personal`.`contratos`
where fecha_caducidad is null;

-- 2) Mostrar los contratos. Indicar nombre y apellido de la persona, razón social de la
-- empresa fecha de inicio del contrato y fecha de caducidad del contrato. Si la fecha no ha
-- terminado mostrar “Contrato Vigente”.
select nro_contrato, razon_social, concat(apellido, " ", nombre), fecha_incorporacion, ifnull(fecha_caducidad,"Contrato Vigente") from `agencia_personal`.`personas` P
INNER JOIN `agencia_personal`.`contratos` CON ON P.dni=CON.dni
INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON CON.cuit=SE.cuit and CON.cod_cargo=SE.cod_cargo and CON.fecha_solicitud=SE.fecha_solicitud
INNER JOIN `agencia_personal`.`empresas` EM ON SE.cuit=EM.cuit;
-- 3) Para aquellos contratos que terminaron antes de la fecha de finalización, indicar la
-- cantidad de días que finalizaron antes de tiempo.
select nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato,fecha_caducidad, sueldo, porcentaje_comision, dni, cuit, cod_cargo, fecha_solicitud, datediff(fecha_finalizacion_contrato,fecha_caducidad) 
from `agencia_personal`.`contratos` CON 
where datediff(fecha_finalizacion_contrato,fecha_caducidad)>=1;

-- 4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, razón social de la
-- empresa y dirección, año y mes de la comisión, importe y la fecha de vencimiento que se
-- calcula como la fecha actual más dos meses. 
select EM.cuit, razon_social, direccion, anio_contrato, mes_contrato, importe_comision, date_add(current_date(), interval 2 MONTH) from `agencia_personal`.`comisiones`COM
INNER JOIN `agencia_personal`.`contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `agencia_personal`.`solicitudes_empresas`SE ON CON.cuit=SE.cuit and CON.cod_cargo=SE.cod_cargo and CON.fecha_solicitud=SE.fecha_solicitud
INNER JOIN `agencia_personal`.`empresas` EM ON SE.cuit=EM.cuit
where fecha_pago is null;

-- 5) Mostrar en qué día mes y año nacieron las personas (mostrarlos en columnas
-- separadas) y sus nombres y apellidos concatenados.
select concat(nombre," ",apellido) "Nombre y Apellido", fecha_nacimiento, day(fecha_nacimiento)"Dia", month(fecha_nacimiento)"Mes", year(fecha_nacimiento)"Anio" 
from `agencia_personal`.`personas`;