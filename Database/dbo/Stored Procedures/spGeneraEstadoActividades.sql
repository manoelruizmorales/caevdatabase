

CREATE PROCEDURE [dbo].[spGeneraEstadoActividades]
	-- Add the parameters for the stored procedure here
	@bd as nvarchar(200)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @sql nvarchar(max);	
	declare @ejercicio int;
	declare @mes int;	
	
	declare @tablaEstadoActividades table(

		Cuenta nvarchar(100),
		Naturaleza char(1),
		Nivel int,
		CuentaD nvarchar(300),
		EjercicioAnterior [money],
		Saldo [money]	

	)	
	

   set @sql=replace('select top 1 @ejercicio=anio from #tokend_db.dbo.Ejercicio','#tokend_db',@bd);  
	  
   exec sp_executesql @sql, N'@ejercicio int out',@ejercicio out


   set @mes=1;
	
   while @mes <= 12
   begin       
   	   

	   print 'INICIA PROCESO: ' +  cast(@mes as nvarchar(5));  	

	   set @sql=FormatMessage(
				 ' exec %s.dbo.ReportesEstadosFinancierosEACONACR
				        @mes=%d 
					   ,@ejercicio=''%s''
					   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mes,convert(nvarchar(50), @ejercicio))
	


	  
	  
	  if(charindex('.',@bd,0)!=0) --nombre de la base contiene referencia a servidor vinculado 
	  begin

	   set @sql=FormatMessage(
				 ' exec %s.dbo.ReportesEstadosFinancierosEACONACR
				        @mes=%d 
					   ,@ejercicio=''''%s''''					 
					   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mes,convert(nvarchar(50), @ejercicio))




	    set @sql=FormatMessage('SELECT * FROM OPENQUERY([BackupServer],''%s'')',@sql)

	  end 
	     	 

	  insert @tablaEstadoActividades exec(@sql)
	  
	

		INSERT INTO [dbo].[EstadoActividades]
           ([Cuenta]
           ,[CuentaD]
           ,[Nivel]
           ,[Naturaleza]
           ,[SaldoEjercicioAnterior]
           ,[SaldoEjercicioActual]
           ,[Mes]
           ,[Ejercicio]
           ,[Municipio])
	   
			    
		select
	
		   cuenta
		  ,cuentad		  
		  ,nivel
		  ,naturaleza
		  ,ejercicioanterior
		  ,saldo		
		  ,@mes		  	  
		  ,@ejercicio
		  ,right(@bd,len(@bd)-charindex('.',@bd,0)) Municipio	
	 
		from @tablaEstadoActividades	
		
		
	   delete @tablaEstadoActividades;  

	   set @mes=@mes + 1;

	  print 'TERMINA PROCESO: ' +  cast(@mes as nvarchar(5));      

   end   
	
END
