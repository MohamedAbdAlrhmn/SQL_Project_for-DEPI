--Calling InsertDepartment procedure 
Exec DatabaseAdmin.InsertDepartment 1,'Computer Science', 'Building A'
Exec DatabaseAdmin.InsertDepartment 2,'Software Engineering', 'Building B'
Exec DatabaseAdmin.InsertDepartment 3,',Artificial Intelligence', 'Building C'
Exec DatabaseAdmin.InsertDepartment 4,'Data Science', 'Building D'
Exec DatabaseAdmin.InsertDepartment 5,'Cybersecurity', 'Building E'
Exec DatabaseAdmin.InsertDepartment 6,'Information Systems', 'Building F'
GO

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
GO

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
GO

--calling UpdateBranch procedure
EXEC TrainingManagers.UpdateBranch @Manager_id = 8, @Branch_id = 11, @New_Branch_name = 'Updated Branch 2024', @New_Dept_id = 6;
GO

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
GO

--calling AddNewTrack procedure
EXEC TrainingManagers.AddNewTrack @Manager_id = 10, @Track_name =' Machine Learning', @Dept_id = 1;
EXEC TrainingManagers.AddNewTrack @Manager_id = 2, @Track_name = '  Data Science', @Dept_id = 6;
EXEC TrainingManagers.AddNewTrack @Manager_id = 1, @Track_name = '  Software Development', @Dept_id = 2;
EXEC TrainingManagers.AddNewTrack @Manager_id = 4, @Track_name = '  Web Development', @Dept_id = 5;
EXEC TrainingManagers.AddNewTrack @Manager_id = 3, @Track_name = '  Database Management', @Dept_id = 3;
GO

--calling InsertCourse procedure
EXEC Instructors.InsertCourse @Crs_ID = 101, @Crs_name = 'Database Systems', @Description = 'Introduction to database design, SQL, and database management systems.', @Min_Degree = 50, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 102, @Crs_name = 'Data Structures and Algorithms', @Description = 'Introduction to Data Structures and algorithms and how to implement it.', @Min_Degree = 60, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 103, @Crs_name = 'Python programming language', @Description = 'Explain basics of python and Explain advanced topics on it.', @Min_Degree = 50, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 104, @Crs_name = 'c# programming language', @Description = 'Explain basics of c# and Explain advanced topics like.Net core .', @Min_Degree = 60, @Max_Degree = 100;
EXEC Instructors.InsertCourse @Crs_ID = 105, @Crs_name = 'Machine & Deep learning ', @Description = 'Introduction to Machine learning and deep learning .', @Min_Degree = 50, @Max_Degree = 100;
GO

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
GO


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
GO

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
GO

--calling Courses_Teached_ByInstructor View
select * from Instructors.Courses_Teached_ByInstructor
GO

--Calling Updates_and_AddsInBranch_ByTriningManager View
select * from TrainingManagers.Updates_and_AddsInBranch_ByTriningManager
GO

--calling Updates_and_AddsInTrack_ByTriningManager View
select * from TrainingManagers.Updates_and_AddsInTrack_ByTriningManager
GO

--Calling GetIntakesByManager function
select * from TrainingManagers.GetIntakesByManager()
GO

--calling GetStudentsAddedByManager function
SELECT * FROM TrainingManagers.GetStudentsByManager();
GO

--calling GetCourseDetails function 
SELECT * FROM Instructors.GetCourseDetails(105);
GO

--Calling GetStudentNameBYID Function
select TrainingManagers.GetStudentNameBYID(3);
GO

--Calling GetInstructorNameByID function
select DatabaseAdmin.GetInstructorNameByID(7);
GO

--Calling GetManagerNameByID function
select DatabaseAdmin.GetManagerNameByID(5);
GO

-- Insert sample questions for Database Systems
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What is a relational database? A) A database structured to recognize relations among stored items of information B) A hierarchical database C) A NoSQL database D) A flat-file database', @Q_Type = 'MCQ', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'A database structured to recognize relations among stored items of information';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What is a primary key? A) A unique identifier for a database record B) A non-unique identifier C) A type of SQL query D) A database user', @Q_Type = 'MCQ', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'A unique identifier for a database record';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What is SQL? A) A programming language B) A standard language for accessing and manipulating databases C) A type of database D) A database management system', @Q_Type = 'MCQ', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'A standard language for accessing and manipulating databases';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'True or False: A primary key uniquely identifies each record in a database table.', @Q_Type = 'True/False', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'True';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'True or False: SQL stands for Structured Query Language.', @Q_Type = 'True/False', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'True';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'True or False: A relational database does not support foreign keys.', @Q_Type = 'True/False', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'False';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'Explain the role of a primary key in a database.', @Q_Type = 'Essay', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'A primary key uniquely identifies each record in a database table, ensuring data integrity and enabling efficient access.';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'Discuss the advantages of using a relational database.', @Q_Type = 'Essay', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'Relational databases support ACID properties, data integrity, and provide powerful querying capabilities with SQL.';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'Describe the basic structure of an SQL query.', @Q_Type = 'Essay', @INS_ID = 4, @Q_Degree = 10, @Correct_Answer = 'An SQL query typically includes a SELECT clause to specify the columns, a FROM clause to specify the tables, and optionally WHERE, GROUP BY, HAVING, and ORDER BY clauses to filter, group, and sort the data.';

go
-- Insert sample questions for Data Structures
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What is a stack? A) A linear data structure that follows the LIFO principle B) A linear data structure that follows the FIFO principle C) A non-linear data structure D) None of the above', @Q_Type = 'MCQ', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'A linear data structure that follows the LIFO principle';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What is a queue? A) A linear data structure that follows the LIFO principle B) A linear data structure that follows the FIFO principle C) A non-linear data structure D) None of the above', @Q_Type = 'MCQ', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'A linear data structure that follows the FIFO principle';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What is a binary tree? A) A tree data structure in which each node has at most two children B) A linear data structure C) A non-linear data structure with no specific structure D) None of the above', @Q_Type = 'MCQ', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'A tree data structure in which each node has at most two children';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'True or False: A stack is a Last In First Out data structure.', @Q_Type = 'True/False', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'True';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'True or False: A queue is a Last In First Out data structure.', @Q_Type = 'True/False', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'False';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'True or False: A binary tree is a tree data structure with at most two children per node.', @Q_Type = 'True/False', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'True';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'Explain the difference between a stack and a queue.', @Q_Type = 'Essay', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'A stack follows LIFO, while a queue follows FIFO.';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'Describe the properties of a binary tree.', @Q_Type = 'Essay', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'Each node has at most two children, left and right.';
EXEC Instructors.InsertQuestionWithAnswer @Q_Text = 'What are the applications of a stack in computer science?', @Q_Type = 'Essay', @INS_ID = 2, @Q_Degree = 10, @Correct_Answer = 'Function call management, expression evaluation, backtracking, etc.';
GO

-- Create an exam with random questions for Database Systems
EXEC Instructors.CreateExamWithQuestions 
    @Exam_Name = 'Midterm Exam - Database Systems',
    @Course_ID = 101,
    @Instructor_ID = 4,
    @Exam_Type = 'Exam',
    @Intake = 2,
    @Branch_ID = 2,
    @Track_ID = 5,
    @Start_Time = '2024-06-01 09:00:00',
    @End_Time = '2024-06-01 11:00:00',
    @Allowance = 'None',
    @Year = 2022,
    @Num_MCQ = 3,
    @Num_TrueFalse = 3,
    @Num_Essay = 3,
    @Manual_Question_IDs = NULL;
GO

-- Create an exam with Manual mode for Data Structure
EXEC Instructors.CreateExamWithQuestions 
    @Exam_Name = 'Midterm Exam - Data Structure',
    @Course_ID = 102,
    @Instructor_ID = 5,
    @Exam_Type = 'Exam',
    @Intake = 7,
    @Branch_ID = 8,
    @Track_ID = 1,
    @Start_Time = '2024-06-01 09:00:00',
    @End_Time = '2024-06-01 11:00:00',
    @Allowance = 'None',
    @Year = 2022,
    @Num_MCQ = 0, -- no need in manual mode 
    @Num_TrueFalse = 0, -- no need in manual mode
    @Num_Essay = 0, -- no need in manual mode
    @Manual_Question_IDs = '10,11,12,13,14,15,16,17,18'	; -- specify all questions ID for that exam 
GO


-- Function to get all exam details 
Select * from Instructors.GetExamDetails(1);
GO

-- function to search for a specific keyword in question table 
SELECT * FROM Instructors.SearchQuestionsByKeyword('stack');
GO

