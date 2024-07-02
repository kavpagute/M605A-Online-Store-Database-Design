-- Stored Procedure
CREATE OR REPLACE PROCEDURE InsertProduct(
    IN p_ProductCode INT,
    IN p_Product_Name VARCHAR(100),
    IN p_Description VARCHAR(250),
    IN p_CategoryId INT,
    IN p_Size VARCHAR(100),
    IN p_Weight VARCHAR(50),
    IN p_Brand VARCHAR(150),
    IN p_Price MONEY,
    IN p_image_file VARCHAR(250)
)
LANGUAGE SQL
AS $$
BEGIN
    INSERT INTO public."Product" ("ProductCode", "Product_Name", "Description", "CategoryId", "Size", 
	"Weight", "Brand", "Price", "image_file")
    VALUES (p_ProductCode, p_Product_Name, p_Description, p_CategoryId, p_Size, p_Weight, p_Brand, p_Price, p_image_file);
END;
$$;

-- Queries

select S."Supplier_Name", P."Product_Name", PD."Quantity"  from "Supplier" as S
inner join "Product" as P on S."SupplierId"=P."SupplierId" 
inner join "Product_Delivery" as PD on P."ProductId"=PD."ProductId"
order by S."Supplier_Name"
--This query displays the quantity of each delivered products. 
--I used inner join to connect Product-Supplier and Product Delivery table.


	
select S."Supplier_Name", Count(P."Product_Name") as TypeOfProducts from "Supplier" as S 
	inner join "Product" as P on S."SupplierId"=P."SupplierId" 
inner join "Product_Delivery" as PD on P."ProductId"=PD."ProductId"
Group by S."Supplier_Name"
--This query gets the number of product type by using the count function in each Supplier.  
--I used inner join to connect Product-Supplier and Product Delivery table.


	
select S."Supplier_Name", Sum(PD."Quantity") as TypeOfProducts from   "Supplier" as S
inner join "Product" as P on S."SupplierId"=P."SupplierId" 
inner join "Product_Delivery" as PD on P."ProductId"=PD."ProductId"
Group by S."Supplier_Name"
--This query gets the sum of all products in each Supplier. 
--I used inner join to join Supplier-Product and Product Delivery table.


select P."Product_Name",S."Supplier_Name", count(OD."ProductCode") as No_Of_Items, 
	sum(OD."Price") as Total_Amount from "OrderDetails" as OD
	inner join "Product" as P
	on P."ProductCode"=OD."ProductCode"
	inner join "Supplier" as S
	on P."SupplierId" = S."SupplierId"
	group by P."ProductCode", P."Product_Name", S."Supplier_Name"
order by No_Of_Items desc
--This query gets the product name, supplier name, number of items.  
--It uses count function to count the number of purchased items and sum to get the total amount.
--I used inner join to connect Product-Supplier and Order Details table.

	
select C."First_Name" ||' '|| C."Last_Name" as Customer_Name,  
	sum(OD."Price") as Total_Purchase from "OrderDetails" as OD inner join "Order" as O 
	on O."OrderId"=OD."OrderId" inner join "Customer" as C on C."CustomerId"=O."CustomerId"
group by  Customer_Name
order by Customer_Name
--This query gets the list of customers who made purchases and sums up all their purchases.  
--I concatenated the first name and last name and named it is customer_name.  
--The query used inner join to connect Customer-OrderDetails and Order table to connect.


	
select P."Product_Name", O."Order_date", RP."Returned_date" from "ReturnedProducts" as RP inner join "OrderDetails" as OD
on RP."Order_detailId"=OD."Order_detailId"
inner join "Product" as P on OD."ProductCode" = P."ProductCode"
inner join "Order" as O on OD."OrderId"=O."OrderId"
--This query will get the records of returned items, date ordered and date returned.  
--It uses inner join to Product-Orderdetails and ReturnedProducts table to connect.


	
Select C."First_Name"||' '|| C."Last_Name" as Customer_Name, S."Shipment_date", S."Shipment_status",  
	O."TotalPrice" from "Shipment" as S inner join "Order" as O
on O."OrderId"=S."OrderId" inner join "Customer" as C on C."CustomerId"=O."CustomerId"
--This query will show the completed shipped orders with customer name and total price.


	
Select C."First_Name"||' '|| C."Last_Name" as Customer_Name, P."Product_Name", S."Shipment_date", S."Shipment_status", 
	O."TotalPrice" from "Shipment" as S 
inner join "Order" as O on O."OrderId"=S."OrderId" 
inner join "Customer" as C on C."CustomerId"=O."CustomerId"
inner join "OrderDetails" as OD on O."OrderId"=OD."OrderId"
inner join "Product" as P on P."ProductCode"=OD."ProductCode"
order by Customer_Name, P."Product_Name"
--This query will get the summary records of the schema including the customer, product ordered, shipment date and total price.






