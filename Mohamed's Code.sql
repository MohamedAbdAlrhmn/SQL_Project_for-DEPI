--***************************************Mohamed's Part***************************************

--Tables 
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

--------------------------------------------------------------------------------------------

--Triggers

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

--------------------------------------------------------------------------------------------

--Main Procedures

--(1)create procedure for insert of table department
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

--Calling InsertDepartment procedure 
Exec DatabaseAdmin.InsertDepartment 1,'Computer Science', 'Building A'
Exec DatabaseAdmin.InsertDepartment 2,'Software Engineering', 'Building B'
Exec DatabaseAdmin.InsertDepartment 3,',Artificial Intelligence', 'Building C'
Exec DatabaseAdmin.InsertDepartment 4,'Data Science', 'Building D'
Exec DatabaseAdmin.InsertDepartment 5,'Cybersecurity', 'Building E'
Exec DatabaseAdmin.InsertDepartment 6,'Information Systems', 'Building F'


--(2)Create procedure for insert Data into table Training Manager


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

--Calling InsertTraninngManger Procedure
exec DatabaseAdmin.InsertTraninngManger 'John', 'Doe', 'john.doe@example.com', 'password123'
exec DatabaseAdmin.InsertTraninngManger 'Jane', 'Smith', 'jane.smith@example.com', 'password456'
exec DatabaseAdmin.InsertTraninngManger 'Michael', 'Johnson', 'michael.johnson@example.com', 'password789'
exec DatabaseAdmin.InsertTraninngManger 'Emily', 'Davis', 'emily.davis@example.com', 'password101'
exec DatabaseAdmin.InsertTraninngManger 'David', 'Brown', 'david.brown@example.com', 'password202'
exec DatabaseAdmin.InsertTraninngManger 'Linda', 'Wilson', 'linda.wilson@example.com', 'password303'
exec DatabaseAdmin.InsertTraninngManger 'Robert', 'Moore', 'robert.moore@example.com', 'password404'
exec DatabaseAdmin.InsertTraninngManger 'Patricia', 'Taylor', 'patricia.taylor@example.com', 'password505'
exec DatabaseAdmin.InsertTraninngManger 'Charles', 'Anderson', 'charles.anderson@example.com', 'password606'
exec DatabaseAdmin.InsertTraninngManger 'Barbara', 'Thomas', 'barbara.thomas@example.com', 'password707'


--(3)Create procedure that make Training Manager add new branch in a department
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

--Calling AddNewBranch Procedure 
EXEC TrainingManagers.AddNewBranch @Manager_id = 1, @Branch_name = 'New Branch 2019', @Dept_id = 1;
EXEC TrainingManagers.AddNewBranch @Manager_id = 1, @Branch_name = 'New Branch 2018', @Dept_id = 6;
EXEC TrainingManagers.AddNewBranch @Manager_id = 3, @Branch_name = 'New Branch 2020', @Dept_id = 2;
EXEC TrainingManagers.AddNewBranch @Manager_id = 4, @Branch_name = 'New Branch 2021', @Dept_id = 3;
EXEC TrainingManagers.AddNewBranch @Manager_id = 10, @Branch_name = 'New Branch 2015', @Dept_id = 4;
EXEC TrainingManagers.AddNewBranch @Manager_id = 7, @Branch_name = 'New Branch 2016', @Dept_id = 5;
EXEC TrainingManagers.AddNewBranch @Manager_id = 9, @Branch_name = 'New Branch 2017', @Dept_id = 1;
EXEC TrainingManagers.AddNewBranch @Manager_id = 2, @Branch_name = 'New Branch 2018', @Dept_id = 4;
EXEC TrainingManagers.AddNewBranch @Manager_id = 5, @Branch_name = 'New Branch 2022', @Dept_id = 3;
EXEC TrainingManagers.AddNewBranch @Manager_id = 6, @Branch_name = 'New Branch 2023', @Dept_id = 2;
EXEC TrainingManagers.AddNewBranch @Manager_id = 8, @Branch_name = 'New Branch 2024', @Dept_id = 5;
EXEC TrainingManagers.AddNewBranch @Manager_id = 2, @Branch_name = 'New Branch 2025', @Dept_id = 4;


--(4)Crate procedure that make Training Manager update branch in a department
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



--(5)Create procedure That enable Training manager to add new intake
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

--Calling AddNewIntake procedure
EXEC TrainingManagers.AddNewIntake @Manager_id = 1, @Intake_name = 'New Intake 2015', @Branch_id = 1;
EXEC TrainingManagers.AddNewIntake @Manager_id = 1, @Intake_name = 'New Intake 2016', @Branch_id = 2;
EXEC TrainingManagers.AddNewIntake @Manager_id = 2, @Intake_name = 'New Intake 2017', @Branch_id = 3;
EXEC TrainingManagers.AddNewIntake @Manager_id = 3, @Intake_name = 'New Intake 2018', @Branch_id = 4;
EXEC TrainingManagers.AddNewIntake @Manager_id = 4, @Intake_name = 'New Intake 2019', @Branch_id = 1;
EXEC TrainingManagers.AddNewIntake @Manager_id = 5, @Intake_name = 'New Intake 2020', @Branch_id = 6;
EXEC TrainingManagers.AddNewIntake @Manager_id = 6, @Intake_name = 'New Intake 2021', @Branch_id = 8;
EXEC TrainingManagers.AddNewIntake @Manager_id = 7, @Intake_name = 'New Intake 2022', @Branch_id = 7;
EXEC TrainingManagers.AddNewIntake @Manager_id = 8, @Intake_name = 'New Intake 2023', @Branch_id = 9;
EXEC TrainingManagers.AddNewIntake @Manager_id = 9, @Intake_name = 'New Intake 2024', @Branch_id = 10;
EXEC TrainingManagers.AddNewIntake @Manager_id = 10, @Intake_name = 'New Intake 2025', @Branch_id = 13;


--(6)Creating procedure that enable Training manager to add new track in a department
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

--calling AddNewTrack procedure
EXEC TrainingManagers.AddNewTrack @Manager_id = 10, @Track_name =' Machine Learning', @Dept_id = 1;
EXEC TrainingManagers.AddNewTrack @Manager_id = 2, @Track_name = '  Data Science', @Dept_id = 6;
EXEC TrainingManagers.AddNewTrack @Manager_id = 1, @Track_name = '  Software Development', @Dept_id = 2;
EXEC TrainingManagers.AddNewTrack @Manager_id = 4, @Track_name = '  Web Development', @Dept_id = 5;
EXEC TrainingManagers.AddNewTrack @Manager_id = 3, @Track_name = '  Database Management', @Dept_id = 3;


--(7)create procedure that enable Training Manger to update tracks in departments
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


--(8)Create procedure that insert courses
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

--calling InsertCourse procedure
EXEC Instructors.InsertCourse @Crs_ID = 101, @Crs_name = 'Database Systems', @Description = 'Introduction to database design, SQL, and database management systems.', @Min_Degree = 50, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 102, @Crs_name = 'Data Structures and Algorithms', @Description = 'Introduction to Data Structures and algorithms and how to implement it.', @Min_Degree = 60, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 103, @Crs_name = 'Python programming language', @Description = 'Explain basics of python and Explain advanced topics on it.', @Min_Degree = 50, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 104, @Crs_name = 'c# programming language', @Description = 'Explain basics of c# and Explain advanced topics like.Net core .', @Min_Degree = 60, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 105, @Crs_name = 'Machine & Deep learning ', @Description = 'Introduction to Machine learning and deep learning .', @Min_Degree = 50, @Max_Degree = 100;


--(9)Create procedure for enable Training manager add new student 
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

--calling AddNewStudent procedure 
EXEC Students.AddNewStudent @St_ID = 1, @St_FName = 'John', @St_LName = 'Doe', @Email = 'john.doe@example.com', @Password = 'John_Doe100', @Dept_ID = 5, @Supervisor_ID = NULL, @Intake_ID = 10, @Track_ID = 1, @Manager_ID = 1, @Branch_ID = 1;
EXEC Students.AddNewStudent @St_ID = 2, @St_FName = 'Bob', @St_LName = 'Smith', @Email = 'Bob.Smith@example.com', @Password = 'Bob_Smith200', @Dept_ID = 6, @Supervisor_ID = 1, @Intake_ID = 13, @Track_ID = 6, @Manager_ID = 3, @Branch_ID = 4;
EXEC Students.AddNewStudent @St_ID = 3, @St_FName = 'Charlie', @St_LName = 'Brown', @Email = 'Charlie.Brown@example.com', @Password = 'Charlie_Brown300', @Dept_ID = 4, @Supervisor_ID = 2, @Intake_ID = 12, @Track_ID = 4, @Manager_ID = 2, @Branch_ID = 2;
EXEC Students.AddNewStudent @St_ID = 4, @St_FName = 'David', @St_LName = 'Wilson', @Email = 'David.Wilson@example.com', @Password = 'David_Wilson400', @Dept_ID = 5, @Supervisor_ID = 1, @Intake_ID = 1, @Track_ID = 3, @Manager_ID = 5, @Branch_ID = 3;
EXEC Students.AddNewStudent @St_ID = 5, @St_FName = 'Eva', @St_LName = 'Davis', @Email = 'Eva.Davis@example.com', @Password = 'Eva_Davis500', @Dept_ID = 1, @Supervisor_ID = 1, @Intake_ID = 1, @Track_ID = 4, @Manager_ID = 7, @Branch_ID = 9;
EXEC Students.AddNewStudent @St_ID = 6, @St_FName = 'Frank', @St_LName = 'Moore', @Email = 'Eva.Moore@example.com', @Password = 'Frank_Moore600', @Dept_ID = 2, @Supervisor_ID = 3, @Intake_ID = 11, @Track_ID = 5, @Manager_ID = 10, @Branch_ID = 10;
EXEC Students.AddNewStudent @St_ID = 7, @St_FName = 'Grace', @St_LName = 'Taylor', @Email = 'Grace.Taylor@example.com', @Password = 'Grace_Taylor700', @Dept_ID = 3, @Supervisor_ID = 3, @Intake_ID = 3, @Track_ID = 3, @Manager_ID = 3, @Branch_ID = 3;
EXEC Students.AddNewStudent @St_ID = 8, @St_FName = 'Henry', @St_LName = 'Anderson', @Email = 'Henry.Anderson@example.com', @Password = 'Henry_Anderson800', @Dept_ID = 4, @Supervisor_ID = 4, @Intake_ID = 8, @Track_ID = 6, @Manager_ID = 4, @Branch_ID = 4;
EXEC Students.AddNewStudent @St_ID = 9, @St_FName = 'Jack', @St_LName = 'Jackson', @Email = 'Jack.Jackson@example.com', @Password = 'Henry_Jackson900', @Dept_ID = 2, @Supervisor_ID = 5, @Intake_ID = 5, @Track_ID = 5, @Manager_ID = 6, @Branch_ID = 6;
EXEC Students.AddNewStudent @St_ID = 10, @St_FName = 'John', @St_LName = 'Smith', @Email = 'John.Smith@example.com', @Password = 'John_Smith1000', @Dept_ID = 4, @Supervisor_ID = 1, @Intake_ID = 11, @Track_ID = 3, @Manager_ID = 6, @Branch_ID = 3;
EXEC Students.AddNewStudent @St_ID = 11, @St_FName = 'Jinat', @St_LName = 'Jan', @Email = 'Jinat.Jan@example.com', @Password = 'Jinat_Jan1001', @Dept_ID = 3, @Supervisor_ID = 4, @Intake_ID = 8, @Track_ID = 3, @Manager_ID = 6, @Branch_ID = 3;


--(10)Create procedure for insert data into table Instructor
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

--calling InsertInstructor procedure
exec Instructors.InsertInstructor 
    @Ins_ID = 1, 
    @Ins_FName = 'John', 
    @Ins_LName = 'Doe', 
    @Ins_degree = 'PhD', 
    @Age = 45, 
    @Email = 'john.doe@example.com', 
    @Password = 'John_Doe@123', 
    @Salary = 90000.00, 
    @Dept_ID = 1;

exec Instructors.InsertInstructor
 @Ins_ID = 2, 
    @Ins_FName = 'Jane', 
    @Ins_LName = 'Smith', 
    @Ins_degree = 'MSc', 
    @Age = 38, 
    @Email = 'Jane.smith@example.com', 
    @Password = 'Jane_smith@451', 
    @Salary = 85000.00, 
    @Dept_ID = 1;
 
 exec Instructors.InsertInstructor 
  @Ins_ID = 3, 
    @Ins_FName = 'Alice', 
    @Ins_LName = 'Johnson', 
    @Ins_degree = 'PhD', 
    @Age = 50, 
    @Email = 'alice.johnson@example.com', 
    @Password = 'Alice_Johnson@156', 
    @Salary = 95000.00, 
    @Dept_ID = 2;
    
exec Instructors.InsertInstructor 
 @Ins_ID = 4, 
    @Ins_FName = 'Bob', 
    @Ins_LName = 'Brown', 
    @Ins_degree = 'MSc', 
    @Age = 42, 
    @Email = 'bob.brown@example.com', 
    @Password = 'Bob_Brown@144', 
    @Salary = 88000.00, 
    @Dept_ID = 6;

exec Instructors.InsertInstructor 
 @Ins_ID = 5, 
    @Ins_FName = 'Carol', 
    @Ins_LName = 'Davis', 
    @Ins_degree = 'PhD', 
    @Age = 48, 
    @Email = 'carol.davis@example.com', 
    @Password = 'Carol_Davis@432', 
    @Salary = 12000.00, 
    @Dept_ID = 4;


Exec Instructors.InsertInstructor
 @Ins_ID = 6, 
    @Ins_FName = 'Jim', 
    @Ins_LName = 'Beam', 
    @Ins_degree = 'PhD', 
    @Age = 50, 
    @Email = 'jim.beam@example.com', 
    @Password = 'jim_beam@126', 
    @Salary = 22000.00, 
    @Dept_ID = 5;
  
  exec Instructors.InsertInstructor 
  @Ins_ID = 7, 
    @Ins_FName = 'Jill', 
    @Ins_LName = 'Valentine', 
    @Ins_degree = 'MSc', 
    @Age = 35, 
    @Email = 'Jill.Valentine@example.com', 
    @Password = 'Jill_Valentine@526', 
    @Salary = 92000.00, 
    @Dept_ID = 6; 
  
  exec Instructors.InsertInstructor
  @Ins_ID = 8, 
    @Ins_FName = 'Jack', 
    @Ins_LName = 'Daniels', 
    @Ins_degree = 'PhD', 
    @Age = 48, 
    @Email = 'Jack.Daniels@example.com', 
    @Password = 'Jack_Daniels@572', 
    @Salary = 72000.00, 
    @Dept_ID = 5;


--(11)create procedure that Assign courses That instructor to teach for student
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

--calling AssignInstructorToCourse
EXEC Instructors.AssignInstructorToCourse @Course_ID = 101, @Instructor_ID = 8;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 102, @Instructor_ID = 5;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 103, @Instructor_ID = 5;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 104, @Instructor_ID = 2;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 105, @Instructor_ID = 3;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 101, @Instructor_ID = 7;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 102, @Instructor_ID = 1;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 104, @Instructor_ID = 6;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 101, @Instructor_ID = 4;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 105, @Instructor_ID = 4;
EXEC Instructors.AssignInstructorToCourse @Course_ID = 102, @Instructor_ID = 6;


----------------------------------------------------------------------------------------

--Views

--(1)This view display for each instructor which courses he teach
create view Instructors.Courses_Teached_ByInstructor
with encryption
as
select i.Ins_ID , i.Ins_FName + ' ' + i.Ins_LName as'Instructor Full Name',
i.Ins_degree,c.Crs_ID,c.Crs_name,c.Description

from Instructor i inner join Instructor_Courses ic
on ic.Instructor_ID = i.Ins_ID inner join Course c
on ic.Course_ID = c.Crs_ID
group by i.Ins_ID, i.Ins_FName + ' ' + i.Ins_LName ,i.Ins_degree,c.Crs_ID,c.Crs_name,c.Description

--calling Courses_Teached_ByInstructor View
select * from Instructors.Courses_Teached_ByInstructor


--(2)This view shows branches that added and updated in each department by each Training Manager
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


--Calling Updates_and_AddsInBranch_ByTriningManager View
select * from TrainingManagers.Updates_and_AddsInBranch_ByTriningManager


--(3)This view shows Tracks that added and updated in each department by each Training Manager
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

--calling Updates_and_AddsInTrack_ByTriningManager View
select * from TrainingManagers.Updates_and_AddsInTrack_ByTriningManager


----------------------------------------------------------------------------------------

--Functions

-- (1)This inline table function displays intakes that added by each training manager
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

--Calling GetIntakesByManager function
select * from TrainingManagers.GetIntakesByManager()



--(2)This inline functions display students that added by training manager in a system
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


--calling GetStudentsAddedByManager function
SELECT * FROM TrainingManagers.GetStudentsByManager();



-- (3)Function To get Course  Name and Description from Course ID
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

--calling GetCourseDetails function 
SELECT * FROM Instructors.GetCourseDetails(105);



-- (4)Function to get student full name by Enter ID
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

--Calling GetStudentNameBYID Function
select TrainingManagers.GetStudentNameBYID(3);



--(5)Function to get the instructor full name
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

--Calling GetInstructorNameByID function
select DatabaseAdmin.GetInstructorNameByID(7);



--(6)This function return Training Manager Name by his id
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


--Calling GetManagerNameByID function
select DatabaseAdmin.GetManagerNameByID(5);


----------------------------------------------------------------------------------------

--Permissions & Schemas

-- Roles
CREATE ROLE AdminRole;
CREATE ROLE TrainingManagerRole;
CREATE ROLE InstructorRole;
CREATE ROLE StudentRole;

-- SCHEMA
CREATE SCHEMA Instructors;
CREATE SCHEMA Students;
CREATE SCHEMA TrainingManagers;
CREATE SCHEMA DatabaseAdmin;

--Tables That belongs to Admin Schema
ALTER SCHEMA DatabaseAdmin transfer dbo.InsertTraninngManger
ALTER SCHEMA DatabaseAdmin transfer dbo.Department
ALTER SCHEMA DatabaseAdmin transfer dbo.InsertDepartment

--Admins Permissions 
GRANT CONTROL ON SCHEMA::DatabaseAdmin TO AdminRole;
GRANT CONTROL ON SCHEMA::TrainingManagers TO AdminRole;
GRANT CONTROL ON SCHEMA::Instructors TO AdminRole;
GRANT CONTROL ON SCHEMA::Students TO AdminRole;
GRANT EXECUTE ON OBJECT::Instructors.InsertInstructor TO AdminRole;
GRANT EXECUTE ON OBJECT::DatabaseAdmin.InsertDepartment TO AdminRole;
GRANT EXECUTE ON OBJECT::DatabaseAdmin.InsertTraninngManger TO AdminRole;
GRANT EXECUTE ON OBJECT::Instructors.InsertInstructor TO AdminRole;

--Tables That belongs to Training Manager Schema
ALTER SCHEMA TrainingManagers transfer dbo.Training_Manager
ALTER SCHEMA TrainingManagers transfer dbo.Branch
ALTER SCHEMA TrainingManagers transfer dbo.Track
ALTER SCHEMA TrainingManagers transfer dbo.Intake
ALTER SCHEMA TrainingManagers transfer dbo.Update_adds_inbranch
ALTER SCHEMA TrainingManagers transfer dbo.Update_adds_inTrack
ALTER SCHEMA TrainingManagers transfer dbo.Intake_addedby_manager
Alter SCHEMA TrainingManagers transfer dbo.AddNewStudent

-- Training Manager permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::TrainingManagers TO TrainingManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Students.Student TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::Students.AddNewStudent TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::TrainingManagers.AddNewBranch TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::TrainingManagers.UpdateBranch TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::TrainingManagers.UpdateBranch TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::TrainingManagers.AddNewIntake TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::TrainingManagers.AddNewTrack  TO TrainingManagerRole
GRANT EXECUTE ON OBJECT::TrainingManagers.UpdateTrack  TO TrainingManagerRole

-- Tables That belongs to Instructor
ALTER SCHEMA Instructors TRANSFER dbo.Instructor
ALTER SCHEMA Instructors TRANSFER dbo.Course
ALTER SCHEMA Instructors TRANSFER dbo.Instructor_Courses
ALTER SCHEMA Instructors TRANSFER dbo.Exam
ALTER SCHEMA Instructors TRANSFER dbo.Question
ALTER SCHEMA Instructors TRANSFER dbo.Exam_Question

--Instructor Permissions 
GRANT SELECT,Update ON SCHEMA::Instructors TO InstructorRole
GRANT SELECT ON Students.Student TO InstructorRole
GRANT EXECUTE ON OBJECT::Instructors.AssignInstructorToCourse TO InstructorRole
GRANT EXECUTE ON OBJECT::Instructors.InsertQuestionWithAnswer TO InstructorRole
GRANT SELECT, INSERT, UPDATE, DELETE ON Instructors.Exam TO InstructorRole
GRANT SELECT, INSERT, UPDATE, DELETE ON Instructors.Exam_Question TO InstructorRole
GRANT EXECUTE ON OBJECT::Instructors.CreateExamWithQuestions TO InstructorRole
GRANT EXECUTE ON OBJECT::Instructors.InsertCourse TO InstructorRole

-- Tables That belongs to Students 
ALTER SCHEMA Students TRANSFER dbo.Student

--Student Permissions
GRANT SELECT ON SCHEMA::Students TO StudentRole;



--Login Accounts
use Examination
go

CREATE LOGIN Mohamed_AdminUser WITH PASSWORD = 'Mohamed@1000';
CREATE LOGIN Youssef_AdminUser WITH PASSWORD = 'Youssef@2000';
CREATE LOGIN Marina_AdminUser WITH PASSWORD = 'Marina@3000';
CREATE LOGIN TrainingManagerUser WITH PASSWORD = 'TR123456';
CREATE LOGIN InstructorUser WITH PASSWORD = 'IU123456';
CREATE LOGIN StudentUser WITH PASSWORD = 'SU123456';




-- Assign users to roles

ALTER ROLE AdminRole ADD MEMBER Mohamed_AdminUser;
ALTER ROLE AdminRole ADD MEMBER Marina_AdminUser;
ALTER ROLE AdminRole ADD MEMBER Youssef_AdminUser;

ALTER ROLE TrainingManagerRole ADD MEMBER TrainingManagerUser;
ALTER ROLE InstructorRole ADD MEMBER InstructorUser;
ALTER ROLE StudentRole ADD MEMBER StudentUser;
