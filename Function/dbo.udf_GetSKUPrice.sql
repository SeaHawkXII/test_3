create or alter function dbo.udf_GetSKUPrice(
   @ID_SKU int
)
returns decimal(18, 2)
as
begin
	declare @SKUPrice decimal(18, 2)

	if exists (
		select 1
		from dbo.Basket as b
		where b.ID_SKU = @ID_SKU
	)
	begin
		declare
			@SumValue decimal(18, 2) = (
				select sum(b.Value)
				from dbo.Basket as b
				where b.ID_SKU = @ID_SKU and isnull(b.Value, 0) <> 0 and isnull(b.Quantity, 0) <> 0
			)
			,@SumQuantity decimal(18, 2) = (
				select cast(sum(b.Quantity) as decimal(18, 2))
				from dbo.Basket as b
				where b.ID_SKU = @ID_SKU and isnull(b.Quantity, 0) <> 0
			)

		if @SumQuantity = 0
			return cast(0 as decimal(18, 2))

		set @SKUPrice = @SumValue / @SumQuantity
	end
	return isnull(@SKUPrice, cast(0 as decimal(18, 2)))
end
