use PortfolioProject

select * from nashvillehousing

--standardize date formate
select saledate  from nashvillehousing

update nashvillehousing
set SaleDate=convert(date,saledate) 

alter table nashvillehousing
add saledateconverted date;

update nashvillehousing
set saledateconverted=convert(date,saledate) 


--populate property address data
select propertyaddress from nashvillehousing
where  propertyaddress is null


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from nashvillehousing a
join nashvillehousing  b on a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.propertyaddress,b.PropertyAddress)
from nashvillehousing a
join nashvillehousing  b on a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual colums(address,city,state)
select propertyaddress from nashvillehousing

select SUBSTRING(PropertyAddress,1,charindex(',',propertyaddress)-1) as address
,SUBSTRING(PropertyAddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as address
from nashvillehousing


alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update nashvillehousing
set propertysplitaddress=SUBSTRING(PropertyAddress,1,charindex(',',propertyaddress)-1)

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update nashvillehousing
set propertysplitcity=SUBSTRING(PropertyAddress,charindex(',',propertyaddress)+1,len(propertyaddress))


select owneraddress from nashvillehousing

select parsename(replace(owneraddress,',','.'),3),
 parsename(replace(owneraddress,',','.'),2),
  parsename(replace(owneraddress,',','.'),1)
from nashvillehousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255);

update nashvillehousing
set ownersplitaddress=parsename(replace(owneraddress,',','.'),3)

alter table nashvillehousing
add ownersplitcity nvarchar(255);

update nashvillehousing
set ownersplitcity=parsename(replace(owneraddress,',','.'),2)

alter table nashvillehousing
add ownersplitstate nvarchar(255);

update nashvillehousing
set ownersplitstate= parsename(replace(owneraddress,',','.'),1)


select distinct(soldasvacant),COUNT(soldasvacant) from nashvillehousing
group by SoldAsVacant


select soldasvacant,case when soldasvacant='Y' then 'Yes' when soldasvacant='N' then 'No'
else soldasvacant end
from nashvillehousing

update nashvillehousing
set SoldAsVacant=case when soldasvacant='Y' then 'Yes' when soldasvacant='N' then 'No'
else soldasvacant end

--removing duplicates
with rownumcte as(
select *,ROW_NUMBER() over(partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid) row_num 

from nashvillehousing

)
select * from rownumcte
where row_num>1 
order by propertyaddress

--delete unused colums

alter table nashvillehousing
--drop column owneraddress,taxdistrict,propertyaddress
drop column saledate