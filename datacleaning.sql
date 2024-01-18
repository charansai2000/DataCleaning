use portfolioproject;

-- datatype formating

select * from nashvillehousing;
set autocommit=0;
alter table nashvillehousing modify saledate date;

-- replacing nulls with their address

select * from nashvillehousing where propertyaddress ='';
update nashvillehousing set propertyaddress=NULL where propertyaddress='';

select a.propertyaddress,b.propertyaddress, ifnull(a.propertyaddress,b.propertyaddress) from nashvillehousing a 
join nashvillehousing b where a.parcelid=b.parcelid and a.uniqueid !=b.uniqueid;

update nashvillehousing,(select a.uniqueid as uniqueid,a.parcelid as parcelid, a.propertyaddress as address1,b.propertyaddress as address2, ifnull(a.propertyaddress ,b.propertyaddress) as up from nashvillehousing a 
join nashvillehousing b) as updates
set nashvillehousing.propertyaddress=updates.up 
where nashvillehousing.parcelid=updates.parcelid and nashvillehousing.uniqueid!=updates.uniqueid;

-- Breaking address

select propertyaddress,substring(propertyaddress,1,locate(',',propertyaddress)-1) as address, 
substring(propertyaddress,locate(',',propertyaddress)+1,length(propertyaddress)) as city 
from nashvillehousing;

alter table nashvillehousing add column address text,add column city text;


update nashvillehousing,( select propertyaddress,substring(propertyaddress,1,locate(',',propertyaddress)-1) as address, 
substring(propertyaddress,locate(',',propertyaddress)+1,length(propertyaddress)) as city 
from nashvillehousing) as newtab
set nashvillehousing.city =newtab.city where nashvillehousing.propertyaddress=newtab.propertyaddress;


update nashvillehousing,( select propertyaddress,substring(propertyaddress,1,locate(',',propertyaddress)-1) as address, 
substring(propertyaddress,locate(',',propertyaddress)+1,length(propertyaddress)) as city 
from nashvillehousing) as newtab
set nashvillehousing.address =newtab.address where nashvillehousing.propertyaddress=newtab.propertyaddress;

-----------------------------------------------------------------------------------

select owneraddress from nashvillehousing;

select substring_index(owneraddress,',',-1) as ownersstate, substring_index(owneraddress,',',1) as ownersaddress,
substring_index(substring_index(owneraddress,',',-2),',',1) as ownerscity   from nashvillehousing;

alter table nashvillehousing add column ownersstate text, add column ownerscity text, add column ownersaddress text;

update nashvillehousing 
set ownerscity=substring_index(substring_index(owneraddress,',',-2),',',1) ;

update nashvillehousing 
set ownersstate=substring_index(owneraddress,',',-1);

update nashvillehousing 
set ownersaddress=substring_index(owneraddress,',',1);

select * from nashvillehousing;


-- changing y and n to yes and no in soldasvacant

select distinct(soldasvacant) from nashvillehousing;

update nashvillehousing set soldasvacant='No' where soldasvacant='N';

update nashvillehousing set soldasvacant='Yes' where soldasvacant='Y';

select distinct(soldasvacant) from nashvillehousing;

-- deleting duplicates
with cte as(
select *, row_number() over(partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by parcelid) as rownum
from nashvillehousing)
delete from cte
where rownum>1
;


-- removing unused columns

select * from nashvillehousing;

alter table nashvillehousing drop column propertyaddress, drop column owneraddress, drop column taxdistrict;