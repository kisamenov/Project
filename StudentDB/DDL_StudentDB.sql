
CREATE TABLE INSTRUCTOR
 (INSTRUCTOR_ID NUMBER(8,0) 
 ,SALUTATION VARCHAR2(5)
 ,FIRST_NAME VARCHAR2(25)
 ,LAST_NAME VARCHAR2(25)
 ,STREET_ADDRESS VARCHAR2(50)
 ,ZIP VARCHAR2(5)
 ,PHONE VARCHAR2(15)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE INSTRUCTOR IS 'Profile information for an instructor.'
/

COMMENT ON COLUMN INSTRUCTOR.INSTRUCTOR_ID IS 'The unique ID for an instructor.'
/

COMMENT ON COLUMN INSTRUCTOR.SALUTATION IS 'This instructor''s title (Mr., Ms., Dr., Rev., etc.)'
/

COMMENT ON COLUMN INSTRUCTOR.FIRST_NAME IS 'This instructor''s first name.'
/

COMMENT ON COLUMN INSTRUCTOR.LAST_NAME IS 'This instructor''s last name'
/

COMMENT ON COLUMN INSTRUCTOR.STREET_ADDRESS IS 'This Instructor''s street address.'
/

COMMENT ON COLUMN INSTRUCTOR.ZIP IS 'The postal zip code for this instructor.'
/

COMMENT ON COLUMN INSTRUCTOR.PHONE IS 'The phone number for this instructor including area code.'
/

COMMENT ON COLUMN INSTRUCTOR.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN INSTRUCTOR.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN INSTRUCTOR.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN INSTRUCTOR.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE GRADE
 (STUDENT_ID NUMBER(8,0) 
 ,SECTION_ID NUMBER(8,0) 
 ,GRADE_TYPE_CODE CHAR(2) 
 ,GRADE_CODE_OCCURRENCE NUMBER(38,0) 
 ,NUMERIC_GRADE NUMBER(3,0) DEFAULT 0 
 ,COMMENTS VARCHAR2(2000)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE GRADE IS 'The individual grades a student received for a particular section(class).'
/

COMMENT ON COLUMN GRADE.STUDENT_ID IS 'The unique ID for the student.'
/

COMMENT ON COLUMN GRADE.SECTION_ID IS 'The unique ID for a section.'
/

COMMENT ON COLUMN GRADE.GRADE_TYPE_CODE IS 'The code which identifies a category of grade.'
/

COMMENT ON COLUMN GRADE.GRADE_CODE_OCCURRENCE IS 'The sequence number of one grade type for one section. For example, there could be multiple assignments numbered 1, 2, 3, etc.'
/

COMMENT ON COLUMN GRADE.NUMERIC_GRADE IS 'Numeric grade value, (e.g. 70, 75.)'
/

COMMENT ON COLUMN GRADE.COMMENTS IS 'Instructor''s comments on this grade.'
/

COMMENT ON COLUMN GRADE.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN GRADE.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN GRADE.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN GRADE.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE GRADE_TYPE
 (GRADE_TYPE_CODE CHAR(2) 
 ,DESCRIPTION VARCHAR2(50) 
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE GRADE_TYPE IS 'Lookup table of a grade types (code) and its description.'
/

COMMENT ON COLUMN GRADE_TYPE.GRADE_TYPE_CODE IS 'The unique code which identifies a category of grade, i.e. MT, HW.'
/

COMMENT ON COLUMN GRADE_TYPE.DESCRIPTION IS 'The description for this code, i.e. Midterm, Homework.'
/

COMMENT ON COLUMN GRADE_TYPE.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN GRADE_TYPE.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN GRADE_TYPE.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN GRADE_TYPE.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE GRADE_CONVERSION
 (LETTER_GRADE VARCHAR2(2) 
 ,GRADE_POINT NUMBER(3,2) DEFAULT 0 
 ,MAX_GRADE NUMBER(3,0) 
 ,MIN_GRADE NUMBER(3,0) 
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30)
 ,MODIFIED_DATE DATE  
 )
/

COMMENT ON TABLE GRADE_CONVERSION IS 'Converts a number grade to a letter grade.'
/

COMMENT ON COLUMN GRADE_CONVERSION.LETTER_GRADE IS 'The unique grade as a letter (A, A-, B, B+, etc.).'
/

COMMENT ON COLUMN GRADE_CONVERSION.GRADE_POINT IS 'The number grade on a scale from 0 (F) to 4 (A).'
/

COMMENT ON COLUMN GRADE_CONVERSION.MAX_GRADE IS 'The highest grade number which makes this letter grade.'
/

COMMENT ON COLUMN GRADE_CONVERSION.MIN_GRADE IS 'The lowest grade number which makes this letter grade.'
/

COMMENT ON COLUMN GRADE_CONVERSION.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN GRADE_CONVERSION.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN GRADE_CONVERSION.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN GRADE_CONVERSION.MODIFIED_DATE IS 'Audit column - date of last update.'
/

CREATE TABLE GRADE_TYPE_WEIGHT
 (SECTION_ID NUMBER(8,0) 
 ,GRADE_TYPE_CODE CHAR(2) 
 ,NUMBER_PER_SECTION NUMBER(3,0) 
 ,PERCENT_OF_FINAL_GRADE NUMBER(3,0) 
 ,DROP_LOWEST CHAR(1) 
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE GRADE_TYPE_WEIGHT IS 'Information on how the final grade for a particular section is computed.  For example, the midterm constitutes 50%, the quiz 10% and the final examination 40% of the final grade.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.SECTION_ID IS 'The unique section ID for a section.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.GRADE_TYPE_CODE IS 'The code which identifies a category of grade.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.NUMBER_PER_SECTION IS 'How many of these grade types can be used in this section.  That is, there may be 3 quizzes.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.PERCENT_OF_FINAL_GRADE IS 'The percentage this category of grade contributes to the final grade.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.DROP_LOWEST IS 'Is the lowest grade in this type removed when determining the final grade? (Y/N)'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN GRADE_TYPE_WEIGHT.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE SECTION
 (SECTION_ID NUMBER(8,0) 
 ,COURSE_NO NUMBER(8,0) 
 ,SECTION_NO NUMBER(3,0) 
 ,START_DATE_TIME DATE
 ,LOCATION VARCHAR2(50)
 ,INSTRUCTOR_ID NUMBER(8,0) 
 ,CAPACITY NUMBER(3,0)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE SECTION IS 'Information for an individual section (class) of a particular course.'
/

COMMENT ON COLUMN SECTION.SECTION_ID IS 'The unique ID for a section.'
/

COMMENT ON COLUMN SECTION.COURSE_NO IS 'The course number for which this is a section.'
/

COMMENT ON COLUMN SECTION.SECTION_NO IS 'The individual section number within this course.'
/

COMMENT ON COLUMN SECTION.START_DATE_TIME IS 'The date and time on which this section meets.'
/

COMMENT ON COLUMN SECTION.LOCATION IS 'The meeting room for the section.'
/

COMMENT ON COLUMN SECTION.INSTRUCTOR_ID IS 'The ID number of the instructor who teaches this section.'
/

COMMENT ON COLUMN SECTION.CAPACITY IS 'The maximum number of students allowed in this section.'
/

COMMENT ON COLUMN SECTION.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN SECTION.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN SECTION.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN SECTION.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE COURSE
 (COURSE_NO NUMBER(8,0) 
 ,DESCRIPTION VARCHAR2(50) 
 ,COST NUMBER(9,2) 
 ,PREREQUISITE NUMBER(8,0)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE COURSE IS 'Information for a course.'
/

COMMENT ON COLUMN COURSE.COURSE_NO IS 'The unique ID for a course.'
/

COMMENT ON COLUMN COURSE.DESCRIPTION IS 'The full name for this course.'
/

COMMENT ON COLUMN COURSE.COST IS 'The dollar amount charged for enrollment in this course.'
/

COMMENT ON COLUMN COURSE.PREREQUISITE IS 'The ID number of the course which must be taken as a prerequisite to this course.'
/

COMMENT ON COLUMN COURSE.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN COURSE.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN COURSE.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN COURSE.MODIFIED_DATE IS 'Audit column - date of last update.'
/

CREATE TABLE ENROLLMENT
 (STUDENT_ID NUMBER(8,0) 
 ,SECTION_ID NUMBER(8,0) 
 ,ENROLL_DATE DATE 
 ,FINAL_GRADE NUMBER(3,0)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE ENROLLMENT IS 'Information for a student registered for a particular section (class).'
/

COMMENT ON COLUMN ENROLLMENT.STUDENT_ID IS 'The unique ID for a student.'
/

COMMENT ON COLUMN ENROLLMENT.SECTION_ID IS 'The unique ID for a section.'
/

COMMENT ON COLUMN ENROLLMENT.ENROLL_DATE IS 'The date this student registered for this section.'
/

COMMENT ON COLUMN ENROLLMENT.FINAL_GRADE IS 'The final grade given to this student for all work in this section (class).'
/

COMMENT ON COLUMN ENROLLMENT.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN ENROLLMENT.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN ENROLLMENT.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN ENROLLMENT.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE STUDENT
 (STUDENT_ID NUMBER(8,0) 
 ,SALUTATION VARCHAR2(5)
 ,FIRST_NAME VARCHAR2(25)
 ,LAST_NAME VARCHAR2(25) 
 ,STREET_ADDRESS VARCHAR2(50)
 ,ZIP VARCHAR2(5) 
 ,PHONE VARCHAR2(15)
 ,EMPLOYER VARCHAR2(50)
 ,REGISTRATION_DATE DATE 
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE STUDENT IS 'Profile information for a student.'
/

COMMENT ON COLUMN STUDENT.STUDENT_ID IS 'The unique ID for a student.'
/

COMMENT ON COLUMN STUDENT.SALUTATION IS 'The student''s title (Ms., Mr., Dr., etc.).'
/

COMMENT ON COLUMN STUDENT.FIRST_NAME IS 'This student''s first name.'
/

COMMENT ON COLUMN STUDENT.LAST_NAME IS 'This student''s last name.'
/

COMMENT ON COLUMN STUDENT.STREET_ADDRESS IS 'The student''s street address.'
/

COMMENT ON COLUMN STUDENT.ZIP IS 'The postal zip code for this student.'
/

COMMENT ON COLUMN STUDENT.PHONE IS 'The phone number for this student including area code.'
/

COMMENT ON COLUMN STUDENT.EMPLOYER IS 'The name of the company where this student is employed.'
/

COMMENT ON COLUMN STUDENT.REGISTRATION_DATE IS 'The date this student registered in the program.'
/

COMMENT ON COLUMN STUDENT.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN STUDENT.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN STUDENT.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN STUDENT.MODIFIED_DATE IS 'Audit column - date of last update.'
/


CREATE TABLE ZIPCODE
 (ZIP VARCHAR2(5) 
 ,CITY VARCHAR2(25)
 ,STATE VARCHAR2(2)
 ,CREATED_BY VARCHAR2(30) 
 ,CREATED_DATE DATE 
 ,MODIFIED_BY VARCHAR2(30) 
 ,MODIFIED_DATE DATE 
 )
/

COMMENT ON TABLE ZIPCODE IS 'City, state and zip code information.'
/

COMMENT ON COLUMN ZIPCODE.ZIP IS 'The zip code number, unique for a city and state.'
/

COMMENT ON COLUMN ZIPCODE.CITY IS 'The city name for this zip code.'
/

COMMENT ON COLUMN ZIPCODE.STATE IS 'The postal abbreviation for the US state.'
/

COMMENT ON COLUMN ZIPCODE.CREATED_BY IS 'Audit column - indicates user who inserted data.'
/

COMMENT ON COLUMN ZIPCODE.CREATED_DATE IS 'Audit column - indicates date of insert.'
/

COMMENT ON COLUMN ZIPCODE.MODIFIED_BY IS 'Audit column - indicates who made last update.'
/

COMMENT ON COLUMN ZIPCODE.MODIFIED_DATE IS 'Audit column - date of last update.'
/

--  student.ind

CREATE INDEX INST_ZIP_FK_I ON INSTRUCTOR
 (ZIP)
/


CREATE INDEX GR_GRTW_FK_I ON GRADE
 (SECTION_ID
 ,GRADE_TYPE_CODE)
/

CREATE INDEX GRTW_GRTYP_FK_I ON GRADE_TYPE_WEIGHT
 (GRADE_TYPE_CODE)
/


CREATE INDEX SECT_CRSE_FK_I ON SECTION
 (COURSE_NO)
/

CREATE INDEX SECT_INST_FK_I ON SECTION
 (INSTRUCTOR_ID)
/

CREATE INDEX CRSE_CRSE_FK_I ON COURSE
 (PREREQUISITE)
/

CREATE INDEX ENR_SECT_FK_I ON ENROLLMENT
 (SECTION_ID)
/


CREATE INDEX STU_ZIP_FK_I ON STUDENT
 (ZIP)
/
--  insertCourse.sql

