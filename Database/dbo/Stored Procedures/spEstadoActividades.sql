

-- =============================================
-- Author:		Manoel Reyes Ruiz Morales
-- Create date: 27/04/2020
-- Description:	Reporte de Estado de actividades especifico y consolidado
-- Parametros: 
-- @bd, cuando es nulo se emite el reporte consolidado, de otro modo se emite para el ente especificado
-- @mes,indica el mes de consulta
-- =============================================
CREATE PROCEDURE [dbo].[spEstadoActividades]
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
			,Sum(SaldoEjercicioAnterior) SaldoEjercicioAnterior
			,Sum(SaldoEjercicioActual) SaldoEjercicioActual		
			,Nivel			
			,Ejercicio
			,Municipio 

	   from EstadoActividades
	   where 
	   Municipio=IIF(@bd IS NULL, Municipio, @bd) and Mes =@mes 
	   and (Cuenta like ('_') or Cuenta like ('_._') or Cuenta like ('_._._')) 
	   group by Municipio,Cuenta,CuentaD,Nivel,Ejercicio

END


SET ANSI_NULLS ON
