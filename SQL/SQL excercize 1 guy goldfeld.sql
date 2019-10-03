------2a. the college manager wanted to ask how many student he has in each department---------

SELECT a.departmentid,b.studentid
INTO dbo.studentiddepartmentid
FROM dbo.courses$ AS a
INNER JOIN dbo.classrooms$ AS b
ON a.courseid=b.courseid

SELECT * FROM dbo.studentiddepartmentid 

SELECT   
departmentid,
COUNT (studentid) AS total_students
INTO dbo.tot_dept_students 
FROM dbo.studentiddepartmentid
GROUP BY departmentid
ORDER BY departmentid

SELECT b.departmentname, a.total_students FROM dbo.tot_dept_students As a  -------the answer----------
INNER JOIN dbo.Departments$ AS b
ON a.departmentid=b.departmentid

------------------question 2b---------------

SELECT a.studentid, a.courseid, b.departmentid, b.coursename
INTO dbo.englishstudents1
 FROM dbo.classrooms$ AS a
 INNER JOIN dbo.courses$ AS b
 ON a.courseid=b.courseid
 WHERE departmentid=1
SELECT * FROM dbo.englishstudents1


SELECT coursename,   ---------how many student in each english course----------
COUNT (studentid) AS totstubycourse
FROM  dbo.englishstudents1 
GROUP BY coursename

SELECT     ---------total english students-----------
COUNT (DISTINCT studentid) 
FROM dbo.englishstudents1 AS tot_eng_stu

---------------------------question 2c -------------------------------------
SELECT * FROM dbo.Departments$

SELECT a.studentid,b.courseid,b.coursename
INTO dbo.science_student_courses
FROM dbo.classrooms$ AS a 
INNER JOIN  dbo.courses$ AS b 
ON a.Courseid=b.Courseid
WHERE Departmentid=2

SELECT * FROM dbo.science_student_courses

SELECT coursename,
COUNT (studentid) AS total_course_stu
INTO dbo.course_stu_amount 
FROM dbo.science_student_courses
GROUP BY coursename

SELECT * FROM dbo.course_stu_amount

SELECT coursename,
CASE WHEN (total_course_stu<22) then 'small'
ELSE 'big' 
END 
AS class_size
INTO dbo.courses_class_size
FROM dbo.course_stu_amount
  
SELECT * FROM dbo.courses_class_size

SELECT class_size,
COUNT (coursename) AS total_class_number
FROM dbo.courses_class_size
GROUP BY class_size -------------the answer----------

------------------------Question 2 d ----------------------------------------

select * FROM dbo.students$

SELECT gender,     ----------the answer---------
COUNT(DISTINCT studentid) AS totalstudents 
FROM dbo.students$
WHERE gender IS NOT NULL
GROUP BY Gender
 
-------the student is wrong there are more 165 females and 115 males-----------------

--------------------------------------Question 2e-------------------

 
 SELECT a.studentID, a.gender, b.courseid
 INTO dbo.stu_gen_cou
 FROM dbo.students$ As a
 INNER JOIN  dbo.classrooms$ AS b
 ON a.studentid=b.studentid
 
 SELECT * FROM dbo.stu_gen_cou

 SELECT courseid, gender, 
 COUNT (DISTINCT studentid) AS totalstudents
 INTO dbo.TOT_cou_stu_by_gen
 FROM dbo.stu_gen_cou
 GROUP BY courseid, gender
 ORDER BY courseid

 SELECT * FROM dbo.TOT_cou_stu_by_gen 
 
 SELECT courseid,
 SUM(totalstudents) AS total 
 INTO dbo.tot_stu_cou
 FROM dbo.TOT_cou_stu_by_gen 
 GROUP BY courseid

 SELECT * FROM dbo.TOT_cou_stu_by_gen

 SELECT a.courseid, a.gender,a.totalstudents AS total_gender_students, b.total
 INTO dbo.full_gen_stu
 FROM dbo.TOT_cou_stu_by_gen AS a
 INNER JOIN  dbo.tot_stu_cou AS b
 ON a.courseid=b.courseid
 ORDER BY courseid 

 SELECT * FROM dbo.full_gen_stu

 SELECT courseid, gender,
 CAST(total_gender_students AS FLOAT) AS new_tot_gen_stu,
 CAST(total AS FLOAT) AS new_total
 INTO dbo.new_course_gen
 FROM dbo.full_gen_stu

 SELECT courseid,gender, new_tot_gen_stu/new_total*100 AS percentage
 INTO dbo.percentage_gen_courses
  FROM dbo.new_course_gen

  SELECT * FROM dbo.percentage_gen_courses

  SELECT b.coursename,a.courseid,a.gender,a.percentage
  FROM dbo.percentage_gen_courses AS a 
  INNER JOIN dbo.Courses$ As B on a.courseid=b.courseid
  WHERE percentage>70

 -------------- question 2f----------------------


SELECT * FROM dbo.Courses$
SELECT * FROM dbo.Classrooms$

SELECT a.courseid, a.coursename,a.departmentid, b.studentid, b.degree
INTO dbo.department_degree
FROM dbo.Courses$ AS a
INNER JOIN dbo.Classrooms$ AS b
ON a.courseid=b.courseid

SELECT departmentid,studentid,
AVG(degree) AS AVG 
INTO dbo.department_avg
FROM dbo.department_degree
GROUP BY departmentid, studentid
ORDER BY DepartmentID


SELECT departmentid,StudentId,[AVG],
CASE WHEN 
AVG>80 THEN 'high'
ELSE 'low'
END AS avgchar
INTO dbo.avgchar
FROM dbo.department_avg

SELECT * FROM dbo.avgchar

SELECT DepartmentID,avgchar,
COUNT(studentid) AS numberofstudents
INTO dbo.department_student_count
FROM dbo.avgchar 
GROUP BY departmentid,avgchar

SELECT departmentid,avgchar, 
CAST(numberofstudents AS FLOAT) AS new_tot_students
INTO dbo.con_dep_student_count
FROM dbo.department_student_count

SELECT departmentid,
SUM(new_tot_students) AS studentquantity
INTO dbo.departmentsumofstudents
FROM dbo.con_dep_student_count
GROUP BY departmentid 

SELECT a.departmentid,a.avgchar,a.new_tot_students ,b.studentquantity AS sumofdeptstudents
INTO dbo.department_over80_anallisys1
FROM dbo.con_dep_student_count AS a
INNER JOIN  dbo.departmentsumofstudents AS b
ON a.DepartmentID=b.DepartmentID

SELECT b.Departmentname,a.avgchar,a.new_tot_students,a.new_tot_students/sumofdeptstudents*100 AS percentage
FROM dbo.department_over80_anallisys1 AS a
INNER JOIN dbo.departments$ AS b
ON a.departmentid=b.departmentid
WHERE avgchar='high'

--------------------question 2g

SELECT * FROM dbo.Courses$
SELECT * FROM dbo.Classrooms$


SELECT * FROM dbo.department_avg

SELECT departmentid,StudentId,[AVG],
CASE WHEN 
AVG>60 THEN 'above60'
ELSE 'below60'
END AS avgchar
INTO dbo.avgchar60
FROM dbo.department_avg

SELECT * FROM dbo.avgchar60


SELECT DepartmentID,avgchar,
COUNT(studentid) AS numberofstudents
INTO dbo.department_student_count60
FROM dbo.avgchar60
GROUP BY departmentid,avgchar



SELECT departmentid,avgchar, 
CAST(numberofstudents AS FLOAT) AS new_tot_students
INTO dbo.con_dep_student_count60_a
FROM dbo.department_student_count60

SELECT departmentid,
SUM(new_tot_students) AS studentquantity
INTO dbo.departmentsumofstudents60
FROM dbo.con_dep_student_count60_a
GROUP BY departmentid 


SELECT a.departmentid,a.avgchar,a.new_tot_students ,b.studentquantity AS sumofdeptstudents
INTO dbo.department_over60_anallisys1
FROM dbo.con_dep_student_count60_a AS a
INNER JOIN  dbo.departmentsumofstudents AS b
ON a.DepartmentID=b.DepartmentID

SELECT b.Departmentname,a.avgchar,a.new_tot_students,a.new_tot_students/sumofdeptstudents*100 AS percentage------the answer-----
FROM dbo.department_over60_anallisys1 AS a
INNER JOIN dbo.departments$ AS b
ON a.departmentid=b.departmentid 
WHERE avgchar='below60'

question 2h

SELECT a.teacherid,a.courseid,b.studentid,b.degree INTO dbo.teachers_students FROM dbo.Courses$ AS a
INNER JOIN dbo.Classrooms$ AS b 
ON a.CourseId=b.CourseId

SELECT teacherid,
AVG(degree) teacher_avg
INTO dbo.avgbyteacherid
 FROM dbo.teachers_students
 GROUP BY TeacherId
 ORDER BY teacher_avg DESC

 SELECT * FROM dbo.avgbyteacherid
 
 SELECT b.firstname,b.lastname,b.gender,a.teacher_avg -------the answer--------- 
 FROM dbo.avgbyteacherid as a
INNER JOIN dbo.Teachers$ as b
ON a.TeacherId=b.TeacherId
ORDER BY teacher_avg DESC
 

-------------------- questiom 3a --------------
 
SELECT a.CourseId,a.coursename,a.departmentid,b.firstname,b.lastname,b.gender
INTO dbo.coursesteachersnames
FROM dbo.Courses$ AS a
INNER JOIN dbo.Teachers$ AS b
ON a.TeacherId=b.TeacherId

SELECT a.coursename, a.departmentid, a.firstname, a.lastname, a.gender, b.total AS [total students]
INTO dbo.teacherandtotalstudentsbycoursesanddepartments
FROM dbo.coursesteachersnames AS a
INNER JOIN dbo.tot_stu_cou AS b 
ON a.CourseId=b.courseid



 CREATE VIEW dbo.Vtotalstudentsbycourse
 AS  SELECT a.coursename, b.DepartmentName, a.firstname, a.lastname,a.gender,a.[total students] 
 FROM dbo.teacherandtotalstudentsbycoursesanddepartments AS a 
 JOIN dbo.Departments$ AS b
 ON  a.departmentid=b.DepartmentId
 

 SELECT * FROM Vtotalstudentsbycourse ------the answer----

--------------------- Question 3b----------------

SELECT a.StudentId,a.degree,a.CourseId,b.DepartmentID INTO dbo.classroom1 FROM dbo.Classrooms$ AS a
INNER JOIN dbo.Courses$ AS b
ON a.CourseId=b.CourseId

SELECT studentid, 
COUNT(courseid) total_nuberof_courses
INTO dbo.totalcoursesbystudentid
FROM dbo.classrooms$
WHERE studentid IS NOT NULL
GROUP BY StudentId


 SELECT Studentid,departmentid,
 AVG(degree) AS avgbydept
 INTO dbo.avgofstudentbydepartment
 FROM dbo.classroom1
 GROUP BY StudentId,DepartmentID

 SELECT Studentid,
 AVG(degree) AS generalavg
 INTO dbo.generalavgbystudentid
 FROM dbo.Classrooms$
 WHERE studentid IS NOT NULL
 GROUP BY StudentId
 
 SELECT b.studentid,a.departmentid,a.avgbydept,b.generalavg 
 INTO [dbo].[studentdept&generalavg]
 FROM dbo.avgofstudentbydepartment AS a
 INNER JOIN  dbo.generalavgbystudentid AS b
 ON a.StudentId=b.studentid


 SELECT a.studentid,b.departmentid, a.total_nuberof_courses,b.avgbydept,b.generalavg 
 INTO dbo.studentsidgeneralanddepartmentaverage
 FROM dbo.totalcoursesbystudentid AS a 
 INNER JOIN [dbo].[studentdept&generalavg] AS b
 ON a.studentid=b.studentid

 
 SELECT a.studentid, b.FirstName, b.LastName, a.total_nuberof_courses, a.departmentid, a.avgbydept, a.generalavg
 INTO dbo.studentgeneralanddepartmentavg
 FROM dbo.studentsidgeneralanddepartmentaverage AS a 
 INNER JOIN dbo.Students$ AS b
 ON a.studentid=b.StudentId 

 
 
 CREATE VIEW dbo.Vstudent_totcourse_avgDEP_gen
 AS SELECT a.studentid,a.FirstName,a.LastName, b.DepartmentName, a.avgbydept AS departmentaverage,  a.total_nuberof_courses,a.generalavg
 FROM dbo.studentgeneralanddepartmentavg AS a
 JOIN dbo.Departments$ AS b 
 ON a.departmentid=b.DepartmentId
 
 SELECT * FROM dbo.Vstudent_totcourse_avgDEP_gen
 ORDER BY StudentId

