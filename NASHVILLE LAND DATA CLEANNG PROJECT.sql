/* CLEANING DATA IN SQL QUERIES */


--SELECT * FROM PORTFOLIOPROJECT.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------------------------

/*  STANDARDIZE DATE FROMAT */

--SELECT SaleDateConverted, CONVERT(Date,SaleDate) FROM PORTFOLIOPROJECT.dbo.NashvilleHousing

--UPDATE NashvilleHousing SET SaleDate = CONVERT(Date,SaleDate)


--ALTER TABLE NashvilleHousing Add SaleDateConverted Date;


--UPDATE NashvilleHousing SET SaleDateConverted = CONVERT(Date,SaleDate)


----------------------------------------------------------------------------------------------------------------------------------------------

/* Populate Property Address Data */

--SELECT ParcelID,PropertyAddress FROM PORTFOLIOPROJECT.dbo.NashvilleHousing
----where PropertyAddress is NULL
--order by ParcelID


--SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
--FROM PORTFOLIOPROJECT.dbo.NashvilleHousing a
--JOIN PORTFOLIOPROJECT.dbo.NashvilleHousing b
--       on a.ParcelID = b.ParcelID
--	   AND a.[UniqueID ] <> b.[UniqueID ]
--WHERE a.PropertyAddress is NULL

--UPDATE a
--SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
--FROM PORTFOLIOPROJECT.dbo.NashvilleHousing a
--JOIN PORTFOLIOPROJECT.dbo.NashvilleHousing b
--       on a.ParcelID = b.ParcelID
--	   AND a.[UniqueID ] <> b.[UniqueID ]
--WHERE a.PropertyAddress is NULL


----------------------------------------------------------------------------------------------------------------------------------------------

/* BREAKING OUT ADDRESS INTO INDIVIDU9AL COLUMNS (ADDRESS,CITY,STATE) */


--SELECT ParcelID,PropertyAddress FROM PORTFOLIOPROJECT.dbo.NashvilleHousing
----where PropertyAddress is NULL
----order by ParcelID

--SELECT	
--SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) as Address
--,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

--FROM PORTFOLIOPROJECT.dbo.NashvilleHousing

--ALTER TABLE NashvilleHousing
--Add PropertySplitAddress Nvarchar(255);

--UPDATE NashvilleHousing
--SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) 


--ALTER TABLE NashvilleHousing
--Add PropertySplitCity Nvarchar(255);

--UPDATE NashvilleHousing
--SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

--ALTERNATE METTHOD USING PARSENAME
--SELECT
--OwnerAddress FROM PORTFOLIOPROJECT.dbo.NashvilleHousing

--SELECT 
--PARSENAME(REPLACE(OwnerAddress,',','.'),3),
--PARSENAME(REPLACE(OwnerAddress,',','.'),2),
--PARSENAME(REPLACE(OwnerAddress,',','.'),1)
--FROM 
--PORTFOLIOPROJECT.dbo.NashvilleHousing


--ALTER TABLE NashvilleHousing
--Add OwnerSplitAddress Nvarchar(255);

--UPDATE NashvilleHousing
--SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


--ALTER TABLE NashvilleHousing
--Add OwnerSplitCity Nvarchar(255);

--UPDATE NashvilleHousing
--SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

--ALTER TABLE NashvilleHousing
--Add OwnerSplitState Nvarchar(255);

--UPDATE NashvilleHousing
--SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

----------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGE Y AND N TO YES OR NO IN "SOLD AS VACANT" FIELD */


--SELECT DISTINCT(SoldAsVacant), COUNT(SoldasVacant)
--FROM PORTFOLIOPROJECT.dbo.NashvilleHousing
--Group by SoldAsVacant
--order by 2


--SELECT SoldasVacant
--, CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
--       WHEN SoldasVacant = 'N' THEN 'No'
--	   ELSE SoldasVacant
--	   END
--FROM PORTFOLIOPROJECT.dbo.NashvilleHousing


--UPDATE NashvilleHousing
--SET SoldAsVacant = CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
--       WHEN SoldasVacant = 'N' THEN 'No'
--	   ELSE SoldasVacant
--	   END

------------------------------------------------------------------------------------------------------------------------------------------------

--/* REMOVE DUPLICATES */

--WITH RowNumCTE AS (
--SELECT *,
--ROW_NUMBER() OVER (
--PARTITION BY ParcelID,
--             PropertyAddress,
--			 SalePrice,
--			 LegalReference
--			 ORDER BY
--			 UniqueID
--			 ) row_num

--FROM PORTFOLIOPROJECT.dbo.NashvilleHousing
--)
--SELECT * FROM RowNumCTE
--WHERE row_num > 1
--Order by PropertyAddress


----------------------------------------------------------------------------------------------------------------------------------------------

/*DELETE UNUSED COLUMNS*/

--SELECT * FROM PORTFOLIOPROJECT.dbo.NashvilleHousing;

--ALTER TABLE PORTFOLIOPROJECT.dbo.NashvilleHousing
--DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate