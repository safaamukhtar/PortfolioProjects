--CLEANING DATA WITH SQL QUIRIES

SELECT *
FROM Portfolio2.dbo.Housing

-------------------------------------------------------------------------------------------

--Standarize data format

SELECT SaleDate, convert (date, saledate) as Date
FROM Portfolio2.dbo.Housing

 update Housing
 set SaleDate= convert (date, saledate)
 from Portfolio2.dbo.Housing

 alter table housing
 add datesaleconverted Date

  update Housing
 set datesaleconverted = convert (date, saledate)
 from Portfolio2.dbo.Housing

 SELECT SaleDate, datesaleconverted as Date
FROM Portfolio2.dbo.Housing

-------------------------------------------------------------------------------------------

--populate property date address

SELECT PropertyAddress
FROM Portfolio2.dbo.Housing
where PropertyAddress is null

SELECT *
FROM Portfolio2.dbo.Housing
where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, a.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
FROM Portfolio2.dbo.Housing a
join Portfolio2.dbo.Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]!= b.[UniqueID ]
where a.PropertyAddress is null


update a
set ParcelID = isnull(a.propertyaddress, b.PropertyAddress)
FROM Portfolio2.dbo.Housing a
join Portfolio2.dbo.Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]!= b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------------------------

--breaking down address into individual columns (address, city, state)
--will use substring , character index

SELECT PropertyAddress
FROM Portfolio2.dbo.Housing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, len(PropertyAddress)) as City
FROM Portfolio2.dbo.Housing

 alter table housing
 add propertysplitaddress nvarchar(255)

  update Housing
 set propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1)
 from Portfolio2.dbo.Housing

  alter table housing
 add propertysplitcity nvarchar(255)

  update Housing
 set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, len(PropertyAddress))
 from Portfolio2.dbo.Housing

 select*
 from Portfolio2..Housing

  select OwnerAddress
 from Portfolio2..Housing

 select
 PARSENAME(replace(owneraddress,',', '.'),3),
 PARSENAME(replace(owneraddress,',', '.'),2),
 PARSENAME(replace(owneraddress,',', '.'),1)
  from Portfolio2..Housing


  alter table housing
 add ownersplitaddress nvarchar(255)

  update Housing
 set ownersplitaddress = PARSENAME(replace(owneraddress,',', '.'),3)
 from Portfolio2.dbo.Housing

 alter table housing
 add ownersplitcity nvarchar(255)

  update Housing
 set ownersplitcity = PARSENAME(replace(owneraddress,',', '.'),2)
 from Portfolio2.dbo.Housing

 alter table housing
 add ownersplitstate nvarchar(255)

  update Housing
 set ownersplitstate = PARSENAME(replace(owneraddress,',', '.'),1)
 from Portfolio2.dbo.Housing

 select* 
 from Portfolio2..Housing

 --------------------------------------------------------------------------------------------------

 --change y and n to yes and no in "sold as vacant" field

 select distinct (soldasvacant), count(soldasvacant)
 from Portfolio2..Housing
 group by SoldAsVacant


 select soldasvacant,
 case when soldasvacant = 'y' then 'Yes'
 when soldasvacant = 'n' then 'No'
 else SoldAsVacant
 end
 from Portfolio2..Housing

 update Housing
 set SoldAsVacant = case when soldasvacant = 'y' then 'Yes'
 when soldasvacant = 'n' then 'No'
 else SoldAsVacant
 end

-------------------------------------------------------------------------------------------------------

 --ROMVING DUBLICATES

 --(not done most of the times)
 --using rank or raw number


 with rownumcte as(
 select *,
 ROW_NUMBER () over (
 partition by parcelid,
              propertyaddress,
			  saleprice,
			  saledate,
			  legalreference
			  order by
			  uniqueid)
			  row_num
 from Portfolio2..Housing
 --order by ParcelID)
 )
 select *
 from rownumcte
where row_num > 1
--order by PropertyAddress



-------------------------------------------------------------------------------------------------------

--DELETING UNUSED COLUMNS

select *
from Portfolio2..Housing


alter table Portfolio2..Housing
drop column owneraddress, taxdistrict, propertyaddress

alter table Portfolio2..Housing
drop column saledate 