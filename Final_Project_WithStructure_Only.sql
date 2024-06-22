create Database Examination;
GO

--************************************Mohamed's Part*************************

--Main Tables in Database
USE Examination
GO
--Department Table
create table Department (
Dept_id int primary key ,
Dept_name nvarchar(50) ,
Dept_location nvarchar(50),
);

--Training Manager Table
create table Training_Manager
(Manager_id int primary key identity(1,1),
Manager_Fname nvarchar(50) not null ,
Manager_Lname nvarchar(50) not null ,
Email nvarchar(100) not null ,
password nvarchar(100) not null ,
);

--Branch Table
create table Branch(
Baranch_id int primary key identity(1,1) ,
Barnch_name nvarchar(max),
dept_id int,

constraint Branch_dept_id_fk foreign key(dept_id)
references Department(Dept_id)
);



--Update_adds_inbranch Table 
create table Update_adds_inbranch(
Manager_id int  ,
Branch_id int  ,
Dept_it int  ,

constraint Update_adds_inbranch_pk primary key (Manager_id,Branch_id,Dept_it),

constraint Update_adds_manage_fk foreign key(Manager_id)
references Training_Manager(Manager_id),

constraint Branch_id_fk foreign key(Branch_id)
references Branch(Baranch_id),

constraint dept_id_update_fk foreign key(Dept_it)
references Department(Dept_id)
);

--Intake Table
create table Intake(
Intake_id int primary key identity (1,1),
Intake_name nvarchar(Max),
Branch_Id int,
constraint Intake_branch_fk foreign key(Branch_Id)
References Branch(Baranch_id)
);

--Intake_addedby_manager Table 
create table Intake_addedby_manager(
Manager_id int , 
Intack_id int 
constraint Intake_manager_pk primary key (Manager_id,Intack_id),
constraint manager_fk foreign key (Manager_id)
references Training_Manager(Manager_id)
);

--Track Table
create table Track (
Track_id int primary key identity (1,1),
Track_name nvarchar(Max),
dept_id int,

constraint Track_dept_id_fk foreign key(dept_id)
references Department(Dept_id)
);

--create table Update_adds_inTrack
create table Update_adds_inTrack(
Manager_id int  ,
Track_id int , 
dept_id int ,

constraint Update_adds_inTrack_pk primary key (Manager_id,Track_id,dept_id),
constraint Manager_id_Track_fk foreign key(Manager_id)
references Training_Manager(Manager_id),

constraint Track_id_fk foreign key(Track_id)
references Track(Track_id),

constraint dept_id_fk foreign key(dept_id)
references Department(Dept_id)
);

--Course Table 
CREATE TABLE Course (
    Crs_ID INT PRIMARY KEY,
    Crs_name NVARCHAR(100),
    Description NVARCHAR(MAX),
    Min_Degree INT,
    Max_Degree INT
);

--Student Table
CREATE TABLE Student (
    St_ID INT PRIMARY KEY,
    St_FName NVARCHAR(50),
    St_LName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    Password NVARCHAR(100),
    Dept_ID INT,
    Supervisor_ID INT,
    Intake_ID INT,
    Track_ID INT,
    Manager_ID INT,
    Branch_ID INT,
    FOREIGN KEY (Supervisor_ID) REFERENCES Student(St_ID)
);


--Instructor Table
CREATE TABLE Instructor (
    Ins_ID INT PRIMARY KEY,
    Ins_FName NVARCHAR(50),
    Ins_LName NVARCHAR(50),
    Ins_degree NVARCHAR(50),
    Age INT,
    Email NVARCHAR(100) UNIQUE,
    Password NVARCHAR(100),
    Salary DECIMAL(18, 2),
    Dept_ID INT,
);


--creation for table Courses Teached Instructors 
create table Instructor_Courses(
Course_ID int ,
Instructor_ID int , 

constraint Instructor_Courses_pk Primary Key(Instructor_ID,Course_ID),
constraint Course_ID_fk foreign key (Course_ID)
references Course (Crs_ID),
constraint Instructor_ID_fk foreign key (Instructor_ID)
references Instructor (Ins_ID)
);
GO
------------------------------------------------------------------------------
--********************************Triggers**************************************************

--This trigger will ensure that any new course inserted has valid Min_Degree and Max_Degree values.
CREATE TRIGGER trg_CheckCourseDegree
ON Instructors.Course
for INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
         WHERE Min_Degree <50 OR Max_Degree < Min_Degree
    )
    BEGIN
        RAISERROR ('Min_Degree should be greater than or equal to 50 and less than or equal to Max_Degree.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
------------------------------------------------------------------------------
GO
--This trigger will ensure that the email for a new instructor or in update existance instructor is unique.
CREATE TRIGGER trg_CheckInstructorEmail
ON Instructors.Instructor
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Instructors.Instructor ins ON i.Email = ins.Email AND i.Ins_ID != ins.Ins_ID
    )
    BEGIN
        RAISERROR ('Email must be unique.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO;
------------------------------------------------------------------------------

--This trigger will ensure that the email for a new student  or updated student is unique and the supervisor is a valid student ID.
CREATE TRIGGER trg_CheckStudentEmailAndSupervisor
ON Students.Student
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Students.Student s ON i.Email = s.Email AND i.St_ID != s.St_ID
    )
    BEGIN
        RAISERROR ('Email must be unique.', 16, 1);
        ROLLBACK TRANSACTION;
    END

    IF EXISTS (
        SELECT 1 
        FROM inserted i
        WHERE i.Supervisor_ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Student s WHERE s.St_ID = i.Supervisor_ID)
    )
    BEGIN
        RAISERROR ('Supervisor_ID must be a valid Student ID.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

------------------------------------------------------------------------------
--This trigger ensures that each instructor can teach one or more courses, and each course may be taught by one instructor per class.
CREATE TRIGGER trg_AssignInstructorToCourse
ON Instructors.Instructor_Courses
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Instructors.Instructor ins ON i.Instructor_ID = ins.Ins_ID
        JOIN Instructors.Course c ON i.Course_ID = c.Crs_ID
        WHERE NOT EXISTS (SELECT 1 FROM Instructor WHERE Ins_ID = i.Instructor_ID)
           OR NOT EXISTS (SELECT 1 FROM Course WHERE Crs_ID = i.Course_ID)
    )
    BEGIN
        RAISERROR ('Instructor or Course does not exist.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

------------------------------------------------------------------------------------------------------
--Main Procedures

--create procedure for insert of table department
create PROCEDURE DatabaseAdmin.InsertDepartment
     @dept_id int,
	 @dept_name nvarchar (50),
	 @dept_location nvarchar(50)
      
with encryption
AS
BEGIN
    INSERT INTO DatabaseAdmin.Department (Dept_id,dept_name, dept_location)
    VALUES (@dept_id,@dept_name,@dept_location);
END;
go
------------------------------------------------------------------------
--Create procedure for insert Data into table Training Manager

GO
create PROCEDURE DatabaseAdmin.InsertTraninngManger
 
	@Manager_Fname nvarchar(50),
	@Manager_Lname nvarchar(50),
	@Email nvarchar(50),
	@password nvarchar(50)

with encryption 
As 
begin
insert into TrainingManagers.Training_Manager(Manager_Fname,Manager_Lname,Email,password)
values (@Manager_Fname,@Manager_Lname,@Email,@password);
end;
go
---------------------------------------------------------------------------------------------
--Create procedure that make Training Manager add new branch in a department
CREATE PROCEDURE TrainingManagers.AddNewBranch
    @Manager_id INT,
    @Branch_name NVARCHAR(MAX),
    @Dept_id INT
AS
BEGIN
    -- Declare a variable to hold the new Branch_id
    DECLARE @Branch_id INT;

    -- Insert the new branch into the Branch table
    INSERT INTO TrainingManagers.Branch (Barnch_name, dept_id)
    VALUES (@Branch_name, @Dept_id);

    -- Get the newly generated Branch_id
    SET @Branch_id = SCOPE_IDENTITY();

    -- Insert the Manager_id, Branch_id, and Dept_id into Update_adds_inbranch table
    INSERT INTO TrainingManagers.Update_adds_inbranch (Manager_id, Branch_id, Dept_it)
    VALUES (@Manager_id, @Branch_id, @Dept_id);

    -- Return success message
    SELECT 'New branch added successfully and recorded by manager.' AS Message;
END;

---------------------------------------------------------------------------------------------
--Crate procedure that make Training Manager update branch in a department
CREATE PROCEDURE TrainingManagers.UpdateBranch
    @Manager_id INT,
    @Branch_id INT,
    @New_Branch_name NVARCHAR(MAX),
    @New_Dept_id INT
AS
BEGIN
    -- Check if the branch exists
    IF NOT EXISTS (SELECT 1 FROM Branch WHERE Baranch_id = @Branch_id)
    BEGIN
        SELECT 'Branch does not exist.' AS Message;
        RETURN;
    END

    -- Update the branch in the Branch table
    UPDATE Branch
    SET Barnch_name = @New_Branch_name,
        dept_id = @New_Dept_id
    WHERE Baranch_id = @Branch_id;

    -- Insert the Manager_id, Branch_id, and Dept_id into Update_adds_inbranch table to log the update
    INSERT INTO TrainingManagers.Update_adds_inbranch (Manager_id, Branch_id, Dept_it)
    VALUES (@Manager_id, @Branch_id, @New_Dept_id);

    -- Return success message
    SELECT 'Branch updated successfully and update recorded by manager.' AS Message;
END;

--calling UpdateBranch procedure
EXEC TrainingManagers.UpdateBranch @Manager_id = 8, @Branch_id = 11, @New_Branch_name = 'Updated Branch 2024', @New_Dept_id = 6;
---------------------------------------------------------------------------------------------
--Create procedure That enable Training manager to add new intake
CREATE or alter PROCEDURE TrainingManagers.AddNewIntake
    @Manager_id INT,
    @Intake_name NVARCHAR(MAX),
    @Branch_id INT
with encryption
AS
BEGIN
    -- Declare a variable to hold the new Intake_id
    DECLARE @Intake_id INT;

    -- Insert the new intake into the Intake table
    INSERT INTO TrainingManagers.Intake (Intake_name, Branch_id)
    VALUES (@Intake_name, @Branch_id);

    -- Get the newly generated Intake_id
    SET @Intake_id = SCOPE_IDENTITY();

    -- Insert the Manager_id and Intake_id into Intake_addedby_manager table
    INSERT INTO TrainingManagers.Intake_addedby_manager (Manager_id, Intack_id)
    VALUES (@Manager_id, @Intake_id);

    -- Return success message
    SELECT 'New intake added successfully and recorded by manager.' AS Message;
END;

---------------------------------------------------------------------------------------------
--Creating procedure that enable Training manager to add new track in a department
CREATE or alter PROCEDURE TrainingManagers.AddNewTrack
    @Manager_id INT,
    @Track_name NVARCHAR(MAX),
    @Dept_id INT
with encryption
AS
BEGIN
    -- Declare a variable to hold the new Track_id
    DECLARE @Track_id INT;

    -- Insert the new track into the Track table
    INSERT INTO TrainingManagers.Track (Track_name, dept_id)
    VALUES (@Track_name, @Dept_id);

    -- Get the newly generated Track_id
    SET @Track_id = SCOPE_IDENTITY();

    -- Insert the Manager_id, Track_id, and Dept_id into Update_adds_inTrack table
    INSERT INTO TrainingManagers.Update_adds_inTrack (Manager_id, Track_id, dept_id)
    VALUES (@Manager_id, @Track_id, @Dept_id);

    -- Return success message
    SELECT 'New track added successfully and recorded by manager.' AS Message;
END;
---------------------------------------------------------------------------------------------
--create procedure that enable Training Manger to update tracks in departments
CREATE or alter PROCEDURE TrainingManagers.UpdateTrack
    @Manager_id INT,
    @Track_id INT,
    @New_Track_name NVARCHAR(MAX),
    @New_Dept_id INT
with encryption
AS
BEGIN
    -- Check if the track exists
    IF NOT EXISTS (SELECT 1 FROM Track WHERE Track_id = @Track_id)
    BEGIN
        SELECT 'Track does not exist.' AS Message;
        RETURN;
    END

    -- Update the track in the Track table
    UPDATE TrainingManagers.Track
    SET Track_name = @New_Track_name,
        dept_id = @New_Dept_id
    WHERE Track_id = @Track_id;

    -- Insert the Manager_id, Track_id, and Dept_id into Update_adds_inTrack table to log the update
    INSERT INTO TrainingManagers.Update_adds_inTrack (Manager_id, Track_id, dept_id)
    VALUES (@Manager_id, @Track_id, @New_Dept_id);

    -- Return success message
    SELECT 'Track updated successfully and update recorded by manager.' AS Message;
END;

--calling TrainingManagers.UpdateTrack Procedure 
exec TrainingManagers.UpdateTrack @Manager_id = 3, @Track_id = 5, @New_Track_name = 'Database Management', @New_Dept_id = 2;

---------------------------------------------------------------------------------------------
--Create procedure that insert courses
CREATE or alter PROCEDURE Instructors.InsertCourse
    @Crs_ID INT,
    @Crs_name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Min_Degree INT,
    @Max_Degree INT
AS
BEGIN
    -- Check if a course with the same Crs_ID already exists
    IF EXISTS (SELECT 1 FROM Course WHERE Crs_ID = @Crs_ID)
    BEGIN
        SELECT 'Course with this ID already exists.' AS Message;
        RETURN;
    END

    -- Insert the new course into the Course table
    INSERT INTO Instructors.Course (Crs_ID, Crs_name, Description, Min_Degree, Max_Degree)
    VALUES (@Crs_ID, @Crs_name, @Description, @Min_Degree, @Max_Degree);

    -- Return success message
    SELECT 'New course added successfully.' AS Message;
END;

---------------------------------------------------------------------------------------------
--Create procedure for enable Training manager add new student 
CREATE or alter PROCEDURE Students.AddNewStudent
    @St_ID INT,
    @St_FName NVARCHAR(50),
    @St_LName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Password NVARCHAR(100),
    @Dept_ID INT,
    @Supervisor_ID INT,
    @Intake_ID INT,
    @Track_ID INT,
    @Manager_ID INT,
    @Branch_ID INT
with encryption
AS
BEGIN
    -- Check if a student with the same St_ID already exists
    IF EXISTS (SELECT 1 FROM Student WHERE St_ID = @St_ID)
    BEGIN
        SELECT 'Student with this ID already exists.' AS Message;
        RETURN;
    END

    -- Check if a student with the same Email already exists
    IF EXISTS (SELECT 1 FROM Student WHERE Email = @Email)
    BEGIN
        SELECT 'Student with this Email already exists.' AS Message;
        RETURN;
    END

    -- Insert the new student into the Student table
    INSERT INTO Students.Student (St_ID, St_FName, St_LName, Email, Password, Dept_ID, Supervisor_ID, Intake_ID, Track_ID, Manager_ID, Branch_ID)
    VALUES (@St_ID, @St_FName, @St_LName, @Email, @Password, @Dept_ID, @Supervisor_ID, @Intake_ID, @Track_ID, @Manager_ID, @Branch_ID);

    -- Return success message
    SELECT 'New student added successfully.' AS Message;
END;

---------------------------------------------------------------------------------------------
--Create procedure for insert data into table Instructor
CREATE or alter PROCEDURE Instructors.InsertInstructor
    @Ins_ID INT,
    @Ins_FName NVARCHAR(50),
    @Ins_LName NVARCHAR(50),
    @Ins_degree NVARCHAR(50),
    @Age INT,
    @Email NVARCHAR(100),
    @Password NVARCHAR(100),
    @Salary DECIMAL(18, 2),
    @Dept_ID INT
with Encryption
AS
BEGIN
    -- Check if an instructor with the same Ins_ID already exists
    IF EXISTS (SELECT 1 FROM Instructor WHERE Ins_ID = @Ins_ID)
    BEGIN
        SELECT 'Instructor with this ID already exists.' AS Message;
        RETURN;
    END

    -- Check if an instructor with the same Email already exists
    IF EXISTS (SELECT 1 FROM Instructor WHERE Email = @Email)
    BEGIN
        SELECT 'Instructor with this Email already exists.' AS Message;
        RETURN;
    END

    -- Insert the new instructor into the Instructor table
    INSERT INTO Instructors.Instructor (Ins_ID, Ins_FName, Ins_LName, Ins_degree, Age, Email, Password, Salary, Dept_ID)
    VALUES (@Ins_ID, @Ins_FName, @Ins_LName, @Ins_degree, @Age, @Email, @Password, @Salary, @Dept_ID);

    -- Return success message
    SELECT 'New instructor added successfully.' AS Message;
END;
----------------------------------------------------------------------------
--create procedure that Assign courses That instructor to teach for student
CREATE or alter PROCEDURE Instructors.AssignInstructorToCourse
    @Course_ID INT,
    @Instructor_ID INT
with encryption
AS
BEGIN
    BEGIN TRY
        -- Check if the association already exists
        IF EXISTS (SELECT 1 FROM Instructor_Courses WHERE Course_ID = @Course_ID AND Instructor_ID = @Instructor_ID)
        BEGIN
            SELECT 'Instructor is already assigned to teach this course.' AS Message;
            RETURN;
        END

        -- Insert the association into Instructor_Courses table
        INSERT INTO Instructors.Instructor_Courses (Course_ID, Instructor_ID)
        VALUES (@Course_ID, @Instructor_ID);

        -- Return success message
        SELECT 'Instructor assigned to teach course successfully.' AS Message;

    END TRY
    BEGIN CATCH
        -- Return error message
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;

--------------------------------------------------------------------------
--Views

--This view display for each instructor which courses he teach
create view Instructors.Courses_Teached_ByInstructor
with encryption
as
select i.Ins_ID , i.Ins_FName + ' ' + i.Ins_LName as'Instructor Full Name',
i.Ins_degree,c.Crs_ID,c.Crs_name,c.Description
from Instructor i inner join Instructor_Courses ic
on ic.Instructor_ID = i.Ins_ID inner join Course c
on ic.Course_ID = c.Crs_ID
group by i.Ins_ID, i.Ins_FName + ' ' + i.Ins_LName ,i.Ins_degree,c.Crs_ID,c.Crs_name,c.Description
------------------------------------------------------------------------------
--This view shows branches that added and updated in each department by each Training Manager
create view TrainingManagers.Updates_and_AddsInBranch_ByTriningManager
with encryption
as
select t.Manager_id,t.Manager_Fname + ' ' + t.Manager_Lname as'Manager Full Name',
b.Baranch_id,b.Barnch_name,d.Dept_id,d.Dept_name

from TrainingManagers.Training_Manager t inner join TrainingManagers.Update_adds_inbranch un
on un.Manager_id = t.Manager_id inner join TrainingManagers.Branch b
on un.Branch_id = b.Baranch_id inner join DatabaseAdmin.Department d
on un.Dept_it = d.Dept_id
group by d.Dept_id,d.Dept_name,t.Manager_id,t.Manager_Fname + ' ' + t.Manager_Lname,b.Baranch_id,b.Barnch_name

------------------------------------------------------------------------------
--This view shows Tracks that added and updated in each department by each Training Manager
create view TrainingManagers.Updates_and_AddsInTrack_ByTriningManager
with encryption
as
select t.Manager_id,t.Manager_Fname + ' ' + t.Manager_Lname as'Manager Full Name',
tr.Track_id,tr.Track_name,d.Dept_id,d.Dept_name

from TrainingManagers.Training_Manager t inner join TrainingManagers.Update_adds_inTrack ut
on ut.Manager_id = t.Manager_id inner join TrainingManagers.Track tr
on ut.Track_id = tr.Track_id inner join DatabaseAdmin.Department d
on ut.dept_id = d.Dept_id
group by t.Manager_id,t.Manager_Fname + ' ' + t.Manager_Lname,tr.Track_id,tr.Track_name,d.Dept_id,d.Dept_name

------------------------------------------------------------------------------
---------------------------------Functions-----------------------------------------

--********************************Inline Table Functions********************************


-- This inline table function displays intakes that added by each training manager
CREATE FUNCTION TrainingManagers.GetIntakesByManager()
RETURNS TABLE
AS
RETURN
(
    SELECT t.Manager_id,t.Manager_Fname + ' ' + t.Manager_Lname as'Manager Name',
	i.Intake_id,i.Intake_name,i.Branch_Id

	from TrainingManagers.Training_Manager t inner join TrainingManagers.Intake_addedby_manager im 
	on im.Manager_id = t.Manager_id inner join Intake i
	on im.Intack_id = i.Intake_id
);  


------------------------------------------------------------------------------
--This inline functions display students that added by training manager in a system
CREATE FUNCTION TrainingManagers.GetStudentsByManager()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        tm.Manager_id,
        tm.Manager_Fname,
        tm.Manager_Lname,
        s.St_ID,
        s.St_FName,
        s.St_LName,
        s.Email,
        s.Dept_ID,
        s.Intake_ID,
        s.Track_ID,
        s.Branch_ID
    FROM 
        TrainingManagers.Training_Manager tm
    JOIN 
        Students.Student s ON tm.Manager_id = s.Manager_ID
);



--------------------------------------------------------------------------

-- Function To get Course  Name and Description from Course ID
CREATE FUNCTION Instructors.GetCourseDetails (@Crs_ID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Crs_name,
        Description
    FROM 
        Instructors.Course
    WHERE 
        Crs_ID = @Crs_ID
);


------------------------------------------------------------------------------
--************************************Scaler Functions*********************************


-- Function to get student full name by Enter ID
CREATE FUNCTION TrainingManagers.GetStudentNameBYID (@St_ID INT)
RETURNS NVARCHAR(101)
AS
BEGIN
    DECLARE @FullName NVARCHAR(101);
    SELECT @FullName = St_FName + ' ' + St_LName
    FROM Students.Student
    WHERE St_ID = @St_ID;
    RETURN @FullName;
END;
GO
---------------------------------------------------------------------------------

-- Function to get the instructor full name
CREATE FUNCTION DatabaseAdmin.GetInstructorNameByID (@Ins_ID INT)
RETURNS NVARCHAR(101)
AS
BEGIN
    DECLARE @FullName NVARCHAR(Max);
    SELECT @FullName = Ins_FName + ' ' + Ins_LName
    FROM Instructors.Instructor
    WHERE Ins_ID = @Ins_ID;
    RETURN @FullName;
END;
GO
-------------------------------------------------------------------------------

--This function return Training Manager Name by his id
CREATE FUNCTION DatabaseAdmin.GetManagerNameByID (@Manager_ID INT)
RETURNS NVARCHAR(max)
as
begin
 DECLARE @FullName NVARCHAR(Max);
 select @FullName = Manager_Fname + ' ' + Manager_Lname 
 from TrainingManagers.Training_Manager 
 where Manager_id = @Manager_ID
     RETURN @FullName;
END;
GO

--------------------------------------------------------------



/*******************************************************************/
-- Youssef Part
/*
* Instructor can make Exam (For his coLurse only) by selecting number of questions of each type,
the system selects the questions random, or he can select them manually from question pool.
And he must put a degree for each question on the exam, and total degrees must not exceed the
courseMax Degree (One course may has more than one exam).
* For each exam, we should know type (exam or corrective), intake, branch, track, course, start
time, End time, total time and allowance options.
* System should store each exam which defined by year, Course, instructor.
*/
/*******************************************************************/

-- Create Exam table with additional fields
CREATE TABLE Exam (
    Exam_ID INT PRIMARY KEY IDENTITY,
    Exam_Name NVARCHAR(100),
    Course_ID INT,
    Instructor_ID INT,
    Exam_Type NVARCHAR(50) /* Exam, Corrective */,
    Intake INT,
    Branch_ID INT,
    Track_ID INT,
    Start_Time DATETIME,
    End_Time DATETIME,
    Total_Time INT,
    Allowance NVARCHAR(MAX),
    Year INT,
    FOREIGN KEY (Course_ID) REFERENCES Instructors.Course(Crs_ID),
    FOREIGN KEY (Instructor_ID) REFERENCES Instructors.Instructor(Ins_ID),
	FOREIGN KEY (Intake) REFERENCES TrainingManagers.Intake(Intake_id),
	FOREIGN KEY (Branch_ID) REFERENCES TrainingManagers.Branch(Baranch_id),
	FOREIGN KEY (Track_ID) REFERENCES TrainingManagers.Track(Track_id)
);
GO
-- Create Question table with fields for correct answers
CREATE TABLE Question (
    Q_ID INT PRIMARY KEY IDENTITY,
    Q_Text NVARCHAR(MAX),
    Q_Type NVARCHAR(50),
    INS_ID INT,
    Q_Degree INT,
    Correct_Answer NVARCHAR(MAX),
    FOREIGN KEY (INS_ID) REFERENCES Instructors.Instructor(Ins_ID)
);
GO
-- Procedure to insert a new question with correct answer
CREATE PROCEDURE Instructors.InsertQuestionWithAnswer
    @Q_Text NVARCHAR(MAX),
    @Q_Type NVARCHAR(50),
    @INS_ID INT,
    @Q_Degree INT,
    @Correct_Answer NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Instructors.Question (Q_Text, Q_Type, INS_ID, Q_Degree, Correct_Answer)
    VALUES (@Q_Text, @Q_Type, @INS_ID, @Q_Degree, @Correct_Answer);
END;
GO
----------------------------------------------
--Exam_Question Table
CREATE TABLE Exam_Question (
    Q_ID INT,
    Exam_ID INT,
	Q_Degree int,
    PRIMARY KEY (Q_ID, Exam_ID),
    FOREIGN KEY (Q_ID) REFERENCES Instructors.Question(Q_ID),
	constraint Exam_ID_ques_fk foreign key (Exam_ID)
    references Instructors.Exam(Exam_Id)
);



-- Procedure to create an exam and select questions
CREATE OR ALTER PROCEDURE Instructors.CreateExamWithQuestions
    @Exam_Name NVARCHAR(100),
    @Course_ID INT,
    @Instructor_ID INT,
    @Exam_Type NVARCHAR(50),
    @Intake INT,
    @Branch_ID INT,
    @Track_ID INT,
    @Start_Time DATETIME,
    @End_Time DATETIME,
    @Allowance NVARCHAR(MAX),
    @Year INT,
    @Num_MCQ INT,
    @Num_TrueFalse INT,
    @Num_Essay INT,
    @Manual_Question_IDs NVARCHAR(MAX) = NULL,  -- Comma-separated question IDs if manually selected
    @Degrees NVARCHAR(MAX) = NULL               -- Comma-separated degrees for each question if manually selected
AS
BEGIN
    DECLARE @Exam_ID INT;
    DECLARE @Total_Degrees INT = 0;
    DECLARE @Degree INT;
    DECLARE @ID INT;
    DECLARE @Total_Time INT;
    DECLARE @DegreeList TABLE (Degree INT);

    -- Calculate Total_Time from Start_Time and End_Time
    SET @Total_Time = DATEDIFF(MINUTE, @Start_Time, @End_Time);

    -- Check if the instructor is allowed to create an exam for the specified course
    IF NOT EXISTS (SELECT 1 FROM Instructors.Instructor_Courses WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Course_ID)
    BEGIN
        RAISERROR('The instructor is not allowed to create an exam for this course', 16, 1);
        RETURN;
    END

    -- Insert the exam into the Exam table
    INSERT INTO Instructors.Exam (Exam_Name, Course_ID, Instructor_ID, Exam_Type, Intake, Branch_ID, Track_ID, Start_Time, End_Time, Total_Time, Allowance, Year)
    VALUES (@Exam_Name, @Course_ID, @Instructor_ID, @Exam_Type, @Intake, @Branch_ID, @Track_ID, @Start_Time, @End_Time, @Total_Time, @Allowance, @Year);

    -- Get the newly inserted Exam_ID
    SET @Exam_ID = SCOPE_IDENTITY();

    -- If questions are manually selected
    IF @Manual_Question_IDs IS NOT NULL
    BEGIN
        -- Split the Manual_Question_IDs and Degrees into individual values
        DECLARE @QuestionList TABLE (Q_ID INT, Q_Degree INT);
        DECLARE @Q_IDList NVARCHAR(MAX) = @Manual_Question_IDs;
        DECLARE @Q_DegreeList NVARCHAR(MAX) = @Degrees;
        WHILE CHARINDEX(',', @Q_IDList) > 0
        BEGIN
            SET @ID = CAST(SUBSTRING(@Q_IDList, 1, CHARINDEX(',', @Q_IDList) - 1) AS INT);
            SET @Degree = CAST(SUBSTRING(@Q_DegreeList, 1, CHARINDEX(',', @Q_DegreeList) - 1) AS INT);
            INSERT INTO @QuestionList (Q_ID, Q_Degree) VALUES (@ID, @Degree);
            SET @Q_IDList = SUBSTRING(@Q_IDList, CHARINDEX(',', @Q_IDList) + 1, LEN(@Q_IDList));
            SET @Q_DegreeList = SUBSTRING(@Q_DegreeList, CHARINDEX(',', @Q_DegreeList) + 1, LEN(@Q_DegreeList));
        END

        -- Insert the last pair of ID and Degree
        SET @ID = CAST(@Q_IDList AS INT);
        SET @Degree = CAST(@Q_DegreeList AS INT);
        INSERT INTO @QuestionList (Q_ID, Q_Degree) VALUES (@ID, @Degree);

        -- Insert into Exam_Question and update total degrees
        INSERT INTO Instructors.Exam_Question (Q_ID, Exam_ID, Q_Degree)
        SELECT Q_ID, @Exam_ID, Q_Degree FROM @QuestionList;
        SET @Total_Degrees = (SELECT SUM(Q_Degree) FROM @QuestionList);
    END
    ELSE
    BEGIN
        -- Randomly select questions
        -- Select MCQ questions
        INSERT INTO Instructors.Exam_Question (Q_ID, Exam_ID, Q_Degree)
        SELECT TOP (@Num_MCQ) Q_ID, @Exam_ID, Q_Degree FROM Question WHERE Q_Type = 'MCQ' AND INS_ID = @Instructor_ID ORDER BY NEWID();

        -- Select True/False questions
        INSERT INTO Instructors.Exam_Question (Q_ID, Exam_ID, Q_Degree)
        SELECT TOP (@Num_TrueFalse) Q_ID, @Exam_ID, Q_Degree FROM Question WHERE Q_Type = 'True/False' AND INS_ID = @Instructor_ID ORDER BY NEWID();

        -- Select Essay questions
        INSERT INTO Instructors.Exam_Question (Q_ID, Exam_ID, Q_Degree)
        SELECT TOP (@Num_Essay) Q_ID, @Exam_ID, Q_Degree FROM Question WHERE Q_Type = 'Essay' AND INS_ID = @Instructor_ID ORDER BY NEWID();

        -- Calculate total degrees for randomly selected questions
        SET @Total_Degrees = (SELECT SUM(Q_Degree) FROM Exam_Question WHERE Exam_ID = @Exam_ID);
    END

    -- Check if Total Degrees exceed Course Max Degree
    DECLARE @Max_Degree INT;
    SELECT @Max_Degree = Max_Degree FROM Course WHERE Crs_ID = @Course_ID;

    IF @Total_Degrees > @Max_Degree
    BEGIN
        RAISERROR('Total degrees exceed the course max degree', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
--------------------------------------------------------------
-- Function to get all exam details 
CREATE FUNCTION Instructors.GetExamDetails(@Exam_ID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        E.Exam_ID,
        E.Exam_Name,
        E.Course_ID,
        C.Crs_name AS Course_Name,
        E.Instructor_ID,
        I.Ins_FName + ' ' + I.Ins_LName AS Instructor_Name,
        E.Exam_Type,
        E.Intake,
        E.Branch_ID,
        E.Track_ID,
        E.Start_Time,
        E.End_Time,
        E.Total_Time,
        E.Allowance,
        E.Year,
        EQ.Q_ID,
        Q.Q_Text,
        Q.Q_Type,
        EQ.Q_Degree,
        Q.Correct_Answer
    FROM
        Exam E
        JOIN Instructors.Course C ON E.Course_ID = C.Crs_ID
        JOIN Instructors.Instructor I ON E.Instructor_ID = I.Ins_ID
        JOIN Instructors.Exam_Question EQ ON E.Exam_ID = EQ.Exam_ID
        JOIN Instructors.Question Q ON EQ.Q_ID = Q.Q_ID
    WHERE
        E.Exam_ID = @Exam_ID
);
GO

-- function to search for a specific keyword in question table 
CREATE FUNCTION Instructors.SearchQuestionsByKeyword(@Keyword NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
(
    SELECT
        Q.Q_ID,
        Q.Q_Text,
        Q.Q_Type,
        Q.INS_ID,
        Q.Q_Degree,
        Q.Correct_Answer
    FROM
        Instructors.Question Q
    WHERE
        Q.Q_Text LIKE '%' + @Keyword + '%'
);
GO

/******************** Indexers *************************/
-- Department indexers 
-- Index on Dept_name for searching by department name
CREATE INDEX IX_Department_Dept_name ON DatabaseAdmin.Department (Dept_name);

-- Index on Dept_location for filtering by department location
CREATE INDEX IX_Department_Dept_location ON DatabaseAdmin.Department (Dept_location);
GO

-- Training_Manager indexers 
-- Index on Email for efficient lookups by email
CREATE INDEX IX_Training_Manager_Email ON TrainingManagers.Training_Manager (Email);
Go
-- Index on Manager_Fname and Manager_Lname for searching by name
CREATE INDEX IX_Training_Manager_Name ON TrainingManagers.Training_Manager (Manager_Fname, Manager_Lname);
GO

-- Branch indexers
-- Index on dept_id for joining with Department table
CREATE INDEX IX_Branch_dept_id ON TrainingManagers.Branch (dept_id);
GO

-- Student Indexers 
-- Index on Email for efficient lookups by email
CREATE INDEX IX_Student_Email ON Students.Student (Email);
-- Index on Dept_ID, Intake_ID, Track_ID, Manager_ID, and Branch_ID for joins and filtering
CREATE INDEX IX_Student_Dept_ID ON Students.Student (Dept_ID);
CREATE INDEX IX_Student_Intake_ID ON Students.Student (Intake_ID);
CREATE INDEX IX_Student_Track_ID ON Students.Student (Track_ID);
CREATE INDEX IX_Student_Manager_ID ON Students.Student (Manager_ID);
CREATE INDEX IX_Student_Branch_ID ON Students.Student (Branch_ID);
GO

-- Instructor Indexers 
-- Index on Email for efficient lookups by email
CREATE INDEX IX_Instructor_Email ON Instructors.Instructor (Email);
-- Index on Dept_ID for joining with Department table
CREATE INDEX IX_Instructor_Dept_ID ON Instructors.Instructor (Dept_ID);
GO

-- Instructor_Courses indexers
-- Composite index on Instructor_ID and Course_ID for efficient lookups and joins
CREATE INDEX IX_Instructor_Courses_Instructor_Course ON Instructors.Instructor_Courses (Instructor_ID, Course_ID);
GO

-- Question indexers 
-- an index on Q_ID column
CREATE INDEX IX_Question_Q_Text ON Instructors.Question ([Q_ID]);
GO

-- an index on INS_ID column for filtering by instructor
CREATE INDEX IX_Question_INS_ID ON Instructors.Question (INS_ID);
GO

-- Exam Indexers 
-- Create an index on Course_ID column for filtering by course
CREATE INDEX IX_Exam_Course_ID ON Instructors.Exam (Course_ID);
GO
-- an index on Instructor_ID column for filtering by instructor
CREATE INDEX IX_Exam_Instructor_ID ON Instructors.Exam (Instructor_ID);
GO
-- an index on Start_Time and End_Time columns for filtering by time range
CREATE INDEX IX_Exam_Start_End_Time ON Instructors.Exam (Start_Time, End_Time);
GO

-- Exam_Question Indexers
-- an index on Exam_ID column for filtering by exam
CREATE INDEX IX_Exam_Question_Exam_ID ON Instructors.Exam_Question (Exam_ID);
GO
-- an index on Q_ID column for filtering by question
CREATE INDEX IX_Exam_Question_Q_ID ON Instructors.Exam_Question (Q_ID);
GO

-- Instructor_Courses Indexers 
-- a composite index on Ins_ID and Crs_ID columns for instructor-course relationships
CREATE INDEX IX_Instructor_Courses_Ins_Crs ON Instructors.Instructor_Courses (Instructor_ID, Course_ID);
GO




--creation of table Exams that Token by students
create table StudentExams(
Exam_ID int ,
Student_ID int , 
StartTime DATETIME,
EndTime DATETIME
constraint Exam_Student_pk Primary Key (Student_ID,Exam_Id),
constraint Exam_Student_fk foreign key (Student_ID)
references Students.Student(St_ID),
constraint Exam_fk foreign key (Exam_ID)
references Instructors.Exam(Exam_Id)
);

------------------------------------------------------------------------------
--Marina's part

--creation of table Exams that Token by students
create table StudentExams(
Exam_ID int ,
Student_ID int , 
StartTime DATETIME,
EndTime DATETIME
constraint Exam_Student_pk Primary Key (Student_ID,Exam_Id),
constraint Exam_Student_fk foreign key (Student_ID)
references Students.Student(St_ID),
constraint Exam_fk foreign key (Exam_ID)
references Instructors.Exam(Exam_Id)
);


/*Instructor can select students that can do specific exam, 
and define Exam date, start time and end time. 
Students can see the exam and do it only on the specified tim*/

	CREATE OR ALTER  PROCEDURE SP_StudentExam
    @StudentID INT,
    @ExamID INT,
    @StartTime DATETIME,
    @EndTime DATETIME
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE St_ID = @StudentID)
    BEGIN
        RAISERROR('Error: StudentID does not exist.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Exam WHERE Exam_ID = @ExamID)
    BEGIN
        RAISERROR('Error: ExamID does not exist.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO StudentExams (Student_ID, Exam_ID, StartTime, EndTime)
        VALUES (@StudentID, @ExamID, @StartTime, @EndTime);

        PRINT 'Insert successful.'
    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

----CREATE TRIGGER trg_CheckExamTime
CREATE TRIGGER trg_CheckExamTime
ON StudentExams
AFTER INSERT
AS
BEGIN
    DECLARE @StudentID INT, @ExamID INT, @StartTime DATETIME, @EndTime DATETIME
    SELECT @StudentID = i.Student_ID, @ExamID = i.Exam_ID, @StartTime = i.StartTime, @EndTime = i.EndTime
    FROM inserted i

    -- Retrieve the exam's start and end times
    DECLARE @ExamStartTime DATETIME, @ExamEndTime DATETIME
    SELECT @ExamStartTime =e.Start_Time , @ExamEndTime = e.End_Time
    FROM Exam e
    WHERE e.Exam_ID = @ExamID

    -- Check if the student's start time is within the allowed exam time
    IF @StartTime < @ExamStartTime
    BEGIN
        RAISERROR ('Error: Exam has not started yet.', 16, 1) -- State 1: Exam not started
        ROLLBACK TRANSACTION
        RETURN
    END

    IF @StartTime > @ExamEndTime or @EndTime > @ExamEndTime
    BEGIN
        RAISERROR ('Error: Exam time has already ended.', 16, 2) -- State 2: Exam ended
        ROLLBACK TRANSACTION
        RETURN
    END

END
GO



-- Creation Table StudentAnswer
CREATE TABLE StudentAnswer (
    Answer_ID INT primary key,
    Student_ID INT,
    Exam_ID INT,
    Q_ID INT,
    Student_Answer NVARCHAR(MAX),
	IsCorrect int,
    FOREIGN KEY (Student_ID) REFERENCES Students.Student(St_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Instructors.Exam(Exam_ID),
    FOREIGN KEY (Q_ID) REFERENCES Instructors.Question(Q_ID)
);
GO


--This procedure used for insert Students answers into table StudentAnswer
CREATE or alter PROCEDURE Students.InsertStudentAnswer
    @Answer_ID INT,
    @StudentID INT,
    @ExamID INT,
    @Q_ID INT,
    @Student_Answer NVARCHAR(MAX),
	@IScorrect int
AS
BEGIN
    BEGIN TRY
        INSERT INTO Students.StudentAnswer (Answer_ID,Student_ID, Exam_ID, Q_ID, Student_Answer,IsCorrect)
        VALUES (@Answer_ID,@StudentID, @ExamID, @Q_ID, @Student_Answer,@IScorrect);

        PRINT 'Answer inserted successfully.'
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO




--This procedure for calculate Student's Total Degree
CREATE OR ALTER PROCEDURE Instructors.SP_calculateTotalDegree
    @St_ID INT,
    @Exam_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @totalDegree DECIMAL(5, 2);
    DECLARE @obtainedDegree DECIMAL(5, 2);
    DECLARE @Percentage DECIMAL(5, 2);
    DECLARE @CorrectiveExamID INT;
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;

    -- Calculate the total degree for the exam, excluding corrective questions with zero degrees
    SELECT @totalDegree = SUM(Q.[Q_Degree])
    FROM Instructors.Exam_Question Q
    WHERE Q.Exam_ID = @Exam_ID
      AND NOT EXISTS (
          SELECT 1
          FROM Instructors.Exam E
          WHERE E.Exam_ID = Q.Exam_ID
            AND E.Exam_Type = 'Corrective'
            AND Q.Q_Degree = 0
      );

    -- Calculate the obtained degree from the StudentAnswers table
    SELECT @obtainedDegree = SUM(CASE WHEN SA.IsCorrect = 1 THEN Q.Q_Degree ELSE 0 END)
    FROM Students.StudentAnswer SA
    JOIN Instructors.Question Q ON SA.Q_ID = Q.Q_ID
    WHERE SA.Student_ID = @St_ID
      AND SA.Exam_ID = @Exam_ID;

    -- Calculate the percentage
    IF @totalDegree > 0
        SET @Percentage = (@obtainedDegree / @totalDegree) * 100;
    ELSE
        SET @Percentage = 0; -- Handle division by zero scenario

    -- Return the obtained degree, total degree, and percentage
    SELECT @obtainedDegree AS StudentDegree, @totalDegree AS TotalDegree, @Percentage AS Percentage;

    -- Check if a corrective exam is needed and assign if necessary
    IF @Percentage < 60
    BEGIN
        -- Find or create a corrective exam
        SELECT @CorrectiveExamID = Exam_ID
        FROM Instructors.Exam
        WHERE Course_ID = (SELECT Course_ID FROM Instructors.Exam WHERE Exam_ID = @Exam_ID)
          AND Exam_Type = 'Corrective'
          AND [Intake] = (SELECT [Intake] FROM Instructors.Exam WHERE Exam_ID = @Exam_ID)
          AND Branch_ID = (SELECT Branch_ID FROM Instructors.Exam WHERE Exam_ID = @Exam_ID)
          AND Track_ID = (SELECT Track_ID FROM Instructors.Exam WHERE Exam_ID = @Exam_ID);

        IF @CorrectiveExamID IS NULL
        BEGIN
            -- Create a new corrective exam
            SET @StartTime = DATEADD(DAY, 7, GETDATE());
            SET @EndTime = DATEADD(HOUR, 2, @StartTime);

            INSERT INTO Instructors.Exam (Course_ID, Instructor_ID, Exam_Type, [Intake], Branch_ID, Track_ID, Start_Time, End_Time, Total_Time, Allowance)
            SELECT Course_ID, Instructor_ID, 'Corrective', [Intake], Branch_ID, Track_ID, @StartTime, @EndTime, 120, ''
            FROM Instructors.Exam
            WHERE Exam_ID = @Exam_ID;

            SET @CorrectiveExamID = SCOPE_IDENTITY(); -- Get the newly created ExamID
        END

        -- Assign the corrective exam to the student
        INSERT INTO Students.StudentExams (Student_ID, Exam_ID, StartTime, EndTime)
        VALUES (@St_ID, @CorrectiveExamID, GETDATE(), DATEADD(DAY, 7, GETDATE()));

        RAISERROR ('Student ID %d scored less than 60%% in Exam ID %d and has been assigned a corrective exam.', 10, 1, @St_ID, @Exam_ID);
    END
END;

--This view shows Questions and answers and Student answers for this question
create view Student_Questions_Answers
with encryption
as
select s.St_ID,s.St_FName + ' ' + s.St_LName as 'Student Name', 
iq.Q_ID ,iq.Q_Type ,iq.Q_Degree,iq.Q_Text, sa.Answer_ID, sa.Student_Answer,sa.ISCorrect
from Instructors.Question iq inner join Students.StudentAnswer sa
on iq.Q_ID = sa.Q_ID inner join Students.Student s
on sa.Student_ID = s.St_ID

select * from Student_Questions_Answers

--This view shows Exams that students take part in
create view Student_andExamsThat_Tooken
with encryption
as
select s.St_ID,s.St_FName + ' ' + s.St_LName as 'Student Name',s.Dept_ID,s.Intake_ID,s.Branch_ID,s.Track_ID,se.Exam_ID,se.StartTime,se.EndTime
from Students.Student s inner join Students.StudentExams se
on se.Student_ID = s.St_ID 

select * from Student_andExamsThat_Tooken


------------------------------------------------------------------------------------------
--I dont run this table for yet


/**
--Result Table
CREATE TABLE Result (
    Result_ID INT PRIMARY KEY,
    Score INT
);

-- Final_Result table
CREATE TABLE Final_Result (
    St_ID INT,
    Crs_ID INT,
    Result_ID INT,
    PRIMARY KEY (St_ID, Crs_ID, Result_ID),
    FOREIGN KEY (St_ID) REFERENCES Student(St_ID),
    FOREIGN KEY (Crs_ID) REFERENCES Course(Crs_ID),
    FOREIGN KEY (Result_ID) REFERENCES Result(Result_ID)
);

--Instructor_Select_Questions Table
CREATE TABLE Instructor_Select_Questions (
    Ins_ID INT,
    Question_ID INT,
    PRIMARY KEY (Ins_ID, Question_ID),
    FOREIGN KEY (Ins_ID) REFERENCES Instructor(Ins_ID),
    FOREIGN KEY (Question_ID) REFERENCES Question(Q_ID)
);

--creation of table Exams that belongs to Intakes
Create table Exams_Intakes(
Intake_ID int ,
Exam_Id int,

constraint Exam_Intake_pk Primary Key (Intake_ID,Exam_Id),

constraint Exam_Intake_fk foreign key (Exam_Id)
references Exam(Exam_Id),

constraint Intake_ID_Ex_fk foreign key(Intake_ID)
references Intake(Intake_id)
);

--creation of table Exams that Assigned to Tracks
create table Exams_Tracks(
Exam_ID int ,
Track_ID int

constraint Exam_Track_pk Primary Key (Track_ID,Exam_Id),
constraint Exam_Track_fk foreign key (Exam_ID)
references Exam(Exam_Id),
constraint Track_ID_Ex_fk foreign key(Track_ID)
references Track(Track_id)
);


--creation of table Exams that Token by students
create table StudentExams(
Exam_ID int ,
Student_ID int , 
StartTime DATETIME,
EndTime DATETIME
constraint Exam_Student_pk Primary Key (Student_ID,Exam_Id),
constraint Exam_Student_fk foreign key (Student_ID)
references Student(St_ID),
constraint Exam_fk foreign key (Exam_ID)
references Exam(Exam_Id)
);

--creation of table Exams created by instructors
create table Instructor_Exams(
Instructor_ID int ,
Exam_ID int ,
Exam_Year nvarchar(20),

constraint Exam_Instructor_pk Primary Key(Instructor_ID,Exam_ID),
constraint Exam_id_fk foreign key (Exam_ID)
references Exam(Exam_Id),
constraint Exam_Instructor_fk foreign key (Instructor_ID)
references Instructor (Ins_ID)
);

--Creation for table Answer
create table Answer (
Answer_ID int primary key identity(1,1),
Answer_Text nvarchar(max),
Answer_Validation nvarchar(max)
);


--Creation for Students that selected for exam by Instructor
create table Student_selected_ByInstructor(
Student_Id int ,
Ins_ID int ,
Exam_Date date ,
Start_Time nvarchar(50),
End_Time  nvarchar(50),

constraint Student_Instructor_pk primary key (Ins_ID,Student_Id),
constraint Student_Id_FK foreign key (Student_Id)
references Student(St_ID),
constraint Instructor_Stud_fk foreign key (Ins_ID)
references Instructor (Ins_ID)
);


--Creation for table Exams associated with branches
create table Exam_branches(
Exam_ID int ,
Branch_ID int ,

constraint Exam_branches_pk primary key (Exam_ID,Branch_ID),
constraint Exam_branches_fk foreign key (Exam_ID)
references Exam(Exam_Id),

constraint Branch_ID_Ex_fk foreign key(Branch_ID)
references Branch(Baranch_id)

);


--creation for table Student Answers
create table Students_Answers(
Stud_ID int ,
Answer_ID int ,

constraint Students_Answers_pk primary key (Stud_ID,Answer_ID),
constraint stud_fk foreign key (Stud_ID)
references Student(St_ID),
constraint Answer_ID_fk foreign key (Answer_ID)
references Answer (Answer_ID)
);





---------------------------------------------------------------------------------------------




----------Marina's part-------------

  create procedure Update_track
  @Manager_id int,
  @Track_id int,
  @dept_id int

   with encryption 
  as 
  begin 
       update Update_adds_intrack
      set 
	  Manager_id=@Manager_id,
      Track_id =@Track_id 
      where dept_id= @dept_id;

  end;
  go

--------------------------------------------------------------
create procedure Update_branch
        @Manager_id int ,
		@Branch_id int,
		@Dept_it int

		with encryption 
		as 
		begin 
		update Update_adds_inbranch
		set 
		Manager_id=@Manager_id,
		@Branch_id=@Branch_id
		where Dept_it=@Dept_it;
		end;




/*Instructor can select students that can do specific exam, 
and define Exam date, start time and end time. 
Students can see the exam and do it only on the specified tim*/


--------------------------------

	CREATE OR ALTER  PROCEDURE SP_StudentExam
    @StudentID INT,
    @ExamID INT,
    @StartTime DATETIME,
    @EndTime DATETIME
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE St_ID = @StudentID)
    BEGIN
        RAISERROR('Error: StudentID does not exist.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Exam WHERE Exam_ID = @ExamID)
    BEGIN
        RAISERROR('Error: ExamID does not exist.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO StudentExams (Student_ID, Exam_ID, StartTime, EndTime)
        VALUES (@StudentID, @ExamID, @StartTime, @EndTime);

        PRINT 'Insert successful.'
    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

--Calling SP_StudentExam Procedure 
EXEC SP_StudentExam @StudentID = 1, @ExamID = 1, @StartTime = '2024-06-01 09:00:00', @EndTime = '2024-06-01 11:00:00';
EXEC SP_StudentExam @StudentID = 2, @ExamID = 2, @StartTime = '2024-06-01 09:00:00', @EndTime = '2024-06-01 11:00:00';
EXEC SP_StudentExam @StudentID = 3, @ExamID = 4, @StartTime = '2024-06-01 09:00:00', @EndTime = '2024-06-01 11:00:00';
EXEC SP_StudentExam @StudentID = 4, @ExamID = 3, @StartTime = '2024-06-01 09:00:00', @EndTime = '2024-06-01 11:00:00';
EXEC SP_StudentExam @StudentID = 5, @ExamID = 3, @StartTime = '2025-06-01 09:00:00', @EndTime = '2025-06-01 11:00:00';
EXEC SP_StudentExam @StudentID = 6, @ExamID = 1, @StartTime = '2025-06-01 12:00:00', @EndTime = '2025-06-01 02:00:00';
EXEC SP_StudentExam @StudentID = 7, @ExamID = 2, @StartTime = '2025-06-01 07:00:00', @EndTime = '2025-06-01 09:00:00';
EXEC SP_StudentExam @StudentID = 8, @ExamID = 4, @StartTime = '2025-06-01 07:00:00', @EndTime = '2025-06-01 09:00:00';
EXEC SP_StudentExam @StudentID = 9, @ExamID = 3, @StartTime = '2025-06-01 09:00:00', @EndTime = '2025-06-01 11:00:00';
EXEC SP_StudentExam @StudentID = 10, @ExamID = 2, @StartTime = '2025-06-01 09:00:00', @EndTime = '2025-06-01 11:00:00';

----CREATE TRIGGER trg_CheckExamTime
CREATE TRIGGER trg_CheckExamTime
ON StudentExams
AFTER INSERT
AS
BEGIN
    DECLARE @StudentID INT, @ExamID INT, @StartTime DATETIME, @EndTime DATETIME
    SELECT @StudentID = i.Student_ID, @ExamID = i.Exam_ID, @StartTime = i.StartTime, @EndTime = i.EndTime
    FROM inserted i

    -- Retrieve the exam's start and end times
    DECLARE @ExamStartTime DATETIME, @ExamEndTime DATETIME
    SELECT @ExamStartTime =e.Start_Time , @ExamEndTime = e.End_Time
    FROM Exam e
    WHERE e.Exam_ID = @ExamID

    -- Check if the student's start time is within the allowed exam time
    IF @StartTime < @ExamStartTime
    BEGIN
        RAISERROR ('Error: Exam has not started yet.', 16, 1) -- State 1: Exam not started
        ROLLBACK TRANSACTION
        RETURN
    END

    IF @StartTime > @ExamEndTime or @EndTime > @ExamEndTime
    BEGIN
        RAISERROR ('Error: Exam time has already ended.', 16, 2) -- State 2: Exam ended
        ROLLBACK TRANSACTION
        RETURN
    END

END
GO

---------------------------------------------------------------------------------------
/*System should store students answer for the exam and 
calculate the correct answers, 
and calculate final result for the student in this course*/

--insert data Exam_Question
INSERT INTO [Examination2].[dbo].[Exam_Question] ([Exam_ID], [Q_ID], [Q_Degree])
VALUES 
    (1, 1, 10), -- Example data row 1
    (1, 2, 8),  -- Example data row 2
    (1, 3, 9);  -- Example data row 3


--insert data Students_Answers
INSERT INTO [Examination2].[dbo].[Students_Answers] ([Stud_ID], [Answer_ID])
VALUES
    (1, 101),
    (2, 102),
    (3, 103),
    (4, 104),
    (5, 105),
    (6, 106),
    (7, 107),
    (8, 108),
    (9, 109),
    (10, 110);

--insert data Students_Answers
INSERT INTO [Examination2].[dbo].[Final_Result] ([St_ID], [Crs_ID], [Result_ID])
VALUES
    (1, 101, 201),
    (2, 102, 202),
    (3, 103, 203),
    (4, 104, 204),
    (5, 105, 205),
    (6, 106, 206),
    (7, 107, 207),
    (8, 108, 208),
    (9, 109, 209),
    (10, 110, 210);

CREATE OR ALTER PROCEDURE SP_calculateTotalDegree
    @studentId INT,
    @examId INT
AS
BEGIN
    DECLARE @totalDegree DECIMAL(5, 2);
    DECLARE @obtainedDegree DECIMAL(5, 2);
    DECLARE @Percentage DECIMAL(5, 2);
    DECLARE @CorrectiveExamID INT;
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;

    -- Calculate the total degree for the exam, excluding corrective questions with zero degrees
    SELECT @totalDegree = SUM(Q.Degree)
    FROM ExamQuestions Q
    JOIN Exams E ON Q.ExamID = E.ExamID
    WHERE Q.ExamID = @examId AND NOT (E.ExamType = 'Corrective' AND Q.Degree = 0);

    -- Calculate the obtained degree from the StudentAnswers table
    SELECT @obtainedDegree = SUM(Degree)
    FROM StudentAnswers SA
    WHERE SA.StudentExamID IN (
        SELECT StudentExamID
        FROM StudentExams
        WHERE StudentID = @studentId AND ExamID = @examId
    )
    AND (SA.IsCorrect = 1 OR (SA.IsCorrect = 0 AND SA.Degree IS NOT NULL));

    -- Calculate the percentage
    SET @Percentage = (@obtainedDegree / @totalDegree) * 100;

    -- Return the obtained degree, total degree, and percentage
    SELECT @obtainedDegree AS StudentDegree, @totalDegree AS TotalDegree, @Percentage AS Percentage;

    -- Check if a corrective exam is needed and assign if necessary
    IF @Percentage < 60
    BEGIN
        -- Find or create a corrective exam
        SELECT @CorrectiveExamID = ExamID
        FROM Exams
        WHERE CourseID = (SELECT CourseID FROM Exams WHERE ExamID = @examId)
          AND ExamType = 'Corrective'
          AND IntakeID = (SELECT IntakeID FROM Exams WHERE ExamID = @examId)
          AND BranchID = (SELECT BranchID FROM Exams WHERE ExamID = @examId)
          AND TrackID = (SELECT TrackID FROM Exams WHERE ExamID = @examId);

        IF @CorrectiveExamID IS NULL
        BEGIN
            -- Create a new corrective exam
            SET @StartTime = DATEADD(DAY, 7, GETDATE());
            SET @EndTime = DATEADD(HOUR, 2, @StartTime);

            INSERT INTO Exams (CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, AllowanceOptions)
            SELECT CourseID, InstructorID, 'Corrective', IntakeID, BranchID, TrackID, @StartTime, @EndTime, 120, ''
            FROM Exams
            WHERE ExamID = @examId;

            SET @CorrectiveExamID = SCOPE_IDENTITY(); -- Get the newly created ExamID
        END

        -- Assign the corrective exam to the student
        INSERT INTO StudentExams (StudentID, ExamID, StartTime, EndTime)
        VALUES (@studentId, @CorrectiveExamID, GETDATE(), DATEADD(DAY, 7, GETDATE()));
        
        RAISERROR ('Student ID %d scored less than 60%% in Exam ID %d and has been assigned a corrective exam.', 10, 1, @studentId, @examId);
    END
END;


*/