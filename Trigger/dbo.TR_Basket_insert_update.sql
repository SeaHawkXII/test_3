create or alter trigger dbo.TR_Basket_insert_update on dbo.Basket
after insert
as
set nocount on
begin
	;with cte_CountSKU as (
		select
			i.ID_SKU
			,count(*) as CountSKU
		from inserted as i
		group by i.ID_SKU
	)
	select
		i.ID
		,i.ID_SKU
		,iif(cs.CountSKU > 1, i.Value * 5 / 100, 0) as DiscountValue
	into #DiscountValueSKU
	from inserted as i
		left join cte_countSKU as cs on cs.ID_SKU = i.ID_SKU
	
	update b
	set DiscountValue = dvs.DiscountValue
	from dbo.Basket as b
		inner join #DiscountValueSKU as dvs on dvs.ID = b.ID
end
