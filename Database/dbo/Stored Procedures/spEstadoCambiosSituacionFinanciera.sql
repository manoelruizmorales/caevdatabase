

-- =============================================
-- Author:		Manoel Reyes Ruiz Morales
-- Create date: 08/05/2020
-- Description:	Reporte de Estado de cambios en la situación financiera, especifico o consolidado
-- Parametros: 
-- @bd, cuando es nulo se emite el reporte consolidado, de otro modo se emite para el ente especificado
-- @mes, se genera el reporte con información para el mes indicado
-- =============================================
CREATE PROCEDURE [dbo].[spEstadoCambiosSituacionFinanciera]
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
		 ,SaldoEjercicioAnterior
		 ,SaldoEjercicioActual
		 ,case 
			    when substring(Cuenta,0,1)='1' And Nivel=3 And (SaldoEjercicioActual > SaldoEjercicioAnterior)  then SaldoEjercicioActual-SaldoEjercicioAnterior 
			    when substring(Cuenta,0,1)!= '1' And Nivel=3 And (SaldoEjercicioActual < SaldoEjercicioAnterior)  then SaldoEjercicioAnterior-SaldoEjercicioActual    
			    else 0 
		  end Origen
		 ,case 
			    when substring(Cuenta,0,1)='1' And Nivel=3 And (SaldoEjercicioActual < SaldoEjercicioAnterior)  then SaldoEjercicioAnterior-SaldoEjercicioActual 
			    when substring(Cuenta,0,1)!= '1' And Nivel=3 And (SaldoEjercicioActual > SaldoEjercicioAnterior)  then SaldoEjercicioActual-SaldoEjercicioAnterior    
			    else 0 
		  end Aplicacion		 
		 ,Ejercicio
		 ,Municipio
	  
	  from (


	   select 
       
			 Cuenta
			,CuentaD
			,Nivel
			,Sum(SaldoEjercicioAnterior) SaldoEjercicioAnterior
			,Sum(SaldoEjercicioActual) SaldoEjercicioActual						
			,Ejercicio
			,Municipio 

	   from EstadoSituacionFinanciera
	   where 
	   Municipio=IIF(@bd IS NULL, Municipio, @bd) and Mes =@mes
	    and (Cuenta like ('_') or Cuenta like ('_._') or Cuenta like ('_._._'))  	   
	   group by Municipio,Cuenta,CuentaD,Nivel,Ejercicio
   		
	) t1

END
