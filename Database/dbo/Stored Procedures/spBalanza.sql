



-- =============================================
-- Author:		Manoel Reyes Ruiz Morales
-- Create date: 17/04/2020
-- Description:	Reporte de balanza acumulada y consolidada
-- Parametros: 
-- @bd, cuando es nulo se emite la balanza consolidada, de otro modo se emite para el ente especificado
-- Si @mesInicio y @mesTermino son iguales, se genera la balanza unicamente del mes indicado
-- Si @mesInicio y @mesTermino son diferentes, se genera la balanza acumulada a partir de @mesInicio y hasta @mesTermino
-- =============================================
CREATE PROCEDURE [dbo].[spBalanza]
	-- Add the parameters for the stored procedure here
	@bd varchar(200)=null,
	@mesInicio int,
	@mesTermino int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		
     with tblCuentaSaldos As (

	   select 

		   Municipio
		  ,Cuenta
		  ,Sum(SaldoInicial) SaldoInicial
		  ,Sum(SaldoFinal) SaldoFinal

	   from 
	   (
		   select 
			   Municipio
			  ,Cuenta
			  ,sum(case Mes when @mesInicio then SaldoInicial else 0.00 end) SaldoInicial
			  ,sum(case Mes when @mesTermino then SaldoFinal else 0.00 end) SaldoFinal
			  ,Mes 
		   from Balanza
		   where Municipio=IIF(@bd IS NULL, Municipio, @bd) and Mes in (@mesInicio,@mesTermino)
		   group by Municipio,Cuenta,Mes

	   ) t
	   group by Municipio,Cuenta

   ),
   tblCuentaCargosAbonos AS (


	   select 
       
			 Cuenta
			,CuentaD
			,Sum(Cargo) Cargo
			,Sum(Abono) Abono
			,Nivel			
			,Ejercicio
			,Municipio 

	   from Balanza
	   where Municipio=IIF(@bd IS NULL, Municipio, @bd) and Mes between @mesInicio and @mesTermino
	   group by Municipio,Cuenta,CuentaD,Nivel,Ejercicio	  

   )


   select  

       Cuenta
	  ,CuentaD
	  ,Nivel
	  ,Sum(SaldoInicial) as SaldoInicial
	  ,Sum(Cargo) as Cargo
	  ,Sum(Abono) as Abono
	  ,Sum(SaldoFinal) as SaldoFinal	  

	from

   (

	   select 

		   tblCuentaCargosAbonos.Cuenta
		  ,tblCuentaCargosAbonos.CuentaD
		  ,tblCuentaCargosAbonos.Nivel
		  ,tblCuentaSaldos.SaldoInicial
		  ,tblCuentaCargosAbonos.Cargo
		  ,tblCuentaCargosAbonos.Abono
		  ,tblCuentaSaldos.SaldoFinal	  
		  ,tblCuentaCargosAbonos.Ejercicio
		  ,tblCuentaCargosAbonos.Municipio

	   from tblCuentaSaldos 
	   inner join tblCuentaCargosAbonos
	   on tblCuentaCargosAbonos.Municipio=tblCuentaSaldos.Municipio 
	   and tblCuentaCargosAbonos.Cuenta=tblCuentaSaldos.Cuenta

   ) t1
   group by t1.Cuenta,t1.CuentaD,t1.Nivel
   order by Cuenta
		

END
