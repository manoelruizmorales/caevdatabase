



-- =============================================
-- Author:		Manoel Reyes Ruiz Morales
-- Create date: 29/04/2020
-- Description:	Reporte de Analitico de activos, especifico o consolidado
-- Parametros: 
-- @bd, cuando es nulo se emite el reporte consolidado, de otro modo se emite para el ente especificado
-- @mes, se genera el reporte con información para el mes indicado
-- =============================================
CREATE PROCEDURE [dbo].[spEstadoAnaliticoActivo]
	-- Add the parameters for the stored procedure here
	@bd varchar(200)=null,
	@mes int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		
     select 
       
			 Cuenta
			,CuentaD
			,Nivel
			,Sum(SaldoInicial) SaldoInicial
			,Sum(Cargos) Cargos
			,Sum(Abonos) Abonos
			,Sum(SaldoFinal) SaldoFinal
			,Sum(Variacion) Variacion				
			,Ejercicio
			,Municipio 

	   from EstadoAnaliticoActivo
	   where 
	   Municipio=IIF(@bd IS NULL, Municipio, @bd) and Mes =@mes 	   
	   group by Municipio,Cuenta,CuentaD,Nivel,Ejercicio
   		

END
