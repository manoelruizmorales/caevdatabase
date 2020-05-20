


CREATE PROCEDURE [dbo].[spGeneraEstadoSituacionFinanciera]
	-- Add the parameters for the stored procedure here
	@bd as nvarchar(200)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @sql1 nvarchar(max);
	declare @sql2 nvarchar(max);		
	declare @ejercicio int;	
	declare @mes int;	
	
	declare @tablaEstadoSituacionFinanciera table(

		 cuenta nvarchar(50),
		 naturaleza char(1),
		 nivel int,
		 descripcion nvarchar(300),		
		 ejercicioanterior money,
		 saldo money
	)	
	

   set @sql1=replace('select top 1 @ejercicio=anio from #tokend_db.dbo.Ejercicio','#tokend_db',@bd);  
	  
   exec sp_executesql @sql1, N'@ejercicio int out',@ejercicio out	


   set @mes=1;
	
   while @mes <= 12
   begin
      

	   print 'INICIA PROCESO: ' +  cast(@mes as nvarchar(2));  	

	   set @sql1=FormatMessage(
				 ' exec %s.dbo.ReportesEstadosFinancierosNivelSFDF1aCONACR 
					    @mes=%d
					   ,@ejercicio=%d					   
					   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mes,@ejercicio)
	
	   set @sql2=FormatMessage(
				 ' exec %s.dbo.ReportesEstadosFinancierosNivelSFDF2aCONACR 
					    @mes=%d
					   ,@ejercicio=%d					   
					   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mes,@ejercicio)

	  
	  
	  if(charindex('.',@bd,0)!=0) --nombre de la base contiene referencia a servidor vinculado 
	  begin	  
				
	    set @sql1=FormatMessage('SELECT * FROM OPENQUERY([BackupServer],''%s'')',@sql1)

		set @sql2=FormatMessage('SELECT * FROM OPENQUERY([BackupServer],''%s'')',@sql2)

	  end 
	     	 

	  insert @tablaEstadoSituacionFinanciera exec(@sql1)
	  insert @tablaEstadoSituacionFinanciera exec(@sql2)	  
	

		insert into [dbo].[EstadoSituacionFinanciera]
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
		  ,descripcion
		  ,nivel
		  ,naturaleza
		  ,ejercicioanterior
		  ,saldo		 
		  ,@mes		  
		  ,@ejercicio
		  ,right(@bd,len(@bd)-charindex('.',@bd,0)) Municipio	
	 
		from @tablaEstadoSituacionFinanciera			
		
	   delete @tablaEstadoSituacionFinanciera; 
	   
	   print 'TERMINA PROCESO: ' +  cast(@mes as nvarchar(2))       

	   set @mes=@mes + 1;

   end   
	
END
