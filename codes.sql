-- FIRST PROCEDURE
-- This procedure shows the average grade for the given function among students 
create or replace procedure avg_grade 
(v_course IN number,
v_average OUT number) as 
begin
select round(avg(numeric_grade)) 
into v_average 
from grade join section
on grade.section_id = section.section_id
join course on section.course_no = course.course_no
where course.course_no = v_course;
dbms_output.put_line('course number = ' || v_course || ', average grade = ' || v_average);
end avg_grade;

-- test it
declare
v_average number;
begin
avg_grade(25, v_average);
end;

-- SECOND PROCEDURE
-- This procedure shows the status of specified function or procedure
create or replace procedure checkStatus (
procedureName IN varchar)as
xstatus varchar2(10);
begin
select status into xstatus
from user_objects
where object_type in ('FUNCTION','PROCEDURE')
and object_name = procedureName;
dbms_output.put_line('Procedure NAME: ' || procedureName);
if xstatus = 'VALID' then
dbms_output.put_line('The procedure is valid');
end if;

exception
when no_data_found then
dbms_output.put_line('The procedure is invalid');
when others then
dbms_output.put_line('Some error occured: ' || SQLERRM);
end checkStatus;create or replace 
procedure checkStatus (
procedureName IN varchar)
as
xstatus varchar2(10);
begin
select status 
into xstatus
from user_objects
where object_type in ('FUNCTION','PROCEDURE')
and object_name = procedureName;
dbms_output.put_line('Procedure NAME: ' || procedureName);
if xstatus = 'VALID' then
dbms_output.put_line('The procedure is valid');
end if;

exception
when no_data_found then
dbms_output.put_line('The procedure is invalid');
when others then
dbms_output.put_line('Some error occured: ' || SQLERRM);
end checkStatus;


-- test it
begin
checkStatus('AVG_GRADE');
end;

-- THIRD FUNCTION
-- This function checks student GPA and if it is greater than 2
-- then a student is passed to the next year, otherwise a student has to be expelled
create or replace function CheckGPA (
xstudent IN number) RETURN VARCHAR IS
type mygrade is record(
numeric_grade grade.numeric_grade%type);
type xgrades is table of mygrade;
xfingrade xgrades := xgrades();
int number := 0;
xgpa number;
xfinalgpa float;
begin

for x in (select numeric_grade
from grade
join student
on grade.student_id=student.student_id
join section on
grade.section_id=section.section_id
join course on
course.course_no=section.course_no
where grade.student_id=xstudent and grade_type_code='FI') loop
xfingrade.extend;
int := int+1;
xfingrade(int).numeric_grade := x.numeric_grade;
end loop;
for x in 1 .. int loop
dbms_output.put_line(xfingrade(x).numeric_grade);
end loop;
xgpa := (xfingrade(1).numeric_grade + xfingrade(2).numeric_grade) / 2;
dbms_output.put_line('Average GPA: ' || xgpa);

case
when xgpa >= 90 then 
xfinalgpa := 3.67;
when xgpa >= 80 and xgpa < 90 then 
xfinalgpa := 3.0;
when xgpa >= 70 and xgpa < 80 then 
xfinalgpa := 2.67;
when xgpa >= 60 and xgpa < 70 then 
xfinalgpa := 2.33;
when xgpa >= 50 and xgpa < 60 then 
xfinalgpa := 2.0;
else xfinalgpa := 0;
end case;

dbms_output.put_line('Final GPA: ' || xfinalgpa);

if xfinalgpa > 2.0 then
return 'Passed to the next year';
else
return 'Expelled from the university';
end if;

exception
when no_data_found then
return 'No data found for that student';

end CheckGPA;

-- test it
declare 
v_result varchar2(30);
begin
v_result := checkGPA(102);
dbms_output.put_line(v_result);
end;


-- FOURTH FUNCTION
-- This function counts the number of students enrolled into course, if less than 
-- 5 then a course gets discount of 5%
create or replace 
function course_discount 
(v_course_no IN number) 
RETURN varchar2
IS
v_count_students NUMBER;
begin
SELECT count(*)
INTO v_count_students
FROM section
JOIN enrollment
ON section.section_id = enrollment.section_id
JOIN course
ON course.course_no = section.course_no
WHERE course.course_no = v_course_no;

IF v_count_students < 5 THEN
UPDATE course
SET cost = (cost * 95) / 100
WHERE course_no = v_course_no;
RETURN 'This course got discount of 5%';
ELSE
RETURN 'No discount for this course';
END IF;

end course_discount;

-- test it
declare 
v_result varchar2(30);
begin
v_result := course_discount(25);
dbms_output.put_line(v_result);
end;


--------------------------------------------
-- COLLECTIONS (ARRAYS AND RECORDS)

-- 1ST EXAMPLE
-- Showing any three sections with more than 5 students enrolled
declare
type mysection is record (
section_id enrollment.section_id%type,
num_rows number);
type myarray is table of mysection index by binary_integer;
v_array myarray;
int number :=0;

begin
for i in ( select * from(select section_id, count(student_id) my_count
from enrollment
group by section_id
having count(student_id) > 5) where rownum <=3 ) loop
int := int+1;
v_array(int).section_id :=i.section_id;
v_array(int).num_rows :=i.my_count;
end loop;

for i in 1 .. int loop
dbms_output.put_line('Section ID: ' || v_array(i).section_id || ', Number of Students enrolled: ' || v_array(i).num_rows);
end loop;

end;


-- 2ND EXAMPLE
-- Create a phone book for instructors
declare
type InstrRec is record (
myinstr instructor.instructor_id%type,
myname varchar2(50),
myzip instructor.zip%type,
myphone instructor.phone%type
);
v_instructor_one InstrRec;
v_instructor_two InstrRec;
v_instructor_three InstrRec;

begin
select instructor_id, first_name || ' ' || last_name, zip, phone
into v_instructor_one
from instructor
where salutation = 'Ms'
and rownum <=1;
select instructor_id, first_name || ' ' || last_name, zip, phone
into v_instructor_two
from instructor
where salutation = 'Ms'
and rownum <=1 and instructor_id = 105;

select instructor_id, first_name || ' ' || last_name, zip, phone
into v_instructor_three
from instructor
where salutation = 'Ms'
and rownum <=1 and instructor_id = 110;
dbms_output.put_line(v_instructor_one.myinstr || ' ' || v_instructor_one.myname ||
' ' || v_instructor_one.myzip || ' ' || v_instructor_one.myphone);

dbms_output.put_line(v_instructor_two.myinstr || ' ' || v_instructor_two.myname ||
' ' || v_instructor_two.myzip || ' ' || v_instructor_two.myphone);

dbms_output.put_line(v_instructor_three.myinstr || ' ' || v_instructor_three.myname ||
' ' || v_instructor_three.myzip || ' ' || v_instructor_three.myphone);

end;


-------------------------------------------------------------------
-- CURSORS

-- 1ST CURSOR 
-- SET DISCOUNT TO COURSES WITH LESS THAN 8 PEOPLE
DECLARE
    CURSOR c_group_discount
    IS
        SELECT distinct s.course_no, c.description
        FROM section s, enrollment e, course c
        WHERE s.section_id = e.section_id
        AND c.course_no = s.course_no
        GROUP BY s.course_no, c.description, e.section_id, s.section_id
        HAVING COUNT(*)<=8;
    BEGIN
        FOR i IN c_group_discount
        LOOP
            UPDATE course
            SET cost = cost*0.95
            WHERE course_no = i.course_no;
        dbms_output.put_line('A 5% discount has been given to ' ||
        i.course_no || ' ' ||
        i.description);
        END LOOP;
END;

-- 2ND CURSOR
-- GET ALL MALE STUDENTS
DECLARE
CURSOR Students IS
SELECT *
FROM student
where salutation = 'Mr.';
StudRecords student%ROWTYPE;
BEGIN
OPEN Students;
LOOP
FETCH Students INTO StudRecords;
EXIT WHEN Students%NOTFOUND;
dbms_output.put_line('Student ' || StudRecords.first_name ||
' ' || StudRecords.last_name || ' has ID: ' || StudRecords.student_id);
END LOOP;
CLOSE Students;
END;

-- 3RD CURSOR 
-- TOP 3 STUDENTS OF THE SPECIFIED COURSE
DECLARE
CURSOR TopStudents (SelectCourse section.course_no%type) IS
select section.course_no, description, grade.numeric_grade, grade.student_id 
from course
join section
on course.course_no=section.course_no
join enrollment
on section.course_no=SelectCourse
join grade
on enrollment.student_id=grade.student_id
where grade_type_code='FI' and section.course_no = SelectCourse
order by grade.numeric_grade desc;
StudentSect section%rowtype;
StudentCourse course%rowtype;
StudentGrade grade%rowtype;

SelectCourse course.course_no%type := &enter_course_no;
invalid_exc exception;

BEGIN
IF NOT (TopStudents%ISOPEN) THEN
OPEN TopStudents(SelectCourse);
END IF;

IF SelectCourse <= 0
THEN RAISE invalid_exc;
ELSE
LOOP
FETCH TopStudents INTO StudentSect.course_no, StudentCourse.description,
StudentGrade.numeric_grade, StudentGrade.student_id;
EXIT WHEN TopStudents%ROWCOUNT = 4;
dbms_output.put_line('Course No and Name: ' || StudentSect.course_no || ' ' 
|| StudentCourse.description || ' Student with ID: ' || StudentGrade.student_id
|| ' has final grade of ' || StudentGrade.numeric_grade);
--dbms_output.put_line('Student ID: ' || StudentSect.section_id);

END LOOP;
COMMIT;

IF (TopStudents%ISOPEN) THEN
CLOSE TopStudents;
END IF;
END IF;

EXCEPTION
when invalid_exc then
dbms_output.put_line('Invalid course number');
when value_error then
dbms_output.put_line('Value error');
END;

-- 4TH CURSOR

-- CONVERTING STUDENTS NUMERIC GRADE INTO LETTER GRADE
DECLARE
stud_id int(12):= &stud_id;
stud_name varchar(32);
course_description varchar(32);
g_numeric integer(3);
CURSOR Student IS
select student.first_name, course.description, grade.numeric_grade
from student
inner join grade on grade.student_id = student.student_id
inner join enrollment on grade.student_id = enrollment.student_id
inner join section on enrollment.section_id = section.section_id
inner join course on section.course_no = course.course_no
where stud_id = student.student_id and grade_type_code = 'FI'
group by student.first_name, course.description, grade.numeric_grade;
student_id_invalid EXCEPTION; 

begin
if stud_id <= 0 then
raise student_id_invalid;

else
open Student;
loop
fetch Student into stud_name, course_description, g_numeric;
exit when Student%NOTFOUND;
dbms_output.put_line('Name:' || stud_name || ', course name: '||course_description);
case
when g_numeric between 85 and 100 then dbms_output.put_line('A');
when g_numeric between 75 and 85 then dbms_output.put_line('B');
when g_numeric between 60 and 75 then dbms_output.put_line('C');
when g_numeric between 50 and 60 then dbms_output.put_line('D');
when g_numeric between 0 and 50 then dbms_output.put_line('F');
end case;

end loop;
close Student;
end if; 

EXCEPTION

when student_id_invalid then
dbms_output.put_line('Invalid student id');
when others then
dbms_output.put_line('Other error!');

end;

-------------------------------------------------------------------------------------
-- PACKAGES

-- 1ST PACKAGE: INSTRUCTOR PACKAGE.
create or replace 
PACKAGE instructor_package AS

procedure DeleteInstructor (
xinstructor_id IN instructor.instructor_id%type);

procedure ListInstructors;

function totalInstructors
(xinstructor_id IN section.instructor_id%type,
xsection_id IN section.section_id%type)
RETURN VARCHAR;

END instructor_package;

create or replace 
PACKAGE BODY instructor_package AS

procedure DeleteInstructor (
xinstructor_id IN instructor.instructor_id%type)
AS
invalid_id exception;
BEGIN
DELETE FROM instructor
WHERE instructor_id = xinstructor_id;

IF xinstructor_id < 0 THEN
RAISE invalid_id;
END IF;

EXCEPTION 
WHEN invalid_id THEN
dbms_output.put_line('Invalid instructor ID');
END DeleteInstructor;

procedure ListInstructors AS
type myinstructors is record (
first_name instructor.first_name%type,
last_name instructor.last_name%type,
modified_date instructor.modified_date%type);
type allInstructors is table of myinstructors;
xinstructors allInstructors := allInstructors();
int number := 0;
BEGIN
for x in (select first_name, last_name, modified_date
from instructor
order by modified_date) loop
xinstructors.extend;
int := int+1;
xinstructors(int).first_name := x.first_name;
xinstructors(int).last_name := x.last_name;
xinstructors(int).modified_date := x.modified_date;
end loop;
for x in 1 .. int loop
dbms_output.put_line(xinstructors(x).first_name || ' ' || xinstructors(x).last_name || ' modified date is ' || 
xinstructors(x).modified_date);
end loop;

END ListInstructors;

function totalInstructors
(xinstructor_id IN section.instructor_id%type,
xsection_id IN section.section_id%type)
RETURN VARCHAR
IS
xcount number;
BEGIN
select count(*) 
into xcount
from section
where section_id = xsection_id AND instructor_id = xinstructor_id;

if xcount > 0 then 
return xcount;
else 
return 'This department has no instructors';
end if;

end totalInstructors;

end instructor_package;


-- 2ND PACKAGE:

CREATE OR REPLACE PACKAGE MyPackage AS

FUNCTION checkEnrollment 
(xstudent_id IN enrollment.student_id%type)
RETURN varchar;

FUNCTION checkEnrollment 
(xstudent_id IN enrollment.student_id%type,
xsection_id IN enrollment.section_id%type)
RETURN varchar;

END MyPackage;

create or replace 
PACKAGE BODY MyPackage AS

FUNCTION checkEnrollment 
(xstudent_id IN enrollment.student_id%type) 
RETURN VARCHAR
IS
xcount number;
BEGIN
SELECT COUNT(*) 
INTO xcount
FROM ENROLLMENT
WHERE STUDENT_ID = xstudent_id;

IF xcount > 0 then
RETURN 'Student is enrolled';
ELSE 
RETURN 'Student is not enrolled';
END IF;

EXCEPTION
when no_data_found then
return 'Student with that ID is not found';
when others then
return 'Some error occured';

END checkEnrollment;


FUNCTION checkEnrollment 
(xstudent_id IN enrollment.student_id%type,
xsection_id IN enrollment.section_id%type) 
RETURN VARCHAR
IS
xcount number;
BEGIN
SELECT COUNT(*) 
INTO xcount
FROM enrollment
WHERE student_id = xstudent_id AND section_id = xsection_id;

IF xcount > 0 then
RETURN 'Student is enrolled into specified section';
ELSE 
RETURN 'Student is not enrolled into this section';
END IF;

EXCEPTION
when no_data_found then
return 'Student with that ID is not found';
when others then
return 'Some error occured';

END checkEnrollment;

END MyPackage;
-- 3RD PACKAGE
create package package3 as

procedure proc1 (sect_no in out section.section_no%type,
cor_no in out section.course_no%type ,
s_id out section.section_id%type,
c_no out section.course_no%type,
counter number,
output varchar2);
function over1 (st_id in out grade.student_id%type,
sec_id out grade.section_id%type,
)
return varchar2;
function over1 (grade_code in out grade_type.grade_type_code%type,
des out grade_type.description%type)
return varchar2;
end package3;

-- 4TH PACKAGE
CREATE OR REPLACE PACKAGE StudentFind AS
PROCEDURE FIND_STUDENT(
    V_STUDENT IN NUMBER,
    V_FNAME OUT VARCHAR2,
    V_LNAME OUT VARCHAR2);
	
END StudentFind;

CREATE OR REPLACE PACKAGE BODY StudentFind AS

PROCEDURE FIND_STUDENT(
    V_STUDENT IN NUMBER,
    V_FNAME OUT VARCHAR2,
    V_LNAME OUT VARCHAR2)

AS

  BEGIN
    SELECT FIRST_NAME, LAST_NAME
    INTO V_FNAME, V_LNAME
    FROM STUDENT
    WHERE STUDENT_ID = V_STUDENT;

  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END FIND_STUDENT;

END StudentFind;


----------------------------------------------------------------
-- TRIGGERS

-- 1ST EXAMPLE
-- Trigger to display cost changes
CREATE OR REPLACE TRIGGER display_cost_changes
BEFORE DELETE OR INSERT OR UPDATE ON course 
FOR EACH ROW 
WHEN (NEW.course_no > 0) 
DECLARE 
   cost_diff number; 
BEGIN 
   cost_diff := :NEW.cost  - :OLD.cost; 
   dbms_output.put_line('Old cost: ' || :OLD.cost); 
   dbms_output.put_line('New cost: ' || :NEW.cost); 
   dbms_output.put_line('Cost difference: ' || cost_diff); 
END; 


-- 2ND EXAMPLE
-- trigger to add all students a bonus point of 5%
create or replace trigger stud_marks 
before INSERT 
on grade 
begin 
update grade
set numeric_grade = numeric_grade + 5;
end;


-- 3RD EXAMPLE
-- Trigger to change the description of the course or delete it at all
CREATE OR REPLACE TRIGGER dept_set_null
  AFTER DELETE OR UPDATE OF description ON course
  FOR EACH ROW

  -- Before row is deleted from dept or primary key (DEPTNO) of dept is updated,
  -- set all corresponding dependent foreign key values in emp to NULL:

BEGIN
  IF UPDATING AND :OLD.description != :NEW.description OR DELETING THEN
    UPDATE course SET course.description = NULL
    WHERE course.description = :OLD.description;
  END IF;
END;


---------------------------------------------------------------------------
-- DYNAMIC SQL

-- 1ST EXAMPLE
-- first define a procedure
CREATE OR REPLACE PROCEDURE calc_stats (
  w NUMBER,x NUMBER,y NUMBER,z NUMBER)
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(w + x + y + z);
END;

-- Test it, using dynamic SQL
DECLARE
  a NUMBER := 5;
  b NUMBER := 6;
  plsql_block VARCHAR2(100);
BEGIN
  plsql_block := 'BEGIN calc_stats(:x, :x, :y, :x); END;';
  EXECUTE IMMEDIATE plsql_block USING a, b;  
END;


-- 2ND EXAMPLE
-- this script finds the difference between course costs
-- first define a procedure
CREATE OR REPLACE PROCEDURE cost_diff (
  x1 NUMBER,x2 NUMBER)
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(x2-x1);
END;

-- Test it, using dynamic SQL
DECLARE
  a number;
  b number;
  plsql_block VARCHAR2(100);
BEGIN
  select cost 
  into a
  from course
  where course_no = 25;
  
  select cost 
  into b
  from course
  where course_no = 80;
  
  plsql_block := 'BEGIN cost_diff(:x, :y); END;';
  EXECUTE IMMEDIATE plsql_block USING a, b;  
END;

-- 3RD EXAMPLE
-- this script gets course information including ID and description
-- first define a procedure
CREATE OR REPLACE PROCEDURE course_info (
  x1 number,x2 varchar2)
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(x1 || ' ' || x2);
END;

-- Test it, using dynamic SQL
DECLARE
  a number;
  b varchar2(30);
  plsql_block VARCHAR2(100);
BEGIN
  select course_no, description 
  into a, b
  from course
  where course_no = 25;
  
  plsql_block := 'BEGIN course_info(:x, :y); END;';
  EXECUTE IMMEDIATE plsql_block USING a, b;  
END;