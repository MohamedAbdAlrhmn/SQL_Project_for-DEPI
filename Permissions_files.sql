USE Examination
GO


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
GRANT SELECT, INSERT, UPDATE, DELETE ON Students.StudentExams TO InstructorRole;

GRANT  EXECUTE ON OBJECT:: Students.SP_StudentExam TO InstructorRole;
GRANT  EXECUTE ON OBJECT:: Instructors.SP_calculateTotalDegree TO InstructorRole;

-- Tables That belongs to Students 
ALTER SCHEMA Students TRANSFER dbo.Student
ALTER SCHEMA Students TRANSFER [dbo].[StudentExams];
ALTER SCHEMA Students TRANSFER [dbo].[StudentAnswer]
--Student Permissions
GRANT SELECT ON SCHEMA::Students TO StudentRole;
GRANT  EXECUTE ON OBJECT::Students.InsertStudentAnswer TO StudentRole;


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