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
				where b.ID_SKU = @ID_SKU and b.Value is not null and b.Quantity is not null
			)
			,@SumQuantity decimal(18, 2) = (
				select cast(sum(iif(b.Quantity is not null, b.Quantity, 0)) as decimal(18, 2))
				from dbo.Basket as b
				where b.ID_SKU = @ID_SKU and b.Value is not null and b.Quantity is not null
			)

		if @SumQuantity = 0
			return cast(0 as decimal(18, 2))

		set @SKUPrice = @SumValue / @SumQuantity
	end
	return isnull(@SKUPrice, cast(0 as decimal(18, 2)))
end
