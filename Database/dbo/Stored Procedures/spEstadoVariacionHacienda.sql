

-- =============================================
-- Author:		Manoel Reyes Ruiz Morales
-- Create date: 11/05/2020
-- Description:	Reporte de Estado de variación de hacienda pública, especifico o consolidado
-- Parametros: 
-- @bd, cuando es nulo se emite el reporte consolidado, de otro modo se emite para el ente especificado
-- @mes, se genera el reporte con información para el mes indicado
-- =============================================
CREATE PROCEDURE [dbo].[spEstadoVariacionHacienda]
	-- Add the parameters for the stored procedure here
	@bd varchar(200)=null,
	@mes int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @sql nvarchar(max);	
	declare @anio int

	declare @tblEstadoVariacionHacienda table(
		
		[Cuenta] [nvarchar](50),
		[CuentaD] [nvarchar](300),
		[Nivel] [int],
		[Naturaleza]char(1),		
		[Saldo] [money],
		[Anio] [int],
		[Ejercicio] [int]		

	)

	declare @tblCuentaVariacion table(
		
		[Cuenta] [nvarchar](50),
		[SaldoActual] [money],
		[SaldoAnterior] [money],
		[Variacion] [money]
	)
	
	 insert into @tblEstadoVariacionHacienda

	 select 
       
		 Cuenta
		,CuentaD
		,Nivel
		,Naturaleza
		,Sum(Saldo)Saldo
		,Anio
		,Ejercicio					
		
	  from EstadoVariacionHacienda
	  where 
	   Municipio=IIF(@bd IS NULL, Municipio, @bd) and Mes=@mes	    	   
	  group by Municipio,Cuenta,CuentaD,Nivel,Naturaleza,Anio,Ejercicio,Municipio
   	  order by Anio,Cuenta

	  set @anio=(select max(Anio)from @tblEstadoVariacionHacienda)


	  insert into @tblCuentaVariacion
	  
	  select
	   
	      t1.Cuenta,
		  t1.Saldo SaldoActual,
		  t2.Saldo SaldoAnterior,
		  t1.Saldo - t2.Saldo as Variacion 

	  from
	  (
	    select 
	      Cuenta
	     ,Saldo
	    from @tblEstadoVariacionHacienda where Anio=(select max(Anio)from @tblEstadoVariacionHacienda)

	  ) t1
	  inner join 
	  (
	    select 
	      Cuenta
	     ,Saldo
	    from @tblEstadoVariacionHacienda where Anio=(select max(Anio)-1 from @tblEstadoVariacionHacienda)

	  )t2
	  on t1.Cuenta=t2.Cuenta

	  

	  select 

	      t1.Cuenta
		 ,t1.CuentaD
		 ,t1.Nivel
		 ,t1.Anio
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.1._' then t2.SaldoAnterior
			   when t1.Anio=@anio and t1.Cuenta like '3.1._' then t2.Variacion
			   else 0.00
          end Contribuido
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.2.[^1]' then t2.SaldoAnterior
			   when t1.Anio=@anio and t1.Cuenta like '3.2.2' then t2.Variacion
			   else 0.00
          end GeneradoEjercicioAnterior 
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.2.1' then t2.SaldoAnterior
			   when t1.Anio=@anio and t1.Cuenta like '3.2.1' then t2.SaldoActual
			   when t1.Anio=@anio and t1.Cuenta like '3.2.2' then (select SaldoAnterior*-1 from @tblCuentaVariacion where Cuenta='3.2.1')
			   when t1.Anio=@anio and t1.Cuenta like '3.2.[^1-2]' then t2.Variacion
			   else 0.00
          end GeneradoEjercicio
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.3._' then t2.SaldoAnterior			   
			   when t1.Anio=@anio and t1.Cuenta like '3.3._' then t2.Variacion
			   else 0.00
          end ExcesoInsuficiencia
		  ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.1._' then 1
			   when t1.Anio=@anio and t1.Cuenta like '3.1._' then 1
			   else 0
          end ShowContribuido
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.2.[^1]' then 1
			   when t1.Anio=@anio and t1.Cuenta like '3.2.2' then 1
			   else 0
          end ShowGeneradoEjercicioAnterior 
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.2.1' then 1
			   when t1.Anio=@anio and t1.Cuenta like '3.2.1' then 1
			   when t1.Anio=@anio and t1.Cuenta like '3.2.2' then 1
			   when t1.Anio=@anio and t1.Cuenta like '3.2.[^1-2]' then 1
			   else 0
          end ShowGeneradoEjercicio
		 ,case 
		       when t1.Anio=@anio-1 and t1.Cuenta like '3.3._' then 1			   
			   when t1.Anio=@anio and t1.Cuenta like '3.3._' then 1
			   else 0
          end ShowExcesoInsuficiencia

	  from @tblEstadoVariacionHacienda t1 inner join @tblCuentaVariacion t2
	  on t1.Cuenta=t2.Cuenta
	  order by t1.Anio,t1.Cuenta
	

END
