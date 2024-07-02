CREATE DATABASE "OnlineStore"
    WITH OWNER = postgres

CREATE TABLE IF NOT EXISTS "Address"
(
    "AddressId" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
    "City" character varying(100) COLLATE pg_catalog."default",
    "PostalCode" character varying(10) COLLATE pg_catalog."default",
    "Country" character varying(100) COLLATE pg_catalog."default",
    "Street" character varying(100) COLLATE pg_catalog."default",
    "House_Building_no" character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT "Address_pkey" PRIMARY KEY ("AddressId")
);

INSERT INTO "Address"("City", "PostalCode", "Country", "Street", "House_Building_no")
	values('Berlin',unnest(array[10117,10119,10178,10179,10243,10245,10247,10249,10315,10317,
	10318,10319,10365,10367,10369,10407,10409,10435,10437,10439]),
	'Germany',unnest(array['Behrenstraße','Lottumstraße 4','Rochstraße 16','Köpenicker Straße 67',
	'Singerstraße 33','Döringstraße 2','Schreinerstraße 12','Pintschstraße 6',
	'Goethestraße 170','Emanuelstraße 6','Gasag 28','Moldaustraße 52','Gotlindestraße 66',
	'Josef-Orlopp-Straße 24','Anton-Saefkow-Platz 3','Sigridstraße 13',
	'Sültstraße 41','Knaackstraße 78','Pappelalle 40a','Czarnikauer Straße 6A']),
	unnest(array['31','4','16','67','33','2','12','6','170','6','28','52','66','24','3','13','41','78','40A','6A']));

CREATE TABLE IF NOT EXISTS "Customer"
(
    "CustomerId" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
    "First_Name" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Last_Name" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Email" character varying(100) COLLATE pg_catalog."default",
    "Last_Login_Time" timestamp without time zone DEFAULT now(),
    "Password" character varying COLLATE pg_catalog."default",
    "AddressId" integer,
    "TelephoneNumebr" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Customer_pkey" PRIMARY KEY ("CustomerId")
);

INSERT INTO "Customer"("First_Name", "Last_Name", "Email", "Password","AddressId","TelephoneNumebr")
	values(unnest(array['Kisky','John','Sam','Eric',
	'Samson','Delilah','Anthony','Jessica','Jessica','Britney']),
	unnest(array['Pagute','Smith','Mchale','Frustosco','Edge','Huoston',
	'Fernandez','Beil','Alba','Spears']),
	unnest(array['k@yahoo.com','j@smith.com','s@sss.com','e@eric.com',
	'sa@samson.com','d@gmail.com','anthony@ymail.com','jessica@alba.com',
	'cassej@hotmail.com','spears@britney.com']),unnest(array['p1','p2','p3','p4',
	'p5','p6','p7','p8','p9','p10']),
	unnest(array[1,2,3,4,5,6,7,8,9,10]),
	unnest(array['+49 151 12345678',
    '+49 152 23456789',
    '+49 153 34567890',
    '+49 157 45678901',
    '+49 160 56789012',
    '+49 162 67890123',
    '+49 163 78901234',
    '+49 170 89012345',
    '+49 171 90123456',
    '+49 172 01234567']));

CREATE TABLE IF NOT EXISTS public."ProductCategory"
(
    "CategoryId" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 ),
    "Category" character varying(150) COLLATE pg_catalog."default",
    PRIMARY KEY ("CategoryId")
);

INSERT INTO "ProductCategory"("Category")
	VALUES(unnest(array['Electronics','Health','Home','Furniture','Fitness','Transport']))

CREATE TABLE IF NOT EXISTS "Product"
(
	"ProductId" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
    "ProductCode" character varying(20) NOT NULL,
    "Product_Name" character varying(100) NOT NULL,
    "Description" character varying(250),
    "CategoryId" integer NOT NULL,
    "Size" character varying(100),
    "Weight" character varying(50),
    "Brand" character varying(150),
    "Price" money,
    "image_file" character varying(250),
	"SupplierId" integer NOT NULL,
    PRIMARY KEY ("ProductId"),
    FOREIGN KEY ("CategoryId")
    REFERENCES public."ProductCategory" ("CategoryId"),
	UNIQUE ("ProductCode"),
	FOREIGN KEY ("SupplierId")
	REFERENCES public."Supplier" ("SupplierId")
);

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
    INSERT INTO public."Product" ("ProductCode", "Product_Name", "Description", "CategoryId", "Size", "Weight", "Brand", "Price", "image_file")
    VALUES (p_ProductCode, p_Product_Name, p_Description, p_CategoryId, p_Size, p_Weight, p_Brand, p_Price, p_image_file);
END;
$$;

INSERT INTO "Product" ("ProductCode", "Product_Name", "Description", "CategoryId", "Size", "Weight", "Brand", "Price", "image_file", "SupplierId") VALUES
('P0001', 'Wireless Mouse', 'Ergonomic wireless mouse with high precision', 2, 'Medium', '100g', 'Logitech', 29.99, 'mouse.jpg', 1),
('P0002', 'Mechanical Keyboard', 'RGB backlit mechanical keyboard with blue switches', 2, 'Full', '800g', 'Corsair', 89.99, 'keyboard.jpg', 2),
('P0003', 'Gaming Headset', 'Surround sound gaming headset with noise-canceling mic', 2, 'Adjustable', '350g', 'SteelSeries', 59.99, 'headset.jpg',1),
('P0004', '4K Monitor', '27-inch 4K UHD monitor with HDR', 2, '27-inch', '5kg', 'Dell', 399.99, 'monitor.jpg',2),
('P0005', 'External SSD', '1TB external SSD with USB-C interface', 2, 'Compact', '150g', 'Samsung', 149.99, 'ssd.jpg',3),
('P0006', 'Smartphone', 'Latest model with 128GB storage and 5G capability', 2, '6.1-inch', '180g', 'Apple', 999.99, 'smartphone.jpg',1),
('P0007', 'Fitness Tracker', 'Waterproof fitness tracker with heart rate monitor', 3, 'Small', '30g', 'Fitbit', 129.99, 'tracker.jpg',2),
('P0008', 'Bluetooth Speaker', 'Portable Bluetooth speaker with 20-hour battery life', 2, 'Compact', '600g', 'JBL', 79.99, 'speaker.jpg',3),
('P0009', 'Smartwatch', 'Smartwatch with GPS and various health tracking features', 3, 'Medium', '50g', 'Garmin', 199.99, 'smartwatch.jpg',1),
('P0010', 'Tablet', '10-inch tablet with 64GB storage and stylus support', 2, '10-inch', '500g', 'Samsung', 349.99, 'tablet.jpg',1),
('P0011', 'Laptop', '15.6-inch laptop with Intel i7 and 16GB RAM', 2, '15.6-inch', '2kg', 'HP', 799.99, 'laptop.jpg',1),
('P0012', 'Wireless Charger', 'Fast wireless charger with overcharge protection', 2, 'Small', '120g', 'Anker', 39.99, 'charger.jpg',1),
('P0013', 'Smart Light Bulb', 'Dimmable smart light bulb with WiFi connectivity', 4, 'Standard', '60g', 'Philips', 24.99, 'lightbulb.jpg',2),
('P0014', 'Action Camera', '4K action camera with waterproof housing', 2, 'Compact', '150g', 'GoPro', 299.99, 'camera.jpg',4),
('P0015', 'E-Reader', 'E-reader with 300ppi display and adjustable front light', 2, '6-inch', '200g', 'Amazon', 129.99, 'ereader.jpg',4),
('P0016', 'Portable Power Bank', '20000mAh power bank with quick charge support', 2, 'Medium', '400g', 'Xiaomi', 49.99, 'powerbank.jpg',6),
('P0017', 'Drone', 'Quadcopter drone with 1080p camera and GPS', 2, 'Medium', '1.2kg', 'DJI', 499.99, 'drone.jpg',5),
('P0018', 'Smart Thermostat', 'WiFi-enabled smart thermostat with learning capabilities', 4, 'Medium', '150g', 'Nest', 249.99, 'thermostat.jpg',1),
('P0019', 'Electric Toothbrush', 'Rechargeable electric toothbrush with multiple modes', 3, 'Standard', '300g', 'Oral-B', 79.99, 'toothbrush.jpg',5),
('P0020', 'Noise Cancelling Headphones', 'Over-ear noise cancelling headphones with Bluetooth', 2, 'Large', '300g', 'Sony', 349.99, 'headphones.jpg',1),
('P0021', 'Smart Doorbell', 'Video doorbell with motion detection and two-way audio', 4, 'Standard', '200g', 'Ring', 199.99, 'doorbell.jpg',4),
('P0022', 'Robot Vacuum', 'Smart robot vacuum with WiFi and voice control', 4, 'Medium', '3kg', 'iRobot', 499.99, 'vacuum.jpg',3),
('P0023', 'Electric Scooter', 'Foldable electric scooter with 25km range', 7, 'Standard', '12kg', 'Xiaomi', 599.99, 'scooter.jpg',3),
('P0024', 'Smart Scale', 'Bluetooth smart scale with body composition analysis', 3, 'Standard', '1.5kg', 'Withings', 99.99, 'scale.jpg',1),
('P0025', 'Portable Projector', 'Mini projector with 1080p support and HDMI input', 2, 'Compact', '800g', 'Anker', 299.99, 'projector.jpg',2),
('P0026', 'Smart Plug', 'WiFi smart plug with energy monitoring', 4, 'Small', '80g', 'TP-Link', 29.99, 'smartplug.jpg',3),
('P0027', 'Dash Cam', '1080p dash cam with night vision and loop recording', 2, 'Compact', '100g', 'Vantrue', 149.99, 'dashcam.jpg',1),
('P0028', 'Gaming Chair', 'Ergonomic gaming chair with adjustable armrests', 5, 'Large', '15kg', 'Secretlab', 399.99, 'gamingchair.jpg',1),
('P0029', 'Air Purifier', 'HEPA air purifier with smart sensor and quiet operation', 4, 'Medium', '4kg', 'Dyson', 499.99, 'airpurifier.jpg',1),
('P0030', 'Electric Kettle', 'Stainless steel electric kettle with temperature control', 4, 'Standard', '1kg', 'Breville', 79.99, 'kettle.jpg',1),
('P0031', 'Instant Camera', 'Instant print camera with built-in selfie mirror', 2, 'Compact', '250g', 'Fujifilm', 69.99, 'instax.jpg',1),
('P0032', 'Fitness Ball', 'Anti-burst exercise ball with quick pump', 6, '65cm', '1.2kg', 'Trideer', 29.99, 'fitnessball.jpg',1),
('P0033', 'Yoga Mat', 'Non-slip yoga mat with carrying strap', 6, 'Standard', '1kg', 'Liforme', 99.99, 'yogamat.jpg',1),
('P0034', 'Coffee Maker', 'Single serve coffee maker with reusable filter', 4, 'Compact', '2kg', 'Keurig', 129.99, 'coffeemaker.jpg',1),
('P0035', 'Blender', 'High-speed blender with multiple preset functions', 4, 'Standard', '3kg', 'Ninja', 149.99, 'blender.jpg',3),
('P0036', 'Laptop Stand', 'Adjustable laptop stand with cooling fan', 2, 'Medium', '1kg', 'Rain Design', 49.99, 'laptopstand.jpg',2),
('P0037', 'Webcam', '1080p webcam with built-in microphone and privacy cover', 2, 'Compact', '150g', 'Logitech', 69.99, 'webcam.jpg',3),
('P0038', 'Smart Lock', 'Keyless entry smart lock with app control', 4, 'Standard', '1.5kg', 'August', 249.99, 'smartlock.jpg',1),
('P0039', 'Electric Shaver', 'Wet and dry electric shaver with charging stand', 3, 'Standard', '300g', 'Philips', 119.99, 'shaver.jpg',2),
('P0040', 'Wireless Earbuds', 'True wireless earbuds with noise isolation', 2, 'Compact', '50g', 'Jabra', 99.99, 'earbuds.jpg',1);

CREATE TABLE IF NOT EXISTS public."Product_Delivery"
(
    "ProductDeliveryId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1),
    "ProductId" integer,
    "Quantity" integer,
    "DateReceived" date,
    CONSTRAINT "Product_Delivery_pkey" PRIMARY KEY ("ProductDeliveryId"),
    CONSTRAINT "ProductIdFKey" FOREIGN KEY ("ProductId")
        REFERENCES public."Product" ("ProductId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

CREATE TABLE IF NOT EXISTS "Order"
(
    "OrderId" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
    "Order_date" date,
    "CustomerId" integer,
    "Status" character varying(200),
	"TotalPrice" money,
    CONSTRAINT "Order_pkey" PRIMARY KEY ("OrderId"),
	FOREIGN KEY ("CustomerId")
    REFERENCES public."Customer" ("CustomerId") 
);

CREATE INDEX idx_order_date
ON public."Order" ("Order_date");

CREATE OR REPLACE FUNCTION check_order_status() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."Status" = 'Cancelled' THEN
        -- Custom logic for handling cancelled orders
        RAISE NOTICE 'Order % has been cancelled.', NEW."OrderId";
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_order_status_trigger
BEFORE UPDATE
ON public."Order"
FOR EACH ROW
EXECUTE FUNCTION check_order_status();




INSERT INTO public."Order" ("Order_date", "CustomerId", "Status") VALUES
('2024-01-01', 11, 'Pending'),
('2024-01-02', 2, 'Completed'),
('2024-01-03', 3, 'Shipped'),
('2024-01-04', 4, 'Cancelled'),
('2024-01-05', 5, 'Pending'),
('2024-01-06', 6, 'Processing'),
('2024-01-07', 7, 'Completed'),
('2024-01-08', 8, 'Shipped'),
('2024-01-09', 9, 'Pending'),
('2024-01-10', 10, 'Completed');

CREATE TABLE IF NOT EXISTS public."OrderDetails"
(
    "Order_detailId" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
    "OrderId" integer,
    "ProductCode" character varying(20),
    "Quantity" integer,
    "Price" money,
    PRIMARY KEY ("Order_detailId"),
	FOREIGN KEY ("OrderId")
	REFERENCES public."Order" ("OrderId"),
	FOREIGN KEY ("ProductCode")
	REFERENCES public."Product" ("ProductCode")
);

CREATE INDEX idx_productcode
ON public."Product" ("ProductCode");

INSERT INTO public."OrderDetails" ("OrderId", "ProductCode", "Quantity", "Price") VALUES 
	(1, 'P0001', 2, 29.99), 
	(1, 'P0002', 1, 89.99), 
	(2, 'P0003', 1, 59.99), 
	(2, 'P0004', 2, 399.99), 
	(3, 'P0005', 1, 149.99), 
	(3, 'P0006', 1, 999.99), 
	(4, 'P0007', 1, 129.99), 
	(4, 'P0008', 1, 79.99), 
	(5, 'P0009', 1, 199.99), 
	(5, 'P0010', 1, 349.99), 
	(6, 'P0011', 1, 799.99), 
	(6, 'P0012', 2, 39.99), 
	(7, 'P0013', 3, 24.99), 
	(7, 'P0014', 1, 299.99), 
	(8, 'P0015', 1, 129.99), 
	(8, 'P0016', 2, 49.99), 
	(9, 'P0017', 1, 499.99), 
	(9, 'P0018', 1, 249.99), 
	(10, 'P0019', 1, 79.99), 
	(10, 'P0020', 1, 349.99), 
	(1, 'P0021', 2, 199.99), 
	(2, 'P0022', 1, 499.99), 
	(3, 'P0023', 1, 599.99), 
	(4, 'P0024', 2, 99.99), 
	(5, 'P0025', 1, 299.99), 
	(6, 'P0026', 1, 29.99), 
	(7, 'P0027', 1, 149.99), 
	(8, 'P0028', 2, 399.99), 
	(9, 'P0029', 1, 499.99), 
	(10, 'P0030', 1, 79.99), 
	(1, 'P0031', 1, 69.99), 
	(2, 'P0032', 2, 29.99), 
	(3, 'P0033', 1, 99.99), 
	(4, 'P0034', 1, 129.99), 
	(5, 'P0035', 1, 149.99), 
	(6, 'P0036', 2, 49.99), 
	(7, 'P0037', 1, 69.99), 
	(8, 'P0038', 1, 249.99), 
	(9, 'P0039', 1, 119.99), 
	(10, 'P0040', 2, 99.99);



CREATE TABLE IF NOT EXISTS public."Payment"
(
    "PaymentId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1),
    "CustomerId" integer NOT NULL,
    "PaymentMethodId" integer NOT NULL,
    "Price" money NOT NULL,
    "OrderId" integer NOT NULL,
    "isSuccessful" boolean,
    "isCancelled" boolean,
    CONSTRAINT "Payment_pkey" PRIMARY KEY ("PaymentId"),
    CONSTRAINT "CustomerId_Fkey" FOREIGN KEY ("CustomerId")
        REFERENCES public."Customer" ("CustomerId")
    CONSTRAINT "OrderId_Fkey" FOREIGN KEY ("OrderId")
        REFERENCES public."Order" ("OrderId")
    CONSTRAINT "PaymentMethodId_Fkey" FOREIGN KEY ("PaymentMethodId")
        REFERENCES public."PaymentMethod" ("PaymentMethodId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
	
Insert into "Payment" 
("OrderId", "CustomerId", "PaymentMethodId", "Price", "isSuccessful", "isCancelled")
values
	(1, 11, 1, 619.94, true, false),
	(2, 2, 1, 1419.94, True, false),
	(3, 3, 3, 1849.96, True, false),
	(4, 4, 4, 539.95, True, false),
	(5, 5, 5, 999.96, True, false),
	(6, 6, 1, 1009.94, True, false),
	(7, 7, 3, 594.94, True, false),
	(8, 8, 1, 1279.94, True, false),
	(9, 9, 1, 1369.96, True, false),
	(10, 10, 4, 709.95, True, false)

CREATE TABLE IF NOT EXISTS public."PaymentMethod"
(
    "PaymentMethodId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1),
    "PaymentMethod" character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "PaymentMethod_pkey" PRIMARY KEY ("PaymentMethodId")
)

insert into "PaymentMethod" ("PaymentMethod")
values(unnest(array['Credit or Debit Card','Apple ID','Microsoft Account','Paypal','Other online Payment']))


CREATE TABLE IF NOT EXISTS public."Product_Delivery"
(
    "ProductDeliveryId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1),
    "ProductId" integer,
    "Quantity" integer,
    "DateReceived" date,
    CONSTRAINT "Product_Delivery_pkey" PRIMARY KEY ("ProductDeliveryId"),
    CONSTRAINT "ProductIdFKey" FOREIGN KEY ("ProductId")
        REFERENCES public."Product" ("ProductId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
	
INSERT INTO "Product_Delivery" (ProductId, Quantity, DateReceived)
values
(	1,	50,	6/12/24	),
(	2,	100,6/1/24	),
(	3,	20,	6/2/24	),
(	4,	20,	1/4/23	),
(	5,	102,1/5/23	),
(	6,	52,	1/6/23	),
(	7,	22,	1/7/23	),
(	8,	92,	1/8/23	),
(	9,	140,1/9/23	),
(	10,	162,1/10/23	),
(	11,	185,1/11/23	),
(	12,	65,	1/12/23	),
(	13,	30,	1/13/23	),
(	14,	50,	1/14/23	),
(	15,	60,	1/15/23	),
(	16,	8,	1/16/23	),
(	17,	21,	1/17/23	),
(	18,	17,	1/18/23	),
(	19,	23,	1/19/23	),
(	20,	10,	1/20/23	),
(	21,	15,	1/21/23	),
(	22,	7,	1/22/23	),
(	23,	20,	1/23/23	),
(	24,	12,	1/24/23	),
(	25,	5,	1/25/23	),
(	26,	22,	1/26/23	),
(	27,	9,	1/27/23	),
(	28,	14,	1/28/23	),
(	29,	16,	1/29/23	),
(	30,	18,	1/30/23	),
(	31,	6,	1/31/23	),
(	32,	13,	2/1/23	),
(	33,	11,	2/2/23	),
(	34,	19,	2/3/23	),
(	35,	8,	2/4/23	),
(	36,	21,	2/5/23	),
(	37,	17,	2/6/23	),
(	38,	23,	2/7/23	),
(	39,	10,	2/8/23	),
(	40,	15,	2/9/23	)

CREATE TABLE IF NOT EXISTS public."ReturnedProducts"
(
    "ReturnedProductId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1),
    "Order_detailId" integer,
    "Returned_date" date,
    "Reason" character varying(200) COLLATE pg_catalog."default",
    "isRefunded" boolean,
    CONSTRAINT "ReturnedProducts_pkey" PRIMARY KEY ("ReturnedProductId"),
    CONSTRAINT "Order_detailIdFkey" FOREIGN KEY ("Order_detailId")
        REFERENCES public."OrderDetails" ("Order_detailId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

INSERT INTO public."ReturnedProducts" ("Order_detailId", "Returned_date", "Reason", "isRefunded")
VALUES
(141, '2024-07-01', 'Defective product', false),
(127, '2024-07-01', 'Changed mind', false),
(126, '2024-07-02', 'Wrong item shipped', false),
(130, '2024-07-02', 'Product did not meet expectations', false);

CREATE TABLE IF NOT EXISTS public."Shipment"
(
    "ShipmentId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1),
    "Shipment_date" date,
    "OrderId" integer,
    "Shipment_status" character varying(200) COLLATE pg_catalog."default",
    "AddressId" integer,
    CONSTRAINT "Shipment_pkey" PRIMARY KEY ("ShipmentId"),
    CONSTRAINT "AddressIdFkey" FOREIGN KEY ("AddressId")
        REFERENCES public."Address" ("AddressId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "OrderIdFkey" FOREIGN KEY ("OrderId")
        REFERENCES public."Order" ("OrderId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

INSERT INTO public."Shipment" ("Shipment_date", "OrderId", "Shipment_status", "AddressId")
VALUES
('2024-01-01', 1, 'Completed', 10),
('2024-01-02', 2, 'Completed', 11),
('2024-01-03', 3, 'Completed', 12),
('2024-01-04', 4, 'Completed', 13),
('2024-01-05', 5, 'Completed', 14),
('2024-01-06', 6, 'Completed', 15),
('2024-01-07', 7, 'Completed', 16),
('2024-01-08', 8, 'Completed', 17),
('2024-01-09', 9, 'Completed', 18),
('2024-01-10', 10, 'Completed', 19);

Create View VSummary as Select C."First_Name"||' '|| C."Last_Name" as Customer_Name, P."Product_Name",O."Order_date", 
S."Shipment_date",S."Shipment_status", O."TotalPrice" from "Shipment" as S inner join "Order" as O
on O."OrderId"=S."OrderId" inner join "Customer" as C on C."CustomerId"=O."CustomerId"
inner join "OrderDetails" as OD on O."OrderId"=OD."OrderId"
inner join "Product" as P on P."ProductCode"=OD."ProductCode"
order by Customer_Name, P."Product_Name"




