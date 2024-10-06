--Cleaning Data Using SQL
select *
from PortfolioProject..Nationalhousing

--Date Formating

select Saledate, convert(date,Saledate)
from PortfolioProject..Nationalhousing

alter table PortfolioProject..Nationalhousing
add SaleDateConverted Date;

Update PortfolioProject..Nationalhousing
set SaleDateConverted = convert(Date,Saledate)

select SaledateConverted, convert(date,Saledate)
from PortfolioProject..Nationalhousing

-- Fill the Null value of Address
select *
from PortfolioProject..Nationalhousing
--where PropertyAddress is Null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nationalhousing a
join PortfolioProject..Nationalhousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set a.PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nationalhousing a
join PortfolioProject..Nationalhousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking down Address into Address,City,State

select PropertyAddress
from PortfolioProject..Nationalhousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From PortfolioProject..Nationalhousing

alter table PortfolioProject..Nationalhousing
add SplitPropertyAdress Char(255);

Update PortfolioProject..Nationalhousing
set SplitPropertyAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

alter table PortfolioProject..Nationalhousing
add SplitPropertyCity Char(255);

Update PortfolioProject..Nationalhousing
set SplitPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
from PortfolioProject..Nationalhousing

Select OwnerAddress
from PortfolioProject..Nationalhousing

select
Parsename(Replace(OwnerAddress,',','.'),3)
,Parsename(Replace(OwnerAddress,',','.'),2)
,Parsename(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..Nationalhousing

alter table PortfolioProject..Nationalhousing
add SplitOwnerAddress Char(255)

update PortfolioProject..Nationalhousing
Set SplitOwnerAddress = Parsename(Replace(OwnerAddress,',','.'),3)

alter table PortfolioProject..Nationalhousing
add SplitOwnerCity Char(255)

Update PortfolioProject..Nationalhousing
Set SplitOwnerCity = Parsename(Replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject..Nationalhousing
add SplitOwnerState Char(255)

Update PortfolioProject..Nationalhousing
Set SplitOwnerState = Parsename(Replace(OwnerAddress,',','.'),1)

Select *
From PortfolioProject..Nationalhousing

-- Change Y and N to Yes and No in SoldAsVacant

Select SoldAsVacant, count(SoldAsVacant)
from PortfolioProject..Nationalhousing
group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..Nationalhousing

update PortfolioProject..Nationalhousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

-- Remove Dublicates

Select *
from PortfolioProject..Nationalhousing

With RowNumCTE As(
Select *,
	ROW_NUMBER() over (
	Partition by ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
				Order by Uniqueid) row_num
from PortfolioProject..Nationalhousing
)
--Delete
select *
from RowNumCTE
where Row_num >1
order by ParcelID

--Delect Unused Colomns

Select *
from PortfolioProject..Nationalhousing

alter table PortfolioProject..Nationalhousing
drop column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict
