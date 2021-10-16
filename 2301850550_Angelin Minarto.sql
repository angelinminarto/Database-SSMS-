--Nama = Angelin Minarto
--NIM = 2301850550

--1. DONE

--2. Create a stored procedure named “UpdateBouquetPrice” 
--to update data in Bouquet table in accordance with the BouquetID inputted by user. 
--The stored procedure parameter is BouquetID and New Bouquet Price.
--Validate BouquetID inputted by the user must exists in Bouquet table.
--If it’s not, then show “Bouquet doesn't exist!” message and no row will be updated. 
--Then, if the BouquetID is exist, 
--delete that data and show “Selected Bouquet has been updated...” message.

GO
CREATE PROCEDURE UpdateBouquetPrice @BouquetID CHAR(5),
@BouquetPrice INT
AS
    IF
    (EXISTS(SELECT * FROM Bouquet 
    WHERE BouquetID = @BouquetID))
    BEGIN
    UPDATE Bouquet SET BouquetPrice=@BouquetPrice WHERE BouquetID=@BouquetID
    PRINT 'Selected Bouquet has been updated...'
    END
    ELSE
    PRINT 'Bouquet doesn''t exist!'

    EXEC UpdateBouquetPrice 'BQ008', 2200000
    DROP PROCEDURE UpdateBouquetPrice

    SELECT * FROM Bouquet WHERE BouquetID='BQ008'

--3. 3.	Create a stored procedure named “BouquetSalesReport” 
--that contains a cursor to display the list of Bouquet in “BouquetStore” database for the selected Bouquet Transaction. 

GO
CREATE PROCEDURE BouquetSalesReport 
  @TransactionId CHAR(5)
AS
DECLARE cur CURSOR
FOR SELECT * FROM Bouquet
OPEN cur
DECLARE @TransactionDate DATE,
		@CustomerName VARCHAR(30),
		@BouquetName VARCHAR(30),
		@BouquetPrice INT,
		@Quantity INT,
		@SubTotal INT,
		@TotalSales INT,
		@TotalBouquetType INT
--Display after the stored procedure is executed
SELECT 
	@TransactionDate = TransactionDate,
	@CustomerName = CustomerName
FROM HeaderTransaction th
JOIN customer c
ON th.CustomerID = c.CustomerID
WHERE TransactionID = @TransactionId
PRINT 'Bouquet Store Sales Report'
PRINT '-------------------------------------------------------------------------------------------------------------------'
PRINT ' | ' + 'Transaction Date :' + CONVERT (VARCHAR, @TransactionDate, 120) + '										 |'
PRINT ' | ' + 'Ordered by		:' + @CustomerName							  + '										 |'
PRINT '-------------------------------------------------------------------------------------------------------------------'
PRINT ' | ' + 'No.' + ' | ' + 'Bouquet Name' + ' | ' + 'Bouquet Price' + ' | ' + 'Quantity' + ' | ' + 'SubTotal' + '     |'
PRINT '-------------------------------------------------------------------------------------------------------------------'
DECLARE cur CURSOR
FOR
SELECT BouquetName, BouquetPrice, Quantity, @SubTotal
FROM Bouquet b
JOIN DetailTransaction dt
ON b.BouquetID = dt.BouquetID
WHERE TransactionID = @TransactionId

OPEN cur
SET @SubTotal = 0 
SET @TotalBouquetType = 0
FETCH NEXT FROM cur INTO @BouquetName, @BouquetPrice,
@Quantity, @SubTotal
WHILE @@FETCH_STATUS = 0
SET @SubTotal = @BouquetPrice * @Quantity
BEGIN
	PRINT '1.' + @BouquetName + CAST (@BouquetPrice AS VARCHAR) + CAST (@Quantity AS VARCHAR) +	CAST(@SubTotal AS VARCHAR)
	PRINT '-------------------------------------------------------------------------------------------------------------------'
	SET @TotalBouquetType += 1
	SET @TotalSales += @SubTotal
FETCH NEXT FROM cur INTO @BouquetName, @BouquetPrice,
@Quantity, @SubTotal
END
PRINT 'Total Bouquet Bought : ' + CAST(@TotalBouquetType AS VARCHAR)
PRINT 'Total Sales			: ' + CAST(@SubTotal AS VARCHAR)

CLOSE cur
DEALLOCATE cur

--4. Create a trigger named “DeleteBouquetTrigger” 
--to display the Bouquet data that deleted from Bouquet 
--for every time user does delete a Bouquet from its table. 
--Show “Bouquet Name”, “Bouquet Flower”, “Bouquet Accessory”, and “Bouquet Price” 
--and message “<Bouquet Name> deleted from list!” after deleted data in the “Messages” tab.

GO
CREATE TRIGGER DeleteBouquetTrigger ON Bouquet
FOR DELETE
AS
DECLARE @BouquetName VARCHAR(30), 
		@BouquetFlower VARCHAR(30),
		@BouquetAccessory VARCHAR(30),
		@BouquetPrice INT

--FINISH