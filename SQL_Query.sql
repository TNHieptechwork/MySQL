-- 1 Liệt kê tất cả các nhân viên trong công ty.
select * from employee;
-- 2 Hiển thị tên và email của các nhân viên thuộc phòng ban "Engineering".
select e.employeeName, e.email from employee as e right join department as d on e.departmentId = d.departmentId
where departmentName = "Engineering";
-- 3 Lấy danh sách các dự án đã bắt đầu trong năm 2022.
select * from project where year(startDate) = 2022;
-- 4 Tìm các nhân viên được thuê sau ngày 01/01/2021.
select * from employee where hireDate > '2021-01-01';
-- 5 Hiển thị tất cả phòng ban có trong công ty.
select * from department;
-- 6 Lấy tên nhân viên và mức lương của họ.
select employeeName, salary from employee;
-- 7 Đếm số lượng nhân viên trong mỗi phòng ban.
select count(e.employeeId) as employee_quantity from employee as e 
join department as d on e.departmentId = d.departmentId;
-- 8 Tìm tất cả các dự án có ngày kết thúc sau '2023-01-01'.
select * from project where endDate > '2023-01-01';
-- 9 Lấy danh sách nhân viên có lương lớn hơn 70,000.
select * from employee where salary > 70000;
-- 10 Liệt kê các nhân viên chưa có người quản lý (manager).
select * from employee where managerId is null;
-- 11 Tính tổng lương của nhân viên trong từng phòng ban.
select sum(e.salary) as total_salary_employee from employee as e join department as d on e.departmentId = d.departmentId;
-- 12 Liệt kê các dự án mà nhân viên có ID = 2 đang tham gia.
select * from project as p join employeeproject as ep on p.projectId = ep.projectId
join employee as e on e.employeeId = ep.employeeId
where ep.employeeId = 2;
-- 13 Hiển thị tên nhân viên và tên phòng ban của họ.
select e.employeeName, d.departmentName from employee as e join department as d on e.departmentId = d.departmentId;
-- 14 Tìm nhân viên có mức lương cao nhất trong mỗi phòng ban.
SELECT e.employeeId, e.employeeName, e.salary, e.departmentId
FROM Employee e
JOIN (
    SELECT departmentId, MAX(salary) AS maxSalary
    FROM Employee
    WHERE departmentId IS NOT NULL
    GROUP BY departmentId
) AS deptMaxSalary
ON e.departmentId = deptMaxSalary.departmentId
AND e.salary = deptMaxSalary.maxSalary;

-- 15 Liệt kê các nhân viên tham gia vào hơn 1 dự án.
select e.employeeId,e.employeeName, count(ep.projectId) as projectCount from employee e
join employeeproject ep on e.employeeId = ep.employeeId
group by e.employeeId,e.employeeName
having count(ep.projectId) > 1;

-- 16 Lấy tên dự án và số lượng nhân viên tham gia mỗi dự án.
select p.projectName,count(ep.employeeId) as employee_quantity from project p join employeeproject ep on p.projectId = ep.projectId
group by  p.projectName;
-- 17 Liệt kê các nhân viên thuộc phòng "HR" và có lương trên 60,000
select e.employeeId, e.employeeName,d.departmentName,e.salary from employee e join department d on e.departmentId = d.departmentId
where d.departmentName = 'Human Resources'
group by e.employeeId, e.employeeName,d.departmentName,e.salary
having e.salary > 60000;

-- 18 Hiển thị các dự án mà không có nhân viên nào tham gia.
select  p.projectName,count(ep.employeeId) as employee_quantity from project p left join employeeproject ep on p.projectId = ep.projectId
group by p.projectName
having count(ep.employeeId) = 0;
-- 19 Liệt kê tất cả nhân viên cùng với người quản lý của họ.
select e.employeeId,e.employeeName,e1.employeeId as managerId,e1.employeeName as managerName 
from employee e 
left join employee e1 on e.employeeId = e1.managerId;
-- 20 Tìm các nhân viên làm việc trong phòng "Sales" nhưng không tham gia bất kỳ dự án nào.
select e.employeeId,e.employeeName,d.departmentId,d.departmentName,count(ep.projectId) as project_quantity
from employee e join department d on e.departmentId = d.departmentId
left join employeeproject ep on e.employeeId = ep.employeeId
where d.departmentName = 'Sales'
group by  e.employeeId,e.employeeName,d.departmentId,d.departmentName
having count(ep.projectId) = 0;
-- 21 Liệt kê tên nhân viên và tên dự án họ tham gia, cùng ngày được phân công.
select e.employeeName,p.projectName,ep.assignedDate from employeeproject ep join employee e on e.employeeId = ep.employeeId 
join project p on p.projectId = ep.projectId;
-- 22 Tìm các dự án có ít nhất 3 nhân viên đang tham gia.
select p.projectId,p.projectName,count(ep.employeeId) as employee_quantity from project p join employeeproject ep on ep.projectId = p.projectId
group by  p.projectId,p.projectName
having count(ep.employeeId) >= 3;
-- 23 Tìm nhân viên làm việc trong cả hai dự án "Website Redesign" và "Mobile App".
select ep.employeeId,e.employeeName ,GROUP_CONCAT(p.projectName) AS projects from employeeproject ep join project p on ep.projectId = p.projectId
left join employee e on e.employeeId = ep.employeeId
where p.projectName IN ('Mobile App', 'Website Redesign')
group by ep.employeeId,e.employeeName
having count(distinct p.projectId) = 2;

-- 24 Liệt kê tất cả nhân viên có cùng người quản lý với "Bob".
select e1.* from employee e join employee e1 on e.managerId = e1.managerId
where e.employeeName = 'Bob Smith' and e1.employeeName != 'Bob Smith';

-- 25 Hiển thị tên phòng ban và mức lương trung bình của nhân viên trong phòng ban đó, chỉ với các phòng ban có hơn 1 nhân viên.
select d.departmentName,avg(e.salary) as average_salary 
from department d join employee e on d.departmentId = e.departmentId
group by d.departmentName
having count(e.employeeId) >1;

-- 26 Tìm nhân viên có mức lương cao nhất toàn công ty nhưng không phải là quản lý của bất kỳ ai.
select * from employee
where salary = 
(select max(salary) from  employee
where employeeId not in 
(select distinct managerId from employee
where managerId is not null
));
-- 27 Hiển thị tên của tất cả các dự án có ít nhất một nhân viên thuộc phòng "Engineering" tham gia.
select p.projectName,count(ep.employeeId) as employee_involved from project p join employeeproject ep on p.projectId = ep.projectId
join employee e on e.employeeId = ep.employeeId 
join department d on d.departmentId = e.departmentId
where d.departmentName ='Engineering'
group by p.projectName
having count(ep.employeeId) >=1;

-- 28 Viết truy vấn hiển thị “cây quản lý” theo từng cấp (employee - manager - grand-manager nếu có).
select e.employeeName as employee,m.employeeName as manager,gm.employeeName as grandManager
 from employee e join employee m on e.managerId = m.employeeId
left join employee gm on m.managerId = gm.employeeId;

-- 29 Tìm các nhân viên đã tham gia dự án nào đó trước khi chính thức 
-- được thuê (assignedDate < hireDate).
select * from employee e 
join employeeproject ep on e.employeeId = ep.employeeId
where e.hireDate > ep.assignedDate;
-- 30 Liệt kê các dự án đang hoạt động (vẫn chưa kết thúc) và chưa đủ 3 nhân viên tham gia.
select p.projectName,count(ep.employeeId) as employee_involved from project p join employeeproject ep on p.projectId = ep.projectId
where endDate > current_date()
group by p.projectName
having count(ep.employeeId) < 3;
