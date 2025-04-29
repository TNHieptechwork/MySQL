--1 Liệt kê tất cả các người dùng trong hệ thống.
select * from users
--2 Tìm tên và email của các khách hàng.
select CONCAT(c.first_name,c.last_name) as full_name,u.email from customers c join users u on c.user_id = u.user_id
--3 Đếm số lượng sản phẩm hiện có.
select i.stock_quantity as current_quantity from products p join inventory i on p.product_id = i.product_id
-- 4 Liệt kê tất cả các đơn hàng và tổng tiền tương ứng.
select * from orders 
-- 5 Tìm các đơn hàng đang ở trạng thái "Pending".
select * from orders
where status like 'Pending'
-- 6 Tìm tất cả sản phẩm có giá lớn hơn 500.
select * from products
where price > 500
-- 7 Đếm số khách hàng theo từng tỉnh/thành phố.
SELECT 
    CAST(address AS VARCHAR(MAX)) AS address, 
    COUNT(customer_id) AS customer_count 
FROM customers
GROUP BY CAST(address AS VARCHAR(MAX));
-- 8 Liệt kê tất cả sản phẩm thuộc danh mục "Electronics".
select * from product_categories pc join categories c 
on pc.category_id = c.category_id
where c.name like N'Electronics'
-- 9 Hiển thị thông tin chi tiết các đơn hàng bao gồm mã đơn hàng, tên sản phẩm, số lượng.
select od.order_id,p.name,od.quantity from order_items od
join products p on od.product_id = p.product_id
-- 10 Tìm tất cả các kho hàng hiện có.
select * from warehouses
-- 11 Liệt kê tất cả sản phẩm có tồn kho dưới 20.
select p.name,i.stock_quantity from products p join inventory i
on p.product_id = i.product_id
where i.stock_quantity < 20 
-- 12 Tìm các phương thức thanh toán có chi phí lớn hơn 1000.
select payment_method from payments
where amount > 1000
-- 13 Liệt kê các đơn hàng của khách hàng có user_id = 5.
select o.* from orders o join customers c
on o.customer_id = c.customer_id
where c.user_id = 5
-- 14 Lấy 10 sản phẩm có giá cao nhất.
select top 10 name, price as max_price from products 
order by price desc

-- 15 Tính tổng tiền đã thanh toán của đơn hàng có ID = 1.
select sum(p.amount) as total_payments from orders o join payments p 
on o.order_id = p.order_id
where o.order_id = 1

-- 16 Liệt kê tên khách hàng và tổng số đơn hàng họ đã đặt.
select concat(c.first_name ,' ', c.last_name) as full_name, count(o.order_id) as total_orders from customers c join orders o
on c.customer_id = o.customer_id
group by concat(c.first_name,' ',c.last_name) 
-- 17 Tìm các sản phẩm chưa từng xuất hiện trong bất kỳ đơn hàng nào.
select p.product_id,p.name from products p join order_items od 
on p.product_id = od.product_id
join orders o on o.order_id = od.order_id
where o.order_id is null
-- 18 Đếm số lượng sản phẩm theo từng danh mục.
select p.name as product_name,c.name as categories,count(p.product_id) as product_count from products p join product_categories pc
on p.product_id = pc.product_id
join categories c on pc.category_id = c.category_id
group by p.name,c.name
-- 19 Liệt kê các sản phẩm của nhà cung cấp có id = 3.
select p.product_id,p.name,s.supplier_id from products p join suppliers s 
on p.supplier_id = s.supplier_id
where s.supplier_id = 3
-- 20 Tìm các đơn hàng có tổng tiền lớn hơn 1000 và đã được giao hàng.
select * from orders
where total_amount > 1000 and status like N'Shipped'
-- 21 Liệt kê tên người dùng và vai trò của họ.
select u.username,r.role_name from users u join user_roles ur
on ur.user_id = u.user_id
join roles r on r.role_id = ur.role_id
-- 22 Đếm số lượng người dùng theo từng vai trò.
select r.role_name,count(u.user_id) as user_count from users u join user_roles ur
on ur.user_id = u.user_id
join roles r on r.role_id = ur.role_id
group by r.role_name
--23 Tìm khách hàng không có bất kỳ đơn hàng nào.
select o.order_id,c.customer_id,concat(c.first_name,' ',c.last_name) as full_name from customers c 
left join orders o
on c.customer_id = o.customer_id
where o.order_id is null
-- 24 Tính tổng số tiền mà mỗi khách hàng đã thanh toán
select concat(c.first_name,' ',c.last_name) as customers, sum(p.amount) as total_payment from payments p join orders o
on p.order_id = o.order_id
join customers c on c.customer_id = o.customer_id
group by concat(c.first_name,' ',c.last_name)
-- 25 Liệt kê danh sách khách hàng và tên sản phẩm họ đã mua.
select concat(c.first_name,' ',c.last_name) as customers,p.name as product_name from customers c join orders o
on c.customer_id = o.customer_id
join order_items od on o.order_id = od.order_id
join products p on p.product_id = od.product_id
where o.status ='Shipped'
-- 26 Tìm các sản phẩm thuộc nhiều hơn một danh mục.
select p.product_id,p.name, count(pc.category_id) as categories_count  
from products p join product_categories pc
on p.product_id = pc.product_id
group by p.product_id,p.name
having count(pc.category_id) > 1
-- 27 Hiển thị các sản phẩm được lưu trữ ở nhiều kho khác nhau.
select p.product_id,p.name,count(w.warehouse_id) ware_house_count from products p join inventory i
on p.product_id = i.product_id
join warehouses w on w.warehouse_id = i.warehouse_id
group by p.product_id,p.name
having count(w.warehouse_id) >= 2
-- 28 Tìm tên sản phẩm và số lượng còn tồn trong mỗi kho.
select p.product_id,p.name,i.stock_quantity,w.name as ware_house_name from products p join inventory i
on p.product_id = i.product_id
join warehouses w on w.warehouse_id = i.warehouse_id
-- 29 Tính tổng giá trị hàng tồn kho tại mỗi kho.
select p.product_id,p.name,sum(p.price * i.stock_quantity) as total_values from products p join inventory i
on p.product_id = i.product_id
join warehouses w on w.warehouse_id = i.warehouse_id
group by p.product_id,p.name
-- 30 Liệt kê các đơn hàng được giao bằng phương thức "Express".
select o.order_id,sm.name as shipping_method from orders o join shipments s
on o.order_id = s.order_id
join shipping_methods sm on sm.shipping_method_id = s.shipping_method_id
where sm.name = 'Express'
-- 31 Tìm đơn hàng có nhiều mặt hàng nhất
select top 1 o.order_id,count(od.product_id) as product_count  from orders o join order_items od
on o.order_id = od.order_id
group by o.order_id
order by product_count desc
-- 32 Tính số lượng sản phẩm bán được theo từng thương hiệu (brand).
select b.name as brand_name,count(p.product_id) as product_sold from products p join brands b
on p.brand_id = b.brand_id
join order_items oi on oi.product_id = p.product_id
group by b.name;
-- 33 Tìm các sản phẩm bán chạy nhất (tổng số lượng cao nhất).
with product_sale as
(
	select p.product_id,p.name as product_name,sum(oi.quantity * p.price) as total_quantity_sold 
	from products p join order_items oi
	on p.product_id = oi.product_id
	group by p.product_id,p.name
)
select ps.product_id,ps.product_name, total_quantity_sold
from product_sale ps
where total_quantity_sold = (select max(total_quantity_sold)
from product_sale
) 
-- 34 Liệt kê tất cả các đơn hàng chưa thanh toán đầy đủ (giả sử có thể xảy ra).
select o.* from orders o join payments p
on o.order_id = p.order_id
where p.amount < o.total_amount
-- 35 Đếm số đơn hàng và tổng tiền theo trạng thái đơn hàng.
select count(order_id) as order_count,sum(total_amount) as total_money,status from orders 
group by status
-- 36 Liệt kê top 5 khách hàng có tổng chi tiêu cao nhất.
select top 5 c.customer_id, concat(c.first_name,' ',c.last_name) as customers, SUM(p.amount) AS total_spent
from customers c join orders o on o.customer_id = c.customer_id
join payments p on p.order_id = o.order_id
group by c.customer_id,concat(c.first_name,' ',c.last_name)
order by total_spent desc
-- 37 Tính trung bình số tiền trên mỗi đơn hàng của mỗi khách hàng.
select c.customer_id,concat(c.first_name,' ',c.last_name) as customers,
avg(o.total_amount) as avg_amount
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id,concat(c.first_name,' ',c.last_name)
-- 38 Liệt kê các sản phẩm bán được trong cả ba phương thức vận chuyển.
select p.product_id,p.name as product_name,sm.name as shipping_method from products p join order_items oi
on p.product_id = oi.product_id
join orders o on o.order_id = oi.order_id
join shipments s on s.order_id = oi.order_id
join shipping_methods sm on s.shipping_method_id = sm.shipping_method_id
group by p.product_id,p.name,sm.name
having count(distinct sm.name) = 3
-- 39 Tìm các sản phẩm chưa được nhập kho nào (không có dòng inventory).
select p.product_id,p.name from products p left join inventory i
on p.product_id = i.product_id
where p.product_id is null

-- 40 Xác định những nhà cung cấp có sản phẩm được bán nhiều nhất.
select top 1 s.supplier_id,s.name as supplier_name,p.name as product_name,
sum(oi.quantity) as total_sold
from products p join suppliers s
on p.supplier_id = s.supplier_id
join order_items oi on oi.product_id = p.product_id
group by s.supplier_id,s.name,p.name
order by total_sold desc
-- 41 Tìm các khách hàng đã đặt hàng nhiều lần trong cùng một ngày.
select c.customer_id,CONCAT(c.first_name,' ',c.last_name) as customers,o.order_date from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id,CONCAT(c.first_name,' ',c.last_name),o.order_date
having count(o.order_id) > 1
-- 42 Liệt kê các đơn hàng có tổng số tiền bằng tổng tiền các sản phẩm trong đó (kiểm tra tính đúng).
select o.order_id,o.total_amount,sum(oi.quantity * p.price) as total_money_product From orders o join order_items oi
on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
group by o.order_id,o.total_amount
having o.total_amount = sum(oi.quantity * p.price)
-- 43 Tìm tên khách hàng và số lượng phương thức thanh toán họ đã sử dụng.
select concat(c.first_name,' ',c.last_name) as customers,count(p.payment_method) as method_quatity from customers c join orders o
on c.customer_id = o.customer_id
join payments p on p.order_id = o.order_id
group by concat(c.first_name,' ',c.last_name)
-- 44 Đếm số lượng sản phẩm theo từng thương hiệu và danh mục.
select b.name as brand_name,c.name as category_name,count(p.product_id) as product_count From products p join brands b
on p.brand_id = b.brand_id
join product_categories pc on pc.product_id = p.product_id
join categories c on c.category_id = pc.category_id
group by b.name,c.name;
-- 45 Tìm các kho chứa sản phẩm có tổng giá trị lớn nhất.
with warehouseValue as (
	select w.warehouse_id,w.name as warehouse_name,sum(p.price * i.stock_quantity) as total_value from warehouses w
	join inventory i on w.warehouse_id = i.warehouse_id
	join products p on p.product_id = i.product_id
	group by w.warehouse_id,w.name
)
select wh.warehouse_id,wh.warehouse_name,total_value from warehouseValue wh
where total_value = (select max(total_value) from warehouseValue);
-- 46 Tính tổng số lượng hàng đã giao cho từng khách hàng trong tháng gần nhất.
 with LatestMonth as
 ( select max(order_date) as latest_month from orders)
select c.customer_id,concat(c.first_name,' ',c.last_name) as customer,MONTH(o.order_date) as month_order,sum(oi.quantity) as total_quantity,o.status from customers c
join orders o on o.order_id = o.order_id
join order_items oi on oi.order_id = o.order_id
join LatestMonth l on l.latest_month = o.order_date
where o.status = 'Shipped'
group by c.customer_id , month(o.order_date),concat(c.first_name,' ',c.last_name),o.status
-- 48 Tìm các đơn hàng có ít nhất 2 sản phẩm thuộc thương hiệu khác nhau.
select o.order_id from orders o 
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
join brands b on b.brand_id = p.brand_id
group by o.order_id
having count(distinct b.brand_id) >= 2
-- 49 Tìm những khách hàng có ít nhất một đơn hàng thuộc trạng thái "Delivered" và thanh toán bằng PayPal.
select c.customer_id,concat(c.first_name,' ',c.last_name) as customers from customers c 
join orders o on c.customer_id = o.customer_id
join shipments s on s.order_id = o.order_id
join shipping_methods sm on sm.shipping_method_id = s.shipping_method_id
where o.status = 'Delivered' and sm.name = 'PayPal'
-- 50 Tạo bảng thống kê tổng tiền theo từng tháng trong năm và theo từng trạng thái đơn hàng.
select YEAR(o.order_date) as year,
	   MONTH(o.order_date) as month,
	   o.status,
       SUM(o.total_amount) as total_amount
from orders o
group by YEAR(o.order_date), MONTH(o.order_date), o.status
order by year desc, month desc, o.status;

--51 Tìm top 3 sản phẩm có doanh thu cao nhất mỗi tháng, bao gồm tên sản phẩm, tháng, tổng doanh thu.
WITH MonthlyRevenue AS (
    SELECT 
        p.name AS product_name,
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month,
        SUM(od.quantity * od.unit_price) AS total_revenue
    FROM 
        orders o
    JOIN 
        order_items od ON o.order_id = od.order_id
    JOIN 
        products p ON od.product_id = p.product_id
    GROUP BY 
        p.name, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    mr.product_name,
    mr.year,
    mr.month,
    mr.total_revenue
FROM 
    MonthlyRevenue mr
WHERE 
    (SELECT COUNT(*) 
     FROM MonthlyRevenue mr2
     WHERE mr2.year = mr.year
     AND mr2.month = mr.month
     AND mr2.total_revenue > mr.total_revenue
    ) < 3
ORDER BY 
    mr.year DESC, mr.month DESC, mr.total_revenue DESC;
-- 52 Tìm các khách hàng có tổng số tiền mua hàng nhiều hơn trung bình tổng chi tiêu của tất cả khách hàng.
WITH CustomerTotal AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(od.quantity * od.unit_price) AS total_spent
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    JOIN 
        order_items od ON o.order_id = od.order_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name
),
AverageSpending AS (
    SELECT 
        AVG(total_spent) AS avg_spending
    FROM 
        CustomerTotal
)
SELECT 
    ct.customer_id,
    ct.customer_name,
    ct.total_spent
FROM 
    CustomerTotal ct,
    AverageSpending avg
WHERE 
    ct.total_spent > avg.avg_spending
ORDER BY 
    ct.total_spent DESC;
-- 53 Liệt kê các sản phẩm được bán bởi nhiều hơn 2 nhà cung cấp khác nhau.
SELECT 
    p.product_id,
    p.name AS product_name,
    COUNT(DISTINCT ps.supplier_id) AS supplier_count
FROM 
    products p
JOIN 
    suppliers ps ON p.supplier_id = ps.supplier_id
GROUP BY 
    p.product_id, p.name
HAVING 
    COUNT(DISTINCT ps.supplier_id) > 2
ORDER BY 
    supplier_count DESC;
-- 54 Tìm tất cả khách hàng đã mua cùng một sản phẩm từ hai đơn hàng khác nhau trong vòng 30 ngày.
SELECT DISTINCT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_id,
    p.name AS product_name
FROM 
    customers c
JOIN 
    orders o1 ON c.customer_id = o1.customer_id
JOIN 
    order_items od1 ON o1.order_id = od1.order_id
JOIN 
    products p ON od1.product_id = p.product_id
JOIN 
    orders o2 ON c.customer_id = o2.customer_id
JOIN 
    order_items od2 ON o2.order_id = od2.order_id
WHERE 
    o1.order_id < o2.order_id 
    AND od1.product_id = od2.product_id
    AND DATEDIFF(DAY, o1.order_date, o2.order_date) BETWEEN 0 AND 30
-- 55 Tìm tất cả các đơn hàng có tổng tiền chênh lệch với tổng đơn giá * số lượng trong order_items.
SELECT 
    o.order_id,
    o.total_amount AS recorded_total,
    SUM(oi.quantity * oi.unit_price) AS money_total,
    ABS(o.total_amount - SUM(oi.quantity * oi.unit_price)) AS difference
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id, o.total_amount
HAVING 
    o.total_amount <> SUM(oi.quantity * oi.unit_price)
ORDER BY 
    difference DESC;
-- 56 Xác định các sản phẩm có doanh thu giảm dần trong 3 tháng gần nhất.
WITH ProductRevenueByMonth AS (
    SELECT 
        p.product_id,
        p.name AS product_name,
        MONTH(o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    JOIN 
        products p ON oi.product_id = p.product_id
    WHERE 
        o.order_date >= DATEADD(MONTH, -3, GETDATE())
    GROUP BY 
        p.product_id, p.name, MONTH(o.order_date)
),

MonthlyRevenuePivot AS (
    SELECT 
        product_id,
        product_name,
        MAX(CASE WHEN month = MONTH(GETDATE()) THEN revenue ELSE 0 END) AS rev_month_0,
        MAX(CASE WHEN month = MONTH(DATEADD(MONTH, -1, GETDATE())) THEN revenue ELSE 0 END) AS rev_month_1,
        MAX(CASE WHEN month = MONTH(DATEADD(MONTH, -2, GETDATE())) THEN revenue ELSE 0 END) AS rev_month_2
    FROM 
        ProductRevenueByMonth
    GROUP BY 
        product_id, product_name
)

SELECT 
    product_id,
    product_name,
    rev_month_2, rev_month_1, rev_month_0
FROM 
    MonthlyRevenuePivot
WHERE 
    rev_month_2 > rev_month_1 AND rev_month_1 > rev_month_0
ORDER BY 
    rev_month_2 DESC;
-- 57 Liệt kê các đơn hàng có ít nhất một sản phẩm được vận chuyển chậm hơn 5 ngày kể từ ngày đặt hàng.
SELECT DISTINCT 
    o.order_id,
    o.order_date,
    s.shipped_date
FROM orders o
JOIN shipments s ON o.order_id = s.order_id
WHERE DATEDIFF(DAY, o.order_date, s.shipped_date) > 5;
-- 58 Tính tổng tiền đơn hàng và so sánh với tổng tiền thanh toán để xác định đơn hàng bị thiếu/ dư tiền.
SELECT 
    o.order_id,
    o.total_amount,
    SUM(oi.quantity * oi.unit_price) AS total_items,
    (o.total_amount - SUM(oi.quantity * oi.unit_price)) AS difference,
    CASE 
        WHEN o.total_amount > SUM(oi.quantity * oi.unit_price) THEN 'Dư tiền'
        WHEN o.total_amount < SUM(oi.quantity * oi.unit_price) THEN 'Thiếu tiền'
        ELSE 'Đúng tiền'
    END AS payment_status
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id, o.total_amount
ORDER BY 
    difference;
-- 59 Liệt kê top 5 kho hàng có tổng giá trị tồn kho cao nhất (số lượng × giá sản phẩm).
SELECT TOP 5
    w.warehouse_id,
    w.name AS warehouse_name,
    SUM(i.stock_quantity * p.price) AS total_inventory_value
FROM 
    warehouses w
JOIN 
    inventory i ON w.warehouse_id = i.warehouse_id
JOIN 
    products p ON i.product_id = p.product_id
GROUP BY 
    w.warehouse_id, w.name
ORDER BY 
    total_inventory_value DESC;
--60 Tìm các khách hàng đã mua hàng từ ít nhất 3 thương hiệu khác nhau.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT b.brand_id) AS brand_count
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    brands b ON p.brand_id = b.brand_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(DISTINCT b.brand_id) >= 3;
-- 61 Tìm các khách hàng đã mua sản phẩm thuộc ít nhất 3 danh mục khác nhau trong cùng một đơn hàng.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    COUNT(DISTINCT pc.category_id) AS category_count
FROM 
    customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOin product_categories pc on pc.product_id = p.product_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, o.order_id
HAVING 
    COUNT(DISTINCT pc.category_id) >= 3;
-- 62 Tạo bảng xếp hạng khách hàng theo số lượng đơn hàng trung bình mỗi tháng.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    COUNT(DISTINCT FORMAT(o.order_date, 'yyyy-MM')) AS active_months,
    ROUND(1.0 * COUNT(o.order_id) / NULLIF(COUNT(DISTINCT FORMAT(o.order_date, 'yyyy-MM')), 0), 2) AS avg_orders_per_month
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(DISTINCT FORMAT(o.order_date, 'yyyy-MM')) > 0
ORDER BY 
    avg_orders_per_month DESC

-- 63 Liệt kê tất cả các đơn hàng có chứa sản phẩm chưa từng được bán trước đó.
SELECT DISTINCT
    o.order_id,
    o.order_date,
    oi.product_id,
    p.name AS product_name
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    oi.product_id NOT IN (
        SELECT DISTINCT oi.product_id
        FROM order_items oi
        WHERE oi.order_id < o.order_id
    )
ORDER BY 
    o.order_date;
-- 64 Xác định tỷ lệ phần trăm đơn hàng bị huỷ hoặc không giao hàng thành công.
SELECT 
    (COUNT(CASE 
               WHEN o.status = 'Cancelled' 
                    OR (s.delivery_date IS NULL OR s.delivery_date > s.shipped_date) 
               THEN 1 
           END) * 100.0) / COUNT(*) AS cancellation_failure_rate
FROM 
    orders o
LEFT JOIN 
    shipments s ON o.order_id = s.order_id;
-- 65 Tìm tất cả khách hàng có tổng số lần thanh toán bằng PayPal nhiều hơn Credit Card.





