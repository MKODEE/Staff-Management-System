-- Staff Management System Database Schema

-- =============================================
-- TABLES CREATION WITH CONSTRAINTS
-- =============================================
-- Departments Table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_head INT,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Positions Table
CREATE TABLE positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_title VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    salary_range_min DECIMAL(10, 2),
    salary_range_max DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Employees Table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    address TEXT,
    position_id INT NOT NULL,
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    employment_status ENUM('Active', 'On Leave', 'Terminated', 'Retired') DEFAULT 'Active',
    manager_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (position_id) REFERENCES positions(position_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Family Information Table
CREATE TABLE family_members (
    family_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    relationship ENUM('Spouse', 'Child', 'Parent', 'Sibling', 'Other') NOT NULL,
    contact_number VARCHAR(20),
    is_emergency_contact BOOLEAN DEFAULT FALSE,
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Qualifications Table
CREATE TABLE qualifications (
    qualification_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    qualification_type ENUM('Degree', 'Certification', 'License', 'Training') NOT NULL,
    title VARCHAR(100) NOT NULL,
    institution VARCHAR(100) NOT NULL,
    date_obtained DATE NOT NULL,
    expiry_date DATE,
    description TEXT,
    document_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Leave Types Table
CREATE TABLE leave_types (
    leave_type_id INT AUTO_INCREMENT PRIMARY KEY,
    leave_name VARCHAR(50) NOT NULL,
    description TEXT,
    default_days INT NOT NULL,
    is_paid BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Leave Requests Table
CREATE TABLE leave_requests (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INT NOT NULL,
    reason TEXT,
    status ENUM('Pending', 'Approved', 'Rejected', 'Cancelled') DEFAULT 'Pending',
    approved_by INT,
    approval_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    FOREIGN KEY (approved_by) REFERENCES employees(employee_id),
    CHECK (end_date >= start_date)
);

-- Training Programs Table
CREATE TABLE training_programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    description TEXT,
    provider VARCHAR(100),
    cost DECIMAL(10, 2),
    duration INT, -- in hours
    is_mandatory BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Employee Training Table
CREATE TABLE employee_training (
    training_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    program_id INT NOT NULL,
    start_date DATE,
    completion_date DATE,
    status ENUM('Scheduled', 'In Progress', 'Completed', 'Failed', 'Cancelled') DEFAULT 'Scheduled',
    score DECIMAL(5, 2),
    certificate_url VARCHAR(255),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (program_id) REFERENCES training_programs(program_id)
);

-- Performance Reviews Table
CREATE TABLE performance_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    review_period_start DATE NOT NULL,
    review_period_end DATE NOT NULL,
    review_date DATE NOT NULL,
    overall_rating DECIMAL(3, 2) NOT NULL, -- Scale of 1.00 to 5.00
    strengths TEXT,
    areas_for_improvement TEXT,
    goals TEXT,
    employee_comments TEXT,
    status ENUM('Draft', 'Submitted', 'Acknowledged', 'Finalized') DEFAULT 'Draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id),
    CHECK (overall_rating BETWEEN 1.00 AND 5.00),
    CHECK (review_period_end >= review_period_start)
);

-- Documents Table
CREATE TABLE documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    document_type ENUM('Contract', 'Certification', 'ID', 'Resume', 'Performance Review', 'Other') NOT NULL,
    title VARCHAR(100) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    upload_date DATE NOT NULL,
    expiry_date DATE,
    is_verified BOOLEAN DEFAULT FALSE,
    verified_by INT,
    verification_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (verified_by) REFERENCES employees(employee_id)
);

-- Job Postings Table
CREATE TABLE job_postings (
    posting_id INT AUTO_INCREMENT PRIMARY KEY,
    position_id INT NOT NULL,
    posting_date DATE NOT NULL,
    closing_date DATE NOT NULL,
    status ENUM('Open', 'Closed', 'On Hold') DEFAULT 'Open',
    description TEXT NOT NULL,
    requirements TEXT NOT NULL,
    hiring_manager_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (position_id) REFERENCES positions(position_id),
    FOREIGN KEY (hiring_manager_id) REFERENCES employees(employee_id),
    CHECK (closing_date >= posting_date)
);

-- Job Applicants Table
CREATE TABLE job_applicants (
    applicant_id INT AUTO_INCREMENT PRIMARY KEY,
    posting_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    resume_url VARCHAR(255),
    application_date DATE NOT NULL,
    status ENUM('Applied', 'Screening', 'Interview', 'Offered', 'Hired', 'Rejected') DEFAULT 'Applied',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (posting_id) REFERENCES job_postings(posting_id)
);

-- =============================================
-- SAMPLE DATA INSERTION
-- =============================================

-- Insert Departments
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Human Resources', 'Floor 1, East Wing'),
(2, 'Information Technology', 'Floor 2, West Wing'),
(3, 'Finance', 'Floor 3, North Wing'),
(4, 'Research & Development', 'Floor 4, South Wing'),
(5, 'Marketing', 'Floor 2, East Wing');

-- Insert Positions
INSERT INTO positions (position_id, position_title, department_id, salary_range_min, salary_range_max) VALUES
(1, 'HR Manager', 1, 70000.00, 90000.00),
(2, 'HR Assistant', 1, 35000.00, 45000.00),
(3, 'IT Director', 2, 100000.00, 130000.00),
(4, 'Software Developer', 2, 60000.00, 85000.00),
(5, 'Network Administrator', 2, 55000.00, 75000.00),
(6, 'Finance Director', 3, 110000.00, 140000.00),
(7, 'Accountant', 3, 50000.00, 70000.00),
(8, 'Research Scientist', 4, 75000.00, 95000.00),
(9, 'Marketing Manager', 5, 65000.00, 85000.00),
(10, 'Marketing Specialist', 5, 40000.00, 60000.00);

-- Insert Employees
INSERT INTO employees (employee_id, first_name, last_name, email, phone, date_of_birth, gender, address, position_id, department_id, hire_date, employment_status) VALUES
(1, 'John', 'Smith', 'john.smith@company.com', '555-123-4567', '1980-05-15', 'Male', '123 Main St, Anytown, USA', 1, 1, '2015-03-10', 'Active'),
(2, 'Sarah', 'Johnson', 'sarah.johnson@company.com', '555-234-5678', '1985-08-22', 'Female', '456 Oak Ave, Somewhere, USA', 3, 2, '2016-01-15', 'Active'),
(3, 'Michael', 'Williams', 'michael.williams@company.com', '555-345-6789', '1978-11-30', 'Male', '789 Pine Rd, Nowhere, USA', 6, 3, '2014-07-05', 'Active'),
(4, 'Emily', 'Brown', 'emily.brown@company.com', '555-456-7890', '1990-04-12', 'Female', '101 Elm St, Anywhere, USA', 8, 4, '2018-09-20', 'Active'),
(5, 'David', 'Jones', 'david.jones@company.com', '555-567-8901', '1982-02-28', 'Male', '202 Maple Dr, Everywhere, USA', 9, 5, '2017-05-18', 'Active'),
(6, 'Jessica', 'Davis', 'jessica.davis@company.com', '555-678-9012', '1988-07-17', 'Female', '303 Cedar Ln, Someplace, USA', 2, 1, '2019-03-15', 'Active'),
(7, 'Robert', 'Miller', 'robert.miller@company.com', '555-789-0123', '1975-09-05', 'Male', '404 Birch Blvd, Othertown, USA', 4, 2, '2016-11-08', 'Active'),
(8, 'Jennifer', 'Wilson', 'jennifer.wilson@company.com', '555-890-1234', '1983-12-10', 'Female', '505 Walnut Way, Thisplace, USA', 7, 3, '2018-02-22', 'Active'),
(9, 'Christopher', 'Moore', 'christopher.moore@company.com', '555-901-2345', '1979-06-25', 'Male', '606 Spruce St, Thatplace, USA', 4, 2, '2017-08-14', 'Active'),
(10, 'Amanda', 'Taylor', 'amanda.taylor@company.com', '555-012-3456', '1992-01-20', 'Female', '707 Fir Ct, Yourtown, USA', 10, 5, '2020-01-10', 'Active');

-- Update department_head
UPDATE departments SET department_head = 1 WHERE department_id = 1;
UPDATE departments SET department_head = 2 WHERE department_id = 2;
UPDATE departments SET department_head = 3 WHERE department_id = 3;
UPDATE departments SET department_head = 4 WHERE department_id = 4;
UPDATE departments SET department_head = 5 WHERE department_id = 5;

-- Insert Family Members
INSERT INTO family_members (family_id, employee_id, name, relationship, contact_number, is_emergency_contact, date_of_birth) VALUES
(1, 1, 'Mary Smith', 'Spouse', '555-111-2222', TRUE, '1982-08-10'),
(2, 1, 'James Smith', 'Child', NULL, FALSE, '2010-04-15'),
(3, 2, 'Thomas Johnson', 'Spouse', '555-222-3333', TRUE, '1984-11-05'),
(4, 3, 'Patricia Williams', 'Spouse', '555-333-4444', TRUE, '1980-02-20'),
(5, 3, 'Elizabeth Williams', 'Child', NULL, FALSE, '2012-07-30'),
(6, 5, 'Susan Jones', 'Spouse', '555-444-5555', TRUE, '1984-05-12'),
(7, 7, 'Nancy Miller', 'Spouse', '555-555-6666', TRUE, '1977-10-08'),
(8, 7, 'Daniel Miller', 'Child', NULL, FALSE, '2008-12-03'),
(9, 7, 'Lisa Miller', 'Child', NULL, FALSE, '2011-03-22');

-- Insert Qualifications
INSERT INTO qualifications (qualification_id, employee_id, qualification_type, title, institution, date_obtained, expiry_date, description) VALUES
(1, 1, 'Degree', 'Bachelor of Business Administration', 'State University', '2002-05-20', NULL, 'Specialization in Human Resources Management'),
(2, 1, 'Certification', 'SHRM Senior Certified Professional', 'Society for Human Resource Management', '2016-06-15', '2024-06-15', 'Advanced HR certification'),
(3, 2, 'Degree', 'Master of Science in Computer Science', 'Tech University', '2008-12-18', NULL, 'Focus on Information Systems'),
(4, 2, 'Certification', 'Certified Information Systems Security Professional', 'ISC2', '2018-03-10', '2024-03-10', 'IT security certification'),
(5, 3, 'Degree', 'Master of Business Administration', 'Business School', '2005-05-25', NULL, 'Finance concentration'),
(6, 3, 'Certification', 'Certified Public Accountant', 'State Board of Accountancy', '2007-11-30', '2025-11-30', 'Accounting certification'),
(7, 4, 'Degree', 'PhD in Biochemistry', 'Science University', '2015-06-12', NULL, 'Research in molecular biology'),
(8, 5, 'Degree', 'Bachelor of Arts in Marketing', 'Marketing College', '2004-05-18', NULL, 'Focus on Digital Marketing'),
(9, 7, 'Certification', 'AWS Certified Solutions Architect', 'Amazon Web Services', '2019-08-22', '2022-08-22', 'Cloud architecture certification');

-- Insert Leave Types
INSERT INTO leave_types (leave_type_id, leave_name, description, default_days, is_paid) VALUES
(1, 'Annual Leave', 'Regular vacation time', 20, TRUE),
(2, 'Sick Leave', 'Leave due to illness or medical appointments', 10, TRUE),
(3, 'Maternity Leave', 'Leave for childbirth and infant care', 90, TRUE),
(4, 'Paternity Leave', 'Leave for fathers after childbirth', 14, TRUE),
(5, 'Bereavement Leave', 'Leave due to death of family member', 5, TRUE),
(6, 'Unpaid Leave', 'Leave without pay for personal reasons', 30, FALSE);

-- Insert Leave Requests
INSERT INTO leave_requests (leave_id, employee_id, leave_type_id, start_date, end_date, total_days, reason, status, approved_by, approval_date) VALUES
(1, 6, 1, '2023-07-10', '2023-07-21', 10, 'Summer vacation', 'Approved', 1, '2023-06-15 10:30:00'),
(2, 7, 2, '2023-06-05', '2023-06-07', 3, 'Flu', 'Approved', 2, '2023-06-01 14:45:00'),
(3, 8, 1, '2023-08-15', '2023-08-25', 9, 'Family trip', 'Approved', 3, '2023-07-20 09:15:00'),
(4, 9, 1, '2023-09-05', '2023-09-15', 9, 'Personal time', 'Pending', NULL, NULL),
(5, 10, 2, '2023-06-12', '2023-06-13', 2, 'Medical appointment', 'Approved', 5, '2023-06-10 11:20:00');

-- Insert Training Programs
INSERT INTO training_programs (program_id, program_name, description, provider, cost, duration, is_mandatory) VALUES
(1, 'Cybersecurity Fundamentals', 'Basic training on cybersecurity practices', 'IT Security Solutions', 1200.00, 16, TRUE),
(2, 'Leadership Development', 'Training for emerging leaders', 'Leadership Institute', 2500.00, 24, FALSE),
(3, 'Project Management Basics', 'Introduction to project management methodologies', 'PM Training Center', 1800.00, 20, FALSE),
(4, 'Data Analysis with Python', 'Programming for data analysis', 'Tech Training Co', 1500.00, 30, FALSE),
(5, 'Workplace Safety', 'Mandatory safety training', 'Safety First Inc', 500.00, 8, TRUE);

-- Insert Employee Training
INSERT INTO employee_training (training_id, employee_id, program_id, start_date, completion_date, status, score) VALUES
(1, 2, 1, '2023-02-15', '2023-02-16', 'Completed', 92.5),
(2, 7, 1, '2023-02-15', '2023-02-16', 'Completed', 88.0),
(3, 9, 1, '2023-02-15', '2023-02-16', 'Completed', 95.0),
(4, 1, 2, '2023-04-10', '2023-04-12', 'Completed', 90.0),
(5, 5, 2, '2023-04-10', '2023-04-12', 'Completed', 87.5),
(6, 4, 4, '2023-05-08', '2023-05-12', 'Completed', 94.0),
(7, 8, 3, '2023-06-20', NULL, 'In Progress', NULL),
(8, 10, 5, '2023-03-05', '2023-03-05', 'Completed', 100.0);

-- Insert Performance Reviews
INSERT INTO performance_reviews (review_id, employee_id, reviewer_id, review_period_start, review_period_end, review_date, overall_rating, strengths, areas_for_improvement, status) VALUES
(1, 6, 1, '2022-01-01', '2022-12-31', '2023-01-15', 4.2, 'Excellent communication skills, good team player', 'Could improve technical knowledge', 'Finalized'),
(2, 7, 2, '2022-01-01', '2022-12-31', '2023-01-18', 4.5, 'Strong technical skills, problem-solving abilities', 'Documentation could be more thorough', 'Finalized'),
(3, 8, 3, '2022-01-01', '2022-12-31', '2023-01-20', 3.8, 'Accurate work, meets deadlines', 'Could take more initiative', 'Finalized'),
(4, 9, 2, '2022-01-01', '2022-12-31', '2023-01-22', 4.0, 'Creative problem solver, good coding practices', 'Could improve communication with non-technical team members', 'Finalized'),
(5, 10, 5, '2022-01-01', '2022-12-31', '2023-01-25', 3.5, 'Creative ideas, good with clients', 'Needs to improve meeting deadlines', 'Finalized');

-- Insert Documents
INSERT INTO documents (document_id, employee_id, document_type, title, file_path, upload_date, expiry_date, is_verified, verified_by, verification_date) VALUES
(1, 1, 'Contract', 'Employment Contract', '/documents/contracts/john_smith_contract.pdf', '2015-03-10', NULL, TRUE, 3, '2015-03-15'),
(2, 1, 'Certification', 'SHRM Certificate', '/documents/certifications/john_smith_shrm.pdf', '2016-06-20', '2024-06-15', TRUE, 3, '2016-06-25'),
(3, 2, 'Contract', 'Employment Contract', '/documents/contracts/sarah_johnson_contract.pdf', '2016-01-15', NULL, TRUE, 1, '2016-01-20'),
(4, 2, 'Certification', 'CISSP Certificate', '/documents/certifications/sarah_johnson_cissp.pdf', '2018-03-15', '2024-03-10', TRUE, 1, '2018-03-20'),
(5, 3, 'Contract', 'Employment Contract', '/documents/contracts/michael_williams_contract.pdf', '2014-07-05', NULL, TRUE, 1, '2014-07-10'),
(6, 7, 'Resume', 'Updated Resume', '/documents/resumes/robert_miller_resume.pdf', '2022-05-10', NULL, TRUE, 2, '2022-05-12'),
(7, 4, 'ID', 'Employee ID', '/documents/ids/emily_brown_id.pdf', '2018-09-20', NULL, TRUE, 1, '2018-09-25'),
(8, 5, 'Performance Review', '2022 Annual Review', '/documents/reviews/david_jones_2022_review.pdf', '2023-01-25', NULL, TRUE, 1, '2023-01-30');

-- Insert Job Postings
INSERT INTO job_postings (posting_id, position_id, posting_date, closing_date, status, description, requirements, hiring_manager_id) VALUES
(1, 4, '2023-05-01', '2023-05-31', 'Closed', 'Looking for an experienced software developer to join our IT team.', 'Bachelor\'s degree in Computer Science or related field, 3+ years of experience in software development, proficiency in Java and Python.', 2),
(2, 7, '2023-06-01', '2023-06-30', 'Closed', 'Seeking a qualified accountant to join our finance department.', 'Bachelor\'s degree in Accounting or Finance, CPA certification, 2+ years of accounting experience.', 3),
(3, 10, '2023-07-01', '2023-07-31', 'Closed', 'Marketing specialist position available in our growing marketing team.', 'Bachelor\'s degree in Marketing or related field, 2+ years of experience in digital marketing, proficiency in social media platforms and analytics tools.', 5),
(4, 5, '2023-08-01', '2023-08-31', 'Open', 'Network administrator needed to maintain and optimize our IT infrastructure.', 'Bachelor\'s degree in IT or related field, 3+ years of experience in network administration, CCNA certification preferred.', 2),
(5, 8, '2023-09-01', '2023-09-30', 'Open', 'Research scientist position available in our R&D department.', 'PhD in Biochemistry or related field, 2+ years of research experience, publication record in peer-reviewed journals.', 4);

-- Insert Job Applicants
INSERT INTO job_applicants (applicant_id, posting_id, first_name, last_name, email, phone, resume_url, application_date, status) VALUES
(1, 1, 'Thomas', 'Anderson', 'thomas.anderson@email.com', '555-111-2222', '/resumes/thomas_anderson.pdf', '2023-05-10', 'Hired'),
(2, 1, 'Julia', 'Roberts', 'julia.roberts@email.com', '555-222-3333', '/resumes/julia_roberts.pdf', '2023-05-15', 'Rejected'),
(3, 2, 'William', 'Clark', 'william.clark@email.com', '555-333-4444', '/resumes/william_clark.pdf', '2023-06-05', 'Hired'),
(4, 2, 'Emma', 'Stone', 'emma.stone@email.com', '555-444-5555', '/resumes/emma_stone.pdf', '2023-06-10', 'Interview'),
(5, 3, 'Ryan', 'Reynolds', 'ryan.reynolds@email.com', '555-555-6666', '/resumes/ryan_reynolds.pdf', '2023-07-08', 'Hired'),
(6, 3, 'Scarlett', 'Johnson', 'scarlett.johnson@email.com', '555-666-7777', '/resumes/scarlett_johnson.pdf', '2023-07-12', 'Rejected'),
(7, 4, 'Chris', 'Evans', 'chris.evans@email.com', '555-777-8888', '/resumes/chris_evans.pdf', '2023-08-05', 'Interview'),
(8, 4, 'Mark', 'Ruffalo', 'mark.ruffalo@email.com', '555-888-9999', '/resumes/mark_ruffalo.pdf', '2023-08-10', 'Screening'),
(9, 5, 'Natalie', 'Portman', 'natalie.portman@email.com', '555-999-0000', '/resumes/natalie_portman.pdf', '2023-09-05', 'Applied');

-- Insert Research Publications
INSERT INTO research_publications (publication_id, employee_id, title, publication_date, journal_name, authors, abstract, doi) VALUES
(1, 4, 'Novel Approaches to Protein Synthesis', '2020-03-15', 'Journal of Biochemistry', 'Emily Brown, Robert Johnson, Sarah Lee', 'This paper explores innovative methods for protein synthesis in laboratory settings', '10.1234/jb.2020.03.15'),
(2, 4, 'Advancements in Molecular Biology Techniques', '2021-06-22', 'Science Today', 'Emily Brown, Michael Chen', 'A review of recent technological advancements in molecular biology research', '10.5678/st.2021.06.22'),
(3, 8, 'Financial Modeling for Sustainable Businesses', '2022-01-10', 'Journal of Finance', 'Jennifer Wilson, David Thompson', 'This research presents new financial models for environmentally sustainable businesses', '10.9012/jf.2022.01.10');

-- Insert Conferences
INSERT INTO conferences (conference_id, employee_id, conference_name, location, start_date, end_date, role, presentation_title, expenses, approval_status, approved_by) VALUES
(1, 4, 'International Biochemistry Summit', 'Geneva, Switzerland', '2022-09-15', '2022-09-18', 'Speaker', 'Recent Discoveries in Protein Synthesis', 2500.00, 'Approved', 3),
(2, 2, 'Cybersecurity Conference', 'Las Vegas, USA', '2022-11-10', '2022-11-13', 'Attendee', NULL, 1800.00, 'Approved', 3),
(3, 5, 'Digital Marketing Expo', 'New York, USA', '2023-02-05', '2023-02-07', 'Presenter', 'Effective Social Media Strategies', 1200.00, 'Approved', 3),
(4, 7, 'Software Development Summit', 'Berlin, Germany', '2023-04-20', '2023-04-23', 'Attendee', NULL, 2200.00, 'Pending', NULL),
(5, 3, 'Financial Leadership Forum', 'London, UK', '2023-05-12', '2023-05-14', 'Speaker', 'Strategic Financial Planning', 2800.00, 'Approved', 1);

-- Insert Promotions
INSERT INTO promotions (promotion_id, employee_id, previous_position_id, new_position_id, promotion_date, reason, approved_by, salary_change) VALUES
(1, 6, 2, 1, '2022-04-15', 'Outstanding performance and leadership skills', 1, 25000.00),
(2, 7, 4, 3, '2022-06-10', 'Exceptional technical expertise and team management', 2, 30000.00),
(3, 8, 7, 6, '2022-08-20', 'Demonstrated financial acumen and strategic thinking', 3, 35000.00);

-- =============================================
-- SAMPLE QUERIES
-- =============================================

-- 1. List all employees with their department and position
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    p.position_title,
    e.hire_date,
    e.employment_status
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    positions p ON e.position_id = p.position_id
ORDER BY 
    e.employee_id;

-- 2. Show all approved leave requests with employee and leave type information
SELECT 
    lr.leave_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    lt.leave_name,
    lr.start_date,
    lr.end_date,
    lr.total_days,
    lr.status,
    CONCAT(a.first_name, ' ', a.last_name) AS approved_by,
    lr.approval_date
FROM 
    leave_requests lr
JOIN 
    employees e ON lr.employee_id = e.employee_id
JOIN 
    leave_types lt ON lr.leave_type_id = lt.leave_type_id
LEFT JOIN 
    employees a ON lr.approved_by = a.employee_id
WHERE 
    lr.status = 'Approved'
ORDER BY 
    lr.start_date DESC;

-- 3. List all employees with their qualifications
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    q.qualification_type,
    q.title,
    q.institution,
    q.date_obtained,
    q.expiry_date
FROM 
    employees e
LEFT JOIN 
    qualifications q ON e.employee_id = q.employee_id
ORDER BY 
    e.employee_id, q.qualification_type;

-- 4. Show all training programs and the employees who completed them
SELECT 
    tp.program_name,
    tp.description,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    et.start_date,
    et.completion_date,
    et.status,
    et.score
FROM 
    training_programs tp
JOIN 
    employee_training et ON tp.program_id = et.program_id
JOIN 
    employees e ON et.employee_id = e.employee_id
WHERE 
    et.status = 'Completed'
ORDER BY 
    tp.program_name, et.completion_date DESC;

-- 5. List all job postings with the number of applicants for each
SELECT 
    jp.posting_id,
    p.position_title,
    d.department_name,
    jp.posting_date,
    jp.closing_date,
    jp.status,
    COUNT(ja.applicant_id) AS number_of_applicants,
    SUM(CASE WHEN ja.status = 'Hired' THEN 1 ELSE 0 END) AS hired_applicants
FROM 
    job_postings jp
JOIN 
    positions p ON jp.position_id = p.position_id
JOIN 
    departments d ON p.department_id = d.department_id
LEFT JOIN 
    job_applicants ja ON jp.posting_id = ja.posting_id
GROUP BY 
    jp.posting_id, p.position_title, d.department_name, jp.posting_date, jp.closing_date, jp.status
ORDER BY 
    jp.posting_date DESC;

-- 6. Show employees with their emergency contacts
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    f.name AS emergency_contact_name,
    f.relationship,
    f.contact_number
FROM 
    employees e
JOIN 
    family_members f ON e.employee_id = f.employee_id
WHERE 
    f.is_emergency_contact = TRUE
ORDER BY 
    e.employee_id;

-- 7. List all employees who attended conferences in the last year
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    c.conference_name,
    c.location,
    c.start_date,
    c.end_date,
    c.role,
    c.presentation_title,
    c.expenses,
    c.approval_status
FROM 
    conferences c
JOIN 
    employees e ON c.employee_id = e.employee_id
WHERE 
    c.start_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
ORDER BY 
    c.start_date DESC;

-- 8. Show performance reviews with ratings above average
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(r.first_name, ' ', r.last_name) AS reviewer_name,
    pr.review_date,
    pr.overall_rating,
    pr.strengths,
    pr.areas_for_improvement
FROM 
    performance_reviews pr
JOIN 
    employees e ON pr.employee_id = e.employee_id
JOIN 
    employees r ON pr.reviewer_id = r.employee_id
WHERE 
    pr.overall_rating > (SELECT AVG(overall_rating) FROM performance_reviews)
ORDER BY 
    pr.overall_rating DESC;

-- 9. List all documents that will expire in the next 90 days
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.document_type,
    d.title,
    d.upload_date,
    d.expiry_date,
    DATEDIFF(d.expiry_date, CURRENT_DATE) AS days_until_expiry
FROM 
    documents d
JOIN 
    employees e ON d.employee_id = e.employee_id
WHERE 
    d.expiry_date IS NOT NULL 
    AND d.expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY)
ORDER BY 
    d.expiry_date;

-- 10. Show all promotions with salary changes
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    p_old.position_title AS previous_position,
    p_new.position_title AS new_position,
    pr.promotion_date,
    pr.salary_change,
    CONCAT(a.first_name, ' ', a.last_name) AS approved_by,
    pr.reason
FROM 
    promotions pr
JOIN 
    employees e ON pr.employee_id = e.employee_id
JOIN 
    positions p_old ON pr.previous_position_id = p_old.position_id
JOIN 
    positions p_new ON pr.new_position_id = p_new.position_id
JOIN 
    employees a ON pr.approved_by = a.employee_id
ORDER BY 
    pr.promotion_date DESC;

-- 11. List employees with their research publications
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    rp.title AS publication_title,
    rp.publication_date,
    rp.journal_name,
    rp.authors,
    rp.citation_count
FROM 
    employees e
JOIN 
    research_publications rp ON e.employee_id = rp.employee_id
ORDER BY 
    rp.publication_date DESC;

-- 12. Show department heads with their departments
SELECT 
    d.department_name,
    CONCAT(e.first_name, ' ', e.last_name) AS department_head,
    p.position_title,
    d.location
FROM 
    departments d
JOIN 
    employees e ON d.department_head = e.employee_id
JOIN 
    positions p ON e.position_id = p.position_id
ORDER BY 
    d.department_name;

-- 13. List employees with pending leave requests
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    lt.leave_name,
    lr.start_date,
    lr.end_date,
    lr.total_days,
    lr.reason,
    lr.status
FROM 
    leave_requests lr
JOIN 
    employees e ON lr.employee_id = e.employee_id
JOIN 
    leave_types lt ON lr.leave_type_id = lt.leave_type_id
WHERE 
    lr.status = 'Pending'
ORDER BY 
    lr.start_date;

-- 14. Show employees who have completed mandatory training
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    tp.program_name,
    et.completion_date,
    et.score
FROM 
    employees e
JOIN 
    employee_training et ON e.employee_id = et.employee_id
JOIN 
    training_programs tp ON et.program_id = tp.program_id
WHERE 
    tp.is_mandatory = TRUE
    AND et.status = 'Completed'
ORDER BY 
    e.employee_id, tp.program_name;

-- 15. List employees with their family members
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    f.name AS family_member_name,
    f.relationship,
    f.date_of_birth,
    CASE WHEN f.is_emergency_contact = TRUE THEN 'Yes' ELSE 'No' END AS emergency_contact
FROM 
    employees e
JOIN 
    family_members f ON e.employee_id = f.employee_id
ORDER BY 
    e.employee_id, f.relationship;