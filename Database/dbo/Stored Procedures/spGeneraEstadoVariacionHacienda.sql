

CREATE PROCEDURE [dbo].[spGeneraEstadoVariacionHacienda]
	-- Add the parameters for the stored procedure here
	@bd as nvarchar(200)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @sql nvarchar(max);		
	declare @ejercicio as int;	
	declare @mes as int;	
	
	declare @tablaEstadoVariacionHacienda table(

		[padre]uniqueidentifier,
		[codigoCompleto] [nvarchar](50),
		[nombre] [nvarchar](300),
		[naturaleza]char(1),
		[nivel] [int],
		[total] [money],
		[año] [int],
		[grupoaño] [int],
		[grupocuentas] [money],
		[identificador] [nvarchar](10)		

	)	
	

   set @sql=replace('select top 1 @ejercicio=anio from #tokend_db.dbo.Ejercicio','#tokend_db',@bd);  
	  
   exec sp_executesql @sql, N'@ejercicio int out',@ejercicio out	 
   

   set @mes=1;
	
   while @mes <= 12
   begin
          
	  

	   print 'INICIA PROCESO: ' +  cast(@mes as varchar(2));  
	   	   		  
	  
	  if(charindex('.',@bd,0)!=0) --nombre de la base contiene referencia a servidor vinculado 
	  begin

	   
		   set @sql=FormatMessage(
					 ' exec %s.dbo.pa_VariacionHacienda 
							@mes=%d					  
						   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mes)

		   set @sql=FormatMessage('SELECT * FROM OPENQUERY([BackupServer],''%s'')',@sql)

	  end
	  else
	  begin

			set @sql=FormatMessage(
					 ' exec %s.dbo.pa_VariacionHacienda 
							@mes=%d					  
						   ',@bd,@mes)
			

	  end 
	     	 

	  insert @tablaEstadoVariacionHacienda exec(@sql)
	  
	

		insert into [dbo].[EstadoVariacionHacienda]
           ([Cuenta]
           ,[CuentaD]
		   ,[Nivel]
		   ,[Naturaleza]          
           ,[Saldo]
           ,[Anio]           
           ,[Mes]
           ,[Ejercicio]
           ,[Municipio])
	   
			    
		select
	
		   codigocompleto		  
		  ,nombre
		  ,nivel
		  ,naturaleza
		  ,total
		  ,año		 
		  ,@mes		  
		  ,@ejercicio 
		  ,right(@bd,len(@bd)-charindex('.',@bd,0)) 
	 
		from @tablaEstadoVariacionHacienda			
		
	   delete @tablaEstadoVariacionHacienda;  	   

	  print 'TERMINA PROCESO: ' +  cast(@mes as varchar(2)); 

	  set @mes=@mes + 1;

   end   
	
END
