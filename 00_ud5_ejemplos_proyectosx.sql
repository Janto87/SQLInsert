/*******EJEMPLOS UNIDAD 5 *******/
/*Uso del Lenguaje de Manipulación de Datos (DML):
INSERT -- insertar filas de datos
UPDATE -- modificar datos en filas
DELETE -- eliminar filas 
*/
USE proyectosx;

-- Sentencia SQL para insertar filas en una tabla
-- https://dev.mysql.com/doc/refman/8.0/en/insert.html
/*INSERT [INTO] nombre_tabla[(list_columnas)] VALUES (lista_valores)*/

-- vemos primero el contenido de la tabla departamento
select * from departamento;
-- vemos la estructura de la tabla departamento para ver su descripción
describe departamento;

-- 1)
-- insertamos un departamento de código '08', nombre 'I+D'
--  y ciudad 'Sevilla'
INSERT INTO departamento (cddep,nombre,ciudad) 
VALUES ('08','I+D', 'Sevilla');
-- comporbamos
select * from departamento;

-- 2)
/*Si insertamos valores para todas las columnas y en el mismo orden 
en que están definidas en la tabla=> se pueden omitir los nombres 
de las columnas*/
INSERT INTO departamento 
VALUES ('18','I+D', 'Sevilla');

-- 3)
/*insertamos sólo algunas columnas o las columnas en orden diferente a la tabla
-- en este caso es obligatorio indicar las columnas a las que se les dará valor*/
-- a)Insertar departamento de nombre 'Ventas' y código '99'
INSERT INTO departamento (cddep,nombre) 
VALUES ('99','Ventas');
select * from departamento; -- comprobación

-- b)Insertar departamento de nombre 'Ventas2', código '77' y ciudad 'Madrid'
INSERT INTO departamento (nombre,cddep,ciudad) 
VALUES ('Ventas2', '77','Madrid');

select * from departamento; -- comprobamos

-- 4)
/*Podrá dar ERROR, si no hay correspondencia entre las columnas a insertar 
y los valores proporcionados, 
así como si no respetamos el orden de columnas y valores*/

-- Ejemplo con error ¿Por qué da error?
INSERT INTO departamento (nombre,cddep, ciudad) 
VALUES ('11','Ventas', 'Almería');

-- 5)
/*INSERT  extendido: un sólo INSERT para insertar varias filas.
Es más eficiente que hacer 3 insert*/
INSERT departamento VALUES ('20','DEPAR20','ALMERÍA'),
('21','DEPART21','ALMERIA'), ('22','DEPART22','GRANADA');

-- comprobamos mostrando la tabla
select * from departamento;


/***************INSERT  de campos AUTONUMÉRICOS o AUTOINCREMENTAL*************/
-- Una columna AUTO_INCREMENT debe ser de tipo entero y el sistema se encarga de
-- incrementarla de forma automática.
-- Lo usual es que empiece por 1 y se incremente en 1
-- Una columna de este tipo se suele usar como clave primaria en algunas tablas.

/* Para probarlo, creamos una nueva tabla de nombre PRUEBA
con varias columnas, una de ellas un autoincremental, que será la clave primaria:
id: autonumérico o autoincremental (Primary Key)
nombre: varchar de 15
apellidos: varchar de 30
-- La creamos en una base de datos EJEMPLOS
*/
CREATE DATABASE EJEMPLOS;
use ejemplos;
CREATE TABLE prueba(
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(15),
apellidos VARCHAR(15)
);

-- Una vez creada la tabla de nombre 'prueba' vemos las formas de
-- insertar filas en tablas en las que la clave primaria es un AUTO_INCREMENT

-- 6)
/* A) Priemra forma: omitiendo la columna autoincremental (la PK)-- el sistema le 
va dando valores consecutivos, desde 1 en adelante, en cada INSERT*/
INSERT INTO prueba (nombre, apellidos)
VALUES('Daniel', 'Ro'); -- ejecuta varias veces este insert y verás que va incrementando el id

select * from prueba;
-- 7)
/*B) Segunda forma: sin omitir la columna autoincremental (que es primary key)*/
-- se da el valor 0 o null a esa columna, el sistema lo ignora
-- y continúa por el autoincremental en curso

INSERT INTO prueba (id, nombre, apellidos) 
VALUES (0,'Manuel','Bellido'); -- ejecuta varias veces este insert

select * from prueba;

-- 8) Si no indicamos los nombres de las columnas a las que le vamos a dar valor,
-- es necesario que incluyamos todos los valores y en el mismo orden de la definición de la tabla. 

INSERT INTO prueba VALUES (null,'David','Segura'); -- ejecuta varias veces este insert

select * from prueba;

-- continuamos con la bd proyectosx
USE proyectosx;
select * from departamento;

/****** Otras formas de insertar filas ***********/
/*************Inserciones con REPLACE***********/
-- REPLACE es un INSERT, pero que en caso de que la clave primaria ya exista,
-- no da error y sustituye los valores existentes por los nuevos indicados.
-- En caso de que no exista, inserta esa nueva fila

-- 9)
-- Insertar el departamento de código 10, nombre 'nuevo' y ciudad 'Almería' 
-- insertamos un departamento que no existe (esa clave primaria no existe)
REPLACE INTO departamento 
VALUES ('10', 'Nuevo', 'Almería');

-- comprobación
select * 
from departamento where cddep='10';
-- 10) 
-- insertamos un departamento que ya existe (esa clave primaria ya existe)
-- Insertar un departamento de clave 10, nombre 'Renuevo' y ciudad 'Almería'
-- si existe el departamento de clave 10, no queremos que de error la inserción,
-- pues nos interesa que en esa clave ahora esten los datos del departamento indicado.
REPLACE INTO departamento 
VALUES ('10', 'Renuevo', 'Almería');

-- comprobación
select * 
from departamento where cddep='10';


/***************INSERT con SET *************/
-- otro formato de INSERT, aunque menos utilizado que el de VALUES

-- 11)
-- insertar un departamento de código '15', nombre 'el 15' y ciudad 'la 15'
INSERT INTO departamento 
SET cddep='15', nombre='el 15', ciudad='la 15';

-- 12)
-- insertar un departamento de código '16' y nobre 'el 16'
INSERT INTO departamento 
SET cddep='16', nombre='el 16';

select * from departamento;

/****** INSERT con ON DUPLICATE KEY **************************/
-- Con la opción, ON DUPLICATE KEY, se realiza eL INSERT aunque
-- la clave primaria ya exista y en ese caso se pueden indicar
-- los valores a insertar en caso de la nueva inserción y otros valores si ya existe

-- 13)
-- insertar el departamento '25' de nombre '25nuevo' y ciudad 'ciudad25'
-- pero si ya existe el departamento '25' entonces cambia su nombre por '25existe' y
-- la ciudad a 'ciudad25existe'
INSERT INTO departamento 
SET cddep='25', nombre='25nuevo', ciudad='ciudad25'
ON DUPLICATE KEY UPDATE nombre='25existe', ciudad='ciudad25existe';

/*La diferencia con REPLACE es que en la inserción, podemos indicar 
valores diferentes para el caso de que sea nuevo o bien que ya exista*/

-- comprobamos
select * from departamento;

-- ¡¡IMPORTANTE!!: Al hacer un INSERT hay que tener en cuenta los errores
-- debidos a infringir las restricciones semánticas o de usuario (columna no nula,
-- columna con valor único, columna de tipo enum, etc.
-- y las restricciones de Integridad Referencial: clave primaria duplicada,
-- clave foránea en tabla hija que no se corresponde con un valor de la clave primaria de la tabla padre.

-- EJERCICIO 1 CLASE: 
-- a) Inserta un departamento con nombre 'Otro depar' y ciudad 'Otra ciudad'. 
-- ¿Da error la solución propuesta? ¿por qué?
INSERT INTO departamento (nombre, ciudad) VALUES ('Otro depar', 'Otra ciudad');
-- b) Inserta el proyecto de código AEE, nombre 'El que sea' y departamento '01'
-- ¿Da error la solución propuesta? ¿por qué?
INSERT INTO proyecto VALUES ('AEE','El que sea', '01');
-- c) Inserta el proyecto de código ASSS, nombre 'El que sea' 
-- y departamento '01'
-- ¿Da error la solución propuesta? ¿por qué?
INSERT INTO proyecto VALUES ('ASSS','El que sea', '01');
-- c) Inserta el proyecto de código ASS, nombre 'El que sea está bien' 
-- y departamento '11'
-- ¿Da error la solución propuesta? ¿por qué?
INSERT INTO proyecto VALUES ('ASE','El que sea', '11');

select * from proyecto;

/*EJERCICIO 2 DE CLASE: Inserta en la tabla de empleados
al empleado 'de datos: 
código 'A00', nombre 'Pepito Grillo', fecha_ingreso: fecha_actual,jefe 'B06', departamento '03'
Solo debes insertar esas columnas.
*/



/************UPDATE **********/
-- Sentencia SQL para modificar los valores de las columnas de una o varias filas.
-- https://dev.mysql.com/doc/refman/8.0/en/update.html
/* UPDATE nombre_tabla SET asignaciones_columnas [WHERE condición]*/

select * from departamento; -- vemos los datos actuales

-- 14)
-- modificar o cambiar la ciudad del departamento '10' a 'Sevilla'
UPDATE departamento
SET ciudad='Sevilla'
WHERE cddep='10';

-- COMPROBAMOS
select * from departamento;

-- 15)
-- En la tabla trabaja, incrementar en 5 las horas trabajadas
-- en el proyecto de código 'AEE'

-- vemos el contenido de la tabla
SELECT * FROM trabaja;

UPDATE trabaja
SET nhoras=nhoras+5
WHERE cdpro='AEE'; -- se modifican varias filas

-- comprobamos
select * from trabaja;

-- 16)
-- Modificar el nombre y ciudad del departamento de código '22'
-- El nuevo nombre es 'I+D' y la ciudad 'Almería'

-- vemos los datos actuales de ese departamento
select * 
from departamento
where cddep='22';

-- modificamos datos con un solo update
UPDATE departamento 
SET nombre = 'I+D', ciudad = 'Almeria'
WHERE cddep='22';

-- Observad que los UPDATES realizados hasta ahora son todos en función
-- de la clave primaria (condición o filtro puesto en WHERE) => 
-- MySQL los considera UPDATES seguros

-- Los UPDATES o DELETES que no están basados en la clave primaria 
-- (el crierio o filtro WHERE
-- no va referido a la clave primaria) => MySQL los considera NO Seguros

/*Un UPDATE en el que el criterio o condición del WHERE 
no va referido a la clave primaria => (MySQL lo considera no seguro)
-- Y Workbench está configurado para no dejar ejecutarlo por defecto*/

-- 17) Por ejemplo:
-- Vamos a comprobar si se puede o no realizar este UPDATE:
-- Modifica la ciudad del departamento de nombre 'I+D' para que sea 'Córdoba'. 

-- vemos departamentos de nombre I+D
select *
from departamento
where nombre='I+D';

-- MODIFICAMOS
UPDATE departamento
SET ciudad='Córdoba'
WHERE nombre='I+D'; -- modificación en función de una columna que no es la clave primaria

-- Ha dado error? => observa el mensaje de MySQL que indica que es un UPDATE sin usar la PK

/*Error Code: 1175. You are using safe update mode and you tried to update 
a table without a WHERE that uses a KEY column To disable safe mode, toggle the option 
in Preferences -> SQL Queries and reconnect.
-- Para EVITAR ese ERROR 1175:
-- Hay que desactivar el modo seguro de los UPDATES Y DELETES, para poder realizar
-- modificaciones y borrados como el anterior.
DESDE WORKBENCH: Edit/Preferences/SQL-Editor: desmarcar SQL_SAFE_UPDATES 
y reconectar al Servidor para actualizar la variable de sistema que controla este hecho*/

-- Realmente la variable de sistema controla esto es --> la variable SQL_SAFE_UPDATES
show variables like '%SQL_SAFE_UPDATE%';
-- Se puede desactivar con la orden siguiente 
-- (en este caso no se reconecta al servidor y solo vale para esa sesión):
-- SET SQL_SAFE_UPDATE=0;

-- 18)
-- ¡¡MUY IMPORTANTE!!: si no se pone un filtro WHERE en el UPDATE se modifican todas las filas
-- Ejemplo:
UPDATE departamento
SET nombre='prueba'; -- pone el mismo nombre a todos los departamentos

select * from departamento;

-- ¡¡IMPORTANTE!!: Al hacer un UPDATE hay que tener en cuenta los errores
-- debidos a infringir las restricciones semánticas o de usuario (columna no nula,
-- columna con valor único, columna de tipo enum, etc.
-- y las restricciones de Integridad Referencial: clave primaria duplicada,
-- clave foránea que no se corresponde con un valor de la clave primaria...

-- EJERCICIO 3 CLASE: 
-- a) Modifica el jefe del empleado B09 al K07. 
-- ¿Da error la solución propuesta? ¿por qué?
UPDATE empleado
SET cdjefe = 'K07'
WHERE cdemp = 'B09';

-- b) Modifica el jefe del empleado B09 y lo dejas sin jefe asignado. 
-- ¿Da error la solución propuesta? ¿por qué?
UPDATE empleado
SET cdjefe = null
WHERE cdemp = 'B09';

select * from empleado; -- comprobamos

/* EJERCICIO 4 de clase. 
-- A)Modifica el departamento del empleado 'A11' para que sea el '01' 
-- y su salario lo incrementas en un 10%. 
- B) Modifica el código del empleado 'C08' por 'C88' ¿se puede? 
-- Observa primero el contenido de la tabla trabaja y verás que hay entradas para ese empleado en la tabla trabaja
-- ¿que ha pasado en las filas relacionadas con ese empleado, en trabaja? 
-- Razona de forma argumentada.
*/





/************* DELETE****************/
-- Para eliminar filas de una tabla
-- https://dev.mysql.com/doc/refman/8.0/en/delete.html
/* DELETE FROM nombre_tabla [WHERE condición]*/

-- 19)
-- Elimina el empleado de código 'A81' (si no existe el empleado, no da error, y no elimina nada)

-- vemos los empleados que hay
select * from empleado;

DELETE FROM empleado
WHERE cdemp='A81'; -- observa que no da error y muestra 0 filas afectadas

-- 20)
-- A) Elimina la empleado A11. Consulta primero la tabla empleado para ver si es jefe de alguien.
select * from empleado;

DELETE FROM empleado
WHERE cdemp='A11';
-- observa lo que pasa al eliminar a los empleados que son Jefe de otros, 
-- como 'A11'

select * from empleado;
-- en la tabla empleado se pone a NULL su jefe, pues la restricción de DELETE de 
-- esa clave foránea cdjefe, en tabla empleado, es ON DELETE SET NULL

-- B) Elimina los empleados del departamento 01.

select * from empleado; -- vemos quienes son esos empleados Y SIN SON JEFES

DELETE FROM empleado 
WHERE cddep='01';

-- 21)
-- ¡¡IMPORTANTE!!: si no se pone un filtro WHERE en el borrado de filas
-- las borra todas dejando la tabla vacía:
DELETE FROM proyecto; -- elimina todas las filas de la tabla proyecto

select * from proyecto; -- lo comprobamos
-- ¿que ha pasado en la tabla trabja? ¿por qué?
select * from trabaja;

-- se han eliminado todas las filas de trabaja, pues en trabaja el código de un proyecto, columna cdpro
-- es clave foránea con restricción ON DELETE CASCADE, luego al eliminar los proyectos, se han eliminado en cascada
-- las entradas que había en trabaja para esos proyectos.

-- 22)
-- Eliminar empleados del departamento 03 y cuyo nombre contenga una v
select * from empleado; -- miramos antes

DELETE FROM empleado
WHERE cddep='03' AND nombre like '%v%';

-- carga de nuevo la base de datos proyectosx para partir de los datos originales
--  y seguimos practicando (ejecuta de nuevo el script de creación de la BD)

use proyectosx;

-- ¡¡IMPORTANTE!!: Al hacer un UPDATE y DELETE hay que tener en cuenta las
-- restricciones o reglas de Integridad referencial que se han indicado en las
-- claves foráneas respecto a los UPDATE  y DELETE, como has visto antes

/**************** Integridad Referencial***************************/
-- observa que la tabla departamento es tabla 'padre' de las tablas 
--  'empleado' y 'proyecto' (en las tablas hijas está la clave foránea que las relaciona
-- con la tabla padre)

-- Observa las restricciones de clave foránea respecto de 'departamento' en las tablas
-- proyecto y empleado, verás que es ON DELETE RESTRICT => lo que implica que si
-- se intenta eliminar un departamento con empleados y/o proyectos relacionados no nos dejará
-- y dará error de foreign key

/* No eliminará al departamento ‘02’ si existen filas en las tablas hijas 
(empleado o proyecto) cuyo valor de columna cddep sea “02”  
*/

-- 23)
-- ¿se puede eliminar el departamento '02'? 
DELETE FROM departamento
WHERE cddep='02'; 

-- no se puede eliminar porque la tabla 'departamento' 
-- tiene dos tablas hijas (empleado y proyecto) y en ambas tablas cddep es clave foránea 
-- con la restricción ON DELETE RESTRICT y HAY filas relacionadas 
-- en las tablas hijas con el departamento '02'

select * from empleado; -- hay empleados del departamento '02'
select * from proyecto; -- hay proyectos asociados al departamento '02'

-- 24)
-- ¿El departamento '07' se puede eliminar?
DELETE FROM departamento
WHERE cddep='07';

-- si se puede eliminar porque no hay filas relacionadas en las tablas hijas
-- (empleado o proyecto), aunque la clave foránea en ambas tablas hijas tenga la restricción 
-- ON DELETE RESTRICT

-- Observa las restricciones de clave foránea respecto de 'departamento' en las tablas
-- proyecto y empleado, verás que es ON UPDATE CASCADE => lo que implica que si
-- se modifica el código de un departamento con empleados y/o proyectos asociados 
-- en las tablas hijas se modifica de la misma forma el código de departamento que es 
-- clave foránea

-- 25)
-- modifica el código del departamento '02' por el '42'
UPDATE departamento
 SET cddep='42'
 WHERE cddep='02';

/* COMPRUEBA: se modifica el valor de la columna  cddep 
del departamento “02” por “42”, en la tabla departamento, 
y también en las tablas hijas proyecto y empleado. 
El cambio se transmite en cascada tal y como se ha indicado 
en la reglas FOREIGN KEY correspondientes*/


SELECT * FROM departamento; 
SELECT * FROM proyecto;
SELECT * FROM empleado;
 
 -- 26)
 /* Realiza la modificación oportuna para que quede 
 el departamento 42 con el código '02' y comprueba las tablas implicadas*/
 
 UPDATE departamento
 SET cddep='02'
 WHERE cddep='42';

SELECT * FROM departamento; 
SELECT * FROM proyecto;
SELECT * FROM empleado;
 
 -- 27)
 /*EJERCICIO 5 CLASE. 
 Observa la tabla trabaja y sus restricciones de clave foránea
 -- trabaja es una tabla hija de empleado y proyecto*/
 
 -- a).- Elimina el proyecto de código DAG. ¿se puede? ¿por qué?
 DELETE FROM proyecto
 WHERE cdpro='DAG';
 select * from Trabaja;

 -- si se puede eliminar, pues la tabla hija de proyecto es trabaja y 
 -- en la restricción de la clave foránea cdpro, tiene ON DELETE CASCADE => borrado en cascada 

-- b).¿Qué ha ocurrido en la tabla hija trabaja y por qué? 
 -- Al tener la FK cdpro en trabaja la restricción ON DELETE CASCADE, 
 -- se han eliminado en cascada las filas del proyecto DAG en trabaja.
 
 -- 28)
 /*EJERCICIO 6. Observa la tabla empleado y sus restricciones de clave foránea*/
 -- a).- Elimina el empleado de código 'A03'. ¿se puede? ¿por qué?
 select * from empleado;-- vemos empleados
 select * from trabaja; -- vemos por si trabaja
 
 DELETE from empleado
 where cdemp='A03';
 
 -- b).¿Qué ha ocurrido en las tabla hijas trabaja y empleado y por qué? -- 

select * from trabaja;
select * from empleado;

-- 29)
/*EJERCICIO 7. Observa la tabla departamento y sus relaciones con otras tablas*/
 -- a).- Elimina el departamento de código '01'. ¿se puede? ¿por qué? Razona de forma argumentada.
 -- b).Elimina el departamento '07'. ¿se puede? y por qué? Razona de forma argumentada.

 


/********************************************************/
 -- MODO GRÁFICO EN WORKBENCH
 
 -- Carga otra vez la BD proyectos para ver estos ejemplos
 
 -- MODO GRÁFICO: Realizar en modo gráfico ejemplos de:
 -- inserciones, modificaciones y eliminaciones 
 
 /*********************************************************/
 
	
  -- Carga otra vez la BD proyectos y la pones en uso
  
 use proeyctosx;
 
 /******* INSERT CON SELECT**********/
 -- Podemos insertar datos que están en otras tablas usando SELECT en vez de VALUES
 /*INSERT [INTO] nbtabla [lista_columnas] SELECT ...*/
 
 -- 30)
 /*Vamos a añadir primero un nuevo proyecto de código y nombre ECS en la tabla proyecto 
 y que lo dirija el departamento '01'*/
 
 INSERT INTO proyecto (cdpro, nombre, cddep) 
 VALUES ('ECS', 'ECS', '01');
 
 -- 31)
 /* Nos piden asignar a todos los empleados del departamento “03” 
 al proyecto con código “ECS” que acabamos de crear, 
 */
-- esto es:
-- Insertar en la tabla trabaja registros con los
-- códigos de empleado (los del departamento 03) y 
-- en el proyecto (ECS)

--  Podemos pensar en ver los empleados del departaemnto '03' e ir insertando uno a uno
-- pero se trata de hacerlo de manera automatizada, una forma más eficiente y productiva. 

-- Hacer un INSERT con una SELECT: 
-- en vez de indicar los valores exactos a insertar (o algunos) 
-- se insertan todos o algunos valores desde las filas de otra tabla
INSERT INTO trabaja (cdemp,cdpro,nhoras) -- las columnas a insertar 
SELECT cdemp,'ECS', 0  -- los valores de esas columnas a insertar
FROM empleado 
WHERE cddep='03';

/* comprobamos*/
SELECT * FROM trabaja
WHERE cdpro='ECS';

-- 32)
-- Insertar en la tabla trabja a los empleados del departamento '02' 
-- (su código de empleado') con el proyecto DAG
INSERT INTO  trabaja (cdemp,cdpro) 
SELECT cdemp,'DAG' 
FROM empleado 
WHERE  cddep='02';

-- comprobamos
SELECT * FROM trabaja
WHERE cdpro='DAG';

-- 33)
/* añadir los empleados que no tienen proyecto asignado,  
al proyecto con código “ECS” => 
insertar en trabaja con proyecto 'ECS' los empleados sin proyecto*/

/*¿qué empleados no tiene proyecto asignado? 
-- aquellos que no están en la tabla trabja */
SELECT cdemp 
FROM empleado
WHERE  cdemp NOT IN (SELECT cdemp FROM trabaja);

/* el insert sería*/
INSERT INTO trabaja (cdemp,cdpro)
SELECT cdemp,'ECS' 
FROM empleado 
WHERE  cdemp NOT IN (SELECT  cdemp 
                 FROM trabaja);
 
 /*EJERCICIO 8.-
 A) Vamos a crear una tabla de nombre tresumen en proyectosx, para guardar por cada proyecto en el que se trabaja
 su código, el total de horas trabajadas y el total de empleados que trabajan en ese proyecto.
 Crea la tabla con las columnas apropiadas para guardar esos datos, y con clave primaria
 una columana autoincremental.
 B) Inserta en la tabla creada anteriormente, para cada proyecto su código, 
 total de horas trabajadas y total de empleados que trabajan en ese proyecto. La inserción debe quedar 
 de más a menos horas trabajadas.
 */
 
 
 
 
 
 
 /********UPDATE CON SELECT*********/    
 -- SELECT en el set
 -- SELECT en el WHERE
 
 -- 34)
 /* UPDATE simple: aumentar en 5 las horas trabajadas
 a los empleados 
 que trabajan en proyecto 'GRE'*/ 

UPDATE trabaja
SET nhoras=nhoras+5
WHERE cdpro='GRE';  

-- comprobamos
select * from trabaja;  
  
 -- UPDATE con SELECT 
  -- 35)
 /* aumentar en 1000 las horas trabajadas, 
 pero sólo a los empleados 
 que trabajan en proyectos 
 del  departamento ‘04’,*/

/*¿qué proyectos dirige el departamento '04'?*/
SELECT cdpro 
FROM proyecto
WHERE cddep ='04';

/*el update sería: */
UPDATE trabaja
SET nhoras=nhoras+1000
WHERE cdpro IN (SELECT cdpro 
                        FROM proyecto
                        WHERE cddep ='04');
                    
-- comprobamos
select * from trabaja;
/* IMPORTANTE: si la sentencia UPDATE incluye una subconsulta sobre 
la misma tabla donde se van a modificar los registros, 
MySQL daría un error ya que la tabla estaría bloqueada 
y no se permite realizar consultas.
*/
-- 36)
-- EJEMPLO:
/*aumentar el salario en 100 euros a aquellos empleados cuyo salario medio 
sea menor a la media de los salarios de los empleados.
La sentencia de actualización sería
*/

-- seguro que piensas en esta sentencia ¿da error su ejecución?
UPDATE empleado
SET salario=salario+100 
WHERE salario <= (SELECT AVG(salario) FROM empleado);

-- recuerda que la tabla del UPDATE no puede aparecer en la subconsulta
-- ¿Cómo resolverlo? con una tabla derivada:

UPDATE empleado 
SET salario=salario+100 
WHERE salario <= 
(SELECT AVG(salario) FROM (SELECT * FROM empleado) AS emp);


-- 37)					
 /*EJERCICIO 9: modificar la ciudad de los departamentos 
 con más de 2 empleados,  a la ciudad Madrid*/
 
 -- Quienes son los departamentos con más de 2 empleados?:
  select cddep, count(*) 
 from empleado
 group by cddep
having count(*) >2
;
 
-- el UPDATE sería:
 UPDATE departamento
 set ciudad = 'Madrid'
 WHERE cddep IN (select cddep 
					from empleado
					group by cddep
					having count(*) >2);
 
 -- comprobamos
 select * from departamento;
 
 -- 38)
/* EJERCICIO 10. modificar el jefe de los empleados 
que trabajan en el proyecto 'ECS' al empleado A03
 */
 
 -- ¿Qué empleados trabajan en proyecto ECS y quién es su jefe?
 select cdemp, cdjefe
 from empleado 
 where cdemp in (select cdemp
from trabaja
where cdpro='ECS' );


select cdemp
from trabaja
where cdpro='ECS';
 
 -- el UPDATE  sería:
 UPDATE empleado 
 SET cdjefe='A03'
 WHERE cdemp IN (select cdemp from trabaja where cdpro='ECS');
 
  -- 39)
 /* asignar a los  empleados sin departamento, 
 al departamento o uno de los departamentos 
 en cuyos proyectos se ha trabajado cero horas*/
 
/*¿quienes son los empleados sin departamento asignado?*/
SELECT cdemp
FROM empleado
WHERE cddep IS NULL;

/*¿en qué departamentos se ha trabajado 0 horas?*/ 
SELECT p.cddep 
FROM proyecto p                        
INNER JOIN trabaja t ON t.cdpro=p.cdpro
GROUP BY t.cdpro
HAVING SUM(t.nhoras)=0 
ORDER By p.cddep;
                     
 /* proporciona un solo departamento*/
SELECT p.cddep 
FROM proyecto p
INNER JOIN trabaja t ON t.cdpro=p.cdpro
GROUP BY t.cdpro
HAVING SUM(t.nhoras)=0
ORDER BY p.cddep
LIMIT 1;    


 /*EL UPDATE sería:*/
UPDATE empleado
SET cddep = (SELECT p.cddep FROM proyecto p
                        INNER JOIN trabaja t ON t.cdpro=p.cdpro
                        GROUP BY t.cdpro
                        HAVING SUM(t.nhoras)=0 
                        ORDER By cddep
                        LIMIT 1)
WHERE cddep IS NULL;  

                   
select * from empleado; -- comprobamos                        
       
 /*EJERCICIO 11.- 
  En la tabla empleado, cambia el jefe del empleado 'B02' para que sea 'A11'
  Y su salario lo incrementas en 50 euros, solo si el salario actual 
  es menor de 1800 euros.  (Con una sola sentencia UPDATE).
  */

UPDATE empleado 
set cdjefe='A11', salario=if(salario <1800,salario+50,salario)
where cdemp='B02';

select * 
from empleado 
where cdemp='b02';

/*EJERCICIO 12.- Modifica el salario del empleado 'A03' asignándole 
como nuevo salario, el salario medio de los empleados
*/   

 
 /*EJERCICIO 13.-
-- Añade una columna de nombre premios a la tabla proyecto, 
y de tipo smallint y con valor por defecto 0.
Actualiza la tabla proyecto de la siguiente forma:
-- Hay que sumar 1 premio a los proyectos en los que se ha colaborado 
-- con un total de más de 50h y siempre que el proyecto tenga menos de 6 premios
  */
 
 
 

 
/****DELETE CON SELECT******/
     -- SELECT en el WHERE
-- 40)
/* eliminar los proyectos en los que no trabaje 
ningún empleado*/

/*¿en qué proyectos no trabaja ningún empleado?*/
-- aquellos que no aparecen en la tabla trabaja
SELECT cdpro
FROM proyecto
WHERE cdpro NOT IN (SELECT cdpro FROM trabaja);

select * from trabaja;

-- dejamos un proyecto en el que no trabaje nadie, por ejemplo DAG
delete from trabaja
where cdpro='DAG';


/* EL DELETE sería: */
DELETE FROM proyecto
WHERE cdpro NOT IN (SELECT cdpro FROM trabaja);

-- Comprobamos que se ha eliminado el proyecto DAG
select * from proyecto;

-- 41)
/* Dar de baja a los empleados que trabajan en proyectos del departamento '02' */

/* ¿qué empleados trabajan en proyectos del departamento '02'?*/
SELECT cdemp 
FROM trabaja t
INNER JOIN proyecto p ON t.cdpro=p.cdpro
WHERE p.cddep='02';

/*el DELETE sería: */
DELETE FROM empleado 
WHERE cdemp IN (SELECT t.cdemp FROM trabaja t
                                INNER JOIN proyecto p ON p.cdpro=t.cdpro
                                WHERE p.cddep='02');
                                

select * from empleado;

/* IMPORTANTE: si la sentencia DELETE incluye una subconsulta sobre 
la misma tabla donde se van a eliminar los registros, 
MySQL daría un error ya que la tabla estaría bloqueada 
y no se permite realizar consultas.
*/

-- 42)
-- EJEMPLO:
/*eliminar o dar de baja a los empleados cuyo salario sea mayor que la media 
de los salarios de los empleados 
*/
-- La siguiente sentencia dará por tanto error

DELETE FROM  empleado 
WHERE salario > (SELECT AVG(salario) FROM empleado);

-- Luego hay que resolverlo con una tabla derivada sería:

DELETE FROM  empleado  
WHERE salario > 
(SELECT AVG(salario) FROM (SELECT * FROM empleado) AS emp);


 
                                
 /**************TRANSACCIONES****************/   
 -- Una transacción es una unidad atómica (no se puede dividir) 
 -- de trabajo que contiene una o más sentencias SQL.
 -- En MySQL (motor InnoDB) se cumplen las propiedades ACID
 -- Ver ejemplos en PDF _Transacciones_ejemplos
 
 /*Sentencias SQL de transacciones:
 -START TRANSACTION -- indica el comienzo de una trasacción
 -COMMIT -- finaliza una transacción confirmando cambios
 -ROLLBACK -- finaliza una transacción deshaciendo cambios
 */
 -- La variable de sistema que controla el modo transaccional es la variable autoconmit 
 -- que puede estar a 0 o 1
/*
Autocommit=0 (autocommit igual a cero u OFF) significa que siempre 
hay abierta una transacción hasta que no se finalice.
Autocommit=1 (autocommit igual a 1 u ON)significa que 
cada sentencia SQL finalizada en ; constituye una transacción en sí misma 
y el ; finaliza y confirma esa transacción.
En MYSQL el valor que suele haber por defecto en Autocommit es 1. 
Cada SGBD funciona con un determinado valor de Autoconmit*/
 
-- Mostramos el valor de esta variable en nuestro sistema
show variables like '%autocommit%';

/* Si el valor de autocommit lo ponemos a 0 u OFF, siempre estará abierta una transacción, 
y los cambios que realicemos sobre la base de datos no se hacen efectivos 
hasta que confirmemos con COMMIT. Podemos por tanto deshacer cambios con ROLLBACK
*/
-- EJEMPLO de autocommit a 0. Vamos a probarlo.  Ponemos autocommit a 0                              
SET autocommit = OFF;   

-- eliminamos todos los proyectos y empleados
delete from proyecto;
delete from empleado;

select * from proyecto; -- comprobamos que no se muestran
select * from empleado;
-- si hacemos rollback, podremos recuperar los datos 
-- (rollback deshace los cambios y confirma la transacción)
rollback;
-- comprobamos
select * from proyecto;
select * from empleado;

-- volvemos a eliminar todos los proyectos y empleados
delete from proyecto;
delete from empleado;
select * from proyecto; -- comprobamos
select * from empleado;
-- confirmamos la transacción
commit;

-- Una vez confirmada la transacción con COMMIT, ya no podemos deshacer los cambios
rollback; -- intentamos deshacer cambios

select * from proyecto;
select * from empleado;
-- FIN EJEMPLO autocommit a 0

-- Volvemos a poner autocommit a 1 u ON, (valor por defecto en MySQL)
SET autocommit = ON;   


/*¡¡¡ IMPORTANTE: si autoconmit=1 para que se puedan incluir varias sentencias 
en una transaccion es necesario iniciar la transacción con START TRANSACTION y finalizarla con:
- COMMIT => se ejecutan las sentencias contra la base de datos. (se confirman)
- ROLLBACK => se deshacen los cambios y no se guardan en base de datos. (se deshacen) 
*/

-- REGARGAR otra vez la base de datos proyectosx
use proeyctosx;

-- 43)
-- comenzar una transacción y modificar las horas trabajadas
-- en proyecto 'ECS' sumando 500 horas. Confirmar cambios.
START TRANSACTION; -- inicio transacción
UPDATE trabaja  -- sentencias de la transacción
SET nhoras=nhoras+500 
WHERE cdpro='DAG';

COMMIT;  -- confirmar operaciones y finalizar transacción

-- comprobar los cambios y que ya no se puede deshacer 
select * from trabaja;
ROLLBACK; -- intentamos deshacer cambios y vemos que ya no se puede

-- 44)							
/*Ejemplo sobre Deshacer cambios  con Rollback*/

START TRANSACTION; -- inicio transacción
UPDATE trabaja -- sentencias de la transacción
SET nhoras=nhoras+1000 
WHERE cdpro='AEE';
-- consulta para ver que se han producido los cambios, pero realmente aún no se han grabado
ROLLBACK; -- deshacer operaciones anteriores y finalizar transacción

/*Una vez ejecutado ROLLBACK, vuelve a consultar 
-- y verás que los cambios se han deshecho*/
select * from trabaja;


-- 45)
/* puntos de salvaguarda o restauración. 
Permiten deshacer cambios hasta ese punto de salvaguarda. 
Pero no finalizan la transacción*/

START TRANSACTION; -- inicio de transacción
INSERT INTO proyectosx.departamento  -- sentencias de la transacción
VALUES('95','depTrans1', 'ciudad1');
SAVEPOINT sp1; -- punto de salvaguarda
INSERT INTO proyectosx.departamento VALUES 
('90', 'depTrans2', 'ciudad2'), ('91', 'depTrans3', 'ciudad3');
/* compruebo cambios viendo departamentos*/
ROLLBACK TO  SAVEPOINT sp1; -- deshace cambios hasta el sp1
/* consulta departamento y comprueba que ya no están los departamentos 90 y 91*/
-- A partir de ahí, hay que finalizar la transacción según proceda:
ROLLBACK; -- deshace cambios y finaliza transacción
COMMIT; -- confirma cambios y finaliza transacción


/* Concurrencia. Políticas de bloqueo*/


USE proyectosx;
-- 46)
-- bloqueo para solo lectura => es un bloqueo compartido 
-- (solo se puede leer, tanto quien ha bloqueado como desde otras conexiones)
LOCK TABLES departamento READ; 

/*//realiza la lectura y muestra los departamentos.*/ 
SELECT  * FROM departamento;  

/*//da error, pues la tabla está bloqueada para lectura*/
UPDATE departamento    
SET ciudad='ciudad'
WHERE nombre='depar20';

-- desbloqueo tablas
UNLOCK TABLES; 

-- 47)
-- bloqueo de escritura => es un bloqueo exclusivo 
-- (se puede leer, pero escribir sólo quien ha realizado el bloqueo)
LOCK TABLES departamento WRITE; 

-- Quien ha bloqueado puede leer y ecribir, otros clientes no pueden escribir
/*//realiza la lectura y muestra los departamentos.*/ 
SELECT  * FROM departamento;  

UPDATE departamento    
SET ciudad= 'ciudad'
WHERE nombre='I+D';

-- desbloqueo tablas
UNLOCK TABLES; 
