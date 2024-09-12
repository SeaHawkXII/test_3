create or alter view dbo.vw_SKUPrice
as
select s.*, dbo.udf_GetSKUPrice(s.ID) as SKUPrice from dbo.SKU as s
