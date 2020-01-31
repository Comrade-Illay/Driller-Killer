/*Код запускался в APEX ORACLE*/
/* Переписать все комментарии на английском */


/* Создание таблиц и последовательностей для автоинкремента первичных ключей
*/
CREATE TABLE staff (
id_staff INTEGER NOT NULL,
surname VARCHAR2(20) NOT NULL,
name VARCHAR2(20) NOT NULL,
middle_name VARCHAR2(20) NOT NULL,
position VARCHAR2(20) NOT NULL,
salary NUMBER(10, 2) NOT NULL CHECK (salary > 0),
expirience NUMBER CHECK (expirience <= 99),
PRIMARY KEY (id_staff)
);

CREATE TABLE watch (
id_watch INTEGER NOT NULL,
head_of_watch INTEGER NOT NULL,
amount_of_workers NUMBER NOT NULL CHECK (amount_of_workers >= 0) ,
PRIMARY KEY (id_watch),
CONSTRAINT head_resume FOREIGN KEY (head_of_watch) REFERENCES staff(id_staff)
);

CREATE TABLE watch_crew (
watch_code INTEGER NOT NULL,
crew_code INTEGER NOT NULL,
CONSTRAINT watch_code_key FOREIGN KEY (watch_code) REFERENCES watch(id_watch),
CONSTRAINT crew_code_key FOREIGN KEY (crew_code) REFERENCES crew(id_crew)
);

CREATE TABLE drilling_crew (
id_crew INTEGER NOT NULL,
drilling_rig INTEGER NOT NULL,
mine INTEGER NOT NULL,
amount_of_watchs NUMBER NOT NULL CHECK (amount_of_watchs > 0),
PRIMARY KEY (id_crew),
CONSTRAINT rig FOREING KEY (drilling_rig) REFERENCES drilling_rig(id_rig),
CONSTRAINT crew_mine FOREIGN KEY (mine) REFERENCES mine(id_mine)
);

CREATE TABLE drilling_rig (
id_rig INTEGER NOT NULL,
name VARCHAR2(20) NOT NULL,
purpose VARCHAR2(20) NOT NULL,
drilling_depth NUMBER NOT NULL CHECK (drilling_depth > 0),
type_of_drive VARCHAR2(20) NOT NULL,
torque NUMBER NOT NULL CHECK (torque > 0),
drilling_method VARCHAR2(20) NOT NULL,
PRIMARY KEY (id_rig)
);

CREATE TABLE mine (
id_mine INTEGER NOT NULL,
name VARCHAR2(20) NOT NULL,
coordinates VARCHAR2(20) NOT NULL,
opening_year DATE NOT NULL,
mining_method VARCHAR2(30) NOT NULL,
type_of_production VARCHAR2(30) NOT NULL,
number_of_products NUMBER NOT NULL CHECK (number_of_products > 0),
PRIMARY KEY (id_mine)
);

CREATE TABLE crew_gang (
crew_code INTEGER NOT NULL,
gang_code INTEGER NOT NULL,
CONSTRAINT sec_crew_code_key FOREING KEY (crew_code) REFERENCES drilling_crew(id_crew) ON DELETE CASCADE,
CONSTRAINT gang_code_key FOREING KEY (gang_code) REFERENCES gang(id_gang) ON DELETE CASCADE
);

CREATE TABLE gang (
id_gang INTEGER NOT NULL,
name VARCHAR2(20) NOT NULL,
exploration_area INTEGER NOT NULL,
amount_of_crew NUMBER NOT NULL CHECK (amount_of_crew > 0),
PRIMARY KEY (id_gang),
CONSTRAINT area_gang FOREIGN KEY (exploration_area) REFERENCES area(id_area),
CONSTRAINT gang_unique UNIQUE (exploration_area, name)
);

CREATE TABLE gang_expedition (
gang_code INTEGER NOT NULL,
expedition_code INTEGER NOT NULL,
CONSTRAINT gang_code_key FOREIGN KEY (gang_code) REFERENCES gang(id_gang),
CONSTRAINT expedition_code_key FOREIGN KEY (expedition_code) REFERENCES expedition(id_expedition)
);

CREATE TABLE area (
id_area INTEGER NOT NULL,
name VARCHAR2(20) NOT NULL,
number_of_settlements NUMBER NOT NULL CHECK (number_of_settlements > 0),
administrative_center VARCHAR2(20) NOT NULL,
region_code NUMBER NOT NULL CHECK (region_code > 0),
PRIMARY KEY (id_area),
CONSTRAINT region_area FOREIGN KEY (region_code) REFERENCES region(id_region),
CONSTRAINT area_unique UNIQUE (name, administrative_center, region_code)
);

CREATE TABLE region (
id_region INTEGER NOT NULL,
name VARCHAR2(20) NOT NULL,
space NUMBER(10, 3) NOT NULL CHECK (space > 0),
administrative_center VARCHAR2(20) NOT NULL,
number_of_settlements NUMBER NOT NULL CHECK (number_of_settlements > 0),
PRIMARY KEY (id_region),
CONSTRAINT region_unique UNIQUE (name, administrative_center)
);

CREATE TABLE expedition (
id_expedition INTEGER NOT NULL,
name VARCHAR2(20) NOT NULL,
amount_of_gangs NUMBER NOT NULL,
expedition_region INTEGER,
country VARCHAR2(20) NOT NULL,
start_of_exp DATE,
end_of_exp DATE,
PRIMARY KEY (id_expedition),
CONSTRAINT expedition_unique UNIQUE (id_expedition, name)
);

CREATE SEQUENCE staff_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER staff_id_trigger
BEFORE INSERT on staff
FOR EACH ROW
BEGIN
IF : new.id_staff is null THEN
SELECT staff_seq.nextval into :new.id_staff FROM dual;
END IF;
END;

CREATE SEQUENCE watch_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER watch_id_trigger
BEFORE INSERT on watch
FOR EACH ROW
BEGIN
IF : new.id_watch is null THEN
SELECT watch_seq.nextval into :new.id_watch FROM dual;
END IF;
END;

CREATE SEQUENCE crew_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER crew_id_trigger
BEFORE INSERT on drilling_crew
FOR EACH ROW
BEGIN
IF : new.id_crew is null THEN
SELECT crew_seq.nextval into :new.id_crew FROM dual;
END IF;
END;

CREATE SEQUENCE mine_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER mine_id_trigger
BEFORE INSERT on mine
FOR EACH ROW
BEGIN
IF : new.id_mine is null THEN
SELECT mine_seq.nextval into :new.id_mine FROM dual;
END IF;
END;

CREATE SEQUENCE gang_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER gang_id_trigger
BEFORE INSERT on gang
FOR EACH ROW
BEGIN
IF : new.id_gang is null THEN
SELECT gang_seq.nextval into :new.id_gang FROM dual;
END IF;
END;

CREATE SEQUENCE area_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER area_id_trigger
BEFORE INSERT on area
FOR EACH ROW
BEGIN
IF : new.id_area is null THEN
SELECT area_seq.nextval into :new.id_area FROM dual;
END IF;
END;

CREATE SEQUENCE exped_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER expedition_id_trigger
BEFORE INSERT on expedition
FOR EACH ROW
BEGIN
IF : new.id_expedition is null THEN
SELECT exped_seq.nextval into :new.id_expedition FROM dual;
END IF;
END;
/* Создание сининонимов */

CREATE OR REPLACE SYNONYM drilling_rig
FOR rig;

CREATE OR REPLACE SYNONYM drilling_crew
FOR crew;

/* Заполнение таблиц данными c использованием многострочкого INSRET-а
*/

INSERT ALL
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Marina', 'Aleksandrovna', 'Ivanov', 'Main Driller',1000.00 , 5)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Hello', 'Sergey', 'Sergeevich', 'Repairer',700.00 , 7)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Ilia', 'Belov', 'Petrovich', 'Driller', 500.00, 6)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('This', 'Oleg', 'Vasilevich', 'Main Driller',1000.00 , 4)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Project', 'Matvei', 'Seferovich', 'Driller', 500.00, 8)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('From', 'Ignat', 'Aleksandrovich', 'Driller', 500.00, 1)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Git', 'Hub', 'Petrovich', 'Main Driller', 1000.00, 7)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Melaev', 'Aleksandr', 'Olegovich', 'Driller', 500.00, 9)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Lonov', 'Konstantin', 'Matveevich', 'Driller', 500.00, 2)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Suvorov', 'Nikita', 'Konstantinovich', 'Main Driller',1000.00, 6)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Martinkov', 'Artem', 'Nikitich', 'Driller', 500.00, 3)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Kozlovich', 'Artemii', 'Artemovich', 'Repairer', 700.00, 5)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Kastinski', 'Roman', 'Aleseevich', 'Main Driller',1000.00 , 8)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Rabonov', 'Aleksei', 'Romanovich', 'Repairer', 700.00, 7)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Kuznets', 'Daniil', 'Stepanovich', 'Main Driller', 1000.00, 6)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Gonchar', 'Stepan', 'Daniilovich', 'Driller',500.00 , 2)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Plotnikov', 'Dmitrii', 'Vadimovich', 'Main Driller',1000.00 , 3)
INTO staff (surname, name, middle_name, position, salary, expirience)
VALUES ('Dubilshik', 'Mark', 'Dmitrievich', 'Main Driller',1000.00 , 8)
SELECT* FROM dual;

INSERT ALL
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 1, 0)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 4, 7)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 6, 2)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 10, 9)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 13, 6)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 15, 8)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 17, 7)
INTO watch (head_of_watch, amount_of_workers)
VALUES ( 18, 4)
SELECT * FROM dual;

INSERT ALL
INTO watch_crew(watch_code, crew_code)
VALUES ( 3, 1)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 1, 1)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 5, 1)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 8, 1)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 6, 2)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 2, 2)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 7, 3)
INTO watch_crew(watch_code, crew_code)
VALUES  ( 4, 3)
SELECT * FROM dual;

INSERT ALL
INTO drilling_crew(drilling_rig, mine, amount_of_watchs)
VALUES ( 8791, 2, 4)
INTO drilling_crew(drilling_rig, mine, amount_of_watchs)
VALUES  ( 7044, 4, 2)
INTO drilling_crew(drilling_rig, mine, amount_of_watchs)
VALUES  ( 5539, 5, 1)
INTO drilling_crew(drilling_rig, mine, amount_of_watchs)
VALUES  ( 3158, 1, 2)
SELECT * FROM dual;

INSERT ALL
INTO drilling_rig(id_rig, name, purpose, drilling_depth, type_of_drive, torque, drilling_method)
VALUES( 8791,'Driller-3000', 'for exploration',1000 , 'electrohydraulic', 5200, 'rotary drilling')
INTO drilling_rig(id_rig, name, purpose, drilling_depth, type_of_drive, torque, drilling_method)
VALUES( 3343,'Driller-1000', 'for technical wells', 500, 'diesel electric', 1250, 'shock drilling')
INTO drilling_rig(id_rig, name, purpose, drilling_depth, type_of_drive, torque, drilling_method)
VALUES( 7044,'UberDriller', 'for operational work', 1500, 'diesel electric', 2000, 'vibration drilling')
INTO drilling_rig(id_rig, name, purpose, drilling_depth, type_of_drive, torque, drilling_method)
VALUES( 3158,'Pioneer', 'for exploration', 1750, 'electrohydraulic', 3600, 'fire jet drilling')
INTO drilling_rig(id_rig, name, purpose, drilling_depth, type_of_drive, torque, drilling_method)
VALUES( 5539,'DrillMec', 'for exploration', 2500, 'electrohydraulic', 2100, 'bit-pulse drilling')
SELECT * FROM dual;

INSERT ALL
INTO mine(name, coordinates, opening_year, mining_method, type_of_production, number_of_products)
VALUES ('Norska', '57,751° 37,173°', '1934.12.05', 'open', 'iron', 1000)
INTO mine(name, coordinates, opening_year, mining_method, type_of_production, number_of_products)
VALUES ('Ostland', '55,831° 77,673°', '1979.06.03', 'mine', 'coal', 2500)
INTO mine(name, coordinates, opening_year, mining_method, type_of_production, number_of_products)
VALUES ('Markendol', '90° 7,63°',  '1997.09.14', 'mine', 'diamond', 0)
INTO mine(name, coordinates, opening_year, mining_method, type_of_production, number_of_products)
VALUES ('Moria', '65,551° 57,763°', '1900.04.19', 'open', 'coal', 3000)
INTO mine(name, coordinates, opening_year, mining_method, type_of_production, number_of_products)
VALUES ('Karak-dol', '54,55° 17,73°', '1989.01.09', 'mine', 'iron', 400)
INTO mine(name, coordinates, opening_year, mining_method, type_of_production, number_of_products)
VALUES ('Karak-uzum', '5,71° 37,176°', '2010.10.07', 'open', 'aluminum', 1300)
SELECT * FROM dual;

INSERT ALL
INTO crew_gang(crew_code, gang_code)
VALUES ( 3, 1)
INTO crew_gang(crew_code, gang_code)
VALUES ( 2, 3)
INTO crew_gang(crew_code, gang_code)
VALUES ( 1, 3)
INTO crew_gang(crew_code, gang_code)
VALUES ( 4, 3)
SELECT * FROM dual;

INSERT ALL
INTO gang(name, exploration_area, amount_of_crew)
VALUES ('Nort-west', 3, 1,)
INTO gang(name, exploration_area, amount_of_crew)
VALUES ('Side-middle', 4, 0,)
INTO gang(name, exploration_area, amount_of_crew)
VALUES ('East-nut', 2, 3,)
SELECT * FROM dual;

INSERT ALL
INTO area(name, number_of_settlements, administrative_center, region_code)
VALUES ('Reikland', 43, 'Altdorf', 321)
INTO area(name, number_of_settlements, administrative_center, region_code)
VALUES ('Sylvania', 13, 'Drakengof', 321)
INTO area(name, number_of_settlements, administrative_center, region_code)
VALUES ('Lioness', 24, 'Barfleur', 115)
INTO area(name, number_of_settlements, administrative_center, region_code)
VALUES ('Brionne', 35, 'Chanteu', 115)
SELECT * FROM dual;

INSERT ALL
INTO gang_expedition(gang_code, expedition_code)
VALUES ( 2, 1)
INTO gang_expedition(gang_code, expedition_code)
VALUES ( 3, 1)
INTO gang_expedition(gang_code, expedition_code)
VALUES ( 1, 2)
SELECT * FROM dual;

INSERT ALL
INTO region(id_region , name, space, number_of_settlements, administrative_center)
VALUES ( 115,' Bretonnia provinse',1500 , 650,'Anguille')
INTO region(id_region , name, space, number_of_settlements, administrative_center)
VALUES ( 321,'Empire mark',3200 , 900,'Altdorf')
SELECT * FROM dual;

INSERT ALL
INTO expedition(name, amount_of_gangs, expedition_region, country, start_of_exp, end_of_exp)
VALUES ('Dukendoom', 2, 115,'Empire', 30.03.1999)
INTO expedition(name, amount_of_gangs, expedition_region, country, start_of_exp, end_of_exp)
VALUES('Bastonet', 1, 321,'Bretonnia', 12.05.2000, 29.09.2010)
SELECT * FROM dual;

/*Различные виды учебных запросов для текущей базы данных*/

SELECT surname, name, middle_name, salary, expirience
FROM staff
WHERE expirience > 2;

SELECT type_of_drive, AVG(drilling_depth), AVG(torque)
FROM drilling_rig
GROUP BY type_of_drive;

SELECT id_crew, amount_of_watchs
FROM drilling_crew
WHERE mine IN (SELECT id_mine FROM mine WHERE type_of_production = 'iron');

SELECT drilling_rig.*
FROM drilling_rig
WHERE NOT EXISTS (SELECT * FROM drilling_crew WHERE drilling_rig = id_rig )

SELECT staff.*
FROM staff
WHERE salary >= ALL(SELECT salary
                    FROM staff
                    WHERE position = 'Repairer')
      AND position NOT IN 'Repairer' ;

SELECT area(administrative_center)
FROM area
UNION
SELECT region(administrative_center)
FROM region;

SELECT *
FROM staff
WHERE salary <= :desired_salary;

SELECT name
FROM expedition
WHERE start_of_exp > '01.01.2000';

SELECT id_crew, mine, drilling_rig.name
FROM drilling_crew LEFT JOIN drilling_rig
ON drilling_crew.drilling_rig = drilling_rig.id_rig
WHERE torque > 2000;

/*Создание представлений
*/

CREATE OR REPLACE VIEW horizontal_view AS
SELECT DISTINCT *
FROM staff
WHERE position IN ('Repairer', 'Driller')
WITH CHECK OPTION;

CREATE OR REPLACE VIEW vertical_view AS
SELECT expedition.name AS name_of_expedition, expedition.amount_of_gangs,
region.name AS region_name, region.space, region.number_of_settlements,
region.administrative_center country, start_of_exp, end_of_exp
FROM expedition, region
WHERE expedition.expedition_region = region.id_region;

CREATE OR REPLACE VIEW limited_view AS
SELECT *
FROM expedition
WHERE (SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'D')) FROM DUAL) BETWEEN '2' AND '6'
AND (SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) FROM DUAL) BETWEEN '9' AND '17';

/*Создание процедур и функций
*/

/* Созадние таблицы необходимой для выполнения процедуры*/
 CREATE TABLE staff_of_expedition (
 name VARCHAR2(20) NOT NULL,
 surname VARCHAR2(20) NOT NULL,
 middle_name VARCHAR2(20) NOT NULL,
 position VARCHAR2(20) NOT NULL
 );

/*Процедура
*/

 CREATE PROCEDURE expedition_staff (name_of_expedition VARCHAR2)
 IS
 no_staff EXCEPTION;
 st_surname staff.surname%TYPE;
 st_name staff.name%TYPE;
 st_middlename staff.middle_name%TYPE;
 st_position staff.position%TYPE;

 CURSOR data_from_staff (name_of_expedition VARCHAR2)
 IS
 SELECT staff.surname, staff.name, staff.middle_name, staff.position
 FROM staff
 INNER JOIN watch
 ON staff.id_staff = watch.head_of_watch
 INNER JOIN watch_crew
 ON watch_crew.watch_code = watch.id_watch
 INNER JOIN drilling_crew
 ON drilling_crew.id_crew = watch_crew.crew_code
 INNER JOIN crew_gang
 ON crew_gang.crew_code = drilling_crew.id_crew
 INNER JOIN gang
 ON gang.id_gang = crew_gang.gang_code
 INNER JOIN gang_expedition
 ON gang_expedition.gang_code = gang.id_gang
 INNER JOIN expedition
 ON expedition.id_expedition = gang_expedition.expedition_code
 WHERE expedition.name = name_of_expedition;

 BEGIN
  OPEN data_from_staff(name_of_expedition);
  IF data_from_staff%NOTFOUND THEN RAISE no_staff;
  END IF;
  LOOP
    FETCH data_from_staff INTO st_name, st_surname, st_middlename, st_position;
    EXIT WHEN data_from_staff%NOTFOUND;
    INSERT INTO staff_of_expedition
    (name, surname, middle_name, position)
    VALUES (st_name, st_surname, st_middlename, st_position);
  END LOOP;
  CLOSE data_from_staff;

 EXCEPTION
 WHEN no_staff THEN
 DBMS_OUTPUT.PUT_LINE('Экспедиция не укомплектована персоналом');

 WHEN NO_DATA_FOUND THEN
 raise_aplication_error('Ошибка');
 END;
 /

/* Функция
*/
CREATE OR REPLACE FUNCTION count_exp (region_name IN VARCHAR2)

RETURN CHAR
IS
result CHAR;
region_code NUMBER ;
no_region EXCEPTION;
no_expedition EXCEPTION;
exp_count NUMBER;

CURSOR c1 (region_name IN VARCHAR2)
IS
SELECT id_region
FROM region
WHERE region.name = region_name;

BEGIN

OPEN c1(region_name);
FETCH c1 INTO region_code;
CLOSE c1;
IF region_code IS NULL THEN RAISE no_region;
 ELSE
SELECT TO_NUMBER(COUNT(id_expedition)) INTO exp_count
FROM expedition
WHERE expedition_region = region_code;
END IF;
IF exp_count = 0 THEN RAISE no_expedition;
ElSE  result := exp_count;
RETURN result;
END IF;

EXCEPTION
WHEN no_region THEN count_exp
DBMS_OUTPUT.PUT_LINE('Регион не найден');
WHEN no_expedition THEN
DBMS_OUTPUT.PUT_LINE('В этом регионе нет экспедиций');
WHEN NO_DATA_FOUND THEN
raise_application_error (-20001, 'Ошибка');

END;

/*Добваление локальных фуекций в процедуру
*/

CREATE OR REPLACE PROCEDURE procedure_with_local_module (name_of_expedition VARCHAR2)
IS
no_staff EXCEPTION;
st_surname staff.surname%TYPE;
st_name staff.name%TYPE;
st_middlename staff.middle_name%TYPE;
st_position staff.position%TYPE;
staff_num INTEGER;

CURSOR data_from_staff (name_of_expedition VARCHAR2)
IS
SELECT staff.surname, staff.name, staff.middle_name, staff.position
FROM staff
INNER JOIN watch
ON staff.id_staff = watch.head_of_watch
INNER JOIN watch_crew
ON watch_crew.watch_code = watch.id_watch
INNER JOIN drilling_crew
ON drilling_crew.id_crew = watch_crew.crew_code
INNER JOIN crew_gang
ON crew_gang.crew_code = drilling_crew.id_crew
INNER JOIN gang
ON gang.id_gang = crew_gang.gang_code
INNER JOIN gang_expedition
ON gang_expedition.gang_code = gang.id_gang
INNER JOIN expedition
ON expedition.id_expedition = gang_expedition.expedition_code
WHERE expedition.name = name_of_expedition;

FUNCTION get_number_of_staff (name_of_expedition VARCHAR2)
RETURN INTEGER
IS
number_of_staff INTEGER;

BEGIN

SELECT count(*) INTO number_of_staff
FROM staff
INNER JOIN watch
ON staff.id_staff = watch.head_of_watch
INNER JOIN watch_crew
ON watch_crew.watch_code = watch.id_watch
INNER JOIN drilling_crew
ON drilling_crew.id_crew = watch_crew.crew_code
INNER JOIN crew_gang
ON crew_gang.crew_code = drilling_crew.id_crew
INNER JOIN gang
ON gang.id_gang = crew_gang.gang_code
INNER JOIN gang_expedition
ON gang_expedition.gang_code = gang.id_gang
INNER JOIN expedition
ON expedition.id_expedition = gang_expedition.expedition_code
WHERE expedition.name = name_of_expedition;
RETURN number_of_staff;
END;

BEGIN
 OPEN data_from_staff(name_of_expedition);
 IF data_from_staff%NOTFOUND THEN RAISE no_staff;
 END IF;
 LOOP
   FETCH data_from_staff INTO st_name, st_surname, st_middlename, st_position;
   EXIT WHEN data_from_staff%NOTFOUND;
   INSERT INTO staff_of_expedition
   (name, surname, middle_name, position)
   VALUES (st_name, st_surname, st_middlename, st_position);
 END LOOP;
 CLOSE data_from_staff;
 staff_num := get_number_of_staff(name_of_expedition);
 DBMS_OUTPUT.PUT_LINE('Количество сотрудников в экспедиции = ' || staff_num);

EXCEPTION
WHEN no_staff THEN
DBMS_OUTPUT.PUT_LINE('Экспедиция не укомплектована персоналом');

END;
/

/*Перегрузка процедуры
 */

 DECLARE
 name_of_expedition VARCHAR2(50) := 'Dukendoom';
 your_expedition_id INTEGER := 2;
 PROCEDURE expedition_staff (name_of_expedition VARCHAR2)
 IS
 no_staff EXCEPTION;
 st_surname staff.surname%TYPE;
 st_name staff.name%TYPE;
 st_middlename staff.middle_name%TYPE;
 st_position staff.position%TYPE;

 CURSOR data_from_staff (name_of_expedition VARCHAR2)
 IS
 SELECT staff.surname, staff.name, staff.middle_name, staff.position
 FROM staff
 INNER JOIN watch
 ON staff.id_staff = watch.head_of_watch
 INNER JOIN watch_crew
 ON watch_crew.watch_code = watch.id_watch
 INNER JOIN drilling_crew
 ON drilling_crew.id_crew = watch_crew.crew_code
 INNER JOIN crew_gang
 ON crew_gang.crew_code = drilling_crew.id_crew
 INNER JOIN gang
 ON gang.id_gang = crew_gang.gang_code
 INNER JOIN gang_expedition
 ON gang_expedition.gang_code = gang.id_gang
 INNER JOIN expedition
 ON expedition.id_expedition = gang_expedition.expedition_code
 WHERE expedition.name = name_of_expedition;

 BEGIN
  OPEN data_from_staff(name_of_expedition);
  IF data_from_staff%NOTFOUND THEN RAISE no_staff;
  END IF;
  LOOP
    FETCH data_from_staff INTO st_name, st_surname, st_middlename, st_position;
    EXIT WHEN data_from_staff%NOTFOUND;
    INSERT INTO staff_of_expedition
    (name, surname, middle_name, position)
    VALUES (st_name, st_surname, st_middlename, st_position);
  END LOOP;
  CLOSE data_from_staff;

 EXCEPTION
 WHEN no_staff THEN
 DBMS_OUTPUT.PUT_LINE('Экспедиция не укомплектована персоналом');

 END;
PROCEDURE expedition_staff (your_id_expedition INTEGER)
IS
no_staff EXCEPTION;
st_surname staff.surname%TYPE;
st_name staff.name%TYPE;
st_middlename staff.middle_name%TYPE;
st_position staff.position%TYPE;

CURSOR data_from_staff (your_id_expedition INTEGER)
IS
SELECT staff.surname, staff.name, staff.middle_name, staff.position
FROM staff
INNER JOIN watch
ON staff.id_staff = watch.head_of_watch
INNER JOIN watch_crew
ON watch_crew.watch_code = watch.id_watch
INNER JOIN drilling_crew
ON drilling_crew.id_crew = watch_crew.crew_code
INNER JOIN crew_gang
ON crew_gang.crew_code = drilling_crew.id_crew
INNER JOIN gang
ON gang.id_gang = crew_gang.gang_code
INNER JOIN gang_expedition
ON gang_expedition.gang_code = gang.id_gang
INNER JOIN expedition
ON expedition.id_expedition = gang_expedition.expedition_code
WHERE your_id_expedition = id_expedition;

BEGIN
 OPEN data_from_staff(your_id_expedition);
 IF data_from_staff%NOTFOUND THEN RAISE no_staff;
 END IF;
 LOOP
   FETCH data_from_staff INTO st_name, st_surname, st_middlename, st_position;
   EXIT WHEN data_from_staff%NOTFOUND;
   INSERT INTO staff_of_expedition
   (name, surname, middle_name, position)
   VALUES (st_name, st_surname, st_middlename, st_position);
 END LOOP;
 CLOSE data_from_staff;

EXCEPTION
WHEN no_staff THEN
DBMS_OUTPUT.PUT_LINE('Экспедиция не укомплектована персоналом');

END;


/*Создание пакета*/

/* Спецификация пакета */

CREATE OR REPLACE PACKAGE DRILLER_3000 IS
 PROCEDURE expedition_staff (name_of_expedition VARCHAR2);
 PROCEDURE expedition_staff (your_id_expedition INTEGER);
 FUNCTION count_exp (region_name IN VARCHAR2) RETURN CHAR;
END DRILLER_3000;
/

/* Тело пакета */

CREATE OR REPLACE PACKAGE BODY DRILLER_3000
IS
CREATE OR REPLACE PROCEDURE expedition_staff (name_of_expedition VARCHAR2)
IS
name_of_expedition VARCHAR2;
no_staff EXCEPTION;
st_surname staff.surname%TYPE;
st_name staff.name%TYPE;
st_middlename staff.middle_name%TYPE;
st_position staff.position%TYPE;

CURSOR data_from_staff (name_of_expedition VARCHAR2)
IS
SELECT staff.surname, staff.name, staff.middle_name, staff.position
FROM staff
INNER JOIN watch
ON staff.id_staff = watch.head_of_watch
INNER JOIN watch_crew
ON watch_crew.watch_code = watch.id_watch
INNER JOIN drilling_crew
ON drilling_crew.id_crew = watch_crew.crew_code
INNER JOIN crew_gang
ON crew_gang.crew_code = drilling_crew.id_crew
INNER JOIN gang
ON gang.id_gang = crew_gang.gang_code
INNER JOIN gang_expedition
ON gang_expedition.gang_code = gang.id_gang
INNER JOIN expedition
ON expedition.id_expedition = gang_expedition.expedition_code
WHERE expedition.name = name_of_expedition;

BEGIN
 OPEN data_from_staff
 IF data_from_staff%NOTFOUND THEN RAISE no_staff
 END IF;
 LOOP
   FETCH data_from_staff INTO st_name, st_surname, st_middlename, st_position
   EXIT WHEN data_from_staff%NOTFOUND;
   INSERT INTO staff_of_expedition
   (name, surname, middle_name, position)
   VALUES (st_name, st_surname, st_middlename, st_position);
 END LOOP;
 CLOSE data_from_staff;

EXCEPTION
WHEN no_staff THEN
DBMS_OUTPUT.PUT_LINE('Экспедиция не укомплектована персоналом')

END;

CREATE OR REPLACE FUNCTION count_exp (region_name IN VARCHAR2)

RETURN CHAR
IS
result CHAR;
region_code NUMBER ;
no_region EXCEPTION;
no_expedition EXCEPTION;
exp_count NUMBER;

CURSOR c1 (region_name IN VARCHAR2)
IS
SELECT id_region
FROM region
WHERE region.name = region_name;

BEGIN

OPEN c1(region_name);
FETCH c1 INTO region_code;
CLOSE c1;
IF region_code IS NULL THEN RAISE no_region;
 ELSE
SELECT TO_NUMBER(COUNT(id_expedition)) INTO exp_count
FROM expedition
WHERE expedition_region = region_code;
END IF;
IF exp_count = 0 THEN RAISE no_expedition;
ElSE  result := exp_count;
RETURN result;
END IF;

EXCEPTION
WHEN no_region THEN count_exp
DBMS_OUTPUT.PUT_LINE('Регион не найден');
WHEN no_expedition THEN
DBMS_OUTPUT.PUT_LINE('В этом регионе нет экспедиций');

END;

CREATE OR REPLACE PROCEDURE expedition_staff (your_id_expedition INTEGER)

your_id_expedition INTEGER;
no_staff EXCEPTION;
st_surname staff.surname%TYPE;
st_name staff.name%TYPE;
st_middlename staff.middle_name%TYPE;
st_position staff.position%TYPE;

CURSOR data_from_staff (your_id_expedition INTEGER)
IS
SELECT staff.surname, staff.name, staff.middle_name, staff.position
FROM staff
INNER JOIN watch
ON staff.id_staff = watch.head_of_watch
INNER JOIN watch_crew
ON watch_crew.watch_code = watch.id_watch
INNER JOIN drilling_crew
ON drilling_crew.id_crew = watch_crew.crew_code
INNER JOIN crew_gang
ON crew_gang.crew_code = drilling_crew.id_crew
INNER JOIN gang
ON gang.id_gang = crew_gang.gang_code
INNER JOIN gang_expedition
ON gang_expedition.gang_code = gang.id_gang
INNER JOIN expedition
ON expedition.id_expedition = gang_expedition.expedition_code
WHERE your_id_expedition = id_expedition;

BEGIN
 OPEN data_from_staff
 IF data_from_staff%NOTFOUND THEN RAISE no_staff
 END IF;
 LOOP
   FETCH data_from_staff INTO st_name, st_surname, st_middlename, st_position
   EXIT WHEN data_from_staff%NOTFOUND;
   INSERT INTO staff_of_expedition
   (name, surname, middle_name, position)
   VALUES (st_name, st_surname, st_middlename, st_position);
 END LOOP;
 CLOSE data_from_staff;

EXCEPTION
WHEN no_staff THEN
DBMS_OUTPUT.PUT_LINE('Экспедиция не укомплектована персоналом')

END;

END DRILLER_3000;
/

/*Триггеры*/

/* Создание талбиц для триггеров */
CREATE TABLE LOG1 (
  user_name VARCHAR2(50),
  sys_time DATE,
  action VARCHAR2(6)
);

CREATE TABLE LOG2 (
  user_name VARCHAR2(50),
  sys_time DATE,
  action VARCHAR2(6)
);

CREATE TABLE LOG3 (
  user_name VARCHAR2(50),
  sys_time DATE,
  action VARCHAR2(6),
  rows_num NUMBER
);

/* DML trigger */
create or replace TRIGGER dml_trigger
 BEFORE INSERT OR UPDATE OR DELETE ON expedition
 FOR EACH ROW
 BEGIN
  CASE
   WHEN INSERTING THEN
    INSERT INTO LOG1(user_name, sys_time, action)
    VALUES (USER, SYSDATE,'insert');
   WHEN UPDATING('name') OR UPDATING THEN
    INSERT INTO expedition(old_name)
     SELECT name FROM expedition ;
    INSERT INTO LOG1(user_name, sys_time, action)
     VALUES (USER, SYSDATE,'insert');
   WHEN DELETING THEN
    INSERT INTO LOG1(user_name, sys_time, action)
     VALUES (USER, SYSDATE,'insert');
  ELSE null;
  END CASE;
  END dml_trigger;

/*DDL triggers*/

CREATE OR REPLACE TRIGGER trigger_on_create
  BEFORE CREATE ON SCHEMA
  DECLARE
  current_time NUMBER;
  wrong_time EXCEPTION;
  BEGIN
  SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) INTO current_time
   FROM DUAL;
   IF current_time NOT BETWEEN '9' AND '17' THEN RAISE wrong_time;
   END IF;
   INSERT INTO LOG2(user_name, sys_time, action)
   VALUES (USER, SYSTIMESTAMP,'create');

   EXCEPTION
   WHEN wrong_time THEN
   RAISE_APPLICATION_ERROR(-20001, 'Access denied');

  END trigger_on_create;
  /

  CREATE OR REPLACE TRIGGER trigger_on_drop
  BEFORE drop ON SCHEMA
  DECLARE
  current_time NUMBER;
  wrong_time EXCEPTION;
  BEGIN
  SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) INTO current_time
   FROM DUAL;
   IF current_time NOT BETWEEN '9' AND '17' THEN RAISE wrong_time;
   END IF;
   INSERT INTO LOG2(user_name, sys_time, action)
   VALUES (USER, SYSTIMESTAMP,'drop');

   EXCEPTION
   WHEN wrong_time THEN
   RAISE_APPLICATION_ERROR(-20001, 'Access denied');

  END trigger_on_drop;
  /

  CREATE OR REPLACE TRIGGER trigger_on_alter
  BEFORE ALTER ON SCHEMA
  DECLARE
  current_time NUMBER;
  wrong_time EXCEPTION;
  BEGIN
  SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) INTO current_time
   FROM DUAL;
   IF current_time NOT BETWEEN '9' AND '17' THEN RAISE wrong_time;
   END IF;
   INSERT INTO LOG2(user_name, sys_time, action)
   VALUES (USER, SYSTIMESTAMP,'alter');

   EXCEPTION
   WHEN wrong_time THEN
   RAISE_APPLICATION_ERROR(-20001, 'Access denied');

  END trigger_on_atler;
  /
/* Системные триггеры */
 CREATE OR REPLACE TRIGGER Log_On_Trigger
  AFTER LOGON ON SCHEMA
  BEGIN
   INSERT INTO LOG3(user_name, sys_time, action)
   VALUES(USER, SYSDATE, 'User is log on');
   INSERT INTO LOG3(rows_num)
   SELECT COUNT(*) FROM expedition;
 END Log_On_Trigger;
 /

 CREATE OR REPLACE TRIGGER Log_Off_Trigger
  AFTER LOGOFF ON SCHEMA
  BEGIN
   INSERT INTO LOG3(user_name, sys_time, action)
   VALUES(USER, SYSDATE, 'User is log off');
   INSERT INTO LOG3(rows_num)
   SELECT COUNT(*) FROM expedition;
 END Log_On_Trigger;
 /
 /* Различные триггеры которые соответсвуют бизнес-логике задания */

/*Таблица для триггера*/

CREATE OR REPLACE TABLE check_boss(
 user_name VARCHAR2(50);
 date_of_check DATE;
 check_status VARCHAR2(1);
 field_for_insert VARCHAR2(1);
)

/* Триггер выполняет проверку находится ли во главе вахты главный бурильщик,
если находится человек с иной должностью, то выбирается незанятый главный бурильщик
и "назначается" на место неподходящего человека */

CREATE OR REPLACE TRIGGER boss_contor
 AFTER INSERT OR UPDATE ON watch
 DECLARE
 id_staff_main INTEGER;
 id_staff_not_main INTEGER;
 no_mistakes EXCEPTION;

 CURSOR not_boss
  IS
  SELECT id_staff
  FROM staff
  INNER JOIN watch
  ON staff.id_staff = watch.head_of_watch
  WHERE position NOT IN 'Main Driller';

 CURSOR free_boss
  IS
  SELECT distinct id_staff
  FROM staff
  WHERE id_staff != ALL (SELECT head_of_watch FROM watch)
  AND position IN ('Main Driller');

 BEGIN
  OPEN not_boss;
  OPEN free_boss;
  LOOP
  FETCH not_boss INTO id_staff_not_main;
  FETCH free_boss INTO id_staff_main;
  EXIT WHEN not_boss%NOTFOUND;
  IF id_staff_main IS NULL AND id_staff_main IS NULL THEN RAISE no_mistakes;
  ELSE
   UPDATE watch SET head_of_watch = id_staff_main WHERE head_of_watch = id_staff_not_main;
  END IF;
  END LOOP;
  CLOSE not_boss;
  CLOSE free_boss;

EXCEPTION
WHEN no_mistakes THEN
DBMS_OUTPUT.PUT_LINE('Все на своих местах');

END boss_contor;


/* Проверяет наличие запасов резурсов в шахте, и при отсутвии таковых удалет
структуры которые были связаны с этой шахтой */

CREATE OR REPLACE TRIGGER mine_control
 AFTER INSERT OR UPDATE ON mine
 DECLARE
 empty_mine_var INTEGER;
 loafer_crew_var INTEGER;
 loafer_watch_var INTEGER;
 no_empty_mine EXCEPTION;

 CURSOR empty_mine
  IS
 SELECT id_mine
 FROM mine
 WHERE number_of_products = 0;

 CURSOR loafer_crew(empty_mine_var INTEGER)
  IS
  SELECT distinct id_crew
  FROM drilling_crew
  WHERE mine = empty_mine_var;

 CURSOR loafer_watch(loafer_crew_var INTEGER)
  IS
  SELECT id_watch
  FROM watch INNER JOIN watch_crew
  ON watch_crew.watch_code = watch.id_watch
  INNER JOIN drilling_crew
  ON drilling_crew.id_crew = watch_crew.crew_code
  WHERE loafer_crew_var = id_crew;

 BEGIN
  OPEN empty_mine;
  LOOP
  FETCH empty_mine INTO empty_mine_var;
  IF empty_mine_var = 0 THEN RAISE no_empty_mine;
  END IF;
  EXIT WHEN empty_mine%NOTFOUND;
  OPEN loafer_crew(empty_mine_var);
  FETCH loafer_crew INTO loafer_crew_var;
  OPEN loafer_watch(loafer_crew_var);
  FETCH loafer_watch INTO loafer_watch_var;
  DELETE FROM crew WHERE id_crew = loafer_crew_var;
  DELETE FROM watch WHERE id_watch = loafer_watch_var;
   END LOOP;
    CLOSE empty_mine;
    CLOSE loafer_watch;
    CLOSE loafer_crew;

  EXCEPTION
  WHEN no_empty_mine THEN
  DBMS_OUTPUT.PUT_LINE('Нет пустой шахты');

END mine_control;


 /*Триггер на мутацию таблиц
  Данный триггер автоматически повышает людей в должности в зависимости от их
  опыта работа. Мутация происходит так как для испольнения триггера используютя
  данные из той же таблицы, которую изменяет триггер
 */

 CREATE OR REPLACE TRIGGER promotion_trigger
  FOR UPDATE OF expirience ON staff
  compound trigger
   readyStaff BOOLEAN;
   ready_staff INTEGER;

   CURSOR c1
   IS
   SELECT id_staff
   FROM staff
   WHERE position = 'Driller' AND expirience = 3;

   BEFORE EACH ROW IS
    BEGIN
     IF :new.expirience = 4 AND :old.position = 'Driller'
      THEN readyStaff := TRUE;
     END IF;
   END BEFORE EACH ROW;

   AFTER statement is
    BEGIN
      IF readyStaff IS NOT NULL THEN
      OPEN c1;
       LOOP
       FETCH c1 INTO ready_Staff;
       EXIT WHEN c1%NOTFOUND;
       UPDATE staff
        SET position = 'Middle Driller'
        WHERE id_staff = ready_staff;
       END LOOP;
       END IF;
       CLOSE c1;
   END AFTER STATEMENT;
 END promotion_trigger;
 /

 /*Планировщик для базы данных*/
 BEGIN
 DBMS_SCHEDULER.CREATE_JOB
 ( job_name => 'staff_exp',
   job_type => 'PLSQL_BLOCK',
   job_action => 'UPDATE staff SET expirience=expirience+1;',
   start_datte => '14-DEC-19 07.00.00 PM',
   repeat_interval => 'FREQ=DAILY; INTERVAL=1',
   enabled => TRUE);
   END;
 /
