Use Portofolioproject

/*

Cleaning Data in SQL Queries

*/

select *
from Portofolioproject.dbo.Nashville_Project

-----------------------------------------------------------------------------------------

-- Standardize Date Format

select Saledate
from Portofolioproject.dbo.nashville_project

select Saledate, convert(date, Saledate)
from Portofolioproject.dbo.nashville_project

Update nashville_project
set saledate = convert(date, saledate)

alter table nashville_project
add Sale_date date;

Update nashville_project
set sale_date = convert(date, saledate)

Select Sale_date
from Portofolioproject.dbo.nashville_project


----------------------------------------------------------------------------

-- Populating Property Address data

Select *
from Portofolioproject.dbo.nashville_project
where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from Portofolioproject.dbo.nashville_project a
join Portofolioproject.dbo.nashville_project b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from Portofolioproject.dbo.nashville_project a
join Portofolioproject.dbo.nashville_project b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------------------

-- Breaking out address into individual columns (Adress, city, state)



Select PropertyAddress
from Portofolioproject.dbo.nashville_project
-- where PropertyAddress is null
-- order by ParcelID
 

select
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address
, SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress) + 1, len(propertyaddress)) as City

from Portofolioproject.dbo.nashville_project 


alter table nashville_project
add propertyadd nvarchar(255) ;

Update nashville_project
set propertyadd = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

alter table nashville_project
add propertycity nvarchar(255);

Update nashville_project
set propertycity = SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress) + 1, len(propertyaddress))




select OwnerAddress
from Portofolioproject.dbo.nashville_project 



select 
PARSENAME(Replace(Owneraddress,',','.'),3),
PARSENAME(Replace(Owneraddress,',','.'),2),
PARSENAME(Replace(Owneraddress,',','.'),1)
from Portofolioproject.dbo.nashville_project 



alter table nashville_project
add Owner_Address nvarchar(255) ;

Update nashville_project
set Owner_Address = PARSENAME(Replace(Owneraddress,',','.'),3)

alter table nashville_project
add Owner_City nvarchar(255) ;

Update nashville_project 
set Owner_City = PARSENAME(Replace(Owneraddress,',','.'),2)

alter table nashville_project
add Owner_State nvarchar(255) ;

Update nashville_project
set Owner_State = PARSENAME(Replace(Owneraddress,',','.'),1)



select *
from Portofolioproject.dbo.Nashville_Project


-----------------------------------------------------------------------------------------------------------

-- Changing Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Portofolioproject.dbo.Nashville_Project
Group by SoldAsVacant
 order by 2



 
select SoldAsVacant
, Case when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
from Portofolioproject.dbo.Nashville_Project


Update Nashville_Project
SET SoldAsVacant =
Case when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
from Portofolioproject.dbo.Nashville_Project



---------------------------------------------------------------------------------------

-- Removing Duplicates

With Rownum AS(
Select *,
	ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
				 PropertyAddress,
				 LandUse,
				 SaleDate,
				 SalePrice,
				 LegalReference

				 ORDER BY UniqueID) Row_num

from Portofolioproject.dbo.Nashville_Project
--order by ParcelID
)

Delete*
From Rownum
where row_num > 1


-------------------------------------------------------------------------------------------------------------


-- Removing unused columns


select *
from Portofolioproject.dbo.Nashville_Project

Alter Table Portofolioproject.dbo.Nashville_Project
drop column OwnerAddress, Saledate, Propertyaddress, TaxDistrict


sp_rename 'Nashville_Project.propertyadd', 'Property_Address', 'Column';
sp_rename 'Nashville_Project.propertycity', 'Property_City', 'Column';

