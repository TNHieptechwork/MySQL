-- 1 Liệt kê tất cả sản phẩm hiện có trong kho.
select * from product;
-- 2 Hiển thị tên và email của tất cả khách hàng.
select customerName,email from customer;
-- 3 Lấy các đơn hàng được đặt trong tháng 1 năm 2023.
select * from orderinfo
where month(orderDate) = 1 and year(orderDate) = 2023;
-- 4 Tìm các sản phẩm có giá trên 500.
select * from product 
where price > 500;
-- 5 Liệt kê đơn hàng có trạng thái là "Completed".
select * from orderinfo
where status = 'Completed';

-- 6 Tìm các khách hàng đăng ký sau ngày 01/06/2022.
select * from orderinfo 
where orderDate > '2022-06-01';
-- 7 Lấy số lượng sản phẩm trong từng danh mục (category).
select category,count(productId) as product_quantity from product
group by category;
-- 8 Tính tổng số sản phẩm có trong kho (stock).
select sum(stock) as total_product from product;
-- 9 Hiển thị tên sản phẩm và giá.
select productName,price from product;
-- 10 Tìm sản phẩm thuộc danh mục "Electronics".
select * from product
where category = 'Electronics';
-- 11 Lấy tên khách hàng và tổng số đơn hàng họ đã đặt.
select c.customerName,sum(o.orderId) as total_ordered from customer c join orderinfo o on c.customerId = o.customerId
group by c.customerName;
-- 12 Tính tổng tiền của từng đơn hàng (quantity × unitPrice).
select orderId,sum(quantity * unitPrice) as total_of_each_orders from orderdetail
group by orderId;
-- 13 Liệt kê các đơn hàng mà tổng tiền lớn hơn 1000.
select orderId,sum(quantity * unitPrice) as total_of_each_orders from orderdetail
group by orderId
having sum(quantity * unitPrice) > 1000;
-- 14 Tìm những khách hàng chưa từng đặt đơn hàng nào.
select * from customer c join orderinfo o on c.customerId = o.customerId
where o.orderId is null;
-- 15 Lấy danh sách khách hàng đã hủy đơn hàng (status = 'Cancelled').
select * from customer c join orderinfo o on c.customerId = o.customerId
where o.status = 'Cancelled';
-- 16 Lấy sản phẩm bán chạy nhất (dựa trên tổng quantity trong OrderDetail).
select p.productName,max(quantity) as quantity_sold_out 
from orderdetail o join product p on o.productId = p.productId;
-- 17 Hiển thị tất cả sản phẩm chưa từng được bán.
select * from product p  join orderdetail o on p.productId = o.productId
where o.productId is null;
-- 18 Lấy các đơn hàng có chứa sản phẩm tên là “Wireless Mouse”.
select o.* from orderdetail o join product p on p.productId = o.productId
where p.productName = 'Wireless Mouse';
-- 19 Tính doanh thu theo từng loại danh mục sản phẩm.
select p.category,(o.quantity * o.unitPrice) as revenue from product p join orderdetail o on p.productId = o.productId
group by p.category;
-- 20 Hiển thị chi tiết từng đơn hàng gồm: tên khách hàng, ngày đặt, sản phẩm và số lượng.
select c.customerName,o.orderDate,p.*,od.quantity from customer c join orderinfo o on c.customerId =  o.customerId
join orderdetail od on od.orderId = o.customerId
join product p on p.productId = od.productId;
-- 21 Tính doanh thu theo từng khách hàng.
select c.customerName, sum(od.quantity * od.unitPrice) as customer_revenu from customer c join orderinfo o on c.customerId=o.customerId
join orderdetail od on o.orderId = od.orderId
group by c.customerId,c.customerName;
-- 22 Tìm đơn hàng có số lượng sản phẩm nhiều nhất.
select o.*,od.productId,od.quantity from orderinfo o join orderdetail od on o.orderId = od.orderId
where od.quantity = (select max(od1.quantity) from orderdetail od1);
-- 23 Liệt kê khách hàng đã mua hàng mỗi tháng trong năm 2023.
select c.customerId,c.customerName from customer c join orderinfo o on c.customerId = o.customerId
where year(o.orderDate) = 2023
group by c.customerId,c.customerName
having count(distinct month(o.orderDate)) = 12;
-- 24 Lấy danh sách sản phẩm được bán trong ít nhất 2 đơn hàng khác nhau.
select o.orderId,p.productId,p.productName from product p join orderdetail od on p.productId = od.productId
join orderinfo o on o.orderId = od.orderId
group by p.productId,p.productName
having count(distinct o.orderId) >=2; 
-- 25 Tìm đơn hàng có giá trị thấp nhất và cao nhất.
-- Lấy 1 đơn hàng có tổng cao nhất và 1 đơn hàng có tổng thấp nhất
(select orderId, total_value 
	from (select orderId,sum(unitPrice * quantity) as total_value 
		from orderdetail
        group by orderId
	  ) as tb_total
      order by total_value asc
      limit 1
)
union
(
	select orderId,total_value
    from (
		select orderId,sum(quantity * unitPrice) as total_value from orderdetail
        group by orderId ) as tb_total
		order by total_value desc
        limit 1
);

-- 26 Tìm khách hàng chi tiêu nhiều nhất từ trước đến nay.
with customer_total as
(select c.customerId,c.customerName,sum(od.quantity * od.unitPrice) as total_spend
from customer c join orderinfo o on c.customerId = o.customerId
join orderdetail od on od.orderId = o.orderId
group by c.customerId,c.customerName )

select c.customerId,c.customerName,ct.total_spend from customer_total ct join customer c
on c.customerId = ct.customerId
where ct.total_spend = (select max(total_spend) from customer_total);

-- 27 Hiển thị danh sách các đơn hàng có ít nhất 2 loại sản phẩm.
select od.orderId
from orderdetail od
group by od.orderId
having COUNT(DISTINCT od.productId) >= 2;
-- 28 Tính doanh thu trung bình mỗi tháng trong năm 2023.
select avg(revenue) as avg_each_month  from 
(select month(o.orderDate) as month,sum(unitPrice * quantity) as revenue from orderdetail od join orderinfo o
on o.orderId = od.orderId
where year(o.orderDate) = 2023
group by month(o.orderDate)) as tb_avg_month;

-- 29 Tạo báo cáo: tên khách hàng, tổng số đơn, tổng tiền đã chi, số lượng sản phẩm đã mua.
select c.customerName,count(o.orderId) as total_orders, sum(od.quantity * od.unitPrice) as total_spent, sum(od.quantity) as total_quantity from customer c join orderinfo o on c.customerId = o.customerId
join orderdetail od on od.orderId = o.orderId
group by c.customerId,c.customerName;

-- 30 Tìm khách hàng mua tất cả sản phẩm thuộc danh mục "Electronics".
select c.customerId,c.customerName from customer c join orderinfo o 
on o.customerId = c.customerId join orderdetail od 
on od.orderId = o.orderId join product p
on p.productId = od.productId
where p.category = 'Electronics'
group by c.customerId,c.customerName 
having count(distinct p.productId) = (select distinct count(productId) from product
where category = 'Electronics')



