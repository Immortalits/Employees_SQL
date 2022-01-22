-- 1.feladat
SELECT departments.dept_no, gender, AVG(salary) AS "Average salary" FROM salaries, employees, dept_emp, departments WHERE
salaries.emp_no = employees.emp_no AND employees.emp_no = dept_emp.emp_no AND dept_emp.dept_no = departments.dept_no GROUP BY departments.dept_no, gender;

-- 2.feladat
SELECT MIN(dept_emp.dept_no) AS "Dept min", MAX(dept_emp.dept_no) AS "Dept max" FROM dept_emp;

-- 3.feladat
SELECT employees.emp_no, dept_emp.dept_no, IF(10040 >= employees.emp_no AND employees.emp_no >= 10021, 110039, IF(employees.emp_no <= 10020, 110022, "")) AS "MANAGER"
FROM dept_emp, employees WHERE employees.emp_no = dept_emp.emp_no AND employees.emp_no <= 10040 AND dept_no IN (SELECT MIN(dept_no) FROM dept_emp WHERE dept_emp.emp_no <= 10040 GROUP BY dept_no);

-- 4.feladat
SELECT CONCAT(first_name, " ", last_name) AS "Employee name " FROM employees WHERE YEAR(hire_date) = 2000;

-- 5.feladat
 -- a)
    SELECT CONCAT(first_name, " ", last_name) AS "Engineers" FROM employees,titles WHERE employees.emp_no = titles.emp_no AND titles.title = "Engineer";
 -- b)
    SELECT CONCAT(first_name, " ", last_name) AS "Senior Engineers" FROM employees,titles WHERE employees.emp_no = titles.emp_no AND titles.title = "Senior Engineer";

-- 6.feladat
CREATE DEFINER=`root`@`localhost` PROCEDURE `last_dept`(IN empnumber INT)
BEGIN
    SELECT dept_name FROM employees, dept_emp, departments WHERE employees.emp_no = dept_emp.emp_no AND dept_emp.dept_no = departments.dept_no AND employees.emp_no = @Emp_id ORDER BY to_date DESC LIMIT 1;
END

-- 7.feladat
SELECT COUNT(*), datediff(to_date,from_date) FROM salaries WHERE salary > 100000 AND datediff(to_date,from_date) > 365;

-- 8.feladat
DELIMITER $$
DROP TRIGGER IF EXISTS employees.before_emp_insert;
create trigger employees.before_emp_insert
before insert on employees
for each row
begin 
	if NEW.hire_date > CURDATE() then
		set NEW.hire_date = CURDATE();
	end if;
end $$


-- 9.feladat
DELIMITER //
DROP FUNCTION IF EXISTS getMinSalary;
CREATE FUNCTION getMinSalary(empnumber integer)
    RETURNS integer
    BEGIN
		declare salary integer;
        
        SELECT MIN(salaries.salary) INTO salary FROM salaries, employees WHERE salaries.emp_no = employees.emp_no;

        RETURN salary;
    END //

DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS getMaxSalary;
CREATE FUNCTION getMaxSalary(empnumber integer)
    RETURNS integer
    BEGIN
		declare salary integer;
        
        SELECT MAX(salaries.salary) INTO salary FROM salaries, employees WHERE salaries.emp_no = employees.emp_no;

        RETURN salary;
    END //

DELIMITER ;

-- 10.feladat -> https://www.techonthenet.com/mysql/loops/if_then.php
DELIMITER //
CREATE FUNCTION getSalary(empnumber integer, rendezes varchar(3))
    RETURNS integer
    BEGIN
		declare salary integer;
        IF rendezes = "min" then
			SELECT MIN(salaries.salary) INTO salary FROM salaries, employees WHERE salaries.emp_no = employees.emp_no;
		ELSEIF rendezes = "max" then
			SELECT MAX(salaries.salary) INTO salary FROM salaries, employees WHERE salaries.emp_no = employees.emp_no;
		ELSE
			SELECT MAX(salaries.salary) - MIN(salaries.salary)  INTO salary FROM salaries, employees WHERE salaries.emp_no = employees.emp_no;
		END IF;
        RETURN salary;
END //

DELIMITER ;