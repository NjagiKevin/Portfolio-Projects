/*
Cleaning Data in SQL Queries
*/


Select *
From [Project II].[dbo].[Nashville Housing]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDateConverted, CONVERT(date, SaleDate)
from [Project II].[dbo].[Nashville Housing]

update [Nashville Housing]
SET SaleDate = CONVERT(date, SaleDate)--Didn't work

Alter Table [Nashville Housing]
Add SaleDateConverted Date;

update [Nashville Housing]
SET SaleDateConverted = CONVERT(date, SaleDate)

--Populate Property Address
 

--where propertyaddress is null
order by ParcelID


--We will do a self join.
Select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
From [Project II].[dbo].[Nashville Housing] a
JOIN [Project II].[dbo].[Nashville Housing] b
	on a.parcelID  = b.parcelID
	and a.uniqueID <> b.uniqueID
where a.propertyaddress is null


Update a --when updating, use  it's alias
Set PropertyAddress= ISNULL(a.propertyaddress,b.PropertyAddress)
From [Project II].[dbo].[Nashville Housing] a
JOIN [Project II].[dbo].[Nashville Housing] b
	on a.parcelID  = b.parcelID
	and a.uniqueID <> b.uniqueID
where a.propertyaddress is null


--Breaking Out Address into Individual Columns (Address, City, State)
Select PropertyAddress
from [Project II].[dbo].[Nashville Housing]

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

from [Project II].[dbo].[Nashville Housing]

Alter Table [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

update [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select*
from [Project II].[dbo].[Nashville Housing]




select OwnerAddress
from [Project II].[dbo].[Nashville Housing]



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Project II].[dbo].[Nashville Housing]

Alter Table [Nashville Housing]
Add OwnwerSplitAddress Nvarchar(255);

update [Nashville Housing]
SET OwnwerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter Table [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

update [Nashville Housing]
SET OwnerSplitSTate = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



--Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(Soldasvacant), count(Soldasvacant)
from [Project II].[dbo].[Nashville Housing]
group by SoldAsVacant
order by 2


select soldasvacant
,case when soldasvacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	END
from [Project II].[dbo].[Nashville Housing]



--Remove Duplicates
with rownumCTE as (
select *,
	row_number() over(
	partition by ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate,
				LegalReference
				order by UniqueID
				)row_num


from [Project II].[dbo].[Nashville Housing]
)
select*
from rownumCTE
where row_num>1
--order by propertyaddress



--Delete unused columns
Select  *
from [Project II].[dbo].[Nashville Housing]


alter table  [Project II].[dbo].[Nashville Housing]
drop column owneraddress, propertyaddress, taxdistrict



alter table  [Project II].[dbo].[Nashville Housing]
drop column saledate

  