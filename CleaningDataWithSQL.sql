#cleaning data with sql

#first view of table to see what we have
#select some areas where the data can be improved for better usability

Select * 
FROM portfolioproject.nhousing;

#standardize real estate sale date format

Select SaleDate, CONVERT(Date, SaleDate)
FROM portfolioproject.nhousing;

UPDATE nhousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE nhousing
Add SaleDateConverted Date

UPDATE nhousing
SET SaleDateConverted = CONVERT(Date, SaleDate);


#populate property address data where address is blank
#some propery address is NULL
#the owners address may be different but the propety address should be consistent nearly 100% of the time

Select PropertyAddress
From portfolioproject.nhousing
Where PropertyAddress is null;

#my suspicion is that the parcel ID is not changing
Select *
From portfolioproject.nhousing
order by ParcelID;

#confirmed
#we can use this to create a join. 
#uniqueID identifies different transactions 

#search for missing addresses
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From portfolioproject.nshousing a
JOIN portfolioproject.nhousing b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null;

#update table to copy appropriate address
Update a
SET PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From portfolioproject.nshousing a
JOIN portfolioproject.nhousing b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID; 


#seperate addresses into component pieces
#the only place where commas "," exist is as a delimiter in the address
#this can be used to parse address into substring
#using character index -1 and +1 to eliminate the comma from attribute

Select 
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1) as SplitAddress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as SplitCity
FROM portfolioproject.nhousing;

#it works so we can now alter the table

ALTER TABLE nhousing
ADD SplitAddress NVARCHAR (255);

Update nhousing
SET SplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE nhousing
ADD SplitCity NVARCHAR (255);

update nhousing
SET SplitCity = (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));

#review the changes 

Select *
From portfolioproject.nhousing;

#separating the Owneraddress using Parsename which is much easier 
#the parse is set in replacing period "." with comma ","
#the parse list is reversed to keep the order "address" (3) "city"(2) "state"(1)

ALTER TABLE nhousing
ADD OwnerSplitAddress NVARCHAR(255);
Update nhousing
Set OwnerSpitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3);

Alter TABLE nhousing
ADD OwnerSplitCity NVARCHAR(255);
Update nhousing 
Set OwnerSpitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2);

Alter TABLE nhousing
ADD OwnerSplitState NVARCHAR(255);
Update nhousing
Set OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1);


#change the sold as vacant column for consistency. there is Y and Yes and N and No 
#this should all be changed to be consistently Yes and No 

Select SoldAsVacant
, CASE when SOldAsVacant = 'Y' THEN  'Yes'
	When SoldAsVacant = 'N' THEN 'No'
    Else SoldAsVacant
    END
From portfolioproject.nhousing;

Update nhousing
SET SoldAsVacant = CASE 
	when SOldAsVacant = 'Y' THEN  'Yes'
	When SoldAsVacant = 'N' THEN 'No' 
    ELSE SoldAsVacant 
    END;
    
#remove duplicates
#not standard practice to completely remove duplicatates
#prefereably create temp tables to hold the removed data


#first find the duplicates if they exist based on data in rows not uniqueiD
WITH RowNum CTE AS(
Select *
	ROW_NUMBER() OVER(
    PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    ORDER BY UniqueID
    ) rownum
From portfolioproject.nhousing
Order By ParcelID
)

#this is showing rows that are duplicates
Select * 
from RowNumCTE 
Where row_num > 1
Order by ParcelID

#delete rows test

DELETE 
from RowNumCTE 
Where row_num > 1
Order by ParcelID;

#delete unused columns to reduce the size of the date to make use easier and more efficient
#this iis only effecting columns with redundant information compared to new columns we created. 
#including the address columns pre-plit and the un formatted saledate

Select * 
From portfolioproject.nhousing;

Alter Table portfolioproject.nhousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

Alter Table portfolioproject.nhousing
DROP COLUMN SaleDate;

