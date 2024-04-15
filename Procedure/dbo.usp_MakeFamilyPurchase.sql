/*
Входной параметр принимает атрибут SurName таблицы dbo.Family
Проблема в том, что атрибут не уникальный, и в таблице dbo.Family может быть несколько семей с одинаковым SurName
Процедура реализована так, что для всех семей по отдельности с заданным SurName выполняется необходимый алгоритм
Также не было условий, может ли BudgetValue быть меньше 0 - поэтому данный момент не проверяется
*/
create or alter procedure dbo.usp_MakeFamilyPurchase
	@FamilySurName varchar(255)
as
set nocount on
begin
	declare @ErrorMessage varchar(255)

	select f.ID
	into #ID_Family
	from dbo.Family as f
	where f.SurName = @FamilySurName
	
	if not exists (select * from #ID_Family)
	begin
		set @ErrorMessage = concat('Семьи ', @FamilySurName, ' нет')
		raiserror(@ErrorMessage, 1, 1)
		return
	end

	select
		b.ID_Family
		,sum(isnull(b.Value, 0)) as SumValue
	into #BasketValue
	from dbo.Basket as b
	where b.ID_Family in (select * from #ID_Family)
	group by b.ID_Family

	update f
	set BudgetValue = f.BudgetValue - bv.SumValue
	from dbo.Family as f
		inner join #BasketValue as bv on bv.ID_Family = f.ID

	return
end
